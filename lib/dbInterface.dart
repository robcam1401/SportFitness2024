import 'dart:io';
import 'dart:convert';

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
    dynamic ret = "";

		// Send data to the server
		socket.writeln(send_string);

		// Listen for data from the server
		socket.listen(
			(data) {
				print('Received from server: ${String.fromCharCodes(data)}');
        ret = data;
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
    return String.fromCharCodes(ret);
	} 
	catch (e) {
    	print('Error: $e');
      return "Error";
  	}
}

final class Insert {

  // Insert a new account
  String new_account(account_info) {
    account_info['Action'] = 'I';
    account_info['Function'] = 'new_user';
    account_info['Followers'] = 0;
    account_info['Following'] = 0;
    final String insert_json = jsonEncode(account_info);
    // print(insert_json);
    dynamic ret = connect_to_server(insert_json);
    // ret will be a string containing an error/success code
    return ret;
  }

  // Insert a new video

  // Insert new content

  // Insert new comments

  // Insert into friends

}

// Query for account info
final class Query {

  // Given an account number, returns all info associated with an account
  String query_account_info(account_number) {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_info',
      'AccountNumber' : account_number
      };
    final String query_json = jsonEncode(query_data);
    // print(query_json);
    dynamic ret = connect_to_server(query_json);
    return ret;
  }
  // Query for account email
  String query_account_email(account_number) {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_email',
      'AccountNumber' : account_number
      };
    final String query_json = jsonEncode(query_data);
    // print(query_json);
    dynamic ret = connect_to_server(query_json);
    // ret should be a dictionary containing the account email and a success/error code
    return ret;
  }

  // Query for videos associated with an account, descending by date
  String query_account_videos_date_desc(account_number) {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_videos_date_desc',
      'AccountNumber' : account_number
      };
    final String query_json = jsonEncode(query_data);
    // print(query_json);
    dynamic ret = connect_to_server(query_json);
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
    return ret;
  }
  // Ascending by date
  String query_account_videos_date_asc(account_number) {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_videos_date_asc',
      'AccountNumber' : account_number
    };
    final String query_json = jsonEncode(query_data);
    print(query_json);
    dynamic ret = connect_to_server(query_json);
    return ret;
  }
  // Query for friend PairIDs associated with an account number
  // account_number should be an integer
  Map friends_list(account_number) {
    final List _people = [];
    final List _pairs = [];
    //const int fList_length = 2;
    // dictionary containing two lists of dictionaries
    // test Map
    const Map friends = {'friends' : [{'pairID' : 1, 'acctNum' : 1}, {'pairID' : 2, 'acctNum' : 2}], 'usernames' : [{'acctNum' : 1, 'username' : 'User1'}, {'acctNum' : 2, 'username' : 'User2'}]};
    // call the db function
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_friends_list',
      'AccountNumber' : account_number
    };
    final String query_json = jsonEncode(query_data);
    dynamic _fList = connect_to_server(query_json);
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
    this might change to joim the dictionaries with a single query

    */
    // iterating through the test map to create the _pairs and _people lists
    // fList_length should be the length of the two lists in the map, which should both be the same lenght
    // if not, something else has gone wrong anyways server-side
    final int fList_length = _fList['usernames'].length();
    for (var i = 0; i < fList_length; i++) {
      // _people contains all the usernames of friends
      _people.add(friends['usernames'][i]['username']);
      // _pairs contains all the pairIDs of friends
      _pairs.add(friends['friends'][i]['pairID']);
    }

    for (var i = 0; i < fList_length; i++) {
      // add to _people
      _people.add(_fList['usernames'][i]['username']);
      // add to _pairs
      _pairs.add(_fList['friends'][i]['pairID']);
    }
    return {'_people' : _people, '_pairs' : _pairs};
    // dictionary containing two lists: _people and _pairs
  }

  Map friend_messages(pair_id) { // pair_id is an integer
    // lists that will contain the necessary information for each message
    // each index represents a single message
    // _messages[0] contains the body of the same message that _timestamps[0] contains the timestamp of
    final List _messages = []; // str
    final List _sender_ids = []; // int
    final List _timestamps = []; // str
    final List _message_ids = []; // int

    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'friend_messages_date',
      'AccountNumber' : pair_id
    };
    // connect to the server and retrieve the message data
    final String json_data = jsonEncode(query_data);
    dynamic _fMessages = connect_to_server(query_data);
    /*
    _fMessages has the form:
    {
      messages: [{},{},{},...]
    }
    with the dictionaries in the messages list as:
    {
      "pairID" : int, 
      "messageID" : int, 
      "message" : str, 
      "timestamp" : str, 
      "sentUser" : int
    }
    */

    // now iterate and construct the lists
    final int fMessages_length = _fMessages['messages'].length();
    for (var i = 0; i < fMessages_length; i++) {
      // _messages contains the bodies of all the messages
      _messages.add(_fMessages['messages'][i]['message']);
      // _message_ids contains the ids
      _message_ids.add(_fMessages['messages'][i]['messageID']);
      // _sender_ids contains the id of the sender
      _sender_ids.add(_fMessages['messages'][i]['sentUser']);
      // _timestamps contains the timestamps
      _timestamps.add(_fMessages['messages'][i]['timestamp']);
    }

    return {'_messages' : _messages, '_message_ids' : _message_ids, '_sender_ids' : _sender_ids, '_timestamps' : _timestamps};
  }
}