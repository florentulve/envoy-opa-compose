.PHONY: build

build:
	podman build -f Dockerfile -t nest-sample-app ./app
