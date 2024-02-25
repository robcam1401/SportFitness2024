from Insert import *
from Query import *
from Edit import *
# required imports
import sys
import os

# find absolute paths
os.chdir("..")
_CloudAPIs =  os.path.join(os.getcwd(), os.path.dirname("CloudAPIs"))
_libs =  os.path.join(os.getcwd(), os.path.dirname("libs"))

# insert into path variables
sys.path.insert(0,_CloudAPIs)
sys.path.insert(0,_libs)

# import from path variables
from CloudAPIs.Insert import *
from CloudAPIs.Query import *
from CloudAPIs.Edit import *
from CloudAPIs.sqlInterface import *

# from Insert import *
# from Query import *
# from Edit import *
# from sqlInterface import *

import datetime

########################
# Unit tests for inserting, deleting, and modifying data in the UserAccount database




# connects to the sql server and queries for all account numbers in the UserAccount table
def ConnectAndQuery():
    cnx,cursor = connect()

    query1=("SELECT AccountNumber FROM UserAccount")
    query2=("SELECT VideoLink FROM Videos WHERE VideoID = 1")
    query3=("SELECT * FROM Friends")
    cursor.execute(query3)

    for item in cursor:
        print(item)

    cursor.close()
    cnx.close()
    return

# connects to the sql server and inserts into the UserAccount table
def ConnectAndInsert():

    data_user = {
        "AccountNumber" : 1,
        "Username" : "Admin",
        "Email" : "user@user.com",
        "PhoneNumber" : 1,
        "Fname" : "Zach",
        "Minit" : "W",
        "Lname" : "Nalepa",
        "UserDoB" : datetime.date(2001,7,20)
    }
    data_user1 = {
        "AccountNumber" : 4,
        "Username" : "GenericUser",
        "Email" : "user2@user.com",
        "PhoneNumber" : 1111111111,
        "Fname" : "Generic",
        "Minit" : "A",
        "Lname" : "User",
        "UserDoB" : datetime.date(2000,1,1),
        "PasswordHash" : 'ABC'
    }

    data_Video = {
        "VideoID" : None,
        "AccountNumber" : 1,
        "Video Title" : "First Video",
        "VidDescription" : "The first video uploaded to our app",
        "Category" : "dev"
    }

    data_friends = {
        "User1ID" : 1,
        "User2ID" : 2,
        "PairID" : 1
    }

    insert.new_user(data_user1)
    #newFriendsInsert(data_friends)
    #Insert.newVideoInsert(data_Video, VideoLink, Thumbnail)
    return

def s2_demo_insert():
    message1 = {
    "PairID" : '1',
    "MessageID" : 1,
    "MessageBody" : 'Hey, are you going to the Y today?',
    "SentStamp" : datetime.datetime.now(datetime.timezone.utc),
    "SentUser" : '1',
    "AttatchedLink" : None
    }
    message2 = {
    "PairID" : '1',
    "MessageID" : 2,
    "MessageBody" : 'Yeah. I\'m going at 6pm.',
    "SentStamp" : datetime.datetime.now(datetime.timezone.utc),
    "SentUser" : '2',
    "AttatchedLink" : None
    }
    message3 = {
    "PairID" : '1',
    "MessageID" : 3,
    "MessageBody" : 'Cool, I\'ll meet you there!',
    "SentStamp" : datetime.datetime.now(datetime.timezone.utc),
    "SentUser" : '1',
    "AttatchedLink" : None
    }
    insert.new_message(message1)
    insert.new_message(message2)
    insert.new_message(message3)
    return

def s2_demo_query():
    cnx,cursor = query.friend_messages_date(1)
    cursor_list = []
    for item in cursor:
        cursor_list.append(item)
    cursor.close()
    cnx.close()
    return cursor_list
        


