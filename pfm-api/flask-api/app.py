import json
from flask import Flask, make_response
from flask import jsonify
from flask import request

app = Flask(__name__)


def bad_request(message):
    response = {
      'message': message
    }
    return response, 400

def server_error():
    response = jsonify({'message': 'Something went wrong in the server. If the problem persists please contact Periculum'})
    return response, 500

@app.route('/health', methods = ['GET'])
def health():
    return jsonify(
      application='Prod Periculum PFM API',
      version='1.0.0'
    )