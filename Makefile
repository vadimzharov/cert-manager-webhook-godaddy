IMAGE_NAME ?= "webhook"
IMAGE_TAG ?= "latest"
ACME_GROUP_NAME ?= "acme.mycompany.com"

OUT := $(shell pwd)/_out

$(shell mkdir -p "$(OUT)")

verify:
	go test -v .

build:
	podman build -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

image:
	podman build -t "$(IMAGE_NAME):$(IMAGE_TAG)" .
	podman push "$(IMAGE_NAME):$(IMAGE_TAG)"

.PHONY: rendered-manifest.yaml
rendered-manifest.yaml:
	helm template \
	    godaddy-webhook \
		--namespace cert-manager \
        --set image.repository=$(IMAGE_NAME) \
        --set image.tag=$(IMAGE_TAG) \
		--set groupName=$(ACME_GROUP_NAME) \
        deploy/godaddy-webhook > "$(OUT)/rendered-manifest.yaml"
