# ArangoDB

A distributed open-source database with a flexible data model for documents,
graphs, and key-values. Build high performance applications using a convenient
sql-like query language or JavaScript extensions.



## Usage

### Start a ArangoDB instance

In order to start an ArangoDB instance run

    unix> docker run --name arangodb-instance -d arangodb/arangodb

By default ArangoDB listen on port 8529 for request and the image includes
`EXPOST 8529`. If you link an application container, it is automatically
available in the linked container. See the following examples.

### Using the instance

In order to use the running instance from an application, link the container

    unix> docker run --name my-app --link arangodb-instance:db-link arangodb/arangodb
    
This will use the instanced with the name `arangodb-instance` and link it into
the application container. 

### Exposing the port to the outside world

If you want to expose the port to the outside world, run

    unix> docker run -p 8529:8529 -d arangodb/arangodb

ArangoDB listen on port 8529 for request and the image includes `EXPOST
8529`. The `-p 8529:8529` exposes this port on the host.

### Command line options

In order to get a list of supported options, run

    unix> docker run -e help=1 arangodb/arangodb

## Persistent Data

ArangoDB use the volume `/data` as database directory to store the collection
data and the volume `/apps` as apps directory to store any extensions. These
directory are marked as docker volumes.

See `docker run -e help=1 arangodb` for all volumes.

A good explanation about persistence and docker container can be found here:
[Docker In-depth: Volumes](http://container42.com/2014/11/03/docker-indepth-volumes/),
[Why Docker Data Containers are Good](https://medium.com/@ramangupta/why-docker-data-containers-are-good-589b3c6c749e)

### Using host directories

You can map the container's volumes to a directory on the host, so that the data
is kept between runs of the container. This path `/tmp/arangodb` is in general
not the correct place to store you persistent files - it is just an example!

    unix> mkdir /tmp/arangodb
    unix> docker run -p 8529:8529 -d \
              -v /tmp/arangodb:/data \
              arangodb

This will use the `/tmp/arangodb` directory of the host as database directory
for ArangoDB inside the container.

### Using a data container

Alternatively you can create a container holding the data.

    unix> docker run -d --name arangodb-persist -v /data ubuntu:14.04 true

And use this data container in your ArangoDB container.

    unix> docker run --volumes-from arangodb-persist -p 8529:8529 arangodb

If want to save a few bytes for you can alternatively use 
[tianon/true](https://registry.hub.docker.com/u/tianon/true/)
or
[progrium/busybox](https://registry.hub.docker.com/u/progrium/busybox/)
for creating the volume only containers. For example

    unix> docker run -d --name arangodb-persist -v /data tianon/true true

# Images

## Building an image

Simple clone the repository and execute the following command in the
`arangodb-docker` folder

    unix> docker build -t arangodb .

This will create a image named `arangodb`.

# LICENSE

Copyright (c) 2014 ArangoDB GmbH, published under Apache V2.0 License.

Based on

- https://github.com/frodenas/docker-arangodb
- https://github.com/hipertracker/docker-arangodb
- https://github.com/joaodubas/docker-arangodb
- https://github.com/webwurst/docker-arangodb
