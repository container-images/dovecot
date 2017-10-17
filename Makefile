.PHONY: dg doc build run test clean

DISTRO = fedora-26-x86_64
VARIANT = upstream
DG = /usr/bin/dg
GOMD2MAN = /usr/bin/go-md2man
DOCKERFILE_SRC := Dockerfile.template
DOCKERFILE := Dockerfile
TEST_IMAGE_NAME := container-images-tests

SELECTORS = --distro ${DISTRO}.yaml --multispec-selector variant=${VARIANT}
DG_EXEC = ${DG} --max-passes 25 --spec specs/configuration.yml --multispec specs/multispec.yml ${SELECTORS}
DISTRO_ID = $(shell ${DG_EXEC} --template "{{ config.os.id }}")
IMAGE_REPOSITORY = $(shell ${DG_EXEC} --template "{{ spec.image_repository }}")

install-dependencies:
	./requirements.sh

dg:
	${DG_EXEC} --template $(DOCKERFILE_SRC) > $(DOCKERFILE)
	${DG_EXEC} --template help/help.md > help/help.md.rendered

doc: dg
	mkdir -p ./root/
	${GOMD2MAN} -in=help/help.md.rendered > ./root/help.1

build: doc dg
	docker build --tag=${IMAGE_REPOSITORY} -f $(DOCKERFILE) .

run: build
	docker run -e MYHOSTNAME=localhost $(IMAGE_REPOSITORY)

test: build
	cd tests; MODULE=docker URL="docker=${IMAGE_REPOSITORY}" DOCKERFILE="../$(DOCKERFILE)" VERSION=${VERSION} DISTRO=${DISTRO} mtf-env-set
	cd tests; MODULE=docker URL="docker=${IMAGE_REPOSITORY}" DOCKERFILE="../$(DOCKERFILE)" VERSION=${VERSION} DISTRO=${DISTRO} mtf --show-job-log *.py

test-in-container: test-image
	docker run --rm -ti -v /root/avocado:/root/avocado -v /var/run/docker.sock:/var/run/docker.sock:Z -v ${PWD}:/src ${TEST_IMAGE_NAME} "SELECTORS=${SELECTORS}"

test-image:
	docker build --tag=${TEST_IMAGE_NAME} -f ./Dockerfile.tests .

clean:
	rm -f $(DOCKERFILE)
	rm -f help/help.md.*
	rm -rf root
