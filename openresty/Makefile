all: push

IMAGE := itsaur/openresty
PROCESSORS := $(shell nproc)
RESTY_CONFIG_OPTIONS := $(shell cat flags)
TAG := $(OPENRESTY_VERSION)

clean:
	@rm --force --recursive "docker-openresty-$(OPENRESTY_VERSION)/"

download: clean
	@echo "Downloading OpenResty v$(OPENRESTY_VERSION)..."
	@wget --quiet --show-progress "https://github.com/openresty/docker-openresty/archive/$(OPENRESTY_VERSION).tar.gz"
	@tar --extract --file "$(OPENRESTY_VERSION).tar.gz"
	@rm "$(OPENRESTY_VERSION).tar.gz"

changes: download
	@echo "Changing OpenResty v$(OPENRESTY_VERSION)..."
	# Naming OpenResty Docker image layer as openresty, in order to reference it later in our Dockerfile.
	@sed --in-place 's/^FROM .*/& AS openresty/' "docker-openresty-$(OPENRESTY_VERSION)/focal/Dockerfile"
	# Changing OpenResty paths.
	@sed --in-place 's@/usr/local/openresty/nginx/logs/@/var/log/nginx/@g' "docker-openresty-$(OPENRESTY_VERSION)/focal/Dockerfile"
	@sed --in-place 's@/usr/local/openresty/@/etc/nginx/@g' "docker-openresty-$(OPENRESTY_VERSION)/focal/Dockerfile"
	@sed --in-place 's@/etc/nginx/nginx/@/etc/nginx/@g' "docker-openresty-$(OPENRESTY_VERSION)/focal/Dockerfile"
	# Appending our Dockerfile.
	@cat Dockerfile >>"docker-openresty-$(OPENRESTY_VERSION)/focal/Dockerfile"

build: changes
	@echo "Building $(IMAGE):$(TAG)..."
	@docker build \
	--build-arg RESTY_CONFIG_OPTIONS="$(RESTY_CONFIG_OPTIONS)" \
	--build-arg RESTY_J="$(PROCESSORS)" \
	--build-arg RESTY_USER="nginx" \
	--file "docker-openresty-$(OPENRESTY_VERSION)/focal/Dockerfile" \
	--tag $(IMAGE):$(TAG) \
	"docker-openresty-$(OPENRESTY_VERSION)/"
	$(MAKE) clean

push: build
	@echo "Pushing $(IMAGE):$(TAG)..."
	@docker push $(IMAGE):$(TAG)
	$(MAKE) remove

remove:
	@echo "Removing $(IMAGE):$(TAG)..."
	@docker rmi $(IMAGE):$(TAG)
