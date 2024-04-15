// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:http/http.dart';

void test_func() {
	print('Hello, World!');
	const insert_data = {
		'Action' : 'I',
		'Function' : 'new_user',
		'AccountNumber' : 4, 
		'Username' : 'Test1',
		'PasswordHash' : 'ABCD',
		'Email' : '123@abc.net',
		'PhoneNumber' : 3,
		'Fname' : 'Test',
		'Minit' : 'T',
		'Lname' : '2',
		'UserDoB' : '1111-11-11 11:11:11'
		};
	const query_data = {
		'Action' : 'Q',
		'Function' : 'account_info',
		'AccountNumber' : 4
		};
	final String query_json = jsonEncode(query_data);
	print(query_json);
  print(connect_to_server(query_json));
  }

// send_string should be a dictionary/json format with an action and function header
Future<String> connect_to_server(send_string) async {
  // Define the server's IP address and port
    final String serverIp = '10.0.2.2'; // Change to the server's IP address
    final int serverPort = 12000; // Change to the server's port

    try {
    // Create a socket connection to the server
		final socket = await Socket.connect(serverIp, serverPort);
    dynamic ret = Completer<String>();

		// Send data to the server
		socket.writeln(send_string);

		// Listen for data from the server
		await socket.listen(
			(data) {
				print('Received from server: ${String.fromCharCodes(data)}');
        Type type = data.runtimeType;
        // print('Type: $type');
        String SocketData = String.fromCharCodes(data);
        // print('data: $SocketData');
        ret.complete(SocketData);
			},
			onDone: () {
				print('Server disconnected.');
				socket.destroy();
			},
			onError: (error) {
				print('Error: $error');
				socket.destroy();
			},
		);

		// Close the socket when you're done
		socket.close();
    return ret.future;
	} 
	catch (e) {
    	print('Error: $e');
      return "Error";
  	}
}

 // helper function to keep from rewriting lots of copy-pasted code
  Future<Map> query_helper(query) async {
    final String query_json = jsonEncode(query);
    try {
      dynamic future_string = await connect_to_server(query_json);
      // print('f_string: $future_string');
      Map _locals = jsonDecode(future_string);
      return _locals;
    }
    on Exception catch (ex) {
      print('Friends List Helper Query Error: $ex');
    }
    throw();
  }

final class Insert {

  // Insert a new account
  Future<Map> new_account(account_info) async {
    account_info['Action'] = 'I';
    account_info['Function'] = 'new_user';
    account_info['Followers'] = 0;
    account_info['Following'] = 0;
    Map _response = await query_helper(account_info);
    // ret will be a string containing an error/success code
    return _response;
  }

  // Insert a new resource
  Future<Map> new_resource(resource_data) async {
    // Assuming resource_data contains the necessary information for inserting a new resource
    resource_data['Action'] = 'I';
    resource_data['Function'] = 'new_resource';
    
    // Map the resource data keys to match the database table columns
    resource_data['AccountNumber'] = resource_data['AccountNumber']; // Assuming AccountNumber is already in resource_data
    resource_data['ResourceName'] = resource_data['ResourceName'];
    resource_data['Resource_Description'] = resource_data['Resource_Description'];
    resource_data['People_amount'] = resource_data['People_amount'] ?? false; // Defaulting to false if not provided
    resource_data['Hours_amount'] = resource_data['Hours_amount'] ?? false;
    resource_data['Date_of_Booking'] = resource_data['Date_of_Booking'] ?? false;
    resource_data['Payment'] = resource_data['Payment'] ?? false;
    resource_data['File_Upload'] = resource_data['File_Upload'] ?? false;
    
    // Assuming 'Following' is not needed for inserting into the UserResource table
    
    // Call the query_helper function with resource_data
    Map _response = await query_helper(resource_data);
    
    // Return the response
    return _response;
  }

