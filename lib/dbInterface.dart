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
    final String insert_json = jsonEncode(account_info);
    print(insert_json);
    dynamic ret = connect_to_server(insert_json);
    return ret;
  }

  void test_string() {
    test_func();
  }

  List test_friends() {
    final List _people = [];
    final List _pairs = [];
    const int fList_length = 2;
    const Map friends = {'friends' : [{'pairID' : 1, 'acctNum' : 1}, {'pairID' : 2, 'acctNum' : 2}], 'usernames' : [{'acctNum' : 1, 'username' : 'User1'}, {'acctNum' : 2, 'username' : 'User2'}]};
    for (var i = 0; i < fList_length; i++) {
      _people.add(friends['usernames'][i]['username']);
    }
    return [_people,_pairs];
  }
  // Insert a new video

  // Insert new content

  // Insert new comments

  // Insert into friends

}

// Query for account info
final class Query {
  String query_account_info(account_number) {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_info',
      'AccountNumber' : account_number
      };
    final String query_json = jsonEncode(query_data);
    print(query_json);
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
    print(query_json);
    dynamic ret = connect_to_server(query_json);
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
    print(query_json);
    dynamic ret = connect_to_server(query_json);
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
  String query_friends_list(account_number) {
    dynamic query_data = {
      'Action' : 'Q',
      'Function' : 'account_friends_list',
      'AccountNumber' : account_number
      };
    final String query_json = jsonEncode(query_data);
    print(query_json);
    dynamic ret = connect_to_server(query_json);
    ret += 'help';
    return ret;
  }

}