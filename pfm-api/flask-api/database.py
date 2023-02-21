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
        
    """Gets Client information by tenant name"""
    def get_client_by_tenant_name(self, tenant):
        """
        :param tenant: Tenant name
        """
        try:
          print("Tenant>>>>")
          print(tenant)

          record = self.db.one("""
            SELECT
              key as client_key,
              name,
              api_id,
              is_active,
              date_created
            FROM Pfm.Client
            WHERE name=%(name)s
              AND is_active=true;""", { 'name': tenant })

          if record is None:
            raise Exception('CLIENT')          
          
          return {
            'client_key': record.client_key,
            'name': record.name,
            'api_id': record.api_id,
            'is_active': record.is_active,
            'date_created': record.date_created
          }
        except:
          traceback.print_exc()           
          raise


    """Log endpoint call to the db"""
    def save_endpoint_call(self, client_key, endpoint_key, response_status):
      """
      :param client_key: The client_key of the client 
      :param endpoint_key: The id of the endpoint call 
      :param response_status: response status from ml model
      """
      
      try:
        dt = datetime.datetime.utcnow()
        date_created = dt.strftime('%Y-%m-%d %H:%M:%S')
        
        self.db.run(
          """
          INSERT INTO Pfm.endpointcallhistory
          (client_key, endpoint_key, price, response_status, date_created)
          VALUES (%(client_key)s, %(endpoint_key)s, 1, %(response_status)s, %(date_created)s);
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