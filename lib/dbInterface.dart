import 'dart:io';
import 'dart:convert';

void main() {
  // main is a test method, should not be called during runtime
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
		'Function' : 'friends_list',
		'AccountNumber' : 1
		};
	final String query_json = jsonEncode(query_data);
	print(query_json);
    connect_to_server(query_json);
    }

Future<String> connect_to_server(send_string) async {
  // Define the server's IP address and port
    final String serverIp = 'localhost'; // Change to the server's IP address
    final int serverPort = 12000; // Change to the server's port
    print('here');
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
    String sent_string = String.fromCharCodes(ret);
    return sent_string;
	} 
	catch (e) {
    	print('Error: $e');
      return "Error";
  	}
}

final class Insert {

  // Insert a new account
  // Basic process for all inserts:
  String account_info(account_info) {
    // Action I denotes an Insert action
    account_info['Action'] = 'I';
    // Function is the function name associated with the desired process
    // in the sqlInterface.py file
    account_info['Function'] = 'new_user';
    // encode the info dictionary into a json for sending
    final String insert_json = jsonEncode(account_info);
    // send to the python server and return any success/failure codes
    dynamic ret = connect_to_server(insert_json);
    return ret;
  }

  // Insert a new video
  String new_video(video_info) {
    video_info['Action'] = 'I';
    video_info['Function'] = 'new_video';
    final String insert_json = jsonEncode(video_info);
    dynamic ret = connect_to_server(insert_json);
    return ret;
  }

  // Insert new content
  String new_content(content_info) {
    content_info['Action'] = 'I';
    content_info['Function'] = 'new_content';
    final String insert_json = jsonEncode(content_info);
    dynamic ret = connect_to_server(insert_json);
    return ret;
  }

  // Insert new comments
  String new_comment(comment_info) {
    comment_info['Action'] = 'I';
    if (comment_info['type'] == 'video') {
      comment_info['Function'] = 'new_video_comment';
    }
    else {
      comment_info['Function'] = 'new_content_comment';
    }
    final String insert_json = jsonEncode(comment_info);
    dynamic ret = connect_to_server(insert_json);
    return ret;
  }

  // Insert new bookmarks/likes
  String new_bookmarks_likes(bookmark_like_info) {
    bookmark_like_info['Action'] = 'I';
    bookmark_like_info['Function'] = 'new_bookmarks_likes';
    final String insert_json = jsonEncode(new_bookmarks_likes(bookmark_like_info));
    dynamic ret = connect_to_server(insert_json);
    return ret;
  }

  // Insert into friend requests
  String new_friend_request(request_info) {
    request_info['Action'] = 'I';
    request_info['Function'] = 'new_friend_request';
    final String insert_json = jsonEncode(request_info);
    dynamic ret = connect_to_server(insert_json);
    return ret;
  }

}

// Query for account info
// basic process for queries
final class Query {
  String account_info(accountNumber) {
    // Action Q denotes a Query action
    // Function is associated with the desired function
    // in the sqlInterface.py file
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_info',
      'AccountNumber' : accountNumber
      };
    // encode the dictionary and send to server
    final String queryJson = jsonEncode(queryData);
    dynamic return_json = connect_to_server(queryJson);
    // return_json is in the format:
    // {'account_info' : {'accountNumber' : <>, ...}}
    // return_json['account_info'] gives just the info json inside
    // the account_info json contains all info associated with a UserAccount table row
    return return_json;
  }
  // Query for account email
  String account_email(accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_email',
      'AccountNumber' : accountNumber
      };
    final String queryJson = jsonEncode(queryData);
    print(queryJson);
    // return_json in this function returns a json as:
    // {'accountEmail' : <email>}
    dynamic return_json = connect_to_server(queryJson);
    return return_json;
  }

  // Query for videos associated with an account, descending by date
  String account_videos_date_desc(accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_videos_date_desc',
      'AccountNumber' : accountNumber
      };
    final String queryJson = jsonEncode(queryData);
    // this return_json is of the form:
    // {1 : {'videoID' : <>, ...}, 2 : {'videoID' : <>}}
    // with the calling value increasing as the videos go on
    dynamic return_json = connect_to_server(queryJson);
    return return_json;
  }
  // Ascending by date
  String account_videos_date_asc(accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_videos_date_asc',
      'AccountNumber' : accountNumber
      };
    final String queryJson = jsonEncode(queryData);
    // this json returns the exact same as the previous function
    // except backwards
    dynamic return_json = connect_to_server(queryJson);
    return return_json;
  }
  // Query for friend PairIDs associated with an account number
  String friends_list(dynamic accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_friends_list',
      'AccountNumber' : accountNumber
      };
    final String queryJson = jsonEncode(queryData);
    // this return_json returns the friends list of an account as:
    // {'friends' : [{'pairID' : <>, 'acctNum' : <>}], 'usernames' : [{'acctNum' : <>, 'username' : <>}]}
    // note: return_json['friends'] and return_json['usernames']
    // are lists of jsons
    // so return_json['friends'][0]['pairID'] gives the pairID of the first pair
    dynamic return_json = connect_to_server(queryJson);
    return return_json;
  }

  String friend_messages(dynamic pairID) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'friend_messages_date',
      'PairID' : pairID
    };
    final String queryJson = jsonEncode(queryData);
    // this return_json is of the form:
    // {'messages' : [{'messageID' : <>, 'message' : <>, 'user' : <>}]}
    // note return_json['messages'] is a list of jsons
    dynamic return_json = connect_to_server(queryJson);
    return return_json;
  }

  String account_communities(dynamic accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_communities',
      'accountNumber' : accountNumber
    };
    final String queryJson = jsonEncode(queryData);
    // this return_json is of the form:
    // {"communities" : [{"commID" : <>}, {...}]}
    dynamic return_json = connect_to_server(queryJson);
    return return_json;
  }

  
}