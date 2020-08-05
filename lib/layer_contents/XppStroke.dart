import 'package:flutter/material.dart';
import 'package:xournalpp/src/XppLayer.dart';

class XppStroke extends XppContent {
  XppStroke({this.tool = XppStrokeTool.PEN, this.points, this.color});

  XppStrokeTool tool;
  List<XppStrokePoint> points;
  Color color;

  @override
  Offset getOffset() {
    if (points.isEmpty) return Offset(0, 0);
    double x = points[0].x;
    // finding smallest x point
    points.forEach((point) {
      if (point.x < x) x = point.x;
    });
    double y = points[0].y;
    // finding smallest y point
    points.forEach((point) {
      if (point.y < y) x = point.y;
    });
    return (Offset(x, y));
  }

  Offset get bottomRight {
    if (points.isEmpty) return Offset(0, 0);
    double x = points[0].x;
    // finding largest x point
    points.forEach((point) {
      if (point.x > x) x = point.x;
    });
    double y = points[0].y;
    // finding largest y point
    points.forEach((point) {
      if (point.y > y) x = point.y;
    });
    return (Offset(x, y));
  }

  @override
  Widget render() {
    if (points.isEmpty) {
      return (Container());
    }
    Color colorToUse = color;
    if (tool == XppStrokeTool.ERASER) color = Colors.white;
    if (tool == XppStrokeTool.HIGHLIGHTER) {
      color = color.withOpacity(.5);
    }
    return new CustomPaint(
      size: Size(
          bottomRight.dx - getOffset().dx, bottomRight.dy - getOffset().dy),
      foregroundPainter: XppStrokePainter(
          points: points, color: colorToUse, topLeft: getOffset()),
    );
  }
}

class XppStrokePainter extends CustomPainter {
  @required
  final List<XppStrokePoint> points;
  @required
  final Color color;
  @required
  final Offset topLeft;

  XppStrokePainter({this.points, this.color, this.topLeft});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    var paint = Paint()
      ..color = color

      /// TODO: workaround pressure
      ..strokeWidth = points[0]?.width ?? 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(
        points[0].offset.dx - topLeft.dx, points[0].offset.dy - topLeft.dy);
    points.forEach((point) {
      Offset offset = point.offset;
      path.lineTo(offset.dx - topLeft.dx, offset.dy - topLeft.dy);
    });
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

enum XppStrokeTool {
  PEN,
  HIGHLIGHTER,
  ERASER,
}

class XppStrokePoint {
  final double x;
  final double y;
  final double width;

  XppStrokePoint({this.x, this.y, this.width});

  Offset get offset => Offset(x, y);
}
