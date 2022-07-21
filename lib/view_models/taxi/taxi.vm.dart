import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/app_routes.dart';
import 'package:fuodz/models/new_taxi_order.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/requests/auth.request.dart';
import 'package:fuodz/requests/order.request.dart';
import 'package:fuodz/requests/taxi.request.dart';
import 'package:fuodz/services/app.service.dart';
import 'package:fuodz/services/location.service.dart';
import 'package:fuodz/services/taxi/new_taxi_booking.service.dart';
import 'package:fuodz/services/taxi/ongoing_taxi_booking.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:fuodz/widgets/bottomsheets/user_rating.bottomsheet.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:firebase_chat/models/chat_entity.dart';
import 'package:firebase_chat/models/peer_user.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/order_details.i18n.dart';

class TaxiViewModel extends MyBaseViewModel {
  TaxiViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  OrderRequest orderRequest = OrderRequest();
  TaxiRequest taxiRequest = TaxiRequest();
  Order onGoingOrderTrip;
  Order finishedOrderTrip;
  NewTaxiOrder newOrder;
  bool canRateTrip = true;
  AppService appService = AppService();

  //
  GoogleMapController googleMapController;
  EdgeInsets googleMapPadding = EdgeInsets.only(top: kToolbarHeight);
  NewTaxiBookingService newTaxiBookingService;
  OnGoingTaxiBookingService onGoingTaxiBookingService;
  StreamSubscription myLocationListener;
  //MAp related variables
  Set<Polyline> gMapPolylines = {};
  // this will hold each polyline coordinate as Lat and Lng pairs
  List<LatLng> polylineCoordinates = [];
  Set<Marker> gMapMarkers = {};
  MarkerId driverMarkerId = MarkerId("driverIcon");
  PolylinePoints polylinePoints = PolylinePoints();
// for my custom icons
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor driverIcon;
//END MAP RELATED VARIABLES

  //
  @override
  void initialise() {
    super.initialise();
    newTaxiBookingService = NewTaxiBookingService(this);
    onGoingTaxiBookingService = OnGoingTaxiBookingService(this);
    getOnlineDriverState();
    setSourceAndDestinationIcons();
    onGoingTaxiBookingService.getOnGoingTrip();
    startListeningToDriverLocation();
  }

  @override
  void dispose() {
    super.dispose();
    newTaxiBookingService.dispose();
    onGoingTaxiBookingService.dispose();
    myLocationListener?.cancel();
  }

  onMapReady(GoogleMapController controller) {
    googleMapController = controller;
    newTaxiBookingService.zoomToCurrentLocation();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppImages.pickupLocation,
    );
    //
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppImages.dropoffLocation,
    );
    //
    driverIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      AppImages.driverCar,
      mipmaps: false,
    );
  }

  //
  clearMapMarkers({bool clearDriver = false}) {
    if (clearDriver) {
      gMapMarkers = {};
    } else {
      gMapMarkers.removeWhere((e) => e.markerId != driverMarkerId);
    }
    notifyListeners();
  }

  removeMapMarker(MarkerId markerId) {
    gMapMarkers.removeWhere((e) => e.markerId == markerId);
    notifyListeners();
  }

  void updateGoogleMapPadding([double height]) {
    googleMapPadding = EdgeInsets.only(
      top: googleMapPadding.top,
      bottom: height,
    );
    notifyListeners();
  }

  //
  clearMapData() {
    clearMapMarkers();
    polylineCoordinates.clear();
    gMapPolylines.clear();
    notifyListeners();
  }

  chatCustomer() {
    //
    Map<String, PeerUser> peers = {
      '${onGoingOrderTrip.driver.id}': PeerUser(
        id: '${onGoingOrderTrip.driver.id}',
        name: onGoingOrderTrip.driver.name,
        image: onGoingOrderTrip.driver.photo,
      ),
      '${onGoingOrderTrip.user.id}': PeerUser(
          id: "${onGoingOrderTrip.user.id}",
          name: onGoingOrderTrip.user.name,
          image: onGoingOrderTrip.user.photo),
    };
    //
    final chatEntity = ChatEntity(
      mainUser: peers['${onGoingOrderTrip.driver.id}'],
      peers: peers,
      //don't translate this
      path: 'orders/' + onGoingOrderTrip.code + "/customerDriver/chats",
      title: "Chat with customer".i18n,
    );
    //
    viewContext.navigator.pushNamed(
      AppRoutes.chatRoute,
      arguments: chatEntity,
    );
  }

  //
  startListeningToDriverLocation() async {
    //
    myLocationListener = LocationService.location.onLocationChanged.listen(
      (event) {
        //
        final driverMarker = Marker(
          markerId: driverMarkerId,
          position: LatLng(
            event.latitude,
            event.longitude,
          ),
          rotation: event.heading,
          icon: driverIcon,
          anchor: Offset(0.5, 0.5),
        );
        //
        if (gMapMarkers.firstWhere(
                (marker) => marker.markerId == driverMarkerId,
                orElse: () => null) !=
            null) {
          gMapMarkers.replaceFirstWhere(
            (marker) => marker.markerId == driverMarkerId,
            driverMarker,
          );
        } else {
          gMapMarkers.add(driverMarker);
        }
        //
        notifyListeners();
      },
    );
  }

  //
  //fetch driver online offline
  getOnlineDriverState() async {
    setBusyForObject(appService.driverIsOnline, true);
    try {
      User driverData = await AuthRequest().getMyDetails();
      appService.driverIsOnline = driverData.isOnline;
      //if is online start listening to new trip
      if (appService.driverIsOnline) {
        newTaxiBookingService.startNewOrderListener();
      }
    } catch (error) {
      print("error getting driver data ==> $error");
    }
    setBusyForObject(appService.driverIsOnline, false);
  }

  Future<bool> syncDriverNewState() async {
    bool updated = false;
    setBusyForObject(appService.driverIsOnline, true);
    try {
      await AuthRequest().updateProfile(
        isOnline: appService.driverIsOnline,
      );
      updated = true;
    } catch (error) {
      print("error getting driver data ==> $error");
      appService.driverIsOnline = !appService.driverIsOnline;
    }
    setBusyForObject(appService.driverIsOnline, false);
    return updated;
  }

  void showUserRating(Order finishedTrip) async {
    //
    finishedTrip = finishedOrderTrip != null ? finishedOrderTrip : finishedTrip;
    //
    await viewContext.push(
      (context) => UserRatingBottomSheet(
        order: finishedTrip,
        onSubmitted: () {
          viewContext.pop();
        },
      ),
    );

    //
    onGoingOrderTrip = null;
    notifyListeners();
    newTaxiBookingService.startNewOrderListener();
    newTaxiBookingService.zoomToCurrentLocation();
    updateGoogleMapPadding(20);
  }
}
