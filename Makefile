.PHONY: build run default

IMAGE_NAME = dovecot


default: run

build:
	docker build --tag=$(IMAGE_NAME) .

run: build
	docker run -v /var/spool/postfix:/var/spool/postfix \
	           -v /var/spool/mail:/var/spool/mail \
	           -e MYHOSTNAME=localhost $(IMAGE_NAME)

