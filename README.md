# Overview / Links
ArangoDB is a multi-model, open-source database with flexible data models for documents, graphs, and key-values. Build high performance applications using a convenient SQL-like query language or JavaScript extensions. Use ACID transactions if you require them. Scale horizontally and vertically with a few mouse clicks.

The supported data models can be mixed in queries and allow ArangoDB to be the aggregation point for the data request you have in mind.

Dockerfile: [`Latest` (Dockerfile)](https://github.com/arangodb/arangodb-docker/blob/master/Dockerfile)

Key Features in ArangoDB
------------------------

**Multi-Model**
Documents, graphs and key-value pairs — model your data as you see fit for your application.

**Joins**
Conveniently join what belongs together for flexible ad-hoc querying, less data redundancy.

**Transactions**
Easy application development keeping your data consistent and safe. No hassle in your client.

Joins and Transactions are key features for flexible, secure data designs, widely used in RDBMSs that you won’t want to miss in NoSQL products. You decide how and when to use Joins and strong consistency guarantees, keeping all the power for scaling and performance as choice. 

Furthermore, ArangoDB offers a microservice framework called [Foxx](https://www.arangodb.com/foxx) to build your own Rest API with a few lines of code.

ArangoDB Documentation
- [ArangoDB Documentation](https://www.arangodb.com/documentation)
- [ArangoDB Tutorials](https://www.arangodb.com/tutorials)

## Usage

### Start an ArangoDB instance

In order to start an ArangoDB instance run

```
unix> docker run -d --name arangodb-instance -d arangodb/arangodb
```

Will create and launch the arangodb docker instance as background process.
The Identifier of the process is printed.
By default ArangoDB listen on port 8529 for request and the image includes
`EXPOST 8529`. If you link an application container it is automatically
available in the linked container. See the following examples.

In order to get the IP arango listens on run:

```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <IDENTIFIER>
```

(where <IDENTIFIER> is the return string of the previous start command)

### Using the instance

In order to use the running instance from an application, link the container

```
unix> docker run --name my-app --link arangodb-instance:db-link arangodb/arangodb
```

This will use the instance with the name `arangodb-instance` and link it into
the application container. The application container will contain environment
variables

```
DB_LINK_PORT_8529_TCP=tcp://172.17.0.17:8529
DB_LINK_PORT_8529_TCP_ADDR=172.17.0.17
DB_LINK_PORT_8529_TCP_PORT=8529
DB_LINK_PORT_8529_TCP_PROTO=tcp
DB_LINK_NAME=/naughty_ardinghelli/db-link
```

These can be used to access the database.

### Exposing the port to the outside world

If you want to expose the port to the outside world, run

```
unix> docker run -p 8529:8529 -d arangodb/arangodb
```

ArangoDB listen on port 8529 for request and the image includes `EXPOST
8529`. The `-p 8529:8529` exposes this port on the host.

### Command line options

In order to get a list of supported options, run

```
unix> docker run -e help=1 arangodb/arangodb
```

## Persistent Data

ArangoDB use the volume `/data` as database directory to store the collection
data and the volume `/apps` as apps directory to store any extensions. These
directories are marked as docker volumes.

See `docker run -e help=1 arangodb` for all volumes.

A good explanation about persistence and docker container can be found here:
[Docker In-depth: Volumes](http://container42.com/2014/11/03/docker-indepth-volumes/),
[Why Docker Data Containers are Good](https://medium.com/@ramangupta/why-docker-data-containers-are-good-589b3c6c749e)

### Using host directories

You can map the container's volumes to a directory on the host, so that the data
is kept between runs of the container. This path `/tmp/arangodb` is in general
not the correct place to store you persistent files - it is just an example!

```
unix> mkdir /tmp/arangodb
unix> docker run -p 8529:8529 -d \
          -v /tmp/arangodb:/data \
          arangodb
```

This will use the `/tmp/arangodb` directory of the host as database directory
for ArangoDB inside the container.

### Using a data container

Alternatively you can create a container holding the data.

```
unix> docker run -d --name arangodb-persist -v /data ubuntu:14.04 true
```

And use this data container in your ArangoDB container.

```
unix> docker run --volumes-from arangodb-persist -p 8529:8529 arangodb
```

If want to save a few bytes you can alternatively use
[tianon/true](https://registry.hub.docker.com/u/tianon/true/)
or
[progrium/busybox](https://registry.hub.docker.com/u/progrium/busybox/)
for creating the volume only containers. For example

```
unix> docker run -d --name arangodb-persist -v /data tianon/true true
```

# Images

## Building an image

Simple clone the repository and execute the following command in the
`arangodb-docker` folder

```
unix> docker build -t arangodb .
```

This will create an image named `arangodb`.

# User Feedback

## Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/arangodb/arangodb-docker/issues).

You can also reach many of the official image maintainers via the `#docker-library` IRC channel on [Freenode](https://freenode.net) - ArangoDB specific questions can be asked in `#arangodb`. 

## Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/arangodb/arangodb-docker/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.

# LICENSE

Copyright (c) 2015 ArangoDB GmbH, published under Apache V2.0 License.

Based on

- https://github.com/frodenas/docker-arangodb
- https://github.com/hipertracker/docker-arangodb
- https://github.com/joaodubas/docker-arangodb
- https://github.com/webwurst/docker-arangodb
