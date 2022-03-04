#!/bin/sh -l

echo "Creating a version module in Terraform Cloud Private Register"


generate_payload() {
 cat <<EOF
  {
  "data": {
    "type": "registry-module-versions",
    "attributes": {
      "version": "$TF_MODULE_VERSION"
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
  https://app.terraform.io/api/v2/organizations/"$TF_ORGANIZATION_NAME"/registry-modules/private/"$TF_ORGANIZATION_NAME"/${TF_MODULE_NAME}/${TF_PROVIDER}/versions \
  2>/dev/null)"

UPLOAD_LINK="$(echo "${RESPONSE}" | jq '.data.links.upload')"
echo "${UPLOAD_LINK}"