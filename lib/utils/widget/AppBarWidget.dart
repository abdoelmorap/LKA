// import 'package:flutter/material.dart';
// import 'package:infixedu/utils/Utils.dart';
// import 'package:infixedu/utils/apis/Apis.dart';
//
// class AppBarWidget {
//   static PreferredSize header(BuildContext context, String title) {
//     int i = 0;
//
//     return PreferredSize(
//       preferredSize: Size(double.infinity, 70.0), // 40 is the height
//       child: StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           if (i < 1) {
//             //if you don't set any condition here setState call again and again
//             Utils.getStringValue('lang').then((value) {
//               if (value == null) {
//                 Utils.getTranslatedLanguage('en', title).then((val) {
//                   print(val);
//                   setState(() => title = val);
//                   i++;
//                 });
//               } else {
//                 Utils.getTranslatedLanguage(value, title).then((val) {
//                   print(val);
//                   setState(() => title = val);
//                   i++;
//                 });
//               }
//             });
//           }
//           return AppBar(
//             primary: false,
//             centerTitle: false,
//             title: Center(
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(top: 10.0),
//                       child: Text(
//                         title,
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                     ),
//                     Expanded(child: Container()),
//                     FutureBuilder(
//                       future: Utils.getStringValue('image'),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<String> snapshot) {
//                         if (snapshot.hasData) {
//                           Utils.saveStringValue('image', snapshot.data);
//                           return Align(
//                             alignment: Alignment.bottomRight,
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 10.0),
//                               child: CircleAvatar(
//                                 radius: 22.0,
//                                 backgroundImage: NetworkImage(InfixApi.root + snapshot.data),
//                                 backgroundColor: Colors.transparent,
//                               ),
//                             ),
//                           );
//                         } else {
//                           return Align(
//                             alignment: Alignment.bottomRight,
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 10.0),
//                               child: CircleAvatar(
//                                 radius: 22.0,
//                                 backgroundImage: NetworkImage(
//                                     'http://saskolhmg.com/images/studentprofile.png'),
//                                 backgroundColor: Colors.transparent,
//                               ),
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             leading: Padding(
//               padding: const EdgeInsets.only(top: 14.0),
//               child: IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: () {
//                     navigateToPreviousPage(context);
//                   }),
//             ),
//             flexibleSpace: Image(
//               image: AssetImage('assets/images/app_toolbar_bg.png'),
//               width: MediaQuery.of(context).size.width,
//               height: 80.0,
//               fit: BoxFit.cover,
//             ),
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//           );
//         },
//       ),
//     );
//   }
//
//   static void navigateToPreviousPage(BuildContext context) {
//     Navigator.pop(context);
//   }
// }
