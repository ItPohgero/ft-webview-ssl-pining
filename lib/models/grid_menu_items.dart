import 'dart:convert';

class GridMenuItem {
  final String title;
  final String imageUrl;
  bool visible;

  GridMenuItem({
    required this.title,
    required this.imageUrl,
    this.visible = true,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'imageUrl': imageUrl,
    'visible': visible,
  };

  factory GridMenuItem.fromJson(Map<String, dynamic> json) => GridMenuItem(
    title: json['title'] as String,
    imageUrl: json['imageUrl'] as String,
    visible: json['visible'] as bool? ?? true,
  );
}
