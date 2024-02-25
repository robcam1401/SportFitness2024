import 'dart:io';
import 'dart:convert';

void main() {
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
  String account_info(account_info) {
    account_info['Action'] = 'I';
    account_info['Function'] = 'new_user';
    final String insert_json = jsonEncode(account_info);
    print(insert_json);
    dynamic ret = connect_to_server(insert_json);
    return ret;
  }

  // Insert a new video

  // Insert new content

  // Insert new comments

  // Insert into friends

}

// Query for account info
final class Query {
  String account_info(accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_info',
      'AccountNumber' : accountNumber
      };
    final String queryJson = jsonEncode(queryData);
    dynamic ret = connect_to_server(queryJson);
    return ret;
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
    dynamic ret = connect_to_server(queryJson);
    return ret;
  }

  // Query for videos associated with an account, descending by date
  String account_videos_date_desc(accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_videos_date_desc',
      'AccountNumber' : accountNumber
      };
    final String queryJson = jsonEncode(queryData);
    dynamic ret = connect_to_server(queryJson);
    return ret;
  }
  // Ascending by date
  String account_videos_date_asc(accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_videos_date_asc',
      'AccountNumber' : accountNumber
      };
    final String queryJson = jsonEncode(queryData);
    dynamic ret = connect_to_server(queryJson);
    return ret;
  }
  // Query for friend PairIDs associated with an account number
  String friends_list(dynamic accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_friends_list',
      'AccountNumber' : accountNumber
      };
    final String queryJson = jsonEncode(queryData);
    dynamic ret = connect_to_server(queryJson);
    return ret;
  }

  String friend_messages(dynamic pairID) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'friend_messages_date',
      'PairID' : pairID
    };
    final String queryJson = jsonEncode(queryData);
    dynamic ret = connect_to_server(queryJson);
    return ret;
  }

  String account_communities(dynamic accountNumber) {
    dynamic queryData = {
      'Action' : 'Q',
      'Function' : 'account_communities',
      'accountNumber' : accountNumber
    };
    final String queryJson = jsonEncode(queryData);
    dynamic ret = connect_to_server(queryJson);
    return ret;
  }

  
}