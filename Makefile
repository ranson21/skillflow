# Global variables
SHELL := /bin/bash
.DEFAULT_GOAL := help

# Get OS type
UNAME := $(shell uname)

# Colors for terminal output
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# Project directories
SKILLFLOW_DIR := apps/skillflow
SERVICES_DIR := services
ASSETS_DIR := assets

.PHONY: help setup dev test build clean

## Display help information
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-20s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Run initial project setup script
init:
	@chmod +x config/scripts/setup.sh
	@./config/scripts/setup.sh

## Setup development environment
setup: setup-tools setup-app setup-services

## Setup required tools and dependencies
setup-tools:
	@echo "Installing required tools..."
	@if [ "$(UNAME)" = "Darwin" ]; then \
		brew install protobuf golang rustup docker docker-compose; \
	elif [ "$(UNAME)" = "Linux" ]; then \
		sudo apt-get update && \
		sudo apt-get install -y protobuf-compiler golang rustup docker docker-compose; \
	fi
	@rustup default stable
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

## Setup Skillflow app
setup-app:
	@echo "Setting up Skillflow app..."
	@cd $(SKILLFLOW_DIR) && flutter pub get
	@cd $(SKILLFLOW_DIR) && flutter pub run build_runner build --delete-conflicting-outputs

## Setup backend services
setup-services:
	@echo "Setting up backend services..."
	@cd $(SERVICES_DIR)/go-services/auth && go mod download
	@cd $(SERVICES_DIR)/go-services/profile && go mod download
	@cd $(SERVICES_DIR)/rust-services/tracker && cargo build
	@cd $(SERVICES_DIR)/rust-services/analytics && cargo build
	@cd $(SERVICES_DIR)/rust-services/notifications && cargo build

## Start development environment
dev: dev-app dev-services

## Start Skillflow app in development mode
dev-app:
	@cd $(SKILLFLOW_DIR) && flutter run -d chrome

## Start backend services
dev-services:
	@docker-compose up -d

## Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@cd $(SKILLFLOW_DIR) && flutter clean
	@find . -name "target" -type d -exec rm -rf {} +
	@find . -name "bin" -type d -exec rm -rf {} +
	@find . -name "build" -type d -exec rm -rf {} +
	@docker-compose down --rmi all --volumes --remove-orphans
