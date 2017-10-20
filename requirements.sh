#!/bin/bash

set -e

dnf install -y dnf-plugins-core make golang-github-cpuguy83-go-md2man python-pexpect telnet
dnf copr enable -y phracek/meta-test-family-devel
dnf install -y --enablerepo=updates-testing meta-test-family distgen

