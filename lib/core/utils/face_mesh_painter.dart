import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:meyoi/app/data/models/stroke_model.dart';
import 'package:meyoi/core/constants/face_keypoints.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';

const double _kFaceBlurSigma = 30.0;
const double _kLipBlurSigma = 3.0;
const double _kCheekBlurSigma = 20.0;
const double _kEyebrowBlurSigma = 1.2;

// --- DATA TOPOLOGI BIBIR ---
const List<int> _upperLipTopIndices = [
  61,
  185,
  40,
  39,
  37,
  0,
  267,
  269,
  270,
  409,
  291,
];
const List<int> _upperLipBottomIndices = [
  61,
  191,
  80,
  81,
  82,
  13,
  312,
  311,
  310,
  415,
  291,
];
const List<int> _lowerLipTopIndices = [
  61,
  78,
  95,
  88,
  178,
  14,
  402,
  318,
  324,
  308,
  291,
];
const List<int> _lowerLipBottomIndices = [
  61,
  146,
  91,
  181,
  84,
  17,
  314,
  405,
  321,
  375,
  291,
];

// --- DATA TOPOLOGI ALIS (DALAM -> LUAR) ---
const List<int> _leftEyebrowTopIndices = [300, 293, 334, 296, 336];
const List<int> _leftEyebrowBottomIndices = [276, 283, 282, 295, 285];

const List<int> _rightEyebrowTopIndices = [107, 66, 105, 63, 70];
const List<int> _rightEyebrowBottomIndices = [55, 65, 52, 53, 46];

// --- DATA TOPOLOGI EYELASH (INNER -> OUTER) ---
const List<int> _leftEyelashIndices = [
  362,
  398,
  384,
  385,
  386,
  387,
  388,
  466,
  263,
];
const List<int> _rightEyelashIndices = [
  33,
  246,
  161,
  160,
  159,
  158,
  157,
  173,
  133,
];

class FaceMeshPainter extends CustomPainter {
  FaceMeshPainter({
    required this.meshes,
    required this.originalImageSize,
    required this.blushColor,
    required this.strokes,
    required this.applyLipColor,
    required this.lipstickColor,
    required this.applyIrisColor,
    required this.irisColor,
    required this.selectedStyle,
    required this.applyFaceSkin,
    required this.faceSkinColor,
    required this.applyCheekColor,
    required this.cheekColor,
    required this.skinOpacity,
    required this.lipOpacity,
    required this.irisOpacity,
    required this.cheekOpacity,
    required this.eyebrowOpacity,
    required this.eyelashOpacity,
    required this.applyEyebrowColor,
    required this.eyebrowColor,
    required this.eyelashColor,
    required this.eyebrowStyle,
    required this.applyEyelashColor,
    this.leftEyelashTexture,
    this.rightEyelashTexture,
    this.upperLipTexture,
    this.lowerLipTexture,
  });

  final List<FaceMesh> meshes;
  final Size originalImageSize;
  final Color blushColor;
  final List<BrushStroke> strokes;
  final bool applyLipColor;
  final Color lipstickColor;
  final bool applyIrisColor;
  final Color irisColor;
  final String? selectedStyle;
  final ui.Image? upperLipTexture;
  final ui.Image? lowerLipTexture;
  final bool applyFaceSkin;
  final Color faceSkinColor;
  final bool applyCheekColor;
  final Color cheekColor;
  final double skinOpacity;
  final double cheekOpacity;
  final double lipOpacity;
  final double irisOpacity;
  final double eyebrowOpacity;
  final double eyelashOpacity;
  final bool applyEyebrowColor;
  final bool applyEyelashColor;
  final Color eyebrowColor;
  final Color eyelashColor;
  final String eyebrowStyle;
  final ui.Image? leftEyelashTexture;
  final ui.Image? rightEyelashTexture;

