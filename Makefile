.PHONY: dg doc build run test clean

DISTRO = fedora-26-x86_64
VARIANT = upstream
DG = /usr/bin/dg
GOMD2MAN = /usr/bin/go-md2man
DOCKERFILE_SRC := Dockerfile.template
DOCKERFILE := Dockerfile
TEST_IMAGE_NAME := container-images-tests

SELECTORS = --distro ${DISTRO}.yaml --multispec-selector --multispec-selector variant=${VARIANT}
DG_EXEC = ${DG} --max-passes 25 --spec specs/common.yml --multispec specs/multispec.yml ${SELECTORS}
DISTRO_ID = $(shell ${DG_EXEC} --template "{{ config.os.id }}")
IMAGE_REPOSITORY = $(shell ${DG_EXEC} --template "{{ spec.image_repository }}")


dg:
	${DG_EXEC} --template $(DOCKERFILE_SRC) --output $(DOCKERFILE)
	${DG_EXEC} --template help/help.md --output help/help.md.rendered

doc: dg
	mkdir -p ./root/
	${GOMD2MAN} -in=help/help.md.rendered -out=./root/help.1

build: doc dg
	docker build --tag=${IMAGE_REPOSITORY} -f $(DOCKERFILE) .

run: build
	docker run -e MYHOSTNAME=localhost $(IMAGE_REPOSITORY)

test: build
	cd tests; MODULE=docker URL="docker=${IMAGE_REPOSITORY}" DOCKERFILE="../$(DOCKERFILE)" VERSION=${VERSION} DISTRO=${DISTRO} mtf -l *.py

test-image:
    docker build --tag=${IMAGE_REPOSITORY} -f ${DOCKERFILE} .

clean:
	rm -f $(DOCKERFILE)
	rm -f help/help.md.*
	rm -rf root
