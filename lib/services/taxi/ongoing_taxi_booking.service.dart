import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/models/delivery_address.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/view_models/taxi/taxi.vm.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supercharged/supercharged.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class OnGoingTaxiBookingService {
  TaxiViewModel taxiViewModel;
  OnGoingTaxiBookingService(this.taxiViewModel);
  //
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  StreamSubscription tripUpdateStream;
  StreamSubscription locationStreamSubscription;

  //
  DeliveryAddress pickupLocation;
  DeliveryAddress dropoffLocation;
  LatLng driverPosition;
  final pickupMarkerId = MarkerId('sourcePin');
  final dropoffMarkerId = MarkerId('destPin');

  //dispose
  void dispose() {
    tripUpdateStream?.cancel();
    locationStreamSubscription?.cancel();
  }

  //
  //get current on going trip
  void getOnGoingTrip() async {
    //
    taxiViewModel.setBusy(true);
    try {
      taxiViewModel.onGoingOrderTrip =
          await taxiViewModel.taxiRequest.getOnGoingTrip();
      loadTripUIByOrderStatus();
    } catch (error) {
      print("trip ongoing error ==> $error");
    }
    taxiViewModel.setBusy(false);
  }

  //Zoom to pickup location
  zoomToPickupLocation() async {
    //
    taxiViewModel.removeMapMarker(pickupMarkerId);
    taxiViewModel.gMapMarkers.add(
      Marker(
        markerId: pickupMarkerId,
        position: LatLng(
          taxiViewModel.onGoingOrderTrip.taxiOrder.pickupLatitude.toDouble(),
          taxiViewModel.onGoingOrderTrip.taxiOrder.pickupLongitude.toDouble(),
        ),
        icon: taxiViewModel.sourceIcon,
        anchor: Offset(0.5, 0.5),
      ),
    );
    //
    taxiViewModel.notifyListeners();
    //actually zoom now
    taxiViewModel.googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            taxiViewModel.onGoingOrderTrip.taxiOrder.pickupLatitude.toDouble(),
            taxiViewModel.onGoingOrderTrip.taxiOrder.pickupLongitude.toDouble(),
          ),
          zoom: 16,
        ),
      ),
    );
  }

  //Zoom to dropoff location
  zoomToDropoffLocation() async {
    //
    taxiViewModel.removeMapMarker(dropoffMarkerId);
    taxiViewModel.gMapMarkers.add(
      Marker(
        markerId: dropoffMarkerId,
        position: LatLng(
          taxiViewModel.onGoingOrderTrip.taxiOrder.dropoffLatitude.toDouble(),
          taxiViewModel.onGoingOrderTrip.taxiOrder.dropoffLongitude.toDouble(),
        ),
        icon: taxiViewModel.destinationIcon,
        anchor: Offset(0.5, 0.5),
      ),
    );
    //
    taxiViewModel.notifyListeners();
    //actually zoom now
    taxiViewModel.googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            taxiViewModel.onGoingOrderTrip.taxiOrder.pickupLatitude.toDouble(),
            taxiViewModel.onGoingOrderTrip.taxiOrder.pickupLongitude.toDouble(),
          ),
          zoom: 16,
        ),
      ),
    );
  }

  //Zoom to bound within driver location & dropoff location
  zoomToTripBoundLocation() async {
    //
    locationStreamSubscription =
        LocationService.location.onLocationChanged.listen(
      (event) {
        //
        driverPosition = LatLng(event.latitude, event.longitude);
        //zoom to driver and dropoff latbound
        updateCameraLocation(
          driverPosition,
          LatLng(
            dropoffLocation.latitude,
            dropoffLocation.longitude,
          ),
          taxiViewModel.googleMapController,
        );
      },
    );
  }

  //
  loadTripUIByOrderStatus() {
    //
    taxiViewModel.newFormKey();
    //
    if (taxiViewModel.onGoingOrderTrip != null && pickupLocation == null) {
      //
      pickupLocation = DeliveryAddress(
        latitude:
            taxiViewModel.onGoingOrderTrip.taxiOrder.pickupLatitude.toDouble(),
        longitude:
            taxiViewModel.onGoingOrderTrip.taxiOrder.pickupLongitude.toDouble(),
        address: taxiViewModel.onGoingOrderTrip.taxiOrder.pickupAddress,
      );
      //
      dropoffLocation = DeliveryAddress(
        latitude:
            taxiViewModel.onGoingOrderTrip.taxiOrder.dropoffLatitude.toDouble(),
        longitude: taxiViewModel.onGoingOrderTrip.taxiOrder.dropoffLongitude
            .toDouble(),
        address: taxiViewModel.onGoingOrderTrip.taxiOrder.dropoffAddress,
      );
      //set the pickup and drop off locations
      drawTripPolyLines();
      startHandlingOnGoingTrip();
    } else if (taxiViewModel.onGoingOrderTrip != null) {
      //
      print("trip status ==> ${taxiViewModel.onGoingOrderTrip.status}");
      switch (taxiViewModel.onGoingOrderTrip.status) {
        case "preparing":
          zoomToPickupLocation();
          break;
        case "ready":
          zoomToPickupLocation();
          break;
        case "enroute":
          zoomToTripBoundLocation();
          break;
        case "delivered":
          taxiViewModel.clearMapData();
          zoomToDropoffLocation();
          tripUpdateStream?.cancel();
          //
          final tripOrder = taxiViewModel.onGoingOrderTrip;
          taxiViewModel.onGoingOrderTrip = null;
          taxiViewModel.notifyListeners();
          taxiViewModel.showUserRating(tripOrder);
          break;
        case "failed":
          taxiViewModel.clearMapData();
          taxiViewModel.newTaxiBookingService.startNewOrderListener();
          break;
        case "cancelled":
          taxiViewModel.clearMapData();
          taxiViewModel.newTaxiBookingService.startNewOrderListener();
          break;
        default:
      }
    }
  }

  //
  String get getNewStateStatus {
    //
    String status = "Arrived";
    switch ((taxiViewModel.onGoingOrderTrip?.status ?? "").toLowerCase()) {
      case "preparing":
        status = "Arrived";
        break;
      case "ready":
        status = "Start Trip";
        break;
      case "enroute":
        status = "End Trip";
        break;
      default:
        break;
    }
    return status;
  }

  //
  String get getNextOrderStateStatus {
    //
    String status = "ready";
    switch ((taxiViewModel.onGoingOrderTrip?.status ?? "").toLowerCase()) {
      case "preparing":
        status = "ready";
        break;
      case "ready":
        status = "enroute";
        break;
      case "enroute":
        status = "delivered";
        break;
      default:
        break;
    }
    return status;
  }

  //
  void startHandlingOnGoingTrip() async {
    //
    //set new on trip step
    tripUpdateStream = firebaseFireStore
        .collection("orders")
        .doc("${taxiViewModel.onGoingOrderTrip.code}")
        .snapshots()
        .listen(
      (event) async {
        //update the rest onGoingTrip details
        if (event.data() != null && event.data().containsKey("status")) {
          //assing the status
          taxiViewModel.onGoingOrderTrip.status = event.data()["status"];
          //
          taxiViewModel.notifyListeners();
          loadTripUIByOrderStatus();
        }
      },
    );
    //start order details listening stream
  }

  //plylines
  drawTripPolyLines() async {
    // source pin
    taxiViewModel.clearMapMarkers();
    taxiViewModel.gMapMarkers.add(
      Marker(
        markerId: pickupMarkerId,
        position: LatLng(
          pickupLocation.latitude,
          pickupLocation.longitude,
        ),
        icon: taxiViewModel.sourceIcon,
        anchor: Offset(0.5, 0.5),
      ),
    );
    // destination pin

    taxiViewModel.gMapMarkers.add(
      Marker(
        markerId: dropoffMarkerId,
        position: LatLng(
          dropoffLocation.latitude,
          dropoffLocation.longitude,
        ),
        icon: taxiViewModel.destinationIcon,
        anchor: Offset(0.5, 0.5),
      ),
    );
    //load the ploylines
    PolylineResult polylineResult =
        await taxiViewModel.polylinePoints?.getRouteBetweenCoordinates(
      AppStrings.googleMapApiKey,
      PointLatLng(pickupLocation.latitude, pickupLocation.longitude),
      PointLatLng(dropoffLocation.latitude, dropoffLocation.longitude),
    );
    //get the points from the result
    List<PointLatLng> result = polylineResult.points;
    //
    if (result.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      result.forEach((PointLatLng point) {
        taxiViewModel.polylineCoordinates
            .add(LatLng(point.latitude, point.longitude));
      });
    }

    // with an id, an RGB color and the list of LatLng pairs
    Polyline polyline = Polyline(
      polylineId: PolylineId("poly"),
      color: AppColor.primaryColor,
      points: taxiViewModel.polylineCoordinates,
      width: 3,
    );
//
    taxiViewModel.gMapPolylines = {};
    taxiViewModel.gMapPolylines.add(polyline);

    //
    //zoom to latbound
    final pickupLocationLatLng = LatLng(
      pickupLocation.latitude,
      pickupLocation.longitude,
    );
    final dropoffLocationLatLng = LatLng(
      dropoffLocation.latitude,
      dropoffLocation.longitude,
    );

    await updateCameraLocation(
      pickupLocationLatLng,
      dropoffLocationLatLng,
      taxiViewModel.googleMapController,
    );
    //
    taxiViewModel.notifyListeners();
  }

  Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController mapController,
  ) async {
    if (mapController == null) return;

    LatLngBounds bounds;

    if (source.latitude > destination.latitude &&
        source.longitude > destination.longitude) {
      bounds = LatLngBounds(southwest: destination, northeast: source);
    } else if (source.longitude > destination.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(source.latitude, destination.longitude),
          northeast: LatLng(destination.latitude, source.longitude));
    } else if (source.latitude > destination.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destination.latitude, source.longitude),
          northeast: LatLng(source.latitude, destination.longitude));
    } else {
      bounds = LatLngBounds(southwest: source, northeast: destination);
    }

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

    return checkCameraLocation(cameraUpdate, mapController);
  }

  Future<void> checkCameraLocation(
      CameraUpdate cameraUpdate, GoogleMapController mapController) async {
    mapController.animateCamera(cameraUpdate);
    LatLngBounds l1 = await mapController.getVisibleRegion();
    LatLngBounds l2 = await mapController.getVisibleRegion();

    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      return checkCameraLocation(cameraUpdate, mapController);
    }
  }

  void processOrderStatusUpdate() async {
    //
    taxiViewModel.setBusy(true);
    try {
      taxiViewModel.onGoingOrderTrip = await taxiViewModel.orderRequest.updateOrder(
        id: taxiViewModel.onGoingOrderTrip.id,
        status: getNextOrderStateStatus,
      );
      taxiViewModel.notifyListeners();

      // loadTripUIByOrderStatus();
    } catch (error) {
      taxiViewModel.toastError("$error");
    }
    taxiViewModel.setBusy(false);
  }
}