  @override
  void paint(Canvas canvas, Size size) {
    if (originalImageSize.width == 0 || originalImageSize.height == 0) return;

    final double scaleX = size.width / originalImageSize.width;
    final double scaleY = size.height / originalImageSize.height;
    
    for (final FaceMesh faceMesh in meshes) {
      if (applyFaceSkin) {
        _drawFaceSkinWithHoles(
          canvas,
          faceMesh.points,
          scaleX,
          scaleY,
          faceSkinColor,
        );
      }

      if (applyCheekColor) {
        _drawCheeks(canvas, faceMesh.points, scaleX, scaleY, cheekColor);
      }

      // --- 3. ALIS ---
      if (applyEyebrowColor) {
        // --- REALISTIC SOLID MODE ---
        final Path leftPath = _createStyledEyebrowPath(
          faceMesh.points,
          _leftEyebrowTopIndices,
          _leftEyebrowBottomIndices,
          scaleX,
          scaleY,
          eyebrowStyle,
          isLeft: true,
        );

        final Path rightPath = _createStyledEyebrowPath(
          faceMesh.points,
          _rightEyebrowTopIndices,
          _rightEyebrowBottomIndices,
          scaleX,
          scaleY,
          eyebrowStyle,
          isLeft: false,
        );

        // PENGATURAN GRADIENT ALIS
        final Rect leftBounds = leftPath.getBounds();
        final Rect rightBounds = rightPath.getBounds();

        // LAYER 1: BASE/SHADOW
        final Paint basePaint = Paint()
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.multiply
          ..color = eyebrowColor.withOpacity(eyebrowOpacity * 0.4)
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            _kEyebrowBlurSigma * 2.5,
          );

        canvas.drawPath(leftPath, basePaint);
        canvas.drawPath(rightPath, basePaint);

        // LAYER 2: MAIN BODY
        final Offset leftGradientCenter = Offset(
          leftBounds.right - (leftBounds.width * 0.2),
          leftBounds.center.dy,
        );
        final double leftGradientRadius = leftBounds.width * 1.2;

        final Paint leftMainPaint = Paint()
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.multiply
          ..shader = ui.Gradient.radial(
            leftGradientCenter,
            leftGradientRadius,
            [
              eyebrowColor.withOpacity(eyebrowOpacity),
              eyebrowColor.withOpacity(eyebrowOpacity * 0.6),
              eyebrowColor.withOpacity(0.0),
            ],
            [0.0, 0.5, 1.0],
          )
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            _kEyebrowBlurSigma,
          );

        final Offset rightGradientCenter = Offset(
          rightBounds.left + (rightBounds.width * 0.2),
          rightBounds.center.dy,
        );
        final double rightGradientRadius = rightBounds.width * 1.2;

        final Paint rightMainPaint = Paint()
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.multiply
          ..shader = ui.Gradient.radial(
            rightGradientCenter,
            rightGradientRadius,
            [
              eyebrowColor.withOpacity(eyebrowOpacity),
              eyebrowColor.withOpacity(eyebrowOpacity * 0.6),
              eyebrowColor.withOpacity(0.0),
            ],
            [0.0, 0.5, 1.0],
          )
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            _kEyebrowBlurSigma,
          );

