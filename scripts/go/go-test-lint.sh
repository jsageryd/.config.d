#!/bin/sh

set -e

go test ./...
go list ./... | xargs -n1 golint -set_exit_status
