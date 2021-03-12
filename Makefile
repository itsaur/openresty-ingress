all: build

build:
	@make --directory openresty/ build
	@make --directory nginx-ingress/ push
	@make --directory openresty/ remove
