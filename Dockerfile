# Copyright (c) 2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#

# Base image for desktop base applications that run in Eclipse Che

FROM fedora:32

ARG HOME=/home/user
ARG WORKDIR=/projects

# List of installed tools:
#   * tigervnc-server - vnc server
#   * novnc - vnc client to access through a webpage
#   * fluxbox - lightweight desktop enironment
#   * wget - network downloader
#   * which - locate a program file in the user's path, used by novnc to find websockify
#   * supervisor - controlling process on UNIX-like operating systems
#   * xterm - x terminal
RUN yum install -y tigervnc-server novnc supervisor wget fluxbox which xterm && yum clean all

# Copy fluxbox configuration
COPY --chown=0:0 assets/fluxbox /home/user/.fluxbox/init

# Copy predefined configs
COPY --chown=0:0 assets/etc /etc/

# Copy entrypoint
COPY --chown=0:0 assets/entrypoint.sh /opt/

# Update permissions
RUN mkdir -p /home/user && \
    chgrp -R 0 /home && \
    chmod -R g=u /etc/passwd /etc/group /home && \
    chmod +x /opt/entrypoint.sh

USER 10001

ENV HOME=$HOME
WORKDIR $WORKDIR
ENTRYPOINT [ "/opt/entrypoint.sh" ]
CMD ["tail", "-f", "/dev/null"]
