#!/bin/sh
TEMPLATE=./aws-sam-cli-managed-template.json
OUTPUT=./tmp-sam.json

cd $(dirname "$0")

if [ -f "./account.sh" ]; then
	. ./account.sh
fi

STACKNAME=aws-sam-cli-managed-default

d=$(aws cloudformation describe-stacks \
	--stack-name "$STACKNAME")

if [ -z "$d" ]; then

	aws cloudformation create-stack \
		--stack-name "$STACKNAME" \
		--template-body "file://$TEMPLATE" \
		--capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND CAPABILITY_IAM

	echo "*** Waiting stack create complete..."
	aws cloudformation wait stack-create-complete \
		--stack-name "$STACKNAME"

	echo "** Stack create complete."

	d=$(aws cloudformation describe-stacks \
		--stack-name "$STACKNAME")
fi

echo "$d" >"$OUTPUT"
