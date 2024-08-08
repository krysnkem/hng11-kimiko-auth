import 'dart:math';

List<String> images = [
  "https://img.freepik.com/free-photo/cartoon-character-with-handbag-sunglasses_71767-99.jpg",
  "https://img.freepik.com/free-photo/cartoon-man-wearing-glasses_23-2151136883.jpg",
  "https://img.freepik.com/free-photo/androgynous-avatar-non-binary-queer-person_23-2151100278.jpg",
  "https://img.freepik.com/free-photo/cartoon-man-wearing-glasses_23-2151136782.jpg"
];

String getRandomImage(){
  Random random = Random();
  String image = images[ random.nextInt(images.length-1)];
  return image;
}