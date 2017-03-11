TEMPLATE = file://./cfn.json

STACK_NAME := s3strm-movies
BUCKET_NAME = $(shell aws cloudformation list-exports --query 'Exports[?Name==`s3strm-movies-bucket`].Value'  --output text)
ACTION := $(shell ./bin/cloudformation_action $(STACK_NAME))

deploy:
	aws cloudformation $(ACTION)-stack                        \
	  --stack-name "$(STACK_NAME)"                            \
	  --template-body "$(TEMPLATE)"                           \
	  --parameters                                            \
	    ParameterKey=BucketName,ParameterValue=${BUCKET_NAME} \
	  --capabilities CAPABILITY_IAM                           \
	  2>&1
	@aws cloudformation wait stack-$(ACTION)-complete \
	  --stack-name $(STACK_NAME)
