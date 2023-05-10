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

class HSpacer extends StatelessWidget {
  final double? offset;
  const HSpacer({
    this.offset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10 + (offset ?? 0),
    );
  }
}
