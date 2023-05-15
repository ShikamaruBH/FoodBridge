import 'package:flutter/material.dart';

class VSpacer extends StatelessWidget {
  final double? offset;
  const VSpacer({
    this.offset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10 + (offset ?? 0),
    );
  }
}

// ignore: must_be_immutable
class HSpacer extends StatelessWidget {
  final double? offset;
  double? width;
  HSpacer({
    this.offset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    width = 10 + (offset ?? 0);
    return SizedBox(
      width: 10 + (offset ?? 0),
    );
  }
}
