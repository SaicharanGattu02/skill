import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';


FadeShimmer_circle(size) {
  return Container(
    margin: EdgeInsets.all(2),
    decoration: new BoxDecoration(
      color: Color(0xffE6E8EB),
      shape: BoxShape.circle,
    ),
    height: size,
    width: size,
  );
}

FadeShimmer_box(height, width, radius) {
  return Container(
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Color(0xffE6E8EB), borderRadius: BorderRadius.circular(radius)),
    height: height,
    width: width,
  );
}

FadeShimmer_box_elite(height, width, radius) {
  return Container(
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Color(0xFF3D3D3D), borderRadius: BorderRadius.circular(radius)),
    height: height,
    width: width,
  );
}

FadeShimmer_box_porter(height, width, radius) {
  return Container(
    margin: EdgeInsets.all(5),
    decoration: BoxDecoration(
        color: Color(0xFF959595), borderRadius: BorderRadius.circular(radius)),
    height: height,
    width: width,
  );
}


// Shimmer component for a circular image
shimmerCircle(double size) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
    ),
  );
}

// Shimmer component for text
shimmerText(double width, double height) {
  return
    Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: Color(0xffE6E8EB), borderRadius: BorderRadius.circular(18)),
      ),
    );
}

// Shimmer component for linear progress bar
shimmerLinearProgress(double height) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: height,
      decoration: BoxDecoration(
          color: Color(0xffE6E8EB), borderRadius: BorderRadius.circular(18)),
    ),
  );
}
