import 'package:flutter/material.dart';

Widget ItemProfile({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isLastItem = false,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Icon(
            icon,
            color: Colors.black87, // Warna ikon agak gelap
            size: 26,
          ),
          title: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios, // Ikon panah kanan khas iOS
            size: 16,
            color: Colors.black54,
          ),
        ),
        // Garis Pembatas (Divider)
        if (!isLastItem)
          const Divider(
            height: 1,
            thickness: 1,
            indent: 20, // Memberi jarak dari kiri (opsional)
            endIndent: 20, // Memberi jarak dari kanan (opsional)
            color: Colors.black12,
          ),
      ],
    );
  }