  // Insert a new video
  // helper functions for uploading
  // files will be uploaded first, then added to the database
  // I'm not exactly sure how this will look on the other end, but it has to work
  Future<String> video_upload(video_link) async {
    var request = MultipartRequest("POST", Uri(host: '10.0.2.2'));
    request.files.add(MultipartFile.fromPath('name', video_link) as MultipartFile);
    request.send().then((response) {
      if (response.statusCode == 200) {
        print('uploaded');
      }
    });
    return 'name';
  }
  Future<String> thumbnail_upload(thumbnail_link) async {
    return 'name';
  }

  Future<Map> new_video(video_info, video_path, thumbnail_path) async {
    // first, send a request to upload to the cloud storage bucket
    String video_name = await video_upload(video_path);
    String thumbnail_name = await thumbnail_upload(thumbnail_path);

    // then send a request to insert into the database
    video_info['Action'] = 'I';
    video_info['Function'] = 'new_video';
    video_info['VideoPath'] = video_name;
    video_info['ThumbnailPath'] = thumbnail_name;
    Map _response = await query_helper(video_info);
    return _response;
  }

  // Insert new picture
  Future<String> picture_upload(pic_path) async {
    var request = MultipartRequest("POST", Uri(host: '10.0.2.2'));
    request.files.add(MultipartFile.fromPath('name', pic_path) as MultipartFile);
    request.send().then((response) {
      if (response.statusCode == 200) {
        print('uploaded');
      }
    });
    return 'name';
  }

  Future<Map> new_picture(picture_info, picture_path) async {
    // first, send a request to upload to the cloud storage bucket
    String picture_name = await picture_upload(picture_path);

    // then send a request to insert into the database
    picture_info['Action'] = 'I';
    picture_info['Function'] = 'new_content';
    picture_info['VideoPath'] = picture_name;
    Map _response = await query_helper(picture_info);
    return _response;
  }
  // Insert new comments

  // Insert into friends

  // Insert into friend messages
  Future<Map> new_friend_messages(message_info) async {
    message_info['Action'] = 'I';
    message_info['Function'] = 'new_message';
    Map _response = await query_helper(message_info);
    return _response;
  }

}

// Query for account info
final class Query {

