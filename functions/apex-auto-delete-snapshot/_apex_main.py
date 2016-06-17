import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        client = boto3.client('ec2')
        imageID = event['detail']['requestParameters']['imageId']

        response = client.describe_snapshots(
            Filters=[
                {
                    'Name': 'description',
                    'Values': [
                        'Created by CreateImage(*) for ' + imageID + ' from *',
                    ]
                }
            ]
        )

        for i in response['Snapshots']:
            client.delete_snapshot(
                SnapshotId=i['SnapshotId']
                )

            logger.info("Delete target:" + i['SnapshotId'] + ", Description:" + i['Description'])

    except Exception as e:
        print(e)
        raise e
