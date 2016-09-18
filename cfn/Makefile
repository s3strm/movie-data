AWS_DEFAULT_REGION := $(shell ./bin/get_setting AWS_DEFAULT_REGION)
STACK_NAME := $(shell ./bin/get_setting STACK_NAME)
TEMPLATE = file://./cfn.json

MOVIE_BUCKET = $(shell ./bin/get_setting MOVIE_BUCKET)
INCOMING_BUCKET = $(shell ./bin/get_setting INCOMING_BUCKET)

PARAMETERS  = "ParameterKey=MovieBucketName,ParameterValue=$(MOVIE_BUCKET)"
PARAMETERS += "ParameterKey=IncomingBucketName,ParameterValue=$(INCOMING_BUCKET)"

ACTION := $(shell aws cloudformation describe-stacks --stack-name $(STACK_NAME) &>/dev/null && echo update || echo create)

deploy:
	aws cloudformation $(ACTION)-stack                \
	  --stack-name "$(STACK_NAME)"                    \
	  --template-body "$(TEMPLATE)"                   \
	  --parameters ${PARAMETERS}                      \
	  --capabilities CAPABILITY_IAM                   \
	  2>&1
	@aws cloudformation wait stack-$(ACTION)-complete \
	  --stack-name $(STACK_NAME)
