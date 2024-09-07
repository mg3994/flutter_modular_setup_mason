// Flutter imports:

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/semantics.dart';
import 'package:core/core.dart' show AppLocalizationsX, NetworkInfo,NetworkConnectivityStatus;

import '../../atom/atom.dart' show BannerHost;

final class SystemEventObserver extends StatefulWidget {
  const SystemEventObserver({
    super.key,
    required this.child,
    required this.networkInfoFactory,
    this.lifeCycle,
    this.onSystemBrightnessChange,
    this.onSystemLocaleChange,
    this.onMemoryPressure,
    this.onAppExitRequest,
    this.onSystemAccessibilityFeaturesChanged,

  });
  final Widget child;
  final NetworkInfo networkInfoFactory;

  final void Function(AppLifecycleState)? lifeCycle;
  final void Function(Brightness)? onSystemBrightnessChange;
  final void Function(List<Locale>?, Locale)? onSystemLocaleChange;
  final void Function()? onMemoryPressure;
  final Future<ui.AppExitResponse> Function()? onAppExitRequest;
  final void Function(AccessibilityFeatures)?
      onSystemAccessibilityFeaturesChanged;


  @override
  State<SystemEventObserver> createState() => _SystemEventObserverState();
}

final class _SystemEventObserverState extends State<SystemEventObserver>
    with WidgetsBindingObserver {
  late final Stream<NetworkConnectivityStatus> _connectivity ;
  Stream<NetworkConnectivityStatus> _connectivityStream() async* {
    try {
      final connectivity = widget.networkInfoFactory;
      final result = await connectivity.isConnected;
      yield result ;
      yield* connectivity.onStatusChange.distinct();

    } catch (e) {
      // Handle the error appropriately
      debugPrint('Connectivity error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivity = _connectivityStream();
    _checkSemantics();

  }

  void _checkSemantics() {
    if (ui.PlatformDispatcher.instance.semanticsEnabled) {
      SemanticsBinding.instance.ensureSemantics();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (widget.lifeCycle != null) {
      widget.lifeCycle!(state);
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    if (widget.onSystemBrightnessChange != null) {
      widget.onSystemBrightnessChange!(
          SchedulerBinding.instance.platformDispatcher.platformBrightness);
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (widget.onSystemLocaleChange != null &&
        locales != null &&
        locales.isNotEmpty) {
      final systemPreferedLocale = locales.first;
      // final systemPreferredLocale =
      //     SchedulerBinding.instance.platformDispatcher.locale;
      widget.onSystemLocaleChange!(
        locales,
        systemPreferedLocale,
      );
    }
  }

  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
    if (widget.onMemoryPressure != null) {
      widget.onMemoryPressure!();
    }
  }

  @override
  Future<ui.AppExitResponse> didRequestAppExit() async {
    if (widget.onAppExitRequest != null) {
      return await widget.onAppExitRequest!();
    }
    return super.didRequestAppExit();
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    if (widget.onSystemAccessibilityFeaturesChanged != null) {
      final accessibilityFeatures =
          ui.PlatformDispatcher.instance.accessibilityFeatures;
      widget.onSystemAccessibilityFeaturesChanged!(accessibilityFeatures);
    }
  }

  @override
  Widget build(BuildContext context) =>
      StreamBuilder<NetworkConnectivityStatus>(
        initialData: NetworkConnectivityStatus.checking, //must be here
          stream:_connectivity,
          builder: (
            BuildContext context,
            AsyncSnapshot<NetworkConnectivityStatus> streamSnapshot,
          ) {


            if (streamSnapshot.connectionState == ConnectionState.none) {
              return Center(child: Text("Loading Connection"), ); //In Material //checking Internet status
              //TODO: load splash here
            } else {
              if(streamSnapshot.hasError){

                return Center(child: Text(streamSnapshot.error.toString()), ); //In Material //checking Internet status error
                //TODO: load  error splash here

              }
              final result = streamSnapshot.requireData;
              return BannerHost(
                  hideBanner: switch (result) {
                    NetworkConnectivityStatus.offline => false,
                    NetworkConnectivityStatus.checking => false,
                    NetworkConnectivityStatus.appOver => false,
                    _ => true
                  },

                  //  (result != connection.ConnectivityResult.none || result != connection.ConnectivityResult.vpn ),
                  banner: Material(
                    color: switch (result) {
                      NetworkConnectivityStatus.offline => Colors.red,
                      NetworkConnectivityStatus.checking => Colors.yellow,
                      NetworkConnectivityStatus.appOver => Colors.redAccent,
                      _ => Colors.green,
                    },
                    // (result != connection.ConnectivityResult.none)
                    //     ? Colors.green
                    //     : Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 12.0,
                      ),
                      child: Text(
                        switch (result) {
                          NetworkConnectivityStatus.checking =>
                          context.l10n.status_checking,
                          NetworkConnectivityStatus.offline =>
                            context.l10n.no_internet_message,
                          NetworkConnectivityStatus.appOver =>
                          context.l10n.app_maintenance,

                          _ => context.l10n.internet_connected("")
                        },
                        // (result != connection.ConnectivityResult.none)
                        //     ? context.l10n.connected(result.name.toString())
                        //     : context.l10n.notConnected,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors. white,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  child: widget.child);
            }
          });

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
