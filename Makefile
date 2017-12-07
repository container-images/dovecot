.PHONY: dg doc build run test clean

DISTRO = fedora-26-x86_64
VARIANT = upstream
DG = /usr/bin/dg
GOMD2MAN = /usr/bin/go-md2man
DOCKERFILE_SRC := Dockerfile.template
DOCKERFILE := Dockerfile
TEST_IMAGE_NAME := container-images-tests
READMEMD_SRC := README.md.template
READMEMD := README.md

SELECTORS = --distro ${DISTRO}.yaml --multispec-selector variant=${VARIANT}
DG_EXEC = ${DG} --max-passes 25 --spec specs/configuration.yml --multispec specs/multispec.yml ${SELECTORS}
DISTRO_ID = $(shell ${DG_EXEC} --template "{{ config.os.id }}")
IMAGE_REPOSITORY = $(shell ${DG_EXEC} --template "{{ spec.image_repository }}")

install-dependencies:
	./requirements.sh

dg:
	${DG_EXEC} --template $(DOCKERFILE_SRC) > $(DOCKERFILE)
	${DG_EXEC} --template help/help.md > help/help.md.rendered
	${DG_EXEC} --template $(READMEMD_SRC) > $(READMEMD)

doc: dg
	mkdir -p ./root/
	${GOMD2MAN} -in=help/help.md.rendered > ./root/help.1

build: doc dg
	docker build --tag=${IMAGE_REPOSITORY} -f $(DOCKERFILE) .

run: build
	docker run -e MYHOSTNAME=localhost -e PLAIN_AUTH $(IMAGE_REPOSITORY)

test: build
	MODULE=docker URL="docker=${IMAGE_REPOSITORY}" DOCKERFILE="../$(DOCKERFILE)" VERSION=${VERSION} DISTRO=${DISTRO} make -C tests test

test-in-container: test-image
	docker run --rm -ti -v /run/docker.sock:/run/docker.sock:Z -v ${PWD}:/src ${TEST_IMAGE_NAME} "SELECTORS=${SELECTORS}"

test-image:
	docker build --tag=${TEST_IMAGE_NAME} -f ./Dockerfile.tests .

clean:
	rm -f $(DOCKERFILE)
	rm -f help/help.md.*
	rm -rf root
