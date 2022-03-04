#!/bin/sh -l

echo "Starting publishing a module in \"$1\" Terraform organization"
echo "Module Name: \"$2\""
echo "Provider: \"$3\""
echo "Version \"$4\""

export TF_ORGANIZATION_NAME=$1
export TF_MODULE_NAME=$2
export TF_PROVIDER=$3
export TF_MODULE_VERSION=$4

echo "Checking module status ...."

curl \
  --request GET \
  --header "Authorization: Bearer ${TF_CLOUD_TOKEN}" \
  --data q="${TF_MODULE_NAME}" \
  https://app.terraform.io/api/v2/organizations/"$TF_ORGANIZATION_NAME"/registry-modules

RESPONSE="$(curl \
  --request GET \
  --header "Authorization: Bearer ${TF_CLOUD_TOKEN}" \
  --data q="${TF_MODULE_NAME}" \
  https://app.terraform.io/api/v2/organizations/"$TF_ORGANIZATION_NAME"/registry-modules \
  2>/dev/null)"

MODULES="$(echo "${RESPONSE}" | jq '.data')"

# Checking if the module exit
if [ "$MODULES" == "[]" ]; then
  # Create a module in Terraform Cloud
  ./createModule.sh
else
  echo  "Uploading new version of the module name: \"${TF_MODULE_NAME}\""
fi


