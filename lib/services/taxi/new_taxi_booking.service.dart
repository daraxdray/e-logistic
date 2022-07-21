import 'dart:async';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/new_taxi_order.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/services/taxi_background_order.service.dart';
import 'package:fuodz/view_models/taxi/taxi.vm.dart';
import 'package:fuodz/views/pages/taxi/widgets/incoming_new_order_alert.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NewTaxiBookingService {
  TaxiViewModel taxiViewModel;
  NewTaxiBookingService(this.taxiViewModel);
  StreamSubscription myLocationListener;
  Location location = new Location();
  bool showNewTripView = false;
  CountDownController countDownTimerController = CountDownController();
  GlobalKey newAlertViewKey = GlobalKey<FormState>();
  //
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  StreamSubscription newOrderStreamSubscription;
  StreamSubscription locationStreamSubscription;

  //dispose
  void dispose() {
    myLocationListener?.cancel();
    newOrderStreamSubscription?.cancel();
  }

  //
  zoomToCurrentLocation() async {
    myLocationListener?.cancel();
    final currentPosition = await Geolocator.getCurrentPosition();
    if (currentPosition != null) {
      zoomToLocation(currentPosition.latitude, currentPosition.longitude);
    }
    //
    myLocationListener =
        LocationService.location.onLocationChanged.listen((locationData) {
      //actually zoom now
      zoomToLocation(locationData.latitude, locationData.longitude);
    });
  }

  //
  zoomToLocation(double lat, double lng) {
    taxiViewModel.googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16,
        ),
      ),
    );
  }

  //
  zoomToPickupLocation() async {
    //
    taxiViewModel.clearMapMarkers();
    taxiViewModel.gMapMarkers.add(
      Marker(
        markerId: MarkerId('sourcePin'),
        position: LatLng(
          taxiViewModel.newOrder.pickup.lat.toDouble(),
          taxiViewModel.newOrder.pickup.long.toDouble(),
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
            taxiViewModel.newOrder.pickup.lat.toDouble(),
            taxiViewModel.newOrder.pickup.long.toDouble(),
          ),
          zoom: 16,
        ),
      ),
    );
  }

  //
  toggleVisibility(bool value) async {
    //
    taxiViewModel.appService.driverIsOnline = value;
    final updated = await taxiViewModel.syncDriverNewState();
    //
    if (updated) {
      if (value && taxiViewModel.onGoingOrderTrip == null) {
        startNewOrderListener();
      } else {
        stopListeningToNewOrder();
      }
    }
  }

  //start lisntening for new orders
  startNewOrderListener() {
    //
    print("start listening to new taxi order");
    //
    newOrderStreamSubscription =
        TaxiBackgroundOrderService().showNewOrderStream.stream.listen(
      (event) {
        stopListeningToNewOrder();
        showNewOrderAlert(event);
      },
    );
  }

  //stop listening to new orders
  stopListeningToNewOrder() {
    locationStreamSubscription?.cancel();
    newOrderStreamSubscription?.cancel();
  }

  //
  showNewOrderAlert(dynamic data) async {
    //
    try {
      taxiViewModel.newOrder =
          (data is NewTaxiOrder) ? data : NewTaxiOrder.fromJson(data);
      zoomToPickupLocation();
      final result = await showModalBottomSheet(
        isDismissible: false,
        context: taxiViewModel.viewContext,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return IncomingNewOrderAlert(taxiViewModel, taxiViewModel.newOrder);
        },
      );
      //
      if (result != null) {
        taxiViewModel.onGoingOrderTrip = result;
        taxiViewModel.onGoingTaxiBookingService.loadTripUIByOrderStatus();
        taxiViewModel.notifyListeners();
      }
    } catch (error) {
      print("show new order alert error ==> $error");
    }
  }

  void countDownCompleted() {
    countDownTimerController?.pause();
    AppService().stopNotificationSound();
    showNewTripView = false;
    zoomToCurrentLocation();
    taxiViewModel.notifyListeners();
  }

  void processOrderAcceptance() {}
}
