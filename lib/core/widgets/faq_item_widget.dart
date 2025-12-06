import 'package:flutter/material.dart';

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  final bool initiallyExpanded;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
    this.initiallyExpanded = false,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  late bool _isExpanded;

  // Warna sesuai gambar (kira-kira)
  final Color _collapsedBgColor = const Color(0xFFEACCD6); // Pink muda solid
  final Color _expandedBorderColor = const Color(0xFFC46A83); // Pink tua (border)
  final Color _expandedIconBgColor = const Color(0xFFEACCD6); // Pink muda (icon bg)

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        // Logika Background: Jika expanded Putih, jika collapsed Pink
        color: _isExpanded ? Colors.white : _collapsedBgColor,
        
        // Logika Border: Jika expanded ada border Pink, jika collapsed tidak ada
        border: _isExpanded 
            ? Border.all(color: _expandedBorderColor, width: 1.5) 
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      // ClipRRect agar konten tidak keluar dari rounded corners
      child: Theme(
        // Menghilangkan garis divider bawaan ExpansionTile
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: widget.initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          
          // Logika perubahan state
          onExpansionChanged: (bool expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          
          // Judul Pertanyaan
          title: Text(
            widget.question,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Ikon Panah Kustom (Dalam Lingkaran)
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isExpanded ? _expandedIconBgColor : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.black87,
              size: 20,
            ),
          ),
          
          // Isi Jawaban
          children: [
            Text(
              widget.answer,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.5, // Spasi antar baris teks
              ),
            ),
          ],
        ),
      ),
    );
  }
}