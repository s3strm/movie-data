AWS_DEFAULT_REGION := $(shell ./bin/get_setting AWS_DEFAULT_REGION)
TEMPLATE = file://./cfn.json

INCOMING_BUCKET := $(shell ./bin/get_setting INCOMING_BUCKET)
MOVIE_BUCKET := $(shell ./bin/get_setting MOVIE_BUCKET)
MOVIE_POSTER_STACK_NAME := $(shell ./bin/get_setting MOVIE_POSTER_STACK_NAME)
MOVIE_STACK_NAME := $(shell ./bin/get_setting MOVIE_STACK_NAME)
MOVIE_STRM_STACK_NAME := $(shell ./bin/get_setting MOVIE_STACK_NAME)
POSTERS_LAMBDA := $(shell ./bin/get_stack_output $(MOVIE_POSTER_STACK_NAME) LambdaArn)
STRM_LAMBDA := $(shell ./bin/get_stack_output $(MOVIE_STRM_STACK_NAME) LambdaArn)

PARAMETERS  = "ParameterKey=MovieBucketName,ParameterValue=$(MOVIE_BUCKET)"
PARAMETERS += "ParameterKey=IncomingBucketName,ParameterValue=$(INCOMING_BUCKET)"
PARAMETERS += "ParameterKey=PostersLambdaArn,ParameterValue=$(POSTERS_LAMBDA)"
PARAMETERS += "ParameterKey=StrmLambdaArn,ParameterValue=$(STRM_LAMBDA)"

ACTION := $(shell ./bin/cloudformation_action $(MOVIE_STACK_NAME))

deploy:
	aws cloudformation $(ACTION)-stack                \
	  --stack-name "$(MOVIE_STACK_NAME)"              \
	  --template-body "$(TEMPLATE)"                   \
	  --parameters $(PARAMETERS)                      \
	  --capabilities CAPABILITY_IAM                   \
	  2>&1
	@aws cloudformation wait stack-$(ACTION)-complete \
	  --stack-name $(MOVIE_STACK_NAME)
