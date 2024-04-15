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
# from CloudAPIs.Insert import *
from Insert import *



def deleteContent(content_id):
    cnx,cursor = connect()
    edit = ("Delete Content WHERE ContentID={}").format(content_id)
    cursor.execute(edit)
    cnx.commit()