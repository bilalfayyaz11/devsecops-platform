import pulumi
import pulumi_aws as aws

vpc = aws.ec2.Vpc("main-vpc",
    cidr_block="10.0.0.0/16",
    enable_dns_hostnames=True,
    enable_dns_support=True,
    tags={
        "Name": "main-vpc",
        "Environment": "lab"
    }
)

bucket = aws.s3.Bucket("secure-bucket",
    tags={
        "Name": "SecureBucket",
        "Environment": "lab"
    }
)

bucket_public_access_block = aws.s3.BucketPublicAccessBlock("bucket-pab",
    bucket=bucket.id,
    block_public_acls=True,
    block_public_policy=True,
    ignore_public_acls=True,
    restrict_public_buckets=True
)

bucket_encryption = aws.s3.BucketServerSideEncryptionConfiguration("bucket-encryption",
    bucket=bucket.id,
    rules=[aws.s3.BucketServerSideEncryptionConfigurationRuleArgs(
        apply_server_side_encryption_by_default=aws.s3.BucketServerSideEncryptionConfigurationRuleApplyServerSideEncryptionByDefaultArgs(
            sse_algorithm="AES256"
        )
    )]
)

bucket_versioning = aws.s3.BucketVersioning("bucket-versioning",
    bucket=bucket.id,
    versioning_configuration=aws.s3.BucketVersioningVersioningConfigurationArgs(
        status="Enabled"
    )
)

pulumi.export("bucket_name", bucket.bucket)
pulumi.export("vpc_id", vpc.id)
