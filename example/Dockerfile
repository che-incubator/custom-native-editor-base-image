# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

FROM custom-native-editor-base-image:latest

# Set up root user to have an ability to install necessary packages
USER root

# Perform package install and copy supervisor configuration
RUN yum install -y vim && yum clean all
COPY --chown=0:0 vim.conf /etc/supervisord.d/vim.conf

# Setup correct user
USER 1001
