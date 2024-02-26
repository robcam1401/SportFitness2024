import 'package:flutter/material.dart';
import 'lesson_booking_page.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  int followingCount = 100;

  @override
  Widget build(BuildContext context) {
    List<Service> services = [
      Service(
        id: '1',
        name: 'One-on-One Lessons',
        resources: [
          Resource(
            id: '1',
            name: 'Tennis Lesson',
            available: true,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LessonBookingPage()));
            },
          ),
        ],
      ),
      Service(
        id: '2',
        name: 'Video Analysis',
        resources: [
          Resource(id: '2', name: 'Video Analysis Session', available: true),
        ],
      ),
      // Add more services as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            // Your profile picture
            backgroundImage: AssetImage('assets/profile_picture.jpg'),
          ),
          SizedBox(height: 20),
          Text(
            'Ilana Tetruashvili',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Your go-to tennis coach! Louisiana Tech Alumn.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Followers: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '100K', // Your followers count
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Following: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                followingCount.toString(), // Your following count
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Feed'),
              Tab(text: 'Services'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Feed Tab
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sample post
                      PostWidget(
                        image: AssetImage('assets/post_image1.jpg'),
                        caption: 'Beautiful day for tennis!',
                      ),
                      // Add more posts as needed
                    ],
                  ),
                ),
                // Services Tab
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: services.map((service) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            service.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: service.resources.map((resource) {
                              return ListTile(
                                title: Text(resource.name),
                                trailing: ElevatedButton(
                                  onPressed: resource.onPressed,
                                  child: Text('Select'),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final ImageProvider image;
  final String caption;

  const PostWidget({
    required this.image,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image
          Image(image: image),
          SizedBox(height: 10),
          // Caption
          Text(
            caption,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class Service {
  final String id;
  final String name;
  final List<Resource> resources;

  Service({required this.id, required this.name, required this.resources});
}

class Resource {
  final String id;
  final String name;
  final bool available;
  final VoidCallback? onPressed;

  Resource({
    required this.id,
    required this.name,
    required this.available,
    this.onPressed,
  });
}

class Appointment {
  final String id;
  final Service service;
  final Resource resource;
  final DateTime dateTime;

  Appointment({
    required this.id,
    required this.service,
    required this.resource,
    required this.dateTime,
  });
}
