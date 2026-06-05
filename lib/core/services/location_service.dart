import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

sealed class LocationResult {
  const LocationResult();
}

class LocationSucces extends LocationResult {
  final String coordinates;
  const LocationSucces(this.coordinates);
}

class LocationDenied extends LocationResult {
  final String message;
  const LocationDenied(this.message);
}

class LocationDeniedForever extends LocationResult {
  const LocationDeniedForever();
}

class LocationServiceDisabled extends LocationResult {
  const LocationServiceDisabled();
}

class LocationService {

  const LocationService();

  Future<LocationResult> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled){
      return const LocationServiceDisabled();
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ) {
        return const LocationDenied(
          'Permiso de ubicación denegado. Puedes buscar tu ciudad manualmente.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationDeniedForever();
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 15),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String locationName;

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        debugPrint('PlaceMark: $place');

        final city = place.locality?.isNotEmpty == true
          ? place.locality!
          : place.subAdministrativeArea?.isNotEmpty == true
              ? place.subAdministrativeArea!
              : place.administrativeArea ?? '';

        final country = place.country ?? '';

        locationName = [city, country]
            .where((s) => s.isNotEmpty)
            .join(', ');
      } else {
        locationName =
            '${position.latitude.toStringAsFixed(4)},${position.longitude.toStringAsFixed(4)}';
      }

      return LocationSucces(locationName);
    } catch (e) {
      return const LocationDenied(
        'No se pudo obtener la ubicación. Intenta de nuevo.',
      );
    }
  }
}