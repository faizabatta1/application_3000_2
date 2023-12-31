import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:zainlak_tech/Constant/AppColor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Services/popularTechnician.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,size: 30, color: Colors.white,),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: PopularTechnicianService.getAllPopularTechnicians(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something Went Wrong',
                style: TextStyle(fontSize: 20),
              ).tr(),
            );
          }

          if (snapshot.data != null) {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Text(
                  'No Products Yet'.tr(),
                  style: TextStyle(fontSize: 24),
                ),
              );
            }

            return Container(
              margin: EdgeInsets.all(12.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: 300,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(-3, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Container(
                              width: 80,
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12.0),
                                  topLeft: Radius.circular(12.0),
                                ),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    snapshot.data[index]['image'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              snapshot.data[index]['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  snapshot.data[index]['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${snapshot.data[index]['price']} SAR',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  String productLink = snapshot.data[index]['link'];
                                  if (productLink.isNotEmpty) {
                                    if (await canLaunchUrl(Uri.parse(productLink))) {
                                      await launchUrl(Uri.parse(productLink));
                                    }
                                  }
                                },
                                child: Text(
                                  'Show More',
                                  style: TextStyle(fontSize: 14),
                                ).tr(),

                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Text('');
        },
      ),
    );
  }
}
