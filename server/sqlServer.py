from socket import *
import json
from time import sleep

from sqlInterface import *


# turn a json string into a dictionary
def json_to_dictionary(json_data):
    new_data = json.loads(json_data)
    return new_data

# using the Action and Function fields in the json string,
# call the appropriate function for the action being requested
def call_from_json(json_data):
    try:
        query_data = json_to_dictionary(json_data)
        if query_data['Action'] == 'I': 
            f = getattr(insert, query_data['Function'])
        if query_data['Action'] == 'Q':
            f = getattr(query,query_data['Function'])
        ret = f(query_data)
        print(f'json_ret: {ret}')
        return ret
    # should add more comprehensive error catching and notification
    # ex. in the case of a duplicate email, send "email already in use"
    except Exception as err:
        print(json_data)
        exception = [("Exception: {}, {}\n".format(err, type(err))),"{}".format(json_data)]

        return "Error", exception

def main():
    # json1 = json.dumps(query.account_friends_list(1))
    # print(json1)

    server_socket = socket(AF_INET, SOCK_STREAM)
    # port number = 12000
    server_socket.bind(('',12000))
    # 1 is an infinite loop
    server_socket.listen(1)
    print("Server is ready to connect...\n")

    while(True):
        connection_socket, address = server_socket.accept()
        print("Connection established with: {}\n".format(address))

        incoming_message = connection_socket.recv(2048)
        received_message = incoming_message.decode()
        print("Received message: {}\n".format(received_message))

        ret = call_from_json(received_message)
        # the returned dictionary is dumped into a json string format
        print(f'ret: {ret}')
        sent_json = json.dumps(ret)
        #sent_json_2 = json.loads(sent_json_1)
        connection_socket.send(sent_json.encode())
        print(f'sent: {sent_json}')
        print("Message sent\n")
        connection_socket.close()

    return

main()
