import secrets

token = secrets.token_hex(16)
print(token)
print(len(token))