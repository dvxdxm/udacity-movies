#!/bin/bash

# Define variables
CLUSTER_NAME="luster"  # Replace with your actual cluster name
REGION="us-east-1"      # Replace with your actual cluster region
IAM_USER_NAME="github-action-user"

# Fetch IAM github-action-user ARN
echo "Fetching IAM github-action-user ARN..."
GITHUB_ACTION_USER_ARN=$(aws iam get-user --user-name $IAM_USER_NAME | jq -r '.User.Arn')

if [ -z "$GITHUB_ACTION_USER_ARN" ]; then
  echo "Error: Unable to fetch IAM user ARN."
  exit 1
fi

# Download and configure the aws-iam-authenticator
echo "Downloading aws-iam-authenticator..."
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/darwin/amd64/aws-iam-authenticator # Change URL if using different OS
chmod +x ./aws-iam-authenticator
sudo mv ./aws-iam-authenticator /usr/local/bin

# Update kubeconfig to use aws-iam-authenticator
echo "Updating kubeconfig for EKS cluster..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION

# Patch the aws-auth ConfigMap
echo "Patching aws-auth ConfigMap..."
kubectl get configmap aws-auth -n kube-system -o yaml > aws-auth-patch.yml

# Add the IAM user to the mapUsers section
echo "
mapUsers: |
  - userarn: $GITHUB_ACTION_USER_ARN
    username: github-action-user
    groups:
      - system:masters" >> aws-auth-patch.yml

kubectl apply -f aws-auth-patch.yml

# Clean up
echo "Cleaning up..."
rm aws-auth-patch.yml
echo "Done."

# Remove aws-iam-authenticator if not needed anymore
sudo rm /usr/local/bin/aws-iam-authenticator
