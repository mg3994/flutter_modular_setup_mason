// // // import 'package:core/cache/cache_manager.dart';
// // // import 'package:preferences/preferences.dart';
// // // import 'package:packages/packages.dart';
// // //
// // //
// // // class ApiServices {
// // //    ApiServices(this.cacheManager, this.dio, this.flavorConfig,){
// // //      cacheManager ??= CacheManagerImpl();
// // //      dio ??= Dio();
// // //      flavorConfig ??= FlavorConfig();
// // //     dio?.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options,RequestInterceptorHandler handler)async{
// // //       if(!options.path.startsWith('http')){
// // //         options.path = flavorConfig!.baseUrl + options.path;
// // //       }
// // //      if(await cacheManager?.read("accessToken") != null){
// // //        options.headers['Authorization'] = 'Bearer ${ await cacheManager?.read("accessToken")}';
// // //      }
// // //      return handler.next(options);
// // //     }, onError: (DioException error, ErrorInterceptorHandler handler)async {
// // //       if(error.response?.statusCode ==401 && error.response?.data['message'] == "Invalid JWT"){
// // //         if (await cacheManager?.read("refreshToken") != null){
// // //           if(await refreshToken()){
// // //             return handler.resolve(await _retry(error.requestOptions));
// // //           }
// // //         }
// // //       }
// // //       return handler.next(error);
// // //     }));
// // //   }
// // //   late final Dio? dio;
// // //   late final CacheManager? cacheManager;
// // //   late final FlavorConfig? flavorConfig;
// // //
// // //    Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
// // //      final options = Options(
// // //        method: requestOptions.method,
// // //        headers: requestOptions.headers,
// // //      );
// // //      return dio!.request<dynamic>(requestOptions.path,
// // //          data: requestOptions.data,
// // //          queryParameters: requestOptions.queryParameters,
// // //          options: options);
// // //    }
// // //    Future<bool> refreshToken() async {
// // //      final refreshToken = await cacheManager?.read("refreshToken") ;
// // //      final response = await dio!
// // //          .post('/auth/refresh', data: {'refreshToken': refreshToken});
// // //
// // //      if (response.statusCode == 201) {
// // //        await  cacheManager?.write("accessToken", response.data['accessToken'])  ;
// // //        return true;
// // //      } else {
// // //        // refresh token is wrong
// // //        cacheManager?.delete("accessToken");
// // //        cacheManager?.delete("refreshToken");
// // //        return false;
// // //        //need login again
// // //      }
// // //    }
// // // }
// //
// //
// // /////////
// //
// //
// // import 'package:core/cache/cache_manager.dart';
// // import 'package:preferences/preferences.dart';
// // import 'package:packages/packages.dart';
// //
// // import '../constants/constants.dart' show HiveKeys;
// //
// // class ApiServices {
// //   late final Dio dio;
// //   late final CacheManager cacheManager;
// //   late final FlavorConfig flavorConfig;
// //   ApiServices({
// //     Dio? dio,
// //     CacheManager? cacheManager,
// //     FlavorConfig? flavorConfig,
// //   }) {
// //     // Assign default values if not provided
// //     this.dio = dio ?? Dio();
// //     this.cacheManager = cacheManager ?? CacheManagerImpl();
// //     this.flavorConfig = flavorConfig ?? FlavorConfig();
// //
// //     _initializeInterceptors();
// //   }
// //
// //   void _initializeInterceptors() {
// //
// //     dio.interceptors.add(InterceptorsWrapper(
// //       onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
// //         // Construct full URL with base URL and query parameters
// //         if (!options.path.startsWith('http')) {
// //           // final queryString = _getQueryString(options.queryParameters);
// //           options.path = '${flavorConfig.baseUrl}${options.path}';
// //
// //         }
// //
// //         // Add Authorization header if token is available
// //         final accessToken = await cacheManager.read<String>(HiveKeys.accessToken);
// //         if (accessToken != null) {
// //           options.headers['Authorization'] = 'Bearer $accessToken';
// //         }
// //
// //         return handler.next(options);
// //       },
// //       onError: (DioException error, ErrorInterceptorHandler handler) async {
// //         if (error.response?.statusCode == 401 && error.response?.data['message'] == "Invalid JWT") {
// //           final refreshToken = await cacheManager.read<String>(HiveKeys.refreshToken);
// //           if (refreshToken != null && await _refreshToken()) {
// //             // Retry the original request with the new token
// //             return handler.resolve(await _retry(error.requestOptions));
// //           }
// //         }
// //
// //         return handler.next(error);
// //       },
// //     ));
// //   }
// //
// //   // String _getQueryString(Map<String, dynamic>? queryParameters) {
// //   //   if (queryParameters == null || queryParameters.isEmpty) {
// //   //     return '';
// //   //   }
// //   //
// //   //   final queryString = queryParameters.entries.map((entry) {
// //   //     final key = Uri.encodeComponent(entry.key);
// //   //     final value = Uri.encodeComponent(entry.value.toString());
// //   //     return '$key=$value';
// //   //   }).join('&');
// //   //
// //   //   return '?$queryString';
// //   // }
// //
// //   Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
// //     final options = Options(
// //       method: requestOptions.method,
// //       headers: requestOptions.headers,
// //       responseType: requestOptions.responseType,
// //     );
// //     return dio.request<dynamic>(
// //       requestOptions.path,
// //       data: requestOptions.data,
// //       queryParameters: requestOptions.queryParameters,
// //       options: options,
// //       cancelToken: requestOptions.cancelToken,
// //       onReceiveProgress: requestOptions.onReceiveProgress,
// //       onSendProgress: requestOptions.onSendProgress,
// //
// //     );
// //   }
// //
// //   Future<bool> _refreshToken() async {
// //     final refreshToken = await cacheManager.read<String>(HiveKeys.refreshToken);
// //     try {
// //       final response = await dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
// //       if (response.statusCode == 201) {
// //         await cacheManager.write(HiveKeys.accessToken, response.data['accessToken']);
// //         return true;
// //       } else {
// //         await _clearTokens();
// //         return false;
// //       }
// //     } catch (e) {
// //       await _clearTokens();
// //       return false;
// //     }
// //   }
// //
// //   Future<void> _clearTokens() async {
// //     await cacheManager.delete(HiveKeys.accessToken);
// //     await cacheManager.delete(HiveKeys.refreshToken);
// //   }
// // }
//
// ///////
//
//
// import 'dart:async';
// import 'dart:io';
//
// import 'package:core/cache/cache_manager.dart';
//
// import 'package:preferences/preferences.dart';
// import 'package:packages/packages.dart';
//
// import '../constants/constants.dart' show HiveKeys;
//
// class ApiServices {
//   late final Dio dio;
//   late final CacheManager cacheManager;
//   late final FlavorConfig flavorConfig;
//   late final Connectivity connectivity;
//
//   ApiServices({
//     Dio? dio,
//     CacheManager? cacheManager,
//     FlavorConfig? flavorConfig,
//     Connectivity? connectivity,
//   }) {
//     // Assign default values if not provided
//     this.dio = dio ?? Dio();
//     this.cacheManager = cacheManager ?? CacheManagerImpl();
//     this.flavorConfig = flavorConfig ?? FlavorConfig();
//     this.connectivity = connectivity ?? Connectivity();
//
//
//     _initializeInterceptors();
//   }
//
//   void _initializeInterceptors() {
//     // Adding Authorization and other interceptors
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
//
//         if (!options.path.startsWith('http')) {
//           options.path = '${flavorConfig.baseUrl}${options.path}';
//         }
//
//
//         // final accessToken = await cacheManager.read<String?>(HiveKeys.accessToken);
//         // if (accessToken != null) {
//         //   options.headers['Authorization'] = 'Bearer $accessToken';
//         // }
//
//         return handler.next(options);
//       },
//       onError: (DioException error, ErrorInterceptorHandler handler) async {
//         // Handle token expiration and retry with refreshed token
//         if (error.response?.statusCode == 401 && error.response?.data['message'] == "Invalid JWT") {
//           final refreshToken = await cacheManager.read(HiveKeys.refreshToken);
//           if (refreshToken != null && await _refreshToken()) {
//             return handler.resolve(await _retry(error.requestOptions));
//           }
//         }
//
//         return handler.next(error);
//       },
//     ));
//
//     // Adding retry on connection errors interceptor
//     dio.interceptors.add(RetryOnConnectionChangeInterceptor(
//       requestRetrier: DioConnectivityRequestRetrier(
//         dio: dio,
//         connectivity: connectivity,
//       ),
//     ));
//   }
//
//   Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
//     final options = Options(
//       method: requestOptions.method,
//       headers: requestOptions.headers,
//       responseType: requestOptions.responseType,
//     );
//     return dio.request<dynamic>(
//       requestOptions.path,
//       data: requestOptions.data,
//       queryParameters: requestOptions.queryParameters,
//       options: options,
//       cancelToken: requestOptions.cancelToken,
//       onReceiveProgress: requestOptions.onReceiveProgress,
//       onSendProgress: requestOptions.onSendProgress,
//     );
//   }
//
//   Future<bool> _refreshToken() async {
//     final refreshToken = await cacheManager.read(HiveKeys.refreshToken);
//     try {
//       final response = await dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
//       if (response.statusCode == 201) {
//         await cacheManager.write(HiveKeys.accessToken, response.data['accessToken']);
//         return true;
//       } else {
//         await _clearTokens();
//         return false;
//       }
//     } catch (e) {
//       await _clearTokens();
//       return false;
//     }
//   }
//
//   Future<void> _clearTokens() async {
//     await cacheManager.delete(HiveKeys.accessToken);
//     await cacheManager.delete(HiveKeys.refreshToken);
//   }
// }
//
// class RetryOnConnectionChangeInterceptor extends Interceptor {
//   final DioConnectivityRequestRetrier requestRetrier;
//
//   RetryOnConnectionChangeInterceptor({
//     required this.requestRetrier,
//   });
//
//   @override
//   Future onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (_shouldRetry(err)) {
//       try {
//         return handler.resolve(await requestRetrier.scheduleRequestRetry(err.requestOptions));
//       } catch (e) {
//         // return e;
//         return handler.next(err);  // Propagate the error if it's not retried
//
//       }
//     }
//     return handler.next(err);
//   }
//
//   bool _shouldRetry(DioException err) {
//     return err.type == DioExceptionType.connectionError &&
//         err.error != null &&
//         err.error is SocketException;
//   }
// }
//
// class DioConnectivityRequestRetrier {
//   final Dio dio;
//   final Connectivity connectivity;
//
//   DioConnectivityRequestRetrier({
//     required this.dio,
//     required this.connectivity,
//   });
//
//   Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
//     StreamSubscription? streamSubscription;
//     final responseCompleter = Completer<Response>();
//
//     streamSubscription = connectivity.onConnectivityChanged.listen(
//           (connectivityResult) {
//         if (connectivityResult.lastOrNull != null && connectivityResult.lastOrNull != ConnectivityResult.none) {
//           final options = Options(
//             method: requestOptions.method,
//             headers: requestOptions.headers,
//             responseType: requestOptions.responseType,
//           );
//           streamSubscription?.cancel();
//           responseCompleter.complete(
//
//             dio.request(
//               requestOptions.path,
//               cancelToken: requestOptions.cancelToken,
//               data: requestOptions.data,
//               onReceiveProgress: requestOptions.onReceiveProgress,
//               onSendProgress: requestOptions.onSendProgress,
//               queryParameters: requestOptions.queryParameters,
//               options: options,
//             ),
//           );
//         }
//       },
//     );
//
//     return responseCompleter.future;
//   }
// }
//
