// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:infixedu/utils/CustomAppBarWidget.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
//
// class JitsiMeetClass extends StatefulWidget {
//
//   final String meetingId;
//   final String meetingSubject;
//   final String userName;
//   final String userEmail;
//   JitsiMeetClass({this.meetingId,this.meetingSubject,this.userEmail,this.userName});
//
//   @override
//   _JitsiMeetClassState createState() => _JitsiMeetClassState();
// }
//
// class _JitsiMeetClassState extends State<JitsiMeetClass> {
//   final serverText = TextEditingController();
//   final roomText = TextEditingController();
//   final subjectText = TextEditingController();
//   final nameText = TextEditingController();
//   final emailText = TextEditingController();
//   final iosAppBarRGBAColor =
//   TextEditingController(text: "#0080FF80");
//   bool isAudioOnly = true;
//   bool isAudioMuted = true;
//   bool isVideoMuted = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     roomText.text = widget.meetingId;
//     subjectText.text = widget.meetingSubject;
//     nameText.text = widget.userName;
//     emailText.text = widget.userEmail;
//
//     JitsiMeet.addListener(JitsiMeetingListener(
//         onConferenceWillJoin: _onConferenceWillJoin,
//         onConferenceJoined: _onConferenceJoined,
//         onConferenceTerminated: _onConferenceTerminated,
//         onError: _onError));
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     JitsiMeet.removeAllListeners();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: CustomAppBarWidget(title: widget.meetingSubject,),
//         body: Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 16.0,
//           ),
//           child: meetConfig(),
//         ),
//       ),
//     );
//   }
//
//   Widget meetConfig() {
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           SizedBox(
//             height: 14.0,
//           ),
//           CheckboxListTile(
//             checkColor: Colors.white,
//             activeColor: Colors.deepPurple,
//             title: Text("Audio Only"),
//             value: isAudioOnly,
//             onChanged: _onAudioOnlyChanged,
//           ),
//           SizedBox(
//             height: 14.0,
//           ),
//           CheckboxListTile(
//             checkColor: Colors.white,
//             activeColor: Colors.deepPurple,
//             title: Text("Audio Muted"),
//             value: isAudioMuted,
//             onChanged: _onAudioMutedChanged,
//           ),
//           SizedBox(
//             height: 14.0,
//           ),
//           CheckboxListTile(
//             checkColor: Colors.white,
//             activeColor: Colors.deepPurple,
//             title: Text("Video Muted"),
//             value: isVideoMuted,
//             onChanged: _onVideoMutedChanged,
//           ),
//           Divider(
//             height: 48.0,
//             thickness: 2.0,
//           ),
//           SizedBox(
//             height: 64.0,
//             width: double.maxFinite,
//             child: ElevatedButton(
//               onPressed: () {
//                 _joinMeeting();
//               },
//               child: Text(
//                 "Watch Now",
//                 style: TextStyle(color: Colors.white),
//               ),
//               style: ButtonStyle(
//                   backgroundColor:
//                   MaterialStateColor.resolveWith((states) => Colors.deepPurple)),
//             ),
//           ),
//           SizedBox(
//             height: 48.0,
//           ),
//         ],
//       ),
//     );
//   }
//
//   _onAudioOnlyChanged(bool value) {
//     setState(() {
//       isAudioOnly = value;
//     });
//   }
//
//   _onAudioMutedChanged(bool value) {
//     setState(() {
//       isAudioMuted = value;
//     });
//   }
//
//   _onVideoMutedChanged(bool value) {
//     setState(() {
//       isVideoMuted = value;
//     });
//   }
//
//   _joinMeeting() async {
//     String serverUrl = serverText.text.trim().isEmpty ? null : serverText.text;
//
//     // Enable or disable any feature flag here
//     // If feature flag are not provided, default values will be used
//     // Full list of feature flags (and defaults) available in the README
//     Map<FeatureFlagEnum, bool> featureFlags = {
//       FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
//     };
//     if (!kIsWeb) {
//       // Here is an example, disabling features for each platform
//       if (Platform.isAndroid) {
//         // Disable ConnectionService usage on Android to avoid issues (see README)
//         featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
//       } else if (Platform.isIOS) {
//         // Disable PIP on iOS as it looks weird
//         featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
//       }
//     }
//     // Define meetings options here
//     var options = JitsiMeetingOptions(room: roomText.text)
//       ..serverURL = serverUrl
//       ..subject = subjectText.text
//       ..userDisplayName = nameText.text
//       ..userEmail = emailText.text
//       ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
//       ..audioOnly = isAudioOnly
//       ..audioMuted = isAudioMuted
//       ..videoMuted = isVideoMuted
//       ..featureFlags.addAll(featureFlags)
//       ..webOptions = {
//         "roomName": roomText.text,
//         "width": "100%",
//         "height": "100%",
//         "enableWelcomePage": false,
//         "chromeExtensionBanner": null,
//         "userInfo": {"displayName": nameText.text}
//       };
//
//     debugPrint("JitsiMeetingOptions: $options");
//     await JitsiMeet.joinMeeting(
//       options,
//       listener: JitsiMeetingListener(
//           onConferenceWillJoin: (message) {
//             debugPrint("${options.room} will join with message: $message");
//           },
//           onConferenceJoined: (message) {
//             debugPrint("${options.room} joined with message: $message");
//           },
//           onConferenceTerminated: (message) {
//             debugPrint("${options.room} terminated with message: $message");
//           },
//           genericListeners: [
//             JitsiGenericListener(
//                 eventName: 'readyToClose',
//                 callback: (dynamic message) {
//                   debugPrint("readyToClose callback");
//                 }),
//           ]),
//     );
//   }
//
//   void _onConferenceWillJoin(message) {
//     debugPrint("_onConferenceWillJoin broadcasted with message: $message");
//   }
//
//   void _onConferenceJoined(message) {
//     debugPrint("_onConferenceJoined broadcasted with message: $message");
//   }
//
//   void _onConferenceTerminated(message) {
//     debugPrint("_onConferenceTerminated broadcasted with message: $message");
//   }
//
//   _onError(error) {
//     debugPrint("_onError broadcasted: $error");
//   }
// }