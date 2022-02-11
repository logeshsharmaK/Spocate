// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:spocate/getxtest/MyController.dart';
//
// class MyScreen extends StatefulWidget {
//   @override
//   _MyScreenState createState() => _MyScreenState();
// }
//
// class _MyScreenState extends State<MyScreen> {
//   MyController myController = Get.put(MyController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//         child: ListView(
//           children: [
//             // Obx(() => Text("Obx  Status  ${myController.status}")),
//             GetBuilder<MyController>(
//                 builder: (_) {
//                   print("GetBuilder Current Status ${myController.status}");
//                   return Text("Current Status ${myController.status}");
//                 }),
//             Padding(padding: EdgeInsets.all(30.0)),
//             ElevatedButton(
//                 onPressed: () {
//                   myController.updateStatus("Second");
//                 },
//                 child: Text("Change Status"))
//           ],
//         ),
//       ),
//     );
//   }
// }
