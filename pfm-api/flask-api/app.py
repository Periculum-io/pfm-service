import json
from flask import Flask, make_response
from flask import jsonify
from flask import request
import jwt
import datetime
from functools import wraps
from flask_oidc  import OpenIDConnect
app = Flask(__name__)

app.config.update({
    'SECRET_KEY': 'my_secret',
    'TESTING': True,
    'DEBUG': True,
    'OIDC_CLIENT_SECRETS': 'client_secrets.json',
    'OIDC_OPENID_REALM': 'local',
    'OIDC_INTROSPECTION_AUTH_METHOD': 'bearer',
    'OIDC-SCOPES': ['openid'],
    'OIDC_INTROSPECTION_AUTH_METHOD': 'client_secret_post',
    'OIDC_TOKEN_TYPE_HINT': 'access_token'
})

oidc = OpenIDConnect(app)

def bad_request(message):
    response = {
      'message': message
    }
    return response, 400

def server_error():
    response = jsonify({'message': 'Something went wrong in the server. If the problem persists please contact Periculum'})
    return response, 500

def token_required(f):
   @wraps(f)
   def decorator(*args, **kwargs):
      token = None
      if 'Authorization' in request.headers:
         data = request.headers['Authorization']
         token = str.replace(str(data), 'Bearer ', '')
      if not token:
         return jsonify({'message': 'a valid token is missing'})
      try:
        data2 = jwt.decode(token, verify=False)
        print(data2['clientId'])
        print(data2['tenant'])
      except:
        return bad_request("Token does not have reqiured claims")
      return f(*args, **kwargs)
   return decorator

@app.route('/health', methods = ['GET'])
@oidc.accept_token(require_token=True)
@token_required
def health():
    return jsonify(
      application='Prod Periculum PFM API',
      version='1.0.0'
    )
