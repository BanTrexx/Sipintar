  import 'package:flutter/material.dart';
  import 'package:flutter_svg/flutter_svg.dart';
  import 'package:pintar/models/type_model.dart';
  import 'package:pintar/api_service.dart'; 
  import 'package:pintar/pages/track_transactions.dart';
  import 'package:pintar/pages/product.dart';
  import 'package:intl/intl.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    List<TypeModel> type = [];
    List<dynamic> pupuk = []; // dari API

    @override
    void initState() {
      super.initState();
      _initModels();
    }

    void _initModels() async {
      type = TypeModel.getType();
      try {
        final data = await ApiService().getAllProducts();
        setState(() {
          pupuk = data;
        });
      } catch (e) {
        print('Gagal mengambil produk dari API: $e');
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: appBar(),
        ),
        body: _body(),
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Colors.white,
        //   showSelectedLabels: false,  // Sembunyikan label
        //   showUnselectedLabels: false, 
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(
        //         'assets/icons/home.svg',
        //         width: 40,
        //         height: 40,
        //       ),
        //       label: ' '
        //     ),
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(
        //         'assets/icons/pin.svg',
        //         width: 40,
        //         height: 40,
        //       ),
        //       label: ' '
        //     ),
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(
        //         'assets/icons/circle.svg',
        //         width: 40,
        //         height: 40,
        //       ),
        //       label: ' '
        //     ),
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(
        //         'assets/icons/layout.svg',
        //         width: 40,
        //         height: 40,
        //       ),
        //       label: ' '
        //     ),
        //   ],
        // ),
      );
    }

    Widget _body() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchBar(),
            SizedBox(height: 20),
            // _categories(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrackTransactionPage()),
                  );
                },
                icon: Icon(Icons.search),
                label: Text("Lacak Transaksi"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            _products(),
          ],
        ),
      );
    }

    
    Column _products() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Direkomendasikan",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),        
            SizedBox(
              height: 500,
              child : GridView.builder(
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Jumlah kolom
                  crossAxisSpacing: 20, // Jarak antar kolom
                  mainAxisSpacing: 20, // Jarak antar baris
                  childAspectRatio: 0.8, // Rasio aspek item grid
                ),
                itemCount: pupuk.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    productId: pupuk[index]['id'],
                    name: pupuk[index]['name'],
                    price: pupuk[index]['price'].toString(),
                    image: pupuk[index]['image_url'] != null ? "https://innovillage-sipintar-api.onrender.com/${pupuk[index]['image_url']}" : "assets/images/01.png",
                    description: pupuk[index]['description'],
                  );
                },
              ),
            )
          ],
        );
    }

    // Column _categories() {
    //   return Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(
    //           height: 150,
    //           child: ListView.separated(
    //             itemCount: type.length,
    //             scrollDirection: Axis.horizontal,
    //             padding: EdgeInsets.only(
    //               left: 0,
    //               right: 0
    //             ),
    //             separatorBuilder: (context, index) => SizedBox(width: 0),
    //             itemBuilder: (context, index) {
    //               return Container(
    //                 margin: EdgeInsets.all(20),
    //                 width: 250,
    //                 decoration: BoxDecoration(
    //                   color: type[index].boxColor,
    //                   boxShadow: [
    //                     type[index].shadowBox
    //                   ],
    //                   borderRadius: BorderRadius.circular(20)
    //                 ),
    //                 child: Row(
    //                   children: [
    //                     Container(
    //                       margin: EdgeInsets.all(15),
    //                       width: 60,
    //                       height: 60,
    //                       child: SvgPicture.asset(type[index].iconpath),
    //                     ),
    //                     Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         Text(
    //                           type[index].name,
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.w600,
    //                             color: Colors.black,
    //                             fontSize: 20
    //                           ),
    //                         ),
    //                         Text(
    //                           "Rp. xxxx",
    //                           style: TextStyle(
    //                             fontWeight: FontWeight.w500,
    //                             color: Colors.black.withAlpha(100),
    //                             fontSize: 20
    //                           ),
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               );
    //             }
    //           ),
    //         )
    //       ],
    //     );
    // }

    Container _searchBar() {
      return Container(
            height: 60,
            margin: EdgeInsets.only(top: 25, left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffdddddd)
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff111111).withAlpha(100),
                  blurRadius: 10,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
                hintText: 'Cari...',
                hintStyle: TextStyle(
                  color: Color(0xffA1A6B3),
                  fontSize: 20
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(10),
                  child : SvgPicture.asset('assets/icons/search.svg'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          );
    }

    AppBar appBar() {
      return AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(top: 30, left: 10),
          child: SvgPicture.asset(
            'assets/logos/pintar.svg',
            width: 120,
            height: 35,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              
            },
            child: Container(
              margin: EdgeInsets.only(top: 25, right: 30),
              child: SvgPicture.asset(
                'assets/icons/drawer.svg'
              ),
            ),
          )
        ],
      );
    }
  }

  class ProductCard extends StatelessWidget {
    final int productId;
    final String name;
    final String price;
    final String image;
    final String description;

    const ProductCard({super.key, 
      required this.productId,
      required this.name,
      required this.price,
      required this.image,
      required this.description,
    });

    @override
    Widget build(BuildContext context) {
      final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                productId: productId,
                name: name,
                price: price,
                image: image,
                description: description,
              ),
            ),
          );
        },
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: image.startsWith('http') ? Image.network(image, fit: BoxFit.cover, width: double.infinity) : Image.asset(image, fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("${formatter.format(int.tryParse(price) ?? 0)}",style: TextStyle(fontSize: 15, color: Colors.green),),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    }
  }
