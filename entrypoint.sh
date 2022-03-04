#!/bin/sh -l

echo "Starting publishing a module in \"$1\" Terraform organization"
echo "Storing environment variables"
export TF_ORGANIZATION_NAME=$($1)
echo "$TF_ORGANIZATION_NAME"
echo "$TF_CLOUD_TOKEN"
time=$(date)
echo "::set-output name=time::$time"