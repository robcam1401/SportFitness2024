# required imports
import sys
import os

# # find absolute paths
# _CloudAPIs =  os.path.join(os.getcwd(), os.path.dirname("CloudAPIs"))
# _libs =  os.path.join(os.getcwd(), os.path.dirname("libs"))

# # insert into path variables
# sys.path.insert(0,_CloudAPIs)
# sys.path.insert(0,_libs)

# import from path variables
# from CloudAPIs.Insert import *
# from CloudAPIs.Query import *
# from CloudAPIs.Edit import *

from Insert import *
from Query import *
from Edit import *

## start with the insert functions
class insert():

    # the account number will be automatically assigned on insertion
    user_info_template = {
        "AccountNumber" : None,
        "Username" : 'str',
        "Email" : 'str',
        "PhoneNumber" : 'int',
        "Fname" : "str",
        "Minit" : "char",
        "Lname" : 'str',
        "UserDoB" : 'yyyy-mm-dd',
        "PasswordHash" : 'str'
    }

    resource_info_template = {
        "AccountNumber": None,
        "ResourceName": 'str',  # Assuming this corresponds to "Username" in your table
        "Resource_Description": 'str',  # Assuming this corresponds to "Email" in your table
        "People_amount": 'bool',  # Assuming this corresponds to "PhoneNumber" in your table
        "Hours_amount": 'bool',  # Assuming this corresponds to "Fname" in your table
        "Date_of_Booking": 'bool',  # Assuming this corresponds to "Minit" in your table
        "Payment": 'bool',  # Assuming this corresponds to "Lname" in your table
        "File_Upload": 'bool'  # Assuming this corresponds to "UserDoB" in your table
    }

    bookmark_like_info_template = {
        "bmlID" : 'int(32)',
        "AccountNumber" : 'int(32)',
        "Bookmarked" : 'bool',
        "Liked" : 'bool',
        # contentType: 0 = video, 1 = content, 2 = comment
        "ContentType" : 'int(2)',
        "ContentID" : 'int(32)'
    }

    # VideoLink, Thumbnail, UploadDate are automatically assigned on insert
    video_info_template = {
        "VideoID" : None,
        "VideoLink" : None,
        "AccountNumber" : 'int',
        "VideoTitle" : 'str',
        "VidDescription" : 'str',
        "Category" : "dev",
        "Views" : 0,
        "UploadDate" : None,
        "Thumbnail" : None
    }

    comment_info_template = {
        "CommentID" : None,
        "AccountNumber" : 'int',
        "CommentBody" : 'str',
        "PostDate" : None,
        "VideoComment" : 'int',
        "ContentComment" : 'int',
        "ThreadParent" : 'int',
        "Edited" : False
    }

    # SentStamp, AttatchedLink are automatically assigned on insert
    message_info_template = {
        "PairID" : 'int',
        "MessageID" : None,
        "MessageBody" : 'str',
        "SentStamp" : None,
        "SentUser" : 'int'
    }

    friend_info_template = {
        "PairID" : None,
        "User1ID" : 'int',
        "User2ID" : 'int'
    }

    friend_request_info_template = {
        "RequestID" : None,
        "User1ID" : 'int',
        "User2ID" : 'int',
        "User1Accepted" : 'bool',
        "User2Accepted" : 'bool'
    }

    message_info_template = {
        "PairID" : 'int',
        "MessageID" : None,
        "MessageBody" : 'str',
        "SentStamp" : None,
        "SentUser" : 'int',
        "AttatchedLink" : None
    }

    community_info_template = {
        "CommunityID" : None,
        "CommName" : 'str',
        "CommDescription" : 'str',
        "CreatedUser" : 'int'
    }

    community_member_template = {
        "CommunityID" : 'int',
        "AccountID" : 'int'
    }

    community_messages_info_template = {
        "CommunityID" : 'int',
        "MessageID" : None,
        "MessageBody" : 'str',
        "AttatchedLink" : 'str',
        "SentStamp" : None,
        "SentUser" : 'int'
    }

    events_info_template = {
        "EventID" : None,
        "EventName" : 'str',
        "EventDesc" : 'str',
        "PostTime" : None,
        "StartTime" : 'datetime',
        "EventLocation" : 'str',
        "PosterID" : 'int',
        "Category" : 'str'
    }

    def new_user(user_info):
        errors = newAccountInsert(user_info)
        return errors

    def new_video(video_info):
        errors = newVideoInsert(video_info)
        return errors
    
    def new_resource(resource_info):
        errors = newResourceInsert(resource_info)
        return errors

    def new_content_comment(comment_info):
        newCommentInsertContent(comment_info)
        return 'Inserted'
    def new_video_comment(comment_info):
        newCommentInsertVideo(comment_info)
        return 'Inserted'

    def new_content(content_info):
        newContentInsert(content_info)
        return 'Inserted'
    
    def new_bookmarks_likes(bookmark_like_info):
        newBookmarksLikes(bookmark_like_info)
        return 'Inserted'

    def add_friends(friend_info):
        newFriendsInsert(friend_info)
        return 'Inserted'
    
    def new_friend_request(request_info):
        newFriendRequests(request_info)
        return 'Inserted'

    def new_message(message_info):
        errors = newFriendMessages(message_info)
        return errors

    def new_message_link(message_info,link):
        newFriendMessages(message_info,link)
        return 'Inserted'

    def new_community(community_info):
        newCommunityInsert(community_info)
        return 'Inserted'

    def new_comm_message(message_info):
        newCommMessages(message_info)
        return 'Inserted'

    def new_comm_message(message_info,link):
        newCommMessages(message_info,link)
        return 'Inserted'

    def new_event(event_info):
        newEvent(event_info)
        return 'Inserted'