        canvas.drawPath(leftPath, leftMainPaint);
        canvas.drawPath(rightPath, rightMainPaint);
      }

      // --- 4. EYELASH (Posisi dan Tinggi) ---
      if (applyEyelashColor &&
          leftEyelashTexture != null &&
          rightEyelashTexture != null) {
        // Eyelash Kiri
        _drawTextureWarp(
          canvas,
          faceMesh.points,
          leftEyelashTexture!,
          eyelashColor,
          _leftEyelashIndices,
          _leftEyelashIndices,
          scaleX,
          scaleY,
          isEyelash: true,
        );

        // Eyelash Kanan
        _drawTextureWarp(
          canvas,
          faceMesh.points,
          rightEyelashTexture!,
          eyelashColor,
          _rightEyelashIndices,
          _rightEyelashIndices,
          scaleX,
          scaleY,
          isEyelash: true,
          isRightEyebrow: true,
        );
      }

      // ... (Kode Bibir & Mata tetap sama) ...
      if (upperLipTexture != null && lowerLipTexture != null && applyLipColor) {
        _drawTextureWarp(
          canvas,
          faceMesh.points,
          upperLipTexture!,
          lipstickColor,
          _upperLipTopIndices,
          _upperLipBottomIndices,
          scaleX,
          scaleY,
          isLip: true
        );
        _drawTextureWarp(
          canvas,
          faceMesh.points,
          lowerLipTexture!,
          lipstickColor,
          _lowerLipTopIndices,
          _lowerLipBottomIndices,
          scaleX,
          scaleY,
          isLip: true
        );
      } else if (applyLipColor) {
        final Path outerLipPath = _createContourPath(
          faceMesh.points,
          FaceKeypoints.outterLipContourIndices,
          scaleX,
          scaleY,
        );
        final Path innerLipPath = _createContourPath(
          faceMesh.points,
          FaceKeypoints.innerLipContourIndices,
          scaleX,
          scaleY,
        );

        final Path lipPath = Path()
          ..addPath(outerLipPath, Offset.zero)
          ..addPath(innerLipPath, Offset.zero);
        lipPath.fillType = PathFillType.evenOdd;

        final Paint basePaint = Paint()
          ..color = lipstickColor.withOpacity(lipOpacity)
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.color
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            _kLipBlurSigma,
          );

        canvas.drawPath(lipPath, basePaint);

        final Paint overlayPaint = Paint()
          ..color = lipstickColor.withOpacity(lipOpacity * 0.6)
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.softLight
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            _kLipBlurSigma,
          );

        canvas.drawPath(lipPath, overlayPaint);
      }

      if (applyIrisColor) {
        final Paint irisPaint = Paint()
          ..color = irisColor.withOpacity(irisOpacity)
          ..style = PaintingStyle.fill
          ..blendMode = BlendMode.color;

        _drawIris(
          canvas,
          faceMesh.points,
          FaceKeypoints.LEFT_EYE_CONTOUR,
          scaleX,
          scaleY,
          irisPaint,
        );
        _drawIris(
          canvas,
          faceMesh.points,
          FaceKeypoints.RIGHT_EYE_CONTOUR,
          scaleX,
          scaleY,
          irisPaint,
        );
      }
    }

    // ... (Stroke drawing) ...
    for (final stroke in strokes) {
      final path = Path();
      if (stroke.points.isEmpty) continue;
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (var i = 1; i < stroke.points.length; i++)
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = stroke.strokeWidth
        ..color = stroke.color
        ..blendMode = stroke.isEraser ? BlendMode.clear : BlendMode.softLight
        ..maskFilter = MaskFilter.blur(
          BlurStyle.normal,
          stroke.strokeWidth * 0.5,
        );

      canvas.drawPath(path, paint);
    }
  }

  // --- LOGIKA STYLING ALIS ---
  Path _createStyledEyebrowPath(
    List<FaceMeshPoint> allPoints,
    List<int> topIndices,
    List<int> bottomIndices,
    double scaleX,
    double scaleY,
    String style, {
    required bool isLeft,
  }) {
    final Path path = Path();
    List<Offset> topPoints = topIndices
        .map((i) => Offset(allPoints[i].x * scaleX, allPoints[i].y * scaleY))
        .toList();
    List<Offset> bottomPoints = bottomIndices
        .map((i) => Offset(allPoints[i].x * scaleX, allPoints[i].y * scaleY))
        .toList();

    if (topPoints.isEmpty || bottomPoints.isEmpty) return path;

    double shift = 5.0 * scaleX;

    if (style == "Straight") {
      topPoints[2] = topPoints[2].translate(0, shift * 0.8);
      bottomPoints[2] = bottomPoints[2].translate(0, shift * 0.8);
      topPoints[4] = topPoints[4].translate(0, -shift * 0.5);
      bottomPoints[4] = bottomPoints[4].translate(0, -shift * 0.5);
    } else if (style == "Rounded") {
      topPoints[1] = topPoints[1].translate(0, -shift * 0.5);
      topPoints[2] = topPoints[2].translate(0, -shift * 0.5);
      bottomPoints[2] = bottomPoints[2].translate(0, -shift * 1.5);
      bottomPoints[1] = bottomPoints[1].translate(0, -shift * 2.5);
      bottomPoints[3] = bottomPoints[3].translate(0, -shift * 2.5);
      bottomPoints[4] = bottomPoints[4].translate(0, -shift * 4.5);
      topPoints[3] = topPoints[3].translate(0, -shift * 0.5);
      topPoints[4] = topPoints[4].translate(0, -shift * 0.7);
    } else if (style == "Hard-Angled") {
      topPoints[2] = topPoints[2].translate(0, -shift * 1.5);
      bottomPoints[2] = bottomPoints[2].translate(0, -shift * 1.5);
      topPoints[1] = topPoints[1].translate(0, shift * 0.2);
      topPoints[3] = topPoints[3].translate(0, shift * 0.2);
    } else if (style == "S-Shape") {
      topPoints[0] = topPoints[0].translate(0, -shift * 0.5);
      bottomPoints[0] = bottomPoints[0].translate(0, -shift * 2.5);
      topPoints[2] = topPoints[2].translate(0, -shift * 3.8);
      bottomPoints[2] = bottomPoints[2].translate(0, -shift * 2.8);
      bottomPoints[3] = bottomPoints[3].translate(0, -shift * 0.8);
      topPoints[4] = topPoints[4].translate(0, shift * 0.2);
    } else if (style == "Classic") {
      topPoints[0] = topPoints[0].translate(0, -shift * 0.5);
      bottomPoints[0] = bottomPoints[0].translate(0, -shift * 2.5);
      topPoints[2] = topPoints[2].translate(0, -shift * 1.8);
      bottomPoints[2] = bottomPoints[2].translate(0, -shift * 2.8);
      bottomPoints[3] = bottomPoints[3].translate(0, -shift * 0.8);
      topPoints[4] = topPoints[4].translate(0, shift * 0.2);
    }

    Offset tailTip = (topPoints.last + bottomPoints.last) / 2;
    Offset direction = tailTip - topPoints[topPoints.length - 2];
    if (direction.distance > 0) {
      tailTip += (direction / direction.distance) * (4.0 * scaleX);
    }
    topPoints.last = tailTip;
    bottomPoints.last = tailTip;

    path.moveTo(topPoints.first.dx, topPoints.first.dy);
    for (int i = 1; i < topPoints.length; i++) {
      final p0 = topPoints[i - 1];
      final p1 = topPoints[i];
      if (style == "Hard-Angled" && (i == 2 || i == 3)) {
        path.lineTo(p1.dx, p1.dy);
      } else {
        final midPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
        path.quadraticBezierTo(p0.dx, p0.dy, midPoint.dx, midPoint.dy);
        path.lineTo(p1.dx, p1.dy);
      }
    }
    path.lineTo(bottomPoints.last.dx, bottomPoints.last.dy);
    for (int i = bottomPoints.length - 2; i >= 0; i--) {
      final p0 = bottomPoints[i + 1];
      final p1 = bottomPoints[i];
      if (style == "Hard-Angled" && (i == 1 || i == 2)) {
        path.lineTo(p1.dx, p1.dy);
      } else {
        final midPoint = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
        path.quadraticBezierTo(p0.dx, p0.dy, midPoint.dx, midPoint.dy);
        path.lineTo(p1.dx, p1.dy);
      }
    }
    path.lineTo(topPoints.first.dx, topPoints.first.dy);
    path.close();
    return path;
  }

  void _drawTextureWarp(
  Canvas canvas,
  List<FaceMeshPoint> allPoints,
  ui.Image texture,
  Color color,
  List<int> topIndices,
  List<int> bottomIndices,
  double scaleX,
  double scaleY, {
  bool isEyebrow = false,
  bool isEyelash = false,
  bool isLip = false,
  bool isRightEyebrow = false,
}) {
  final List<Offset> vertices = [];
  final List<Offset> textureCoords = [];
  int count = math.min(topIndices.length, bottomIndices.length);

  for (int i = 0; i < count; i++) {
    final topPoint = allPoints[topIndices[i]];
    final bottomPoint = allPoints[bottomIndices[i]];

    Offset topPos = Offset(topPoint.x * scaleX, topPoint.y * scaleY);
    Offset bottomPos = Offset(bottomPoint.x * scaleX, bottomPoint.y * scaleY);

    if (isEyebrow) {
      final Offset center = (topPos + bottomPos) / 2.0;
      final Offset diff = topPos - bottomPos;
      final Offset dir = (diff.distance == 0) ? const Offset(0, -1) : diff / diff.distance;

      double expansionFactor = 25.0 * scaleX;
      if (isRightEyebrow) expansionFactor = 32.0 * scaleX;

      topPos = center + (dir * (expansionFactor * 0.6));
      bottomPos = center - (dir * (expansionFactor * 0.4));
    } else if (isEyelash) {
      double shiftX = (isRightEyebrow) ? -2.0 : 2.0;
      double shiftY = (isRightEyebrow) ? 4.0 : 4.0;

      bottomPos = Offset(
        bottomPoint.x * scaleX + shiftX,
        bottomPoint.y * scaleY + shiftY,
      );

      const Offset upDir = Offset(0, -3.2);
      double lashHeight = 20.0 * scaleX;
      double lashWidth = 30.0 * scaleY;

      topPos = bottomPos + (upDir * lashHeight);

      // Pelebaran
      topPos = Offset(topPos.dx + (lashWidth * (i / count - 0.5)), topPos.dy);
      bottomPos = Offset(bottomPos.dx + (lashWidth * (i / count - 0.5)), bottomPos.dy);

      // ROTASI sederhana (pivot tengah)
      double eyelashRotationDeg = (isRightEyebrow) ? 15.0 : 30.0;
      double angle = eyelashRotationDeg * math.pi / 180.0;
      final pivot = Offset((topPos.dx + bottomPos.dx) / 2.0, (topPos.dy + bottomPos.dy) / 2.0);

      Offset rotate(Offset p) {
        double x = p.dx - pivot.dx;
        double y = p.dy - pivot.dy;
        double cosA = math.cos(angle);
        double sinA = math.sin(angle);
        double rx = x * cosA - y * sinA;
        double ry = x * sinA + y * cosA;
        return Offset(rx + pivot.dx, ry + pivot.dy);
      }

      topPos = rotate(topPos);
      bottomPos = rotate(bottomPos);
    }

    vertices.add(topPos);
    vertices.add(bottomPos);

    double u = (count > 1) ? i / (count - 1) : 0.0;
    double slideX = isRightEyebrow ? -35 : -10.0;
    double texWidth = u * texture.width + slideX;
    double texHeight = 1.0 * texture.height;

    textureCoords.add(Offset(texWidth, 0.0));
    textureCoords.add(Offset(texWidth, texHeight.toDouble()));
  }

  // Paint untuk menggambar texture mesh (semua jenis termasuk lip)
  final Paint paint = Paint()
    ..shader = ui.ImageShader(
      texture,
      TileMode.clamp,
      TileMode.clamp,
      Float64List.fromList(Matrix4.identity().storage),
    )
    ..filterQuality = FilterQuality.medium;

  if (isEyebrow) {
    paint.colorFilter = ColorFilter.mode(color.withOpacity(eyebrowOpacity), BlendMode.srcIn);
    paint.blendMode = BlendMode.multiply;
  } else if (isEyelash) {
    paint.colorFilter = ColorFilter.mode(color.withOpacity(eyelashOpacity), BlendMode.srcIn);
    paint.blendMode = BlendMode.multiply;
  } else {
    paint.colorFilter = ColorFilter.mode(color.withOpacity(lipOpacity), BlendMode.srcIn);
    paint.blendMode = BlendMode.multiply;
  }

  final ui.Vertices meshVertices = ui.Vertices(
    VertexMode.triangleStrip,
    vertices,
    textureCoordinates: textureCoords,
  );

  // Gambar mesh texture pertama (base)
  canvas.drawVertices(meshVertices, BlendMode.modulate, paint);

  // Jika lip -> overlay ombre gradient dengan cara CLIP PATH (tidak pakai saveLayer)
  if (isLip && vertices.isNotEmpty) {
    // Bentuk path dari vertices: top sequence lalu bottom reversed
    final Path lipPath = Path();
    // Ambil top vertices urut: indices 0,2,4,... (karena kita push top,bottom)
    final int vertCount = vertices.length ~/ 2; // jumlah pasang
    if (vertCount > 0) {
      // top
      lipPath.moveTo(vertices[0].dx, vertices[0].dy);
      for (int i = 0; i < vertCount; i++) {
        final Offset topV = vertices[i * 2];
        lipPath.lineTo(topV.dx, topV.dy);
      }
      // bottom reversed
      for (int i = vertCount - 1; i >= 0; i--) {
        final Offset bottomV = vertices[i * 2 + 1];
        lipPath.lineTo(bottomV.dx, bottomV.dy);
      }
      lipPath.close();

      // Hitung center & maxDist
      Offset lipCenter = Offset.zero;
      for (final p in vertices) lipCenter = lipCenter + p;
      lipCenter = Offset(lipCenter.dx / vertices.length, lipCenter.dy / vertices.length);

      double maxDist = 0.0;
      for (final p in vertices) {
        final d = (p - lipCenter).distance;
        if (d > maxDist) maxDist = d;
      }
      if (maxDist <= 0.1) maxDist = 20.0;

      // Gradient ombre: dalam lebih pekat, luar lebih soft
      final double innerIntensity = 1.15; // tweakable
      final double outerIntensity = 0.002; // tweakable

      final shaderPaint = Paint()
        ..shader = ui.Gradient.radial(
          lipCenter,
          maxDist,
          [
            color.withOpacity((lipOpacity * innerIntensity).clamp(0.0, 1.0)),
            color.withOpacity((lipOpacity * outerIntensity).clamp(0.0, 1.0)),
          ],
          [0.0, 1.0],
          TileMode.clamp,
        )
        ..blendMode = BlendMode.srcATop;

      // Clip dan gambar gradient overlay pada bounding rect lip
      // Gunakan save/restore seimbang
      // Compute bounding rect
      double minX = double.infinity, minY = double.infinity, maxX = -double.infinity, maxY = -double.infinity;
      for (final p in vertices) {
        if (p.dx < minX) minX = p.dx;
        if (p.dy < minY) minY = p.dy;
        if (p.dx > maxX) maxX = p.dx;
        if (p.dy > maxY) maxY = p.dy;
      }
      final Rect drawRect = Rect.fromLTRB(minX - 8, minY - 8, maxX + 8, maxY + 8);

      canvas.save(); // <-- harus dipasangkan dengan restore()
      canvas.clipPath(lipPath);
      canvas.drawRect(drawRect, shaderPaint);
      canvas.restore(); // <-- pasangan
    }
  }
}



