.ONESHELL: changes

all: build

IMAGE := itsaur/openresty-ingress
TAG := $(NGINX_INGRESS_VERSION)

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
	@sed --in-place 's@FROM nginx:1.21.0 AS debian@FROM itsaur/openresty:$(OPENRESTY_VERSION) AS debian@g' "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/build/Dockerfile"
	# Removing unnecessary changes.
	@sed --in-place '/libcap2-bin/d' "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/build/Dockerfile"
	@sed --in-place '/cap_net_bind_service=+ep/d' "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/build/Dockerfile"
	@cd "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/build/"
	@bash generate_default_cert_and_key.sh
	@mv default.pem ../
	@cd ../../
	@sed --in-place 's@# ADD default.pem /etc/nginx/secrets/default@ADD default.pem /etc/nginx/secrets/default@g' "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/build/Dockerfile"

build: changes
	@echo "Building $(IMAGE):$(TAG)..."
	$(MAKE) --directory "kubernetes-ingress-$(NGINX_INGRESS_VERSION)/" PREFIX=$(IMAGE) TARGET=container VERSION=$(NGINX_INGRESS_VERSION) debian-image
	$(MAKE) clean

push: build
	@echo "Tagging $(IMAGE):$(TAG) to $(IMAGE):latest..."
	@docker tag $(IMAGE):$(TAG) $(IMAGE):latest
	@echo "Tagging $(IMAGE):$(TAG) to $(IMAGE):$(TAG)-$(OPENRESTY_VERSION)..."
	@docker tag $(IMAGE):$(TAG) $(IMAGE):$(TAG)-$(OPENRESTY_VERSION)
	@echo "Pushing $(IMAGE)..."
	@docker push --all-tags $(IMAGE)
	$(MAKE) remove

remove:
	@echo "Removing $(IMAGE):latest..."
	@docker rmi $(IMAGE):latest
	@echo "Removing $(IMAGE):$(TAG)..."
	@docker rmi $(IMAGE):$(TAG)
	@echo "Removing $(IMAGE):$(TAG)-$(OPENRESTY_VERSION)..."
	@docker rmi $(IMAGE):$(TAG)-$(OPENRESTY_VERSION)
