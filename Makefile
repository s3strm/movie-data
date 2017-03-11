TEMPLATE = file://./cfn.json

STACK_NAME := s3strm-movies
BUCKET_NAME = $(shell aws cloudformation list-exports --query 'Exports[?Name==`s3strm-movies-bucket`].Value'  --output text)
ACTION := $(shell ./bin/cloudformation_action $(STACK_NAME))

.PHONY: deploy sample

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

sample:
	-@aws s3 rm s3://${BUCKET_NAME}/tt0000000/video.mp4 &> /dev/null
	aws s3 cp ./sample/tt0000000.mp4 s3://${BUCKET_NAME}/tt0000000/video.mp4
