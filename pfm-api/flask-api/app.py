import numpy as np
import pandas as pd
import json
import uuid
from glob import escape
from http.client import UNAUTHORIZED
from flask import Flask, make_response
from flask import jsonify
from flask import request
from helpers import salary_variables, other_income_variables
from businesslogic import analyse_transctions

# Keycloak
import jwt
import datetime
from functools import wraps
from flask_oidc  import OpenIDConnect

# AWS
import boto3
import csv
from shared_logic.database import DatabaseClient
from shared_logic.secretsmanager import SecretsManagerSecret

config = {
  'aws_iam_access_key': None,
  'aws_iam_secret_access_key': None,
  'aws_secrets_manager_secret_name': None,
}

boto3_session = None
secrets_manager_secret = None
secret = None
database_client = None
tenant = None

with open('../../../credentials.csv', newline='') as credentials_file:
  reader = csv.reader(credentials_file)
  items = list(reader)[0]
  config['aws_iam_access_key'] = items[0]
  config['aws_iam_secret_access_key'] = items[1]
  config['aws_secrets_manager_secret_name'] = items[2]

session = boto3.Session(
  aws_access_key_id = config['aws_iam_access_key'],
  aws_secret_access_key = config['aws_iam_secret_access_key'],
  region_name='us-east-1'
)

secrets_manager_secret = SecretsManagerSecret(
  session.client('secretsmanager'),
  config['aws_secrets_manager_secret_name']
)

secret = json.loads(secrets_manager_secret.get_value())

database_client = DatabaseClient(
  server = secret['database_connection_string'],
  dbname = 'Pfm',
  username = secret['database_username'],
  password = secret['database_password']
)

client_secrets_dictionary = {
  "web":{
    "issuer": secret['keycloak_authority'],
    "auth_uri": str(secret['keycloak_authority'])+"/protocol/openid-connect/auth",
    "client_id": "pfm-flask-api",
    "client_secret": secret['keycloak_clientsecret'], 
    "userinfo_uri": str(secret['keycloak_authority'])+"/protocol/openid-connect/userinfo",
    "token_uri": str(secret['keycloak_authority'])+"/protocol/openid-connect/token",
    "token_introspection_uri": str(secret['keycloak_authority'])+"/protocol/openid-connect/token/introspect"
  }
}
client_secrets = json.dumps(client_secrets_dictionary)

# Writin secrets to a json file
with open("../../../client_secrets.json", "w") as outfile:
    outfile.write(client_secrets)

print("PFM Config Settings!!")
print(client_secrets)
print(config)
print(secret['keycloak_realm'])

# Flask App Setup
app = Flask("pfm-api")
app.debug = True
app.config.update({
    'SECRET_KEY': str(uuid.uuid4()),
    'TESTING': True,
    'DEBUG': True,
    'OIDC_CLIENT_SECRETS': '../../../client_secrets.json',
    'OIDC_OPENID_REALM': secret['keycloak_realm'],
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
        decoded = jwt.decode(token, key=None, options={"verify_signature":False, "verify_aud": False})
        if(len(decoded['clientId']) == 0 or len(decoded['tenant']) == 0):
            return bad_request("Token does not have reqiured claims - clientId and tenant")

      except Exception as e: 
        print(e)
        return bad_request("An error occured during authentication - Please try again later: " + str(e))
      
      return f(*args, **kwargs)

   return decorator


@app.route('/healthz', methods = ['GET'])
def health():
    return jsonify(
      application='Prod Periculum PFM Flask API',
      version='1.0.0'
    )

@app.route("/analytics", methods=["POST"])
@oidc.accept_token(require_token=True)
@token_required
def process():
    
    token = str.replace(str(request.headers['Authorization']), 'Bearer ', '')
    decoded = jwt.decode(token, key=None, options={"verify_signature":False})
    
    # print("Decoded Tenant")
    # print(decoded['tenant'])
    
    # get data
    query = request.json
    account_name = query['account_name'].lower()

    df = pd.DataFrame(query['transactions'])
    data = df.copy()

    output = analyse_transctions(data, salary_variables=salary_variables, other_income_variables=other_income_variables, account_name=account_name)

    # Log DB Call
    #database_client.save_endpoint_call(decoded['tenant'], 1, 'SUCCESS')

    return output

if __name__ == "__main__":
    print("starting pfm flask app")
    app.debug = True
    app.run()
