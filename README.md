# ArangoDB Docker

This Dockerfile will produce an image for ArangoDB.

## Usage

### Building an image

Simple clone the repository and execute the following command in the
`arangodb-docker` folder

    unix> docker build -t arangodb .

This will create a image named `arangodb`.

### Running the image

After you have created an image, you can run ArangoDB as follows

    unix> docker run -p 8529:8529 -d arangodb

ArangoDB listen on port 8529 for request. The `-p 8529:8529` exposes this port 
on the host.

# Data

ArangoDB use a database directory `/data` to store the data and an apps directory
`/apps` to store any extensions. These directory are marked as docker volumes.

See `docker run -e help=1 arangodb` for all volumes.

## Using host directories

You can map the container's volumes to a directory on the host, so that the data
is keep between runs of the container.

    unix> docker run -p 8529:8529 -d \
              -v /tmp/arangodb:/data \
              arangodb

This will use the `/tmp/arangodb` directory of the host as database directory
for ArangoDB inside the container.

## Using a data container

Alternatively you can create a container holding the data.

    unix> docker run -d --name arangodb-persist -v /data ubuntu:14.04 true

And use this data container in your ArangoDB container.

    unix> docker run --volumes-from arangodb-persist -p 8529:8529 arangodb

# LICENSE

Copyright (c) 2014 ArangoDB GmbH, published under Apache V2.0 License.

Based on

- https://github.com/frodenas/docker-arangodb
- https://github.com/hipertracker/docker-arangodb
- https://github.com/joaodubas/docker-arangodb
- https://github.com/webwurst/docker-arangodb
