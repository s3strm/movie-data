AWS_DEFAULT_REGION := $(shell ./bin/get_setting AWS_DEFAULT_REGION)
TEMPLATE = file://./cfn.json

STACK_NAME := s3strm-movies
MOVIE_BUCKET := $(shell ./bin/get_setting MOVIE_BUCKET)

PARAMETERS  = "ParameterKey=MovieBucketName,ParameterValue=$(MOVIE_BUCKET)"

ACTION := $(shell ./bin/cloudformation_action $(STACK_NAME))

deploy:
	aws cloudformation $(ACTION)-stack                \
	  --stack-name "$(STACK_NAME)"                    \
	  --template-body "$(TEMPLATE)"                   \
	  --parameters $(PARAMETERS)                      \
	  --capabilities CAPABILITY_IAM                   \
	  2>&1
	@aws cloudformation wait stack-$(ACTION)-complete \
	  --stack-name $(STACK_NAME)
