import 'package:exercise_app/post.dart';
import 'package:flutter/material.dart';

class otherProfile extends StatefulWidget{
  @override
  State<otherProfile> createState() => _otherProfile();
}

class _otherProfile extends State<otherProfile> {
  final List _post = [
    'post 1',
    'post 2',
    'post 3',
    'post 4',
    'post 5',
    'post 6',
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text("other user profile"),
        centerTitle: true,
        backgroundColor: Colors.red[600],     
         ),
      body:  Column(
        children: [
          const Expanded(
            
            flex: 20,
            child: CircleAvatar(
              radius: 45,
              ),
          ),
                //made a temporary row of two button to show the friends and groups list 
                // pressing the button will switch to those pages
                
                      Expanded(
                        flex: 20,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [Container(
                              child: Text("friends: 89")
                            ),
                            Container(child: Text("followers: 500"),)
                            ],
                          ),
                          
                        ),
                      ),
                      Expanded(
                        flex: 60,
                        child: ListView.builder(
                          itemCount: _post.length,
                          itemBuilder: (context, index) {
                            return MyPost(
                            child: _post[index],
                  );
                          },
                          padding: const EdgeInsets.all(20),
                          
                        ),
                      ),
                  
                    ],
                  ),
                );
      
  }
}