#!/bin/sh -l

echo "Starting publishing a module in \"$1\" Terraform organization"
echo "Module Name: \"$2\""
echo "Provider: \"$3\""
echo "Version \"$4\""

export TF_ORGANIZATION_NAME=$1
export TF_MODULE_NAME=$2
export TF_PROVIDER=$3
export TF_MODULE_VERSION=$4

echo
echo "Checking module status ...."
echo 

RESPONSE="$(curl \
  --request GET \
  --header "Authorization: Bearer ${TF_CLOUD_TOKEN}" \
  --data q="${TF_MODULE_NAME}" \
  https://app.terraform.io/api/v2/organizations/"$TF_ORGANIZATION_NAME"/registry-modules \
  2>/dev/null)"

MODULES="$(echo "${RESPONSE}" | jq '.data')"
VERSION="$(echo "${RESPONSE}" | jq '.data' | jq '.[0].attributes."version-statuses"' | jq '.[0].version')"
echo "${VERSION}"
# .attributes.version-statuses.version

# Checking if the module exit
if [ "$MODULES" == "[]" ]; then
  # Create a module in Terraform Cloud
  ./createModule.sh
else
  # Check if version exist
  VERSIONS="$(echo "${RESPONSE}" | jq '.data' | jq '.[0].attributes."version-statuses"')"
  # Create a module version in Terraform Cloud
  ./createVersion.sh

  
fi


