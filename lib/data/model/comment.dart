class Comment {
  String id;
  String text;
  String productId;
  String userId;
  String userThumbnailUrl;
  String username;
  String avatar;

  Comment(this.id, this.productId, this.text, this.userId, this.avatar,
      this.username, this.userThumbnailUrl);
  factory Comment.fromMapJson(Map<String, dynamic> jsonObject) {
    return Comment(
        jsonObject['id'],
        jsonObject['product_id'],
        jsonObject['text'] ?? "",
        jsonObject['user_id'] ?? "",
        'http://startflutter.ir/api/files/${jsonObject['expand']['user_id']['collectionName']}/${jsonObject['expand']['user_id']['id']}/${jsonObject['expand']['user_id']['avatar']}',
        jsonObject['expand']['user_id']['name'],
        jsonObject['expand']['user_id']['avatar']);
  }
}
