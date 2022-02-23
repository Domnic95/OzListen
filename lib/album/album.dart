class Album {
  String id;
  String title;
  String url;
  String thumbnailUrl;
  String stars;
  String ifpaid;
  String image;
  String author;
  String dateCreated;
  String description;
  String status;
  String price;
  String rating;
  String sort;
  String total_reviews;
  String avarge_reviews;
  bool current_user_paid;
  String base_url;

  Album({this.id, this.title, this.url, this.thumbnailUrl,this.stars,this.ifpaid, this.author, this.description, this.status, this.dateCreated, this.price, this.rating, this.sort, this.total_reviews, this.avarge_reviews, this.current_user_paid, this.base_url, this.image});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      dateCreated: json['date_created'] as String,
      status: json['status'] as String,
      thumbnailUrl: json['image'] as String,
      ifpaid: json['ifpaid'] as String,
      image: json['image'] as String,

      price: json['price'] as String,
      rating: json['rating'] as String,
      sort: json['sort'] as String,
      total_reviews: json['total_reviews'] as String,
      avarge_reviews: json['avarge_reviews'] as String,
      current_user_paid: json['current_user_paid'] as bool,
      base_url: json['base_url"'] as String,
    );
  }
}
