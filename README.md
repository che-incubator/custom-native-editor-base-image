<br />

  <h3 align="center">Custom Native Editor Base Image</h3>

  <p align="center">
    Base image to run desktop application inside a container in Eclipse Che.
  </p>
</p>


## Table of Contents

* [About the Project](#about-the-project)
  * [Built With](#built-with)
* [Getting Started](#getting-started)
  * [Build](#build)
* [Usage](#usage)
* [Roadmap](#roadmap)
* [License](#license)



## About The Project

![Screenshot](https://user-images.githubusercontent.com/1968177/98000170-df450400-1df4-11eb-8be4-7c7df72cbf6b.jpg)

This repository is a starting point to build an image with custom desktop application that runs in a container inside Eclipse Che.

The image itself works in cooperation with devfile as image for components that has type `cheEditor`.

### Built With
* [Docker](https://docs.docker.com/get-docker/)
* [Fedora 32](https://hub.docker.com/layers/fedora/library/fedora/32/images/sha256-17653c38432100783edd20e51bf71df5b5f5262f01dc1d99d283c3512197a849?context=explore)



## Getting Started

This is the flow of how you may build and test base editor image.

### Build

1. Clone the repo
```sh
git clone https://github.com/che-incubator/custom-native-editor-base-image && cd custom-native-editor-base-image
```
2. Build image with docker
```sh
docker build -t custom-native-editor-base-image .
```
3. Run built container
```sh
docker run -it -p 8080:8080 custom-native-editor-base-image
```
4. Navigate to run container
```
http://localhost:8080/vnc.html?resize=remote&autoconnect=1
```




## Usage

Below provided an example how to use base editor image to create custom editor image based on the `vim` editor.

Source code of example provided in `/example` directory.

1. Create file `Dockerfile`
```dockerfile
FROM custom-native-editor-base-image:latest

# Set up root user to have an ability to install necessary packages
USER root

# Perform package install and copy supervisor configuration
RUN yum install -y vim && yum clean all
COPY --chown=0:0 vim.conf /etc/supervisord.d/vim.conf

# Setup correct user
USER 1001
```

2. Create file `vim.conf`
```properties
[program:vim]
command=xterm -display :0 -e /bin/bash -l -c "vim"
stdout_logfile=/tmp/vim.log
stderr_logfile=/tmp/vim.log
user=user
environment=DISPLAY=":0"
autorestart=true
priority=999
```

3. Build an image
```bash
docker build -t vim-custom-editor .
```

4. Run image
```bash
docker run -it -p 8080:8080 vim-custom-editor
```

5. Navigate to run container
```
http://localhost:8080/vnc.html?resize=remote&autoconnect=1
```

![xterm](https://user-images.githubusercontent.com/1968177/98012353-ad866a00-1e01-11eb-858d-d7f9a65d80d3.jpg)

6. Push image to public registry
```
docker tag vim-custom-editor:latest <username>/vim-custom-editor:latest
docker push <username>/vim-custom-editor:latest
```

7. Create file `meta.yaml` and upload it to have a public access to it, e.g. to https://gist.github.com/
```yaml
apiVersion: v2
publisher: <username>
name: vim-NOVNC
version: 1.0
type: Che Editor
displayName:  Vim
title:  Vim (in browser using noVNC) as editor for Eclipse Che
description:  Vim running on the Web with noVNC
icon: https://raw.githubusercontent.com/vim/vim/master/runtime/vimlogo.gif
category: Editor
repository: https://github.com/che-incubator/custom-native-editor-base-image
firstPublicationDate: "2020-11-03"
spec:
  endpoints:
   -  name: "dirigible"
      public: true
      targetPort: 8080
      attributes:
        protocol: http
        type: ide
        path: /vnc.html?resize=remote&autoconnect=true&reconnect=true
  containers:
   - name: vim-novnc
     image: "<username>/vim-custom-editor:latest"
     mountSources: true
     ports:
         - exposedPort: 8080
     memoryLimit: "1024M"
```

8. Create file `devfile.yaml`
```yaml
metadata:
  name: vim-workspace
components:
  - type: cheEditor
    reference: '<url for meta.yaml goes here>'
    alias: theia-editor
apiVersion: 1.0.0
```

9. Navigate to https://che.openshift.io/ and create a workspace from current `devfile.yaml`

![xterm in che.openshift.io](https://user-images.githubusercontent.com/1968177/98015506-89c52300-1e05-11eb-9eea-1e71f1e93bf7.jpg)


## Roadmap

See the [open issues](https://github.com/che-incubator/custom-native-editor-base-image/issues) for a list of proposed features (and known issues).



## License

Distributed under the Eclipse Public License - v 2.0 license. See `LICENSE` for more information.
