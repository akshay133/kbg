import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kbg/constants/colors.dart';
import 'package:kbg/widgets/bottom_sheet_widget.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Client\nManagement',
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold, color: grayColor),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.amberAccent),
              child: IconButton(
                  onPressed: () {
                    Get.bottomSheet(BottomSheetWidget(), isDismissible: false);
                  },
                  icon: const Icon(
                    Icons.add,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
