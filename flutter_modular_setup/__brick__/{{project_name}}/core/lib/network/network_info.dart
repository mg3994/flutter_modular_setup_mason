


import 'network_connectivity_status.dart';

abstract interface class NetworkInfo {
  const NetworkInfo();
  Stream<NetworkConnectivityStatus> get onStatusChange;
  Future<NetworkConnectivityStatus> get isConnected;
}

