import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompletedProjectScreen extends StatelessWidget {
  const CompletedProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("projects")
          .where('percentage', isEqualTo: '1')
          .snapshots(),
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var ds = snapshot.data!.docs;
          return ds.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: ds.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(ds[index]['name']));
                  })
              : const Center(child: Text('No project done'));
        }
      },
    ));
  }
}
