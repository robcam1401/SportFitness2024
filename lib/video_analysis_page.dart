import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
  String _filePath = '';

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: true,
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 8), // Adding space using SizedBox
                  Text(
                    'SEND\n'
                    'We can focus on your matchplay strategy, or look at your strokes within competitive situations. Send a message with your video explaining your needs. Get tips on how to shoot your video.\n',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'REVIEW\n'
                    'I will take 30 mins to review your video, while preparing notes and helpful videos for our Skype session.\n',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'ANALYZE\n'
                    'Together we can analyze your video and discuss ways to make the necessary tactical and technical improvements.\n',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'RECEIVE\n'
                    'I will screen record our Skype session and provide you with the video of our discussion.\n',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _openFilePicker,
          child: Text('Upload Video'),
        ),
        SizedBox(height: 16),
        Text(
          'Selected File: $_filePath',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
