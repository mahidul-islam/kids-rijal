import 'package:flutter/material.dart';

Matrix4 sizeToRect(Size src, Rect dst,
    {BoxFit fit = BoxFit.contain, Alignment alignment = Alignment.center}) {
  FittedSizes fs = applyBoxFit(fit, src, dst.size);
  double scaleX = fs.destination.width / fs.source.width;
  double scaleY = fs.destination.height / fs.source.height;
  Size fittedSrc = Size(src.width * scaleX, src.height * scaleY);
  Rect out = alignment.inscribe(fittedSrc, dst);

  return Matrix4.identity()
    ..translate(out.left, out.top)
    ..scale(scaleX, scaleY);
}

/// Like [sizeToRect] but accepting a [Rect] as [src]
Matrix4 rectToRect(Rect src, Rect dst,
    {BoxFit fit = BoxFit.contain, Alignment alignment = Alignment.center}) {
  return sizeToRect(src.size, dst, fit: fit, alignment: alignment)
    ..translate(-src.left, -src.top);
}
