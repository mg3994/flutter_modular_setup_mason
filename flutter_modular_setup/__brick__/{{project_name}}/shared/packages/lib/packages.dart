library packages;

// ?# dependencies:
export 'package:intl/intl.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:json_annotation/json_annotation.dart';
export 'package:freezed_annotation/freezed_annotation.dart';

export 'package:dio/dio.dart';
//
// comment me
// export 'package:web/web.dart';
export 'package:connectivity_plus/connectivity_plus.dart';



export 'package:dartz/dartz.dart' hide State;
export 'package:hive_flutter/hive_flutter.dart';
export 'package:l10n/l10n.dart';

// ?# dev_dependencies:

// ? # self
export 'equatable/equatable.dart'; // make sure macro can lead to error  either hide it or try to use as for alias ,
export 'macros/macros.dart';
