import boto3
import uuid


def write_to_s3(bucket_name, content):
    s3 = boto3.client("s3")

    # Use uuid for the object key
    object_key = f"data/{uuid.uuid4()}.txt"

    s3.put_object(Bucket=bucket_name, Key=object_key, Body=content)

    # Return the full S3 path (bucket + object key)
    s3_path = f"s3://{bucket_name}/{object_key}"
    return {"s3_path": s3_path}
