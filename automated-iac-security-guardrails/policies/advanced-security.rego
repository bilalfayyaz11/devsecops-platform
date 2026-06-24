package pulumi.advanced

required_tags := ["Environment", "Owner", "Project"]

deny[msg] {
    resource := input.resources[_]
    resource.type == "aws:s3/bucket:Bucket"
    missing_tags := required_tags[_]
    not resource.properties.tags[missing_tags]
    msg := sprintf("Resource %s is missing required tag: %s", [resource.name, missing_tags])
}

deny[msg] {
    resource := input.resources[_]
    resource.type == "aws:s3/bucket:Bucket"
    not startswith(resource.name, "secure-")
    msg := sprintf("S3 bucket name must start with 'secure-': %s", [resource.name])
}
