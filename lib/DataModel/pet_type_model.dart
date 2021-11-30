class PetTypeModel {
  String name;
  String petImage;
  bool isSelected;
  int backgroundColor;

  PetTypeModel(
      {this.name, this.petImage, this.isSelected, this.backgroundColor});
}

final List<PetTypeModel> petYpeList = [
  PetTypeModel(
      name: "Dog",
      petImage: "assets/gif/dggif.gif",
      isSelected: false,
      backgroundColor: 0xff9984FF),
  PetTypeModel(
      name: "Cat",
      petImage: "assets/gif/cttgif.gif",
      isSelected: false,
      backgroundColor: 0xffC1FFF9),
  PetTypeModel(
      name: "Bird",
      petImage: "assets/gif/brdgif.gif",
      isSelected: false,
      backgroundColor: 0xffE5A7AD),
  PetTypeModel(
    name: "Others",
    petImage: "assets/gif/rbt.gif",
    isSelected: false,
    backgroundColor: 0xffE9FFFD,
  ),
];
//https://d2m3ee76kdhdjs.cloudfront.net/static_assets/app/cttgif.gif
