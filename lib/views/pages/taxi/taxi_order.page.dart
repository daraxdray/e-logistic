import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/view_models/taxi/taxi.vm.dart';
import 'package:fuodz/views/pages/taxi/widgets/ongoing_trip.view.dart';
import 'package:fuodz/views/pages/taxi/widgets/online_offline_indicator.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class TaxiOrderPage extends StatefulWidget {
  const TaxiOrderPage({Key key}) : super(key: key);

  @override
  _TaxiOrderPageState createState() => _TaxiOrderPageState();
}

class _TaxiOrderPageState extends State<TaxiOrderPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  //
  TaxiViewModel taxiViewModel;

  //
  @override
  void initState() {
    super.initState();
    taxiViewModel = TaxiViewModel(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("resumed");
      taxiViewModel?.googleMapController?.setMapStyle("[]");
      taxiViewModel.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BasePage(
      body: ViewModelBuilder<TaxiViewModel>.reactive(
        viewModelBuilder: () => taxiViewModel,
        onModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return Stack(
            children: [
              //google map
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(0.00, 0.00),
                ),
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                onMapCreated: vm.onMapReady,
                padding: vm.googleMapPadding,
                markers: vm.gMapMarkers,
                polylines: vm.gMapPolylines,
              ),

              //trip details view
              OnGoingTripView(vm),

              //Online/offline
              OnlineOfflineIndicatorView(vm),

              //loading
              Visibility(
                visible: vm.isBusy,
                child: BusyIndicator(
                  color: AppColor.primaryColor,
                )
                    .wh(60, 60)
                    .box
                    .white
                    .rounded
                    .p32
                    .makeCentered()
                    .box
                    .color(Colors.black.withOpacity(0.3))
                    .make()
                    .wFull(context)
                    .hFull(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
