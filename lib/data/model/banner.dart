class BannerChampin {
  String? id;
  String? collectionId;
  String? thumbnail;
  String? categoryId;

  BannerChampin(this.id, this.collectionId, this.thumbnail, this.categoryId);

  factory BannerChampin.fromJson(Map<String, dynamic> jsonObject) {
    return BannerChampin(
      jsonObject['id'],
      jsonObject['collectionId'],
      'http://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['categoryId'],
    );
  }
}
