all: build

build:
	$(MAKE) --directory openresty/ build
	$(MAKE) --directory nginx-ingress/ push
	$(MAKE) --directory openresty/ remove
