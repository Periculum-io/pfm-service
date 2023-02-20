import datetime
from pprint import pprint
import traceback
import calendar
import boto3
import time

from postgres import Postgres

class DatabaseClient:
    """Encapsulates Database Access Functions."""
    def __init__(self, server, dbname, username, password):
        """
        :param server: The database host server address
        :param databaseName: The name of the database
        :param username: The database username to login with
        :param password: The database password to login with
        """
        self.server = server
        self.dbname = dbname
        self.username = username
        self.password = password
        self.db = Postgres(
          url='host={server} dbname={db_name} user={user} password={password}'.format(server=server,db_name=dbname,user=username,password=password),
          minconn=1,
          maxconn=10,
          idle_timeout=120,
          readonly=False
        )
        
    """Log endpoint call to the db"""
    def save_endpoint_call(self, tenant, endpoint_key, response_status):
      """
      :param tenant: The id of the client 
      :param endpoint_key: The id of the endpoint call 
      :param response_status: response status from ml model
      """
      
      try:
        dt = datetime.datetime.utcnow()
        date_created = dt.strftime('%Y-%m-%d %H:%M:%S')

        print("In the database client...")

        # Get client_key from tenant name
        client_key = 2

        self.db.run(
          """
          INSERT INTO Pfm.endpointcallhistory
          (client_key, endpoint_key, response_status, date_created)
          VALUES (%(client_key)s, %(endpoint_key)s, %(response_status)s);
          """,
          {
            'client_key': client_key,
            'endpoint_key': endpoint_key,
            'response_status': response_status, 
            'date_created': date_created
          }
        )
      except:
        traceback.print_exc()         
        raise