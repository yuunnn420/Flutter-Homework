class Restaurant {
  String title;
  String plot;
  String imagePath;

  Restaurant({
    required this.title,
    required this.plot,
    required this.imagePath,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json){
    const nullImage = 'asset/null.jpg';
    return Restaurant(
        title: json['name'] as String,
        imagePath:
        (json['photo']['images'] == null)
            ? nullImage
            : json['photo']['images']['original']['url'],
        plot: (json['description'] == null)
        ? 'no desc'
        : json['description'],
    );
  }
}
