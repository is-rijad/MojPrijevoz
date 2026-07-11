import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:moj_prijevoz_admin/common/mp_build_context_extension.dart';
import 'package:moj_prijevoz_admin/resources/responses/stats/users_by_city/users_by_city_response.dart';

class UsersByCityMap extends StatelessWidget {
  final List<UsersByCityResponse> data;
  const UsersByCityMap({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(43.85, 18.13),
        initialZoom: 7.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.fit.mojprijevoz',
        ),
        MarkerLayer(
          markers: data.map((c) {
            final size = _markerSize(c.usersCount);
            return Marker(
              point: LatLng(double.parse(c.lat), double.parse(c.long)),
              width: size,
              height: size,
              child: _CountBubble(count: c.usersCount, size: size),
            );
          }).toList(),
        ),
      ],
    );
  }

  double _markerSize(int count) {
    return 20 + 10 * sqrt(count.toDouble());
  }
}

class _CountBubble extends StatelessWidget {
  final int count;
  final double size;
  const _CountBubble({required this.count, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.primaryColor.withAlpha(185),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
