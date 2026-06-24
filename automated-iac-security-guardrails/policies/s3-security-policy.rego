package pulumi.s3

deny[msg] {
    resource := input.resources[_]
    resource.type == "aws:s3/bucketPublicAccessBlock:BucketPublicAccessBlock"
    resource.properties.blockPublicAcls == false
    msg := sprintf("S3 bucket public access block must block public ACLs: %s", [resource.name])
}

deny[msg] {
    resource := input.resources[_]
    resource.type == "aws:s3/bucketPublicAccessBlock:BucketPublicAccessBlock"
    resource.properties.blockPublicPolicy == false
    msg := sprintf("S3 bucket public access block must block public policies: %s", [resource.name])
}

deny[msg] {
    resource := input.resources[_]
    resource.type == "aws:s3/bucketPublicAccessBlock:BucketPublicAccessBlock"
    resource.properties.ignorePublicAcls == false
    msg := sprintf("S3 bucket public access block must ignore public ACLs: %s", [resource.name])
}

deny[msg] {
    resource := input.resources[_]
    resource.type == "aws:s3/bucketPublicAccessBlock:BucketPublicAccessBlock"
    resource.properties.restrictPublicBuckets == false
    msg := sprintf("S3 bucket public access block must restrict public buckets: %s", [resource.name])
}

deny[msg] {
    bucket := input.resources[_]
    bucket.type == "aws:s3/bucket:Bucket"
    not has_encryption_config(bucket.name)
    msg := sprintf("S3 bucket must have server-side encryption enabled: %s", [bucket.name])
}

has_encryption_config(bucket_name) {
    resource := input.resources[_]
    resource.type == "aws:s3/bucketServerSideEncryptionConfiguration:BucketServerSideEncryptionConfiguration"
    resource.properties.bucket == bucket_name
}

deny[msg] {
    bucket := input.resources[_]
    bucket.type == "aws:s3/bucket:Bucket"
    not has_versioning_enabled(bucket.name)
    msg := sprintf("S3 bucket must have versioning enabled: %s", [bucket.name])
}

has_versioning_enabled(bucket_name) {
    resource := input.resources[_]
    resource.type == "aws:s3/bucketVersioning:BucketVersioning"
    resource.properties.bucket == bucket_name
    resource.properties.versioningConfiguration.status == "Enabled"
}
