class Post {
  String authorName;
  String authorImageUrl;
  String timeAgo;
  String imageUrl;

  Post({
    this.authorName,
    this.authorImageUrl,
    this.timeAgo,
    this.imageUrl,
  });
}

final List<Post> posts = [
  Post(
    authorName: 'Sam Martin',
    authorImageUrl: 'assets/images/user0.png',
    timeAgo: '5 min',
    imageUrl: 'assets/images/garlicbread.jpg',
  ),
  Post(
    authorName: 'Jane Doe',
    authorImageUrl: 'assets/images/post0.jpg',
    timeAgo: '10 min',
    imageUrl: 'assets/images/macandcheese.jpg',
  ),
];

final List<String> stories = [
  'assets/images/user1.png',
  'assets/images/user2.png',
  'assets/images/user3.png',
  'assets/images/user4.png',
  'assets/images/user0.png',
  'assets/images/user1.png',
  'assets/images/user2.png',
  'assets/images/user3.png',
];
