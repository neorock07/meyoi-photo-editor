import 'dart:ui';
import 'stroke_model.dart';

class EditorState {
  final List<BrushStroke> paintedPoints;
  final bool isLipColored;
  final Color lipColor;
  final bool isIrisColored;
  final Color irisColor;
  final bool isFaceColored;
  final Color faceColor;
  final bool isCheekColored;
  final Color cheekColor;
  final bool isEyebrowColored;
  final Color eyebrowColor;
  final String eyebrowStyle;
  final bool isEyelashColored;
  final String eyelashStyle;

  EditorState({
    required this.paintedPoints,
    required this.isLipColored,
    required this.lipColor,
    required this.isIrisColored,
    required this.irisColor,
    required this.isFaceColored,
    required this.faceColor,
    required this.isCheekColored,
    required this.cheekColor,
    required this.isEyebrowColored,
    required this.eyebrowColor,
    required this.eyebrowStyle,
    required this.isEyelashColored,
    required this.eyelashStyle,
  });

  // CopyWith untuk memudahkan pembuatan state baru
  EditorState copyWith({
    List<BrushStroke>? paintedPoints,
    bool? isLipColored,
    Color? lipColor,
    bool? isIrisColored,
    Color? irisColor,
    bool? isFaceColored,
    Color? faceColor,
    bool? isCheekColored,
    Color? cheekColor,
    bool? isEyebrowColored,
    Color? eyebrowColor,
    String? eyebrowStyle,
    bool? isEyelashColored,
    String? eyelashStyle,
  }) {
    return EditorState(
      paintedPoints: paintedPoints ?? List.from(this.paintedPoints),
      isLipColored: isLipColored ?? this.isLipColored,
      lipColor: lipColor ?? this.lipColor,
      isIrisColored: isIrisColored ?? this.isIrisColored,
      irisColor: irisColor ?? this.irisColor,
      isFaceColored: isFaceColored ?? this.isFaceColored,
      faceColor: faceColor ?? this.faceColor,
      isCheekColored: isCheekColored ?? this.isCheekColored,
      cheekColor: cheekColor ?? this.cheekColor,
      isEyebrowColored: isEyebrowColored ?? this.isEyebrowColored,
      eyebrowColor: eyebrowColor ?? this.eyebrowColor,
      eyebrowStyle: eyebrowStyle ?? this.eyebrowStyle,
      isEyelashColored: isEyelashColored ?? this.isEyelashColored,
      eyelashStyle: eyelashStyle ?? this.eyelashStyle,
    );
  }
}