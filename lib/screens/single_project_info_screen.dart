import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/controller/dashboard_controller.dart';
import 'package:kbg/screens/photo_view_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SingleProjectInfoScreen extends StatelessWidget {
  int ssum = 0;
  var tl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
          title: Text('Project Info'),
        ),
        body: GetBuilder<DashboardController>(
          init: DashboardController(),
          builder: (_) {
            List imgs = _.snapshot.get('imagesUrls');
            List activities = _.snapshot.get('activities');
            List assigned = _.snapshot.get('assigned');
            for (var element in activities) {
              int um = element['percentage'];
              ssum = ssum + um;
              tl = ssum / activities.length;
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      height: Get.height * 0.25,
                      width: Get.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.blue.shade50,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0.5, 0.6))
                          ],
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: imgs.first,
                                  fit: BoxFit.cover,
                                  height: Get.height * 0.15,
                                  width: Get.width * 0.25,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    _.snapshot.get('name'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              CircularPercentIndicator(
                                radius: 45.0,
                                animation: true,
                                animationDuration: 1200,
                                lineWidth: 15.0,
                                percent: tl.toDouble() / 100,
                                center: Text(
                                  tl.toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.butt,
                                backgroundColor: Colors.yellow,
                                progressColor: Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'More Images',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemCount: imgs.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  Get.to(PhotoViewScreen(
                                    img: imgs[index],
                                  ));
                                },
                                child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: CachedNetworkImage(
                                      height: Get.height * 0.18,
                                      imageUrl: imgs[index],
                                      fit: BoxFit.cover,
                                    ))),
                          );
                        })
                  ],
                ),
              ),
            );
          },
        ));
  }
}
