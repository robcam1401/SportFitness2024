// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class VideoAnalysisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Analysis Service'),
      ),
      body: VideoAnalysisForm(),
    );
  }
}

class VideoAnalysisForm extends StatefulWidget {
  @override
  _VideoAnalysisFormState createState() => _VideoAnalysisFormState();
}

class _VideoAnalysisFormState extends State<VideoAnalysisForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8), // Adding space using SizedBox
          Text(
            "\tSEND\n"
            "\tWe can focus on your matchplay strategy, or look at your strokes within competitive situations. Send a message with your video explaining your needs. Get tips on how to shoot your video.\n",
            textAlign: TextAlign.left,
          ),
          Text(
            "\tREVIEW\n"
            "\tI will take 30 mins to review your video, while preparing notes and helpful videos for our Skype session.\n",
            textAlign: TextAlign.left,
          ),
          Text(
            "\tANALYZE\n"
            "\tTogether we can analyze your video and discuss ways to make the necessary tactical and technical improvements.\n",
            textAlign: TextAlign.left,
          ),
          Text(
            "\tRECEIVE\n"
            "\tI will screen record our Skype session and provide you with the video of our discussion.\n",
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

