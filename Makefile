.EXPORT_ALL_VARIABLES:

IMAGE_NAME := $(shell basename `pwd`)

CI_PROJECT_NAME := $(shell basename `pwd`)
CI_PROJECT_NAMESPACE := $(shell basename $(shell dirname `pwd`))
CI_PROJECT_PATH_SLUG := $(shell echo ${CI_PROJECT_NAMESPACE}-${CI_PROJECT_NAME} | sed 's/\./-/g' | tr '[:upper:]' '[:lower:]')

BASE_PATH ?= $(PWD)
VERSION ?= dev
SOURCE_BRANCH ?= master
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
TOOL_NAME := $(shell basename `pwd`)

all: help

TAG  ?= $(shell git describe --tags --abbrev=0 HEAD)

build: ## docker build image
	docker build . -t otsuarez/aws-ssm-agent
	#docker build . -t otsuarez/aws-ssm-agent:${TAG}

push: ##  push to docker hub
	#docker push otsuarez/aws-ssm-agent:${TAG}
	docker push otsuarez/aws-ssm-agent

run: ## run a container using the image
	# docker run --rm -it otsuarez/aws-ssm-agent:${TAG}
	docker run --rm -it otsuarez/aws-ssm-agent
	# @docker run --rm -it $(CI_PROJECT_NAMESPACE)/$(CI_PROJECT_NAME) /bin/sh

.PHONY: help
help:
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
