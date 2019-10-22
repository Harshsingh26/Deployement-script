#!/usr/bin/env bash
# This script will copy the data to S3 and invalidate cloudfront distribution
# Requires awscli and local IAM account with sufficient permissions

# Verify AWS CLI Credentials are setup
# http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

# Create Profile by providing AWS Access KEY ID, and SECRET 
# aws configure --profile name

echo "Git branch"
git branch

echo "==================================================="



echo "Export AWS Profile"
echo " "
echo "====================================================="
read -r -p "Enter the aws profile name: " CLIENT

echo " "
echo "====================================================="
echo "Exporting AWS Profile: "$CLIENT

export AWS_DEFAULT_PROFILE=$CLIENT

echo " "
echo "====================================================="
echo "AWS Buckets List"
aws s3 ls 

echo " "
echo "====================================================="

read -r -p "Enter the S3 Bucket to copy data: " BUCKET

echo " "
echo "====================================================="


echo "Choose linked cloudfront to invalidate: " $BUCKET

aws cloudfront list-distributions --query 'DistributionList.Items[*].{Id:Id, OriginBucket:Origins.Items[0].Id}'

echo " "
echo "====================================================="

read -r -p "Enter the cloudfront Distribution ID to invalidate: " DISTRIBUTIONID

echo " "
echo "====================================================="
echo "Create Build"
ng build --configuration=qa
echo " "
echo "====================================================="

# read -r -p "Enter Build folder location: e.g. (./client/build) " FOLDER


echo " "
echo "====================================================="

echo "Copy Data in Progress to S3 Bucket: " $BUCKET


# aws s3 cp $FOLDER s3://$BUCKET --recursive --acl public-read 

 
aws s3 cp ./dist/client s3://$BUCKET --recursive --acl public-read 

echo " "
echo "====================================================="

echo "Completed!  S3 Copy: " $BUCKET

echo " "
echo "====================================================="

echo "Cloudfront Invalidation Data in Progress: " $DISTRIBUTIONID

aws cloudfront create-invalidation --distribution-id $DISTRIBUTIONID --paths '/*'

echo " "
echo "====================================================="

echo "Completed cloudfront Invalidation for distribution-id" $DISTRIBUTIONID

echo " "
echo "====================================================="