double _computeLipDistanceFactor(Offset pos, Offset center, double maxDist) {
  double d = (pos - center).distance;
  double t = (d / maxDist).clamp(0.0, 1.0);
  return 1.0 - t; // 1.0 bagian dalam, 0.0 bagian luar
}
  void _drawCheeks(
    Canvas canvas,
    List<FaceMeshPoint> allPoints,
    double scaleX,
    double scaleY,
    Color color,
  ) {
    _drawSingleCheek(
      canvas,
      allPoints,
      FaceKeypoints.LEFT_CHEEK_CONTOUR,
      scaleX,
      scaleY,
      color,
    );
    _drawSingleCheek(
      canvas,
      allPoints,
      FaceKeypoints.RIGHT_CHEEK_CONTOUR,
      scaleX,
      scaleY,
      color,
    );
  }

  void _drawSingleCheek(
    Canvas canvas,
    List<FaceMeshPoint> allPoints,
    List<int> contourIndices,
    double scaleX,
    double scaleY,
    Color color,
  ) {
    final Path cheekPath = _createContourPath(
      allPoints,
      contourIndices,
      scaleX,
      scaleY,
    );
    final Rect bounds = cheekPath.getBounds();
    final Paint paint = Paint()
      ..shader = ui.Gradient.radial(
        bounds.center,
        math.max(bounds.width, bounds.height) * 0.7,
        [color.withOpacity(cheekOpacity), color.withOpacity(0.0)],
        [0.2, 1.0],
      )
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.multiply
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, _kCheekBlurSigma);

    canvas.drawPath(cheekPath, paint);
  }

  void _drawFaceSkinWithHoles(
    Canvas canvas,
    List<FaceMeshPoint> allPoints,
    double scaleX,
    double scaleY,
    Color color,
  ) {
    final Path facePath = _createContourPath(
      allPoints,
      FaceKeypoints.FACE_OVAL,
      scaleX,
      scaleY,
    );
    final Path leftEyePath = _createContourPath(
      allPoints,
      FaceKeypoints.LEFT_EYE_CONTOUR,
      scaleX,
      scaleY,
    );
    final Path rightEyePath = _createContourPath(
      allPoints,
      FaceKeypoints.RIGHT_EYE_CONTOUR,
      scaleX,
      scaleY,
    );
    final Path leftEyebrowPath = _createContourPath(
      allPoints,
      FaceKeypoints.LEFT_EYEBROW_CONTOUR,
      scaleX,
      scaleY,
    );
    final Path rightEyebrowPath = _createContourPath(
      allPoints,
      FaceKeypoints.RIGHT_EYEBROW_CONTOUR,
      scaleX,
      scaleY,
    );
    final Path lipsOutlinePath = _createContourPath(
      allPoints,
      FaceKeypoints.outterLipContourIndices,
      scaleX,
      scaleY,
    );

    Path skinPath = Path.combine(
      PathOperation.difference,
      facePath,
      leftEyePath,
    );
    skinPath = Path.combine(PathOperation.difference, skinPath, rightEyePath);
    skinPath = Path.combine(
      PathOperation.difference,
      skinPath,
      leftEyebrowPath,
    );
    skinPath = Path.combine(
      PathOperation.difference,
      skinPath,
      rightEyebrowPath,
    );
    skinPath = Path.combine(
      PathOperation.difference,
      skinPath,
      lipsOutlinePath,
    );

    final Paint paint = Paint()
      ..color = color.withOpacity(skinOpacity)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.color
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, _kFaceBlurSigma);

    canvas.drawPath(skinPath, paint);
  }

  void _drawIris(
    Canvas canvas,
    List<FaceMeshPoint> allPoints,
    List<int> eyeContourIndices,
    double scaleX,
    double scaleY,
    Paint paint,
  ) {
    final List<Offset> eyePoints = eyeContourIndices.map((index) {
      final point = allPoints[index];
      return Offset(point.x * scaleX, point.y * scaleY);
    }).toList();

    if (eyePoints.isEmpty) return;

    final Path eyePath = Path()..addPolygon(eyePoints, true);
    final Rect eyeBounds = eyePath.getBounds();
    final Offset eyeCenter = eyeBounds.center;
    final double irisRadius = eyeBounds.width * 0.20;

    canvas.drawCircle(eyeCenter, irisRadius, paint);
  }

  Path _createContourPath(
    List<FaceMeshPoint> allPoints,
    List<int> contourIndices,
    double scaleX,
    double scaleY,
  ) {
    final path = Path();
    List<Offset> points = [];

    for (final index in contourIndices) {
      final point = allPoints[index];
      points.add(Offset(point.x * scaleX, point.y * scaleY));
    }
    path.addPolygon(points, true);
    return path;
  }

  @override
  bool shouldRepaint(covariant FaceMeshPainter oldDelegate) {
    return oldDelegate.meshes != meshes ||
        oldDelegate.originalImageSize != originalImageSize ||
        oldDelegate.blushColor != blushColor ||
        oldDelegate.strokes != strokes ||
        oldDelegate.applyLipColor != applyLipColor ||
        oldDelegate.lipstickColor != lipstickColor ||
        oldDelegate.applyIrisColor != applyIrisColor ||
        oldDelegate.irisColor != irisColor ||
        oldDelegate.upperLipTexture != upperLipTexture ||
        oldDelegate.lowerLipTexture != lowerLipTexture ||
        oldDelegate.selectedStyle != selectedStyle ||
        oldDelegate.applyFaceSkin != applyFaceSkin ||
        oldDelegate.faceSkinColor != faceSkinColor ||
        oldDelegate.applyCheekColor != applyCheekColor ||
        oldDelegate.cheekColor != cheekColor ||
        oldDelegate.skinOpacity != skinOpacity ||
        oldDelegate.lipOpacity != lipOpacity ||
        oldDelegate.irisOpacity != irisOpacity ||
        oldDelegate.cheekOpacity != cheekOpacity ||
        oldDelegate.eyebrowOpacity != eyebrowOpacity ||
        oldDelegate.eyelashOpacity != eyelashOpacity ||
        oldDelegate.applyEyelashColor != applyEyelashColor ||
        oldDelegate.leftEyelashTexture != leftEyelashTexture ||
        oldDelegate.rightEyelashTexture != rightEyelashTexture ||
        oldDelegate.applyEyebrowColor != applyEyebrowColor ||
        oldDelegate.eyebrowColor != eyebrowColor ||
        oldDelegate.eyebrowStyle != eyebrowStyle;
  }
}