  // Given an account number, returns all info associated with an account
  Future<Map> account_info(account_number) async {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_info',
      'AccountNumber' : account_number
      };
    Map _info = await query_helper(query_data);
    return _info;
  }

  // login
  Future<Map> account_login(username, password) async {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'passwordHash',
      'Username' : username,
      'PasswordHash' : password
    };
    Map _info = await query_helper(query_data);
    return _info;
  }

  // Query for owner name of an account
  Future<Map> account_name(account_number) async {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_name',
      'AccountNumber' : account_number
    };
    Map _name = await query_helper(query_data);
    return _name['name'];
  }

  // Query for account email
  Future<Map> account_email(account_number) async {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_email',
      'AccountNumber' : account_number
      };
    Map _email = await query_helper(query_data);
    return _email;
    // _email is a dictionary containing the email address
    // {'email' : 'abc@xyz.com'}
  }

  // Query for videos associated with an account, descending by date
  Future<Map> account_videos_date_desc(account_number) async {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_videos_date_desc',
      'AccountNumber' : account_number
      };
    Map _videos = await query_helper(query_data);
    // ret should be a dictionary containing lots of video data:
    /* 
    {
      'videos' : [link, ...],
      'thumbnails' : [link, ...],
      'creator' : [string, ...],
      'creator_pfp' : [link, ...],
      'views' : [int, ...],
      'upload_date' : [str, ...]
    }
    */
    return _videos;
  }
  // Ascending by date
  Future<Map> account_videos_date_asc(account_number) async {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_videos_date_asc',
      'AccountNumber' : account_number
    };
    Map _videos = await query_helper(query_data);
    return _videos;
  }
  // Query for friend PairIDs associated with an account number
  // account_number should be an integer


  Future<Map> friends_list(account_number) async{
    final List _people = [];
    final List _pairs = [];
    //const int fList_length = 2;
    // dictionary containing two lists of dictionaries
    // test Map
    // const Map friends = {'friends' : [{'pairID' : 1, 'acctNum' : 1}, {'pairID' : 2, 'acctNum' : 2}], 'usernames' : [{'acctNum' : 1, 'username' : 'User1'}, {'acctNum' : 2, 'username' : 'User2'}]};
    // call the db function
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_friends_list',
      'AccountNumber' : account_number
    };
    print(query_data);
    Map _fList = await query_helper(query_data);
    print(_fList);
    /* ret should contain a json of the form:
    {
      'friends' : [{},{}],
      'usernames' : [{},{}]
    }
    with the 'friends' list dictionaries as:
    {
      'pairID' : int
      'acctNum' : int
    }
    and 'usernames' as:
    {
      'acctNum' : int,
      'username' : str
    }
    this might change to join the dictionaries with a single query

    */
    // iterating through the test map to create the _pairs and _people lists
    // fList_length should be the length of the two lists in the map, which should both be the same lenght
    // if not, something else has gone wrong anyways server-side
    final int fList_length = _fList['usernames'].length;
    // for (var i = 0; i < fList_length; i++) {
    //   // _people contains all the usernames of friends
    //   _people.add(friends['usernames'][i]['username']);
    //   // _pairs contains all the pairIDs of friends
    //   _pairs.add(friends['friends'][i]['pairID']);
    // }

    for (var i = 0; i < fList_length; i++) {
      // add to _people
      _people.add(_fList['usernames'][i]['username']);
      // add to _pairs
      _pairs.add(_fList['friends'][i]['pairID']);
    }
    return {'_people' : _people, '_pairs' : _pairs};
    // dictionary containing two lists: _people and _pairs
  }

  Future<Map> friend_messages(pair_id, account_number) async { // pair_id is an integer
    // lists that will contain the necessary information for each message
    // each index represents a single message
    // _messages[0] contains the body of the same message that _timestamps[0] contains the timestamp of

    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'friend_messages_date',
      'PairID' : pair_id
    };
    // connect to the server and retrieve the message data
    dynamic _fMessages = await query_helper(query_data);
    /*
    _fMessages has the form:
    {
      messages: [{},{},{},...]
    }
    each dictionary represents a separate message
    with the dictionaries in the messages list as:
    {
      "pairID" : int, 
      "messageID" : int, 
      "message" : str, 
      "timestamp" : str, 
      "sentUser" : int
    }
    */
    // now iterate and construct the list of message widgets
    final int fMessages_length = _fMessages['messages'].length;
    final _messages = _fMessages['messages'];
    List<Widget> children = [];
    bool sender = false;
    Color color = Color(0xFFE8E8EE);
    for (var i = 0; i < fMessages_length; i++) {
      // String message = _messages[i]["MessageBody"];
      // print("message: $message");
      // determine the sender of each message and change color and sender args accordingly
      if (_messages[i]["SentUser"] == account_number) {
        sender = true;
        color = Color.fromARGB(255, 192, 192, 252);
      }
      else {
        sender = false;
        color  = Color(0xFFE8E8EE);
      }
      Widget child = BubbleSpecialThree(
        text: _messages[i]["MessageBody"],
        color: color,
        tail: true,
        isSender: sender,
      );
      children.add(child);
    }
    // children is a list: [Widget, Widget, ...]
    return {'children' : children};
  }

  Future<Map> groups_list(account_number) async {
    final List _groups = [];
    
    // create the query and send to server
    dynamic query = {
      "Action" : "Q", 
      "Function" : "account_communities", 
      "AccountNumber" : account_number
      };
    
    Map _gList = await query_helper(query);

    // create the group list
    final int gList_length = _gList['groups'].length;
    for (var i = 0; i < gList_length; i++) {
      // add to _groups
      _groups.add(_gList['groups'][i]['group_name']);
    }
    return {'_groups' : _groups};
  }
}
