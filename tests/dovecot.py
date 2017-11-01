#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# This Modularity Testing Framework helps you to write tests for modules
# Copyright (C) 2017 Red Hat, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# he Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
# Authors: Jan Scotka <jscotka@redhat.com>
#

import socket
import pexpect
from moduleframework import module_framework


class DovecotSanityTests(module_framework.AvocadoTest):
    """
    :avocado: enable
    """

    def test_connect_to_dovecot_over_telnet(self):
        self.start()
        session = pexpect.spawn("telnet localhost %s " % self.getConfig()['service']['port'])
        session.expect("OK")
        session.sendline("a login dummy redhat")
        session.expect("OK")
        session.sendline("a logout")
        session.close()

    def test_dovecot_exists(self):
        self.start()
        self.run("ls -la /usr/sbin/dovecot")

    def test_configuration_is_ok(self):
        self.start()
        self.run("doveconf -n")

    def test_dovecot_imap_config(self):
        self.start()
        self.run("doveconf -n | grep \"protocols = imap\"")
        self.run("doveconf -n | grep \"ssl = no\"")
        self.run("doveconf -n | grep \"port = %s\"" % self.getConfig()['service']['port'])
        self.run("doveconf -n | grep \"auth_mechanisms = plain login\"")
