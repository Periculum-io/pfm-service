import numpy as np
import pandas as pd
import json
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

app = Flask("pfm-api")
app.debug = True

# app.config.update({
#     'SECRET_KEY': '',
#     'TESTING': True,
#     'DEBUG': True,
#     'OIDC_CLIENT_SECRETS': 'client_secrets.json', 
#     'OIDC_OPENID_REALM': 'local',
#     'OIDC_INTROSPECTION_AUTH_METHOD': 'bearer',
#     'OIDC-SCOPES': ['openid'],
#     'OIDC_INTROSPECTION_AUTH_METHOD': 'client_secret_post',
#     'OIDC_TOKEN_TYPE_HINT': 'access_token'
# })

# oidc = OpenIDConnect(app)

config = {
  'aws_iam_access_key': None,
  'aws_iam_secret_access_key': None,
  'aws_secrets_manager_secret_name': None,
}

boto3_session = None
secrets_manager_secret = None
secret = None
database_client = None

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
        # Do tenant verification here
      except:
        return bad_request("Token does not have reqiured claims")
      return f(*args, **kwargs)
   return decorator


@app.route('/healthz', methods = ['GET'])
def health():
    return jsonify(
      application='Prod Periculum PFM Flask API',
      version='1.0.0'
    )

@app.route("/analytics", methods=["POST"])
# @oidc.accept_token(require_token=True)
# @token_required
def process():

    # get data
    query = request.json
    account_name = query['account_name'].lower()

    

    df = pd.DataFrame(query['transactions'])
    data = df.copy()
 
    output = analyse_transctions(data, salary_variables=salary_variables, other_income_variables=other_income_variables, account_name=account_name)

    return output

if __name__ == "__main__":
    print("starting pfm flask app")
    app.debug = True
    app.run()
