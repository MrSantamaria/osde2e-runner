.PHONY: check generate build-image push-image push-latest test

PKG := github.com/openshift/osde2e-test
DOC_PKG := $(PKG)/cmd/osde2e-docs

DIR := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

OUT_DIR := $(DIR)out
OSDE2E := $(DIR)out/osde2e

OSDE2E_RUNNER_IMAGE_NAME := quay.io/app-sre/osde2e-test
IMAGE_TAG := $(shell git rev-parse --short=7 HEAD)

CONTAINER_ENGINE ?= docker

ifndef $(GOPATH)
    GOPATH=$(shell go env GOPATH)
    export GOPATH
endif

fmt:
	gofmt -s -w .

check: lint vipercheck 
	CGO_ENABLED=0 go test -v $(PKG)/cmd/... $(PKG)/pkg/...

lint:
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(shell go env GOPATH)/bin v1.50.1
	(cd "$(DIR)"; golangci-lint run -c .golang-ci.yml ./...)

vipercheck:
	@if [ "$(shell go list -f '{{.Name}} {{.Imports}}' ./... | grep -v -E "^concurrentviper" | grep 'github.com/spf13/viper'| wc -l)" -gt 0 ]; then echo "Error: Code contains direct import of github.com/spf13/viper, use github.com/openshift/osde2e/pkg/common/concurrentviper instead." && exit 1; else echo "make vipercheck has passed, concurrentViper is being used."; fi

build-image:
	$(CONTAINER_ENGINE) build -f "$(DIR)Dockerfile" -t "$(OSDE2E_RUNNER_IMAGE_NAME):$(IMAGE_TAG)" .

push-image:
	@$(CONTAINER_ENGINE) --config=$(DOCKER_CONF) push "$(OSDE2E_RUNNER_IMAGE_NAME):$(IMAGE_TAG)"

push-latest:
	$(CONTAINER_ENGINE) tag "$(OSDE2E_RUNNER_IMAGE_NAME):$(IMAGE_TAG)" "$(OSDE2E_RUNNER_IMAGE_NAME):latest"
	@$(CONTAINER_ENGINE) --config=$(DOCKER_CONF) push "$(OSDE2E_RUNNER_IMAGE_NAME):latest"

build:
	mkdir -p "$(OUT_DIR)"
	go build -o "$(OUT_DIR)" "$(DIR)cmd/..."
