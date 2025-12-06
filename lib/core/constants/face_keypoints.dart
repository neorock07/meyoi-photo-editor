class FaceKeypoints {
  FaceKeypoints._();

  static final List<int> LIP = [
    // Bibir Luar & Dalam (tetap digunakan untuk pengecekan umum)
    61, 146, 91, 181, 84, 17, 314, 405, 321, 375, 291, 409, 270, 269, 267, 0, 37, 39, 40, 185,
    78, 95, 88, 178, 87, 14, 317, 402, 318, 324, 308, 415, 310, 311, 312, 13, 82, 81, 80, 191,
  ];

  static final List<int> outterLipContourIndices = [
    61, 146, 91, 181, 84, 17, 314, 405, 321, 375, 291, 409, 270, 269, 267, 0, 37, 39, 40, 185,
  ];
  static final List<int> innerLipContourIndices = [
    78, 95, 88, 178, 87, 14, 317, 402, 318, 324, 308, 415, 310, 311, 312, 13, 82, 81, 80, 191,
  ];

  // --- PERBAIKAN: Hapus indeks kornea mata yang salah ---
  // static final int rightIrisCenterIndex = 468; // INI SALAH
  // static final int leftIrisCenterIndex = 473; // INI SALAH

  // --- GANTI DENGAN KONTUR MATA UNTUK MENGHITUNG PUSAT ---
  static final List<int> LEFT_EYE_CONTOUR = [33, 246, 161, 160, 159, 158, 157, 173, 133, 155, 154, 153, 145, 144, 163, 7];
  static final List<int> RIGHT_EYE_CONTOUR = [362, 466, 388, 387, 386, 385, 384, 398, 263, 249, 390, 373, 374, 380, 381, 382];

  // Keypoints untuk Bounding Box Bibir Atas
  static final List<int> UPPER_LIP_OUTER_CONTOUR = [61, 185, 40, 39, 37, 0, 267, 269, 270, 409, 291];
  static final List<int> UPPER_LIP_INNER_CONTOUR = [61, 191, 80, 81, 82, 13, 312, 311, 310, 415, 291];
  
  static final List<int> LEFT_CHEEK_CONTOUR = [
    116, 123, 147, 213, 192, 214, 212, 57, 186, 50, 205, 207, 121, 47, 100
  ];

  // Area Pipi Kanan (Tulang Pipi & Apple of Cheek)
  static final List<int> RIGHT_CHEEK_CONTOUR = [
    345, 352, 376, 433, 416, 434, 432, 287, 410, 280, 425, 427, 350, 277, 329
  ];


   static final List<int> FACE_OVAL = [
    10, 338, 297, 332, 284, 251, 389, 356, 454, 323, 361, 288, 397, 365, 379, 378, 
    400, 377, 152, 148, 176, 149, 150, 136, 172, 58, 132, 93, 234, 127, 162, 21, 
    54, 103, 67, 109
  ];

  // Keypoints untuk Bounding Box Bibir Bawah
  static final List<int> LOWER_LIP_OUTER_CONTOUR = [61, 146, 91, 181, 84, 17, 314, 405, 321, 375, 291];
  static final List<int> LOWER_LIP_INNER_CONTOUR = [61, 78, 95, 88, 178, 87, 14, 317, 402, 318, 324, 308, 291];

  // Titik patokan penting
  static final int LIP_TOP_CENTER = 0;
  static final int LIP_BOTTOM_CENTER = 17;
  static final int LIP_LEFT_CORNER = 61;
  static final int LIP_RIGHT_CORNER = 291;
  
  static final List<int> LEFT_EYEBROW_CONTOUR = [70, 63, 105, 66, 107, 55, 65, 52, 53, 46];
  static final List<int> RIGHT_EYEBROW_CONTOUR = [336, 296, 334, 293, 300, 285, 295, 282, 283, 276];
  

 // Alis Kiri
  static final List<int> LEFT_EYEBROW_TOP = [285, 295, 282, 283, 76]; 
  static final List<int> LEFT_EYEBROW_BOTTOM = [336, 296, 334, 293, 300]; 
  // Ditambahkan titik 34 dan 244 untuk mencakup lebih banyak area ujung luar dan dalam alis

  // Alis Kanan
  static final List<int> RIGHT_EYEBROW_TOP = [70, 63, 105, 66, 107]; 
  static final List<int> RIGHT_EYEBROW_BOTTOM = [46, 53, 52, 65, 55];
  
    // Untuk Warping, kita gunakan titik kelopak mata atas sebagai dasar.
  static final List<int> LEFT_EYELASH_BASE = [362, 382, 381, 380, 374, 373, 390, 249, 263];

  // Bulu Mata Kanan (Urutan: Dalam -> Luar)
  static final List<int> RIGHT_EYELASH_BASE = [133, 173, 157, 158, 159, 160, 161, 246, 33];


  static final List<int> LEFT_EYELASH_TOP = [386, 385, 384, 398, 362]; 
  static final List<int> LEFT_EYELASH_BOTTOM = [249, 263, 466, 388, 387];

// Mata Kanan
static final List<int> RIGHT_EYELASH_TOP = [159, 158, 157, 173, 133];
static final List<int> RIGHT_EYELASH_BOTTOM = [22, 23, 24, 110, 243];

  static final Set<int> EYE_LEFT = {
    33, 7, 163, 144, 145, 153, 154, 155, 133, 173, 157, 158, 159, 160, 161, 246,
  };
  static final Set<int> EYE_RIGHT = {
    362, 382, 381, 380, 373, 374, 390, 249, 263, 466, 388, 37, 386, 385, 384, 398,
  };

  static final Set<int> EYEBROW_LEFT = {
    70, 63, 105, 66, 107, 55, 65, 52, 53, 46,
  };

  static final Set<int> EYEBROW_RIGHT = {
    336, 296, 334, 293, 300, 285, 295, 282, 283, 276,8
  };

  static final Set<int> EXCLUDE_KEYPOINTS = {
    // Bibir Dalam
    78, 95, 88, 178, 87, 14, 317, 402, 318, 324, 308, 415, 310, 311, 312, 13, 82, 81, 80, 191,
    // Mata Kiri
    33, 7, 163, 144, 145, 153, 154, 155, 133, 173, 157, 158, 159, 160, 161, 246,
    // Mata Kanan
    362, 382, 381, 380, 373, 374, 390, 249, 263, 466, 388, 387, 386, 385, 384, 398,
    // Alis Kiri
    70, 63, 105, 66, 107, 55, 65, 52, 53, 46,
    // Alis Kanan
    336, 296, 334, 293, 300, 285, 295, 282, 283, 276,
  };
}