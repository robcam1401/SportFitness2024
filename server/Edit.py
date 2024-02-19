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

def videoTitle(video_id,new_title):
    cnx,cursor = connect()

    edit = ("UPDATE Videos SET VideoTitle={} WHERE VideoID={}").format(new_title,video_id)
    cursor.execute(edit)
    cnx.commit()

    cursor.close()
    cnx.close()
    return

def videoDescription(video_id,new_desc):
    cnx,cursor = connect()

    edit = ("UPDATE Videos SET VidDescription={} WHERE VideoID={}").format(new_desc,video_id)
    cursor.execute(edit)
    cnx.commit()
    
    cursor.close()
    cnx.close()
    return

def commentBody(comment_id,new_comment):
    cnx,cursor = connect()

    edit = ("UPDATE Comments SET CommentBody={} WHERE CommentID={}").format(new_comment,comment_id)
    edit2 = ("UPDATE Comments SET Edited=true WHERE CommentID={}").format(comment_id)
    cursor.execute(edit,edit2)
    cnx.commit()
    
    cursor.close()
    cnx.close()

    return

def contentBody(content_id,new_body):
    cnx,cursor = connect()
    edit = ("UPDATE Content Set BodyDescription={} WHERE ContentID={}").format(new_body,content_id)
    cursor.execute(edit)
    cnx.commit()
    
    cursor.close()
    cnx.close()

    return