#!/usr/bin/env bash
# audit_aws_sns
#
# Refer to Section(s) 3.15 Page(s) 129-30 CIS AWS Foundations Benchmark v1.1.0
# Refer to https://www.cloudconformity.com/conformity-rules/SNS/sns-topic-exposed.html
#.
  RED='\033[0;31m'
  NC='\033[0m'
  GREEN='\033[0;32m'
  BOLD='\033[1m'
  printf "\n\n"
  printf "${BOLD}############\n"
  printf "    SNS\n"
  printf "############${NC}\n\n"
for  aws_region in ap-south-1 eu-west-2 eu-west-1 ap-northeast-2 ap-northeast-1 sa-east-1 ca-central-1 ap-southeast-1 ap-southeast-2 eu-central-1 us-east-1 us-east-2 us-west-1 us-west-2;do
  topics=`aws sns list-topics --region $aws_region --query 'Topics[].TopicArn' --output text`
  for topic in $topics; do
    # Check SNS topics have subscribers
    subscribers=`aws sns list-subscriptions-by-topic --region $aws_region --topic-arn $topic --output text`
    if [ ! "$subscribers" ]; then
      printf "${RED}SNS topic $topic has no subscribers${NC}\n"
    else
      printf "${GREEN}SNS topic $topic has subscribers${NC}\n"
    fi
    #check SNS topics are not publicly accessible
    check=`aws sns get-topic-attributes --region $aws_region --topic-arn $topic --query 'Attributes.Policy'  |egrep "\*|{\"AWS\":\"\*\"}"`
    if [ "$check" ]; then
      printf "${RED}SNS topic $topic is publicly accessible${NC}\n"
    else
      printf "${GREEN}SNS topic $topic is not  publicly accessible${NC}\n"
    fi
  done
done
