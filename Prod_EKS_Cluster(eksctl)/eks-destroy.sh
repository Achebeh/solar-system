#!/bin/bash
# This script deletes the EKS cluster created with eksctl

CLUSTER_NAME="lohli-prod"
AWS_DEFAULT_REGION="us-east-1"

echo "Deleting EKS cluster: ${CLUSTER_NAME} in region: ${AWS_DEFAULT_REGION}"
eksctl delete cluster --name=${CLUSTER_NAME} --region=${AWS_DEFAULT_REGION} --wait

if [ $? -eq 0 ]; then
  echo "EKS cluster ${CLUSTER_NAME} deleted successfully."
else
  echo "Error deleting EKS cluster ${CLUSTER_NAME}."
  exit 1
fi
