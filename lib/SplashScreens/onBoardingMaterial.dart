class UnbordingContent {
  String image;
  String title1;
  String title2;
  String subtitle;
  String discription;

  UnbordingContent(
      {required this.image,
        required this.title1,
        required this.title2,
        required this.subtitle,
        required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title1: 'Life is short and the',
      title2: 'world is ',
      subtitle: 'wide',
      image: 'assets/images/a2.jpg',
      discription: "At Friends tours and travel, we customize "
          "reliable and trutworthy educational tours to "
          "destinations all over the world "),
  UnbordingContent(
      title1: "It's a big world out",
      title2: 'there go ',
      subtitle: 'explore',
      image: 'assets/images/a3.jpg',
      discription: "At Friends tours and travel, we customize "
          "reliable and trutworthy educational tours to "
          "destinations all over the world "),
  UnbordingContent(
      title1: "People don't take trips,",
      title2: 'trips take ',
      subtitle: 'People',
      image: 'assets/images/a4.jpg',
      discription: "At Friends tours and travel, we customize "
          "reliable and trutworthy educational tours to "
          "destinations all over the world "),
];
