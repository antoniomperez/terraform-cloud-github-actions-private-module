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
#echo "${MODULES}"

# Checking if the module exit
if [ "$MODULES" = "[]" ]; then
  # Create a module in Terraform Cloud
  ./createModule.sh
else
  # Check if version exist
  VERSIONS="$(echo "${RESPONSE}" | jq '.data' | jq '.[0].attributes."version-statuses"' | jq --arg v "${TF_MODULE_VERSION}" '.[] | select(.version == $v)' )"

  if [ "$VERSIONS" != "" ]; then
    echo "The version number \"$TF_MODULE_VERSION\" exists in Terraform Cloud Registry. Try another version number"
    exit 1;
  fi

  # Create a module version in Terraform Cloud
  ./createVersion.sh
fi



