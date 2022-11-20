// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double height;

  ShimmerList({this.itemCount,this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
                child: Container(
                  width: 50,
                  height: height,
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100);
          }),
    );
  }
}
