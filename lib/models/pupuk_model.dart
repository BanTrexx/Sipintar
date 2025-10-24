class PupukModel {
  String name;
  String price;
  String imgpath;

  PupukModel({
    required this.name,
    required this.price,
    required this.imgpath,
  });

  static List<PupukModel> getPupuk() {
    List<PupukModel> pupuk = [];

    pupuk.add(PupukModel(
      name: "Pupuk NPK Organik", 
      price: "Rp. xxxx", 
      imgpath: 'assets/images/05.png'
    ));

    pupuk.add(PupukModel(
      name: "Pupuk KCL", 
      price: "Rp. xxxx", 
      imgpath: 'assets/images/02.png'
    ));

    pupuk.add(PupukModel(
      name: "Pupuk Urea", 
      price: "Rp. xxxx", 
      imgpath: 'assets/images/03.png'
    ));

    pupuk.add(PupukModel(
      name: "Pupuk ZA", 
      price: "Rp. xxxx", 
      imgpath: 'assets/images/03.png'
    ));

    return pupuk;
  }
}