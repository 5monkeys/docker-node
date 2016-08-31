# node.js on alpine [![Docker Repository on Quay][quay-svg]][quay-repo]

node.js built on top of [Alpine Linux][alpine].

The aim with these images is to provide an Alpine Linux build for node.js with
the same tag names that we expect the main node.js images to have once they are
provided as alpine builds.

[alpine]: http://dockerhub.com/_/alpine
[quay-repo]: https://quay.io/repository/5monkeys/node
[quay-svg]: https://quay.io/repository/5monkeys/node/status

## Image

```console
$ docker pull quay.io/5monkeys/node
```

## Tags

- [`6.4-alpine`][6.4-alpine] node.js v6.4.0
- `latest`, [`6.5-alpine`][6.5-alpine] node.js v6.5.0

[6.4-alpine]: https://github.com/5monkeys/docker-node/tree/6.4-alpine
[6.5-alpine]: https://github.com/5monkeys/docker-node/tree/6.5-alpine

## Acknowledgements

-   Thanks to [mhart](https://github.com/mhart/alpine-node/tree/master) for
    inspiration with the node.js build. mhart's builds are also currently half
    the size of our builds.

## Development

To create a new tag for `$VERSION`:

```console
$ git checkout -b $VERSION-alpine master
$ make set-version v=6.5.0
$ git commit Dockerfile
$ git push -u origin $VERSION-alpine
```
