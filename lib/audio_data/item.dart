class PlaylistItem {
  final String id;
  final String title;
  final String url;
  final String thumbnailUrl;
  final String stars;
  final String ifpaid;
  final String album_name;
  final String album_image;
  String favorite;

  PlaylistItem(
  {
    this.stars='2.3',
    this.id,
    this.title,
    this.thumbnailUrl,
    this.url,
    this.ifpaid,
    this.album_name,
    this.album_image,
    this.favorite,
    }
  );
}
