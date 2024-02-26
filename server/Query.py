# from Insert import connect

# required imports
import sys
import os

os.chdir("..")
# find absolute paths
_CloudAPIs =  os.path.join(os.getcwd(), os.path.dirname("CloudAPIs"))
_libs =  os.path.join(os.getcwd(), os.path.dirname("libs"))

# insert into path variables
sys.path.insert(0,_CloudAPIs)
sys.path.insert(0,_libs)

# import from path variables
#from CloudAPIs.Insert import *
from Insert import *

## useful queries for the database

# returns all information about a specified account
def accountInfo(acct_num):
    cnx,cursor = connect()

    query = ("SELECT * FROM UserAccount\
             WHERE AccountNumber = {}").format(acct_num)

    cursor.execute(query)
    cnx.commit()
    cnx.close()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

def accountSearchName(search_term):
    cnx,cursor = connect()

    query = ("SELECT * FROM UserAccount\
             WHERE Username = {}").format(search_term)
    cursor.execute(query)
    cnx.commit()
    cnx.close()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

# returns the email address associated with a specific account
def accountSearchEmail(account_id):
    cnx,cursor = connect()

    query = ("SELECT Email FROM UserAccount\
             WHERE AccountNumber = {}").format(account_id)
    cursor.execute(query)
    cnx.commit()
    cnx.close()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

# returns all videos posted by a single account
# ordered by date, descending or ascending, chosen by calling function
def accountVideosDate(acct_num, sort):
    cnx,cursor = connect()

    query = ("SELECT * FROM Videos\
             WHERE AccountNumber = {}\
             ORDER BY UploadDate{}").format(acct_num, sort)

    cursor.execute(query)
    cnx.commit()
    cnx.close()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

def accountContentDate(acct_num, sort):
    cnx,cursor = connect()

    query = ("SELECT * FROM Content\
             WHERE AccountNumber = {}\
             ORDER BY UploadDate{}").format(acct_num, sort)

    cursor.execute(query)
    cnx.commit()
    cnx.close()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

def videoSearchName(search_term):
    cnx, cursor = connect()

    query = ("SELECT * FROM Videos\
             WHERE VideoTitle = {}").format(search_term)
    cursor.execute(query)
    cnx.commit()
    cnx.close()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

# returns IDs of all top-level comments under a post
def commentsUnderPost(post_id,sort,post_type):
    cnx,cursor = connect()

    if (post_type == 1):
        query = ("SELECT CommentID FROM Comment\
                WHERE VideoComment = {}, ThreadParent = 0\
                ORDER BY PostDate{}").format(post_id, sort)
    else:
        query = ("SELECT CommentID FROM Comment\
                WHERE ContentComment = {}, ThreadParent = 0\
                ORDER BY PostDate{}").format(post_id, sort)

    cursor.execute(query)
    cnx.commit()
    cnx.close()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

def commentBody(comment_id):
    cnx,cursor = connect()

    query = ("SELECT CommentBody FROM Comments\
             WHERE CommentID = {}").format(comment_id)

    cursor.execute(query)
    cnx.commit()
    cnx.close()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

def friendsList(account_number):
    cnx,cursor = connect()
    query = ("SELECT * FROM Friends\
             Where User1ID = {} OR User2ID = {}".format(account_number,account_number))
    cursor.execute(query)
    cnx.commit()
    # pair matrix will contain dictionaries of friend pairs
    pair_matrix = []
    k = 0
    # find the user that is not the current user
    for i in cursor:
        if i[0] == account_number:
            j = i[1]
        else:
            j = i[0]
        json1 = {"pairID" : i[2], "acctNum" : j}
        pair_matrix.append(json1)
        k += 1
    cursor.close()
    cnx.close()
    # put the pair matrix in a dictionary to be sent to the client
    # dictionaries can easily be turned into json datatypes
    sent_json = {"friends" : pair_matrix}
    cnx,cursor = connect()
    username_array = []
    # now query for usernames associated with accounts the user is friends with
    # and put these usernames in the username array
    for i in sent_json["friends"]:
        print(i["acctNum"])
        query = ("SELECT Username FROM UserAccount\
             Where AccountNumber = {}".format(i["acctNum"]))
        cursor.execute(query)
        cnx.commit()
        for j in cursor:
            json2 = {"acctNum" : i["acctNum"], "username" : j[0]}
        username_array.append(json2)
    # append the array to the json to send to the client
    sent_json["usernames"] = username_array
    # final json has the form {"friends" : ["pairID" : <>, "acctNum" : <>],
    #                         "usernames" : ["acctNum" : <>, "username" : <>]}
    # ultimately is a json containing lists of dictionaries containing the data
    return sent_json

def friendPairMessages(pair_id):
    cnx,cursor = connect()
    query = ("SELECT * FROM FriendMessages\
             Where PairID={} ORDER BY SentStamp desc".format(pair_id))
    cursor.execute(query)
    cnx.commit()
    message_array = [] 
    for i in cursor:
        json1 = {"pairID" : i[0], "messageID" : i[1], "message" : i[2], "timestamp" : i[3], "sentUser" : i[4]}
        message_array.append(json1)
    cursor.close()
    cnx.close()
    sent_json = {"messages" : message_array}
    return sent_json

def accountCommunities(account_id):
    cnx,cursor = connect()
    query = ("SELECT * FROM CommunityMembers\
             WHERE AccountID = {}".format(account_id))
    cursor.execute(query)
    cnx.commit() 
    member_array = []
    for i in cursor:
        json1 = {"commID" : i[0]}
        member_array.append(json1)
    cursor.close()
    cnx.close()
    sent_json = {"communities" : member_array}
    return sent_json