## query functions
class query():

    # given an account number, returns the row containing the account number
    def account_info(account_info):
        return_matrix = accountInfo(account_info['AccountNumber'])
        return return_matrix
    # given an account number, returns the email associated
    def account_email(account_info):
        return_matrix = accountSearchEmail(int(account_info['AccountNumber']))
        return return_matrix
    
    def account_name(account_info):
        return_matrix = accountName(int(account_info['AccountNumber']))
        return return_matrix
    
    # given a password hash and a username, returns authentication and a login token
    def password_hash(auth_info):
        return_matrix = passwordHashAuth(auth_info['PasswordHash'],auth_info['Username'])
        return return_matrix

    # given a username, search for the user account
    def account_name_info(search_term):
        return_matrix = accountSearchName(search_term)        
        return return_matrix

    # given a depth to search, search all videos by date
    def all_videos_date(depth):
        return_matrix = allVideosDate(depth)
        return return_matrix

    # given an account number, returns a table containing all videos by the specified account
    # ordered descending and ascending by date
    def account_videos_date_desc(account_info):
        return_matrix = accountVideosDate(account_info['AccountNumber'], " DESC")
        return return_matrix
    def account_videos_date_asc(account_info):
        return_matrix = accountVideosDate(account_info['AccountNumber'], "")
        return return_matrix
    
    # given a search term, returns a cursor containing the video(s)
    def search_videos_name(search_term):
        return_matrix = videoSearchName(search_term)
        return return_matrix

    # given an account number, returns a table containing all content by the specified account
    # ordered descending and ascending by date
    def account_content_date_desc(account_number):
        return_matrix = accountContentDate(account_number, " DESC")
        return return_matrix
    def account_content_date_asc(account_number):
        return_matrix = accountContentDate(account_number, "")
        return return_matrix
    
    # given a search term, search for videos matching the search term
    def video_search_name(search_term):
        return_matrix = videoSearchName(search_term)
        return return_matrix
    
    # given a video/content id, returns a table containing all top-level comments on the specified video/content
    # ordered descending and ascending by date
    # 1 specifies videos for the server-level api, 0 specifies content
    def video_comments_asc(videoid):
        return_matrix = commentsUnderPost(videoid, "",1)
        return return_matrix
    def video_comments_desc(videoid):
        return_matrix = commentsUnderPost(videoid," DESC",1)
        return return_matrix
    # return children of a specific comment
    def video_comments_desc_children(commentinfo):
        return_matrix = commentsUnderComment(commentinfo['VideoID'],'DESC',1,commentinfo['ParentID'])
        return return_matrix
    def video_comments_asc_children(commentinfo):
        return_matrix = commentsUnderComment(commentinfo['VideoID'],'',1,commentinfo['ParentID'])
        return return_matrix

    def content_comments_asc(contentid):
        return_matrix = commentsUnderPost(contentid, "",0)
        return return_matrix
    def content_comments_desc(contentid):
        return_matrix = commentsUnderPost(contentid, " DESC",0)
        return return_matrix
    # return children of a specific comment
    def content_comments_desc_children(commentinfo):
        return_matrix = commentsUnderComment(commentinfo['ContentID'],'DESC',0,commentinfo['ParentID'])
        return return_matrix
    def content_comments_asc_children(commentinfo):
        return_matrix = commentsUnderComment(commentinfo['ContentID'],'',0,commentinfo['ParentID'])
        return return_matrix
    
    def comment_body(commentid):
        return_matrix = commentBody(commentid)
        return return_matrix
    
        # given an account number, retrieve the friends list of a user
    def account_friends_list(query_info):
        return_matrix = friendsList(query_info['AccountNumber'])
        return return_matrix
    # given a pair id, return the messages between two friends
    def friend_messages_date(pair_id):
        return_matrix = friendPairMessages(pair_id)
        return return_matrix
    
    def account_communities(query_info):
        return_matrix = accountCommunities(query_info['AccountNumber'])
        return return_matrix

## edit functions, for editable tables and columns
    
class edit():
    def video_title(videoid,newtitle):
        videoTitle(videoid,newtitle)
        return 
    def video_description(videoid,newdescription):
        videoDescription(videoid,newdescription)
        return
    
    def comment_body(commentid,newbody):
        commentBody(commentid,newbody)
        return
    
    def content_body(contentid,newbody):
        contentBody(contentid,newbody)
        return

## delete functions for deleteable tables and columns

class delete():
    def de():
        pass
##
