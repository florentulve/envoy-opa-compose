.PHONY: build

build:
	cd app && npm install && npm run build && npm prune --production
	podman build -f Dockerfile -t nest-sample-app ./app
