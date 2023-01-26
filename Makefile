include .env

build:
	DOCKER_BUILDKIT=1 docker build -t cumbuca --ssh default --no-cache \
	--build-arg MIX_ENV=dev \
	.