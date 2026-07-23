import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:food_delivery/utils/log.dart';

/// This method takes any Object and tries to convert it to indented json string and returns it.
/// If the object is null returns "null"
String prettyJson(Object? object) {
  if (object == null) {
    return "null";
  }

  const encoder = JsonEncoder.withIndent('  ');
  try {
    // attempt to decode and conver string to json indented if its a string
    if (object is String) return encoder.convert(jsonDecode(object));

    if (object is Response<dynamic>) {
      return encoder.convert(object.data);
    }

    // attempt to convert object to json indented string (object is dynamic always returns true)
    return encoder.convert(object);
  } catch (e) {
    logger.warn(
      "Json pretty format failed using .toString(), error:\n${e.toString()}",
    );
    if (object is String) return object;
    return object.toString();
  }
}
