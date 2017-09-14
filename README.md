
[![dockeri.co](http://dockeri.co/image/_/arangodb)](https://registry.hub.docker.com/_/arangodb/)

# Building your own ArangoDB image

We are auto generating docker images via our build system so the Dockerfile is a template. To build your own ArangoDB image:

```console
cp Dockerfile.templ Dockerfile
```

Adjust @VERSION@ in the Dockerfile to the version of arangodb you want to have and issue:

```console
docker build -t arangodb .
```

This will create an image named `arangodb`.

## Reference documentation

For user documentation please refer to our official docker hub documentation:

https://hub.docker.com/_/arangodb/

## Changing the base distribution

The integration and the release flow this repository is involved in is documented here: https://github.com/arangodb/documents/blob/master/Core/arangodb_docker.md
