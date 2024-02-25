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
from CloudAPIs.Insert import *

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
    query = ("SELECT PairID FROM Friends\
             Where User1ID = {} OR User2ID = {}".format(account_number,account_number))
    cursor.execute(query)
    cnx.commit()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix

def friendPairMessages(pair_id):
    cnx,cursor = connect()
    query = ("SELECT * FROM FriendMessages\
             Where PairID={} ORDER BY SentStamp desc".format(pair_id))
    cursor.execute(query)
    cnx.commit()
    return_matrix = []
    for i in cursor:
        return_matrix.append(i)
    cursor.close()
    return return_matrix