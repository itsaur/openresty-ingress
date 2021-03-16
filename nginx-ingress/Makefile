all: build

IMAGE = itsaur/openresty-ingress
TAG = $(NGINX_INGRESS_VERSION)

clean:
	@rm --force --recursive "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/"

download: clean
	@echo "Downloading NGINX Ingress v$(NGINX_INGRESS_VERSION)..."
	@wget --quiet --show-progress "https://github.com/nginxinc/kubernetes-ingress/archive/v$(NGINX_INGRESS_VERSION).tar.gz"
	@tar --extract --file "v$(NGINX_INGRESS_VERSION).tar.gz"
	@rm "v$(NGINX_INGRESS_VERSION).tar.gz"

changes: download
	@echo "Changing NGINX Ingress v$(NGINX_INGRESS_VERSION)..."
	# Changing NGINX Docker image to our OpenResty Docker image.
	@sed --in-place 's@FROM nginx:1.19.6 AS base@FROM itsaur/openresty:$(OPENRESTY_VERSION) AS base@g' "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/build/Dockerfile"
	# Removing unnecessary changes.
	@sed --in-place '/libcap2-bin/d' "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/build/Dockerfile"
	@sed --in-place '/cap_net_bind_service=+ep/d' "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/build/Dockerfile"

build: changes
	@echo "Building $(IMAGE):$(TAG)..."
	@make --directory "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/" PREFIX=$(IMAGE) container
	@make clean

push: build
	@echo "Pushing $(IMAGE):$(TAG)..."
	@docker push $(IMAGE):$(TAG)
	@make remove

remove:
	@echo "Removing $(IMAGE):$(TAG)..."
	@docker rmi $(IMAGE):$(TAG)
