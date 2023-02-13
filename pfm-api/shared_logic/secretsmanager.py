from pprint import pprint
from botocore.exceptions import ClientError

class SecretsManagerSecret:
    """Encapsulates Secrets Manager functions."""
    def __init__(self, s3client, name):
        """
        :param secretsmanager_client: A Boto3 Secrets Manager client.
        """
        self.secretsmanager_client = s3client
        self.name = name
        self.secret = None

    def get_value(self, stage=None):
        """
        Gets the value of a secret.

        :param stage: The stage of the secret to retrieve. If this is None, the
                      current stage is retrieved.
        :return: The value of the secret. When the secret is a string, the value is
                 contained in the `SecretString` field. When the secret is bytes,
                 it is contained in the `SecretBinary` field.
        """
        if self.name is None:
            raise ValueError

        if self.secret is None:
          try:
              kwargs = {'SecretId': self.name}
              if stage is not None:
                  kwargs['VersionStage'] = stage
              response = self.secretsmanager_client.get_secret_value(**kwargs)["SecretString"]
              self.secret = response
          except ClientError:
              print("Couldn't get value for secret %s.", self.name)
              raise
          else:
              return response
        else:
          return self.secret