## inserting has issues with timestamp triggers
def s2_unit_test():
    passed = 0
    #begin by inserting a new user
    print("Inserting new User")
    #try:
    data_user1 = {
    "AccountNumber" : 3,
    "Username" : "GenericUser2",
    "Email" : "user3@user.com",
    "PhoneNumber" : 2,
    "Fname" : "Generic",
    "Minit" : "A",
    "Lname" : "User",
    "UserDoB" : datetime.date(2000,1,1),
    "PasswordHash" : 'ABC'
    }
    insert.new_user(data_user1)
    print("New User Inserted\n")
    passed += 1
    #except:
    print("Error Inserting New User\n")

    # now, query the new user's info
    print("Querying New User")
    try:
        cursor = query.account_info(3)
        print(cursor.fetchone())
        cursor.close()
        print("New User Queried\n")
        passed += 1
    except:
        print("Error querying new user\n")

    # insert a new video on the new user
    print("Inserting new video")
    try:
        video1 = {
        "VideoID" : 2,
        "VideoLink" : 'https://storage.googleapis.com/exerciseapp-bucket1/testvid.mp4',
        "AccountNumber" : '3',
        "VideoTitle" : 'UnitTest1-Title',
        "VidDescription" : 'UnitTest1-Description',
        "Category" : "dev",
        "Views" : 0,
        "UploadDate" : None,
        "Thumbnail" : 'https://storage.googleapis.com/exerciseapp-bucket1/techdiff.jpg'
        }
        insert.new_video(video1)
        print("New Video Inserted\n")
        passed += 1
    except:
        print("Error inserting new video\n")

    # edit the video
    print("Editing video title")
    try:
        edit.video_title(2,"UnitTest1-Title Edited")
        print("Video Title Edited")
        edit.video_description(2,"UnitTest1-Description Edited")
        print("Video Description Edited\n")
        passed += 2
    except:
        print("Error editing video\n")

    # query for a video
    print("Querying for the video")
    try:
        cursor = query.search_videos_name("UnitTest1-Title Edited")
        print(cursor.fetchone())
        cursor.close()
        print("Video queried\n")
        passes += 1
    except:
        print("Error querying videos\n")

    # insert a comment
    print("Inserting new comment")
    try:
        comment1 = {
        "CommentID" : 1,
        "AccountNumber" : 1,
        "CommentBody" : "First Comment",
        "PostDate" : datetime.date(2024,1,31),
        "VideoComment" : 1,
        "ContentComment" : None,
        "ThreadParent" : 0,
        "Edited" : False
        }
        insert.new_video_comment(comment1)
        print("New comment inserted\n")
        passed += 1
    except:
        print("Error inserting new comment\n")
    
    # edit the comment
    print("Editing the comment")
    try:
        edit.comment_body(1,'First Comment Edit')
        print("Comment edited\n")
        passed += 1
    except:
        print("Error editing comment\n")

    # insert new friends
    print("Inserting new friends")
    try:
        friend1 = {
        "PairID" : None,
        "User1ID" : 1,
        "User2ID" : 3
        }
        insert.add_friends(friend1)
        print("Friends added\n")
        passed += 1
    except:
        print("Error adding friends\n")

    # insert new friend message
    print("Inserting new friend message")
    try:
        message1 = {
        "PairID" : 1,
        "MessageID" : None,
        "MessageBody" : 'First message sent',
        "SentStamp" : datetime.date(2024,1,31),
        "SentUser" : 1,
        "AttatchedLink" : None
        }
        insert.new_message(message1)
        print("Friend message sent\n")
        passed += 1
    except:
        print("Error sending friend message\n")

    # inserting a new community
    print("Inserting new community")
    try:
        community1 = {
            "CommunityID" : None,
            "CommName" : 'str',
            "CommDescription" : 'str',
            "CreatedUser" : 'int'
            }
        insert.new_community(community1)
        print("Community inserted\n")
        passed += 1
    except:
        print("Error inserting community\n")
    
    # insert an event
    print("Inserting an Event")
    try:
        events1 = {
        "EventID" : None,
        "EventName" : 'First Event',
        "EventDesc" : 'First Event description',
        "PostTime" : datetime.date(2024,1,31),
        "StartTime" : datetime.date(2024,1,31),
        "EventLocation" : 'Nethken',
        "PosterID" : 1,
        "Category" : 'dev'
        }
        insert.new_event(events1)
        print("Event inserted\n")
        passed += 1
    except:
        print("Error inserting event\n")
    
    print("Total successes: {} Percent success: {}".format(passed, passed/12))
    return


#ConnectAndInsert()
#s2_unit_test()
m = s2_demo_query()
for i in m:
    print(i[2])