from Insert import connect
from secrets import token_hex
from zachhash import zachhash

# should be called once when starting up the app, and during priveleged actions (uploading,deleting)
def acct_auth(acct_id,token):
    cnx,cursor = connect()
    auth = False
    try:
        query = ("SELECT * FROM UserAuth WHERE AccountNumber={} AND Token={}").format(acct_id,token)
        cursor.execute(query)
        cnx.commit()
        if cursor.rowcount > 0:
            auth = True
    except:
        auth = False
    return auth

# Create a new token for an account when logging in
def create_token(acct_id):
    cnx,cursor = connect()

    new_token = token_hex(16)
    user_token_pair = {
        "AccountID" : acct_id,
        "Token" : new_token
    }

    query = ("INSERT INTO Content "
              "(AccountID, Token)"
              "VALUES (%(AccountID)s, %(Token)s)")
    
    cursor.execute(query,user_token_pair)
    cnx.commit()
    cnx.close()
    return new_token

def password_auth(pw):
    return zachhash(pw)
