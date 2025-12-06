import 'package:meyoi/app/modules/coba/controller/coba_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditingWidget extends StatelessWidget {
  const EditingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Get.find() untuk mendapatkan instance controller yang sudah ada
    final CobaController controller = Get.find<CobaController>();

    return Obx(() {
      // Sembunyikan semua kontrol jika tidak ada gambar yang dipilih
      if (controller.selectedImage.value == null) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Kontrol untuk Mode Kuas dan Penghapus
            _buildModeToggles(controller),
            const SizedBox(height: 16),
            // Slider untuk Ukuran Kuas
            if (controller.isPainting.value || controller.isErasing.value)
              _buildBrushSizeSlider(controller),
            SizedBox(height: 16),
            _ColorPalette(
              selectedColor: controller.isLipColored.value
                  ? controller.lipColor.value
                  : controller.blushColor.value,
              onColorSelected: (color) {
                controller.changeActiveColor(color);
              },
            ),
          ],
        ),
      );
    });
  }

  // Widget untuk tombol mode
  Widget _buildModeToggles(CobaController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Blush Wajah Otomatis (Default)
        Tooltip(
          message: 'Blush Otomatis',
          child: IconButton(
            icon: Icon(
              Icons.face_retouching_natural,
              size: 30,
              color:
                  !controller.isPainting.value &&
                      !controller.isErasing.value &&
                      !controller.isLipColored.value
                  ? Colors.blueAccent
                  : Colors.grey,
            ),
            onPressed: () => controller.paintMode(), // Bisa diubah jika perlu
          ),
        ),
        const SizedBox(width: 20),
        // Tombol Warna Bibir
        Tooltip(
          message: 'Mode Warna Bibir',
          child: IconButton(
            icon: Icon(
              Icons
                  .sports_gymnastics_rounded, // Menggunakan ikon kuas untuk bibir
              size: 30,
              color: controller.isLipColored.value
                  ? Colors.blueAccent
                  : Colors.grey,
            ),
            onPressed: () => controller.LipColorMode(),
          ),
        ),
        const SizedBox(width: 20),
        // --- TOMBOL BARU ---
        Tooltip(
          message: 'Mode Warna Mata',
          child: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              size: 30,
              color: controller.isIrisColored.value
                  ? Colors.blueAccent
                  : Colors.grey,
            ),
            onPressed: () => controller.IrisColorMode(),
          ),
        ),

        const SizedBox(width: 20),
        // Tombol Kuas Manual
        Tooltip(
          message: 'Mode Kuas Manual',
          child: IconButton(
            icon: Icon(
              Icons.edit,
              size: 30,
              color: controller.isPainting.value
                  ? Colors.blueAccent
                  : Colors.grey,
            ),
            onPressed: () => controller.paintMode(),
          ),
        ),
        const SizedBox(width: 20),
        // Tombol Penghapus
        Tooltip(
          message: 'Mode Penghapus',
          child: IconButton(
            icon: Icon(
              Icons.cleaning_services_rounded,
              size: 30,
              color: controller.isErasing.value
                  ? Colors.blueAccent
                  : Colors.grey,
            ),
            onPressed: () => controller.erasedMode(),
          ),
        ),
      ],
    );
  }

  // Widget untuk slider ukuran kuas
  Widget _buildBrushSizeSlider(CobaController controller) {
    return Column(
      children: [
        Text(
          'Ukuran Kuas: ${controller.brushSize.value.toStringAsFixed(1)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: controller.brushSize.value,
          min: 5.0,
          max: 50.0,
          divisions: 9, // (50-5) / 5
          label: controller.brushSize.value.toStringAsFixed(1),
          onChanged: (value) {
            controller.changeBlushSize(value);
          },
        ),
      ],
    );
  }
}

// Widget _ColorPalette dipindahkan ke sini
class _ColorPalette extends StatelessWidget {
  const _ColorPalette({
    required this.selectedColor,
    required this.onColorSelected,
  });

  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      Color.fromRGBO(255, 220, 190, 0.9),
      Color.fromRGBO(230, 190, 150, 0.9),
      Color.fromRGBO(160, 115, 80, 0.9),
      Color.fromRGBO(70, 55, 40, 1),
      Colors.redAccent.withOpacity(0.7),
      Colors.blueAccent,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.map((color) {
        final bool isSelected = selectedColor.value == color.value;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.blueAccent, width: 3)
                  : Border.all(color: Colors.grey.shade300, width: 1),
            ),
          ),
        );
      }).toList(),
    );
  }
}
