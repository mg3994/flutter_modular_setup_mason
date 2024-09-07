import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:packages/packages.dart';
import 'package:flutter/foundation.dart';
import 'package:preferences/preferences.dart';




// class NetworkConnectivityCheckerImpl implements NetworkConnectivityChecker {
//  const  NetworkConnectivityCheckerImpl( {
//     required this.config,
//    // this.apiClient = ,
//   });
//   final FlavorConfig config;
//   // final ApiClient apiClient
//   @override
//  //done
//   Stream<NetworkConnectivityStatus> get onStatusChange =>
//       Connectivity().onConnectivityChanged.asyncMap((connectivityResult) async {
//         if (connectivityResult.lastOrNull == ConnectivityResult.none) {
//           return NetworkConnectivityStatus.offline;
//         } else {
//           final networkResult = await _computedNetworkCheck();
//           return networkResult;
//         }
//       });
//   @override
//   Future<NetworkConnectivityStatus> hasConnection() async {
//     final networkResult = await _computedNetworkCheck() ;
//     return networkResult;
//   }
//  Future<NetworkConnectivityStatus> _computedNetworkCheck() => compute(_performNetworkRequest, "${config.baseUrl}");
//   Future<NetworkConnectivityStatus> _performNetworkRequest(String uri) async {
//     try {
// final response = await Dio().get(uri); //todo pas api client with interceptor and check if banned or other
//   debugPrint(response.statusCode!.toString());
//       if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! <= 404) {
//         return NetworkConnectivityStatus.online;
//       } else if (response.statusCode != null && response.statusCode! > 499 && response.statusCode! <= 600) {
//         return NetworkConnectivityStatus.appOver;
//       }
//     } catch (e) {
//       print('Network Request Error checking connection: $e');
//     }
//     return NetworkConnectivityStatus.offline;
//   }
// }
//
//
//
//




 class NetworkInfoImpl implements NetworkInfo  {
 const NetworkInfoImpl(
     this._connectivity, this.dio, this.cacheManager, this.flavorConfig
     );


 final Connectivity _connectivity;
 final Dio dio;
 final CacheManager cacheManager;
 final FlavorConfig flavorConfig;


  @override
  Stream<NetworkConnectivityStatus> get onStatusChange => _connectivity.onConnectivityChanged.asyncMap((connectivityResult) async {
      if (connectivityResult.isNotEmpty && connectivityResult.lastOrNull != null &&
         connectivityResult.lastOrNull != ConnectivityResult.none) {
          final networkResult = await _computedNetworkCheck();
          return networkResult;
        } else {
          return NetworkConnectivityStatus.offline;
        }
      });
  Future<NetworkConnectivityStatus> _computedNetworkCheck() async{
    try{
    final accessToken=await  cacheManager.read(HiveKeys.accessToken);
    // final refreshToken=await  cacheManager.read(HiveKeys.refreshToken);
    dio.interceptors.clear(); // Clear existing interceptors
    dio.interceptors.addAll([
      InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        if (!options.path.startsWith('http')) {
          options.path = '${flavorConfig.baseUrl}${options.path}';
        }
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        return handler.next(options);
      },
        //can't send request as request is in compute and as BinaryIsolateMessanger error will be there
        // onError: (DioException error, ErrorInterceptorHandler handler) async {
        //
        //   if (error.response?.statusCode == 401 && error.response?.data['message'] == "Invalid JWT") {
        //     if (refreshToken != null && await _refreshToken(refreshToken)) {
        //
        //       return handler.resolve(await _retry(error.requestOptions)); //can't run this in compute as BinaryIsolateMessanger error will be there
        //     }
        //   }
        //
        //   return handler.next(error);
        // }
        ),// ....
    ]); } catch(e) {
 // if (kDebugMode) {
 print(e);
 // }
 }
    return  compute(_performNetworkRequest, ""
          // "/status/check"
      );}

  Future<NetworkConnectivityStatus> _performNetworkRequest(String uri) async {

    try {
      final response = await dio.get(uri); //replace with Api Client
      debugPrint(response.statusCode?.toString());
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! <= 404) {
        return NetworkConnectivityStatus.online;
      } else if (response.statusCode != null &&
          response.statusCode! > 499 &&
          response.statusCode! <= 600) {
        return NetworkConnectivityStatus.appOver;
        //else if  UserBanned
      }
    }on SocketException {

        await _connectivity.checkConnectivity().then((connectivityResult) async {
          if(connectivityResult.isNotEmpty && connectivityResult.lastOrNull != null && connectivityResult.lastOrNull != ConnectivityResult.none){
          await  Future.delayed(const Duration(seconds: 5));
            return await _computedNetworkCheck(); //keep retrying
          }
        });

    }
     catch (e) {
 // if user JWt token Expres as per that error refresh the token // but will face issue to save that in hive box as Isolates are different as it is in compute
      debugPrint('Network Request Error checking connection: $e');
    }
    return NetworkConnectivityStatus.offline;
  }

 //  Future<void> writeNewAccessToken(String? accessToken)async {
 //    await cacheManager.write(HiveKeys.accessToken, accessToken);
 //  }
 // Future<void> writeNewRefreshToken(String? refreshToken)async {
 //   await cacheManager.write(HiveKeys.refreshToken, refreshToken);
 // }
  @override
  Future<NetworkConnectivityStatus> get isConnected => _computedNetworkCheck();

 // bool _shouldRetry(DioException err) {
 //   return err.type == DioExceptionType.connectionError &&
 //       err.error != null &&
 //       err.error is SocketException;
 // }

 // Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
 //   final options = Options(
 //     method: requestOptions.method,
 //     headers: requestOptions.headers,
 //     responseType: requestOptions.responseType,
 //   );
 //   return dio.request<dynamic>(
 //     requestOptions.path,
 //     data: requestOptions.data,
 //     queryParameters: requestOptions.queryParameters,
 //     options: options,
 //     cancelToken: requestOptions.cancelToken,
 //     onReceiveProgress: requestOptions.onReceiveProgress,
 //     onSendProgress: requestOptions.onSendProgress,
 //   );
 // }

 // Future<bool> _refreshToken(String? refreshToken) async {
 //
 //   try {
 //     final response = await dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
 //     if (response.statusCode == 201) {
 //       await writeNewAccessToken(response.data['accessToken']); //can't write this in isolate say compute as it is seperate from our ui isolate
 //       await writeNewRefreshToken(response.data['refreshToken']); //can't write this in isolate say compute as it is seperate from our ui isolate
 //
 //       return true;
 //     } else {
 //       await _clearTokens();
 //       return false;
 //     }
 //   } catch (e) {
 //     await _clearTokens();
 //     return false;
 //   }
 // }

 // Future<void> _clearTokens() async {
 //   await cacheManager.delete(HiveKeys.accessToken);
 //   await cacheManager.delete(HiveKeys.refreshToken);
 // }
}

