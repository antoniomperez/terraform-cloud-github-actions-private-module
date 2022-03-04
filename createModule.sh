#!/bin/sh -l

echo "Creating a module in Terraform Cloud Private Register"
RESPONSE="$(curl \
  --header "Authorization: Bearer ${TF_CLOUD_TOKEN}" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @payload.json \
  https://app.terraform.io/api/v2/organizations/"$TF_ORGANIZATION_NAME"/registry-modules \
  2>/dev/null)"


echo "::set-output name=module::$RESPONSE"