#!/bin/sh -l

echo "Creating a module in Terraform Cloud Private Register"

generate_payload() {
 cat <<EOF
  {
  "data": {
    "type": "registry-modules",
    "attributes": {
      "name": "$TF_MODULE_NAME",
      "provider": "$TF_PROVIDER",
      "registry-name": "private"
    }
  }
}
EOF
}

RESPONSE="$(curl \
  --header "Authorization: Bearer ${TF_CLOUD_TOKEN}" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data "$(generate_payload)" \
  https://app.terraform.io/api/v2/organizations/"$TF_ORGANIZATION_NAME"/registry-modules \
  2>/dev/null)"


MODULE="$(echo "${RESPONSE}" | jq '.data')"

# Create a module version in Terraform Cloud
./createVersion.sh

# echo "::set-output name=module::$MODULE"