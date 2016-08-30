# vim: set tabstop=2 softtabstop=2 shiftwidth=2
FROM alpine:3.4

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.4.0
ENV NODE_PREFIX /usr/local

RUN echo "Installing build dependencies" \
  && export \
    SOURCE_BASE_URL="https://nodejs.org/dist/v$NODE_VERSION" \
    SOURCE_ARCHIVE_NAME="node-v$NODE_VERSION.tar.xz" \
    SOURCE_SIGN_NAME="SHASUMS256.txt.asc" \
    BUILD_DIR="$HOME/source-node-v$NODE_VERSION" \
    RUNTIME_DEPS="libstdc++ libssl1.0" \
    BUILD_DEPS="coreutils gnupg curl tar xz build-base python openssl-dev linux-headers" \
  && export \
    SOURCE_ARCHIVE_URL="$SOURCE_BASE_URL/$SOURCE_ARCHIVE_NAME" \
    SOURCE_SIGN_URL="$SOURCE_BASE_URL/$SOURCE_SIGN_NAME" \
  && echo "Installing runtime dependencies: '$RUNTIME_DEPS' and build dependencies: '$BUILD_DEPS'" \
  && apk add --no-cache $RUNTIME_DEPS $BUILD_DEPS \
  && echo "Downloading and verifying node.js v$NODE_VERSION" \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done \
  && set -x \
  && curl -SLO $SOURCE_ARCHIVE_URL \
  && curl -SLO $SOURCE_SIGN_URL \
  && gpg --batch --decrypt --output SHASUMS256.txt $SOURCE_SIGN_NAME \
  && grep " $SOURCE_ARCHIVE_NAME\$" SHASUMS256.txt | sha256sum -c - \
  && set +x \
  && echo "Building node.js v$NODE_VERSION" \
  && set -x \
  && mkdir $BUILD_DIR \
  && tar -xJf $SOURCE_ARCHIVE_NAME -C $BUILD_DIR --strip-components=1 \
  && cd $BUILD_DIR \
  && ./configure --prefix=$NODE_PREFIX \
  && make -j$(nproc --ignore=1) install \
  && set +x \
  && curl https://www.npmjs.org/install.sh | sh \
  && echo "Removing build dependencies: '$BUILD_DEPS'" \
  && apk del $NODE_BUILD_DEPS \
  && echo "Removing build directory" \
  && rm -r $BUILD_DIR \
  && echo "Installing runtime dependencies" \
  && apk add --no-cache $NODE_RUNTIME_DEPS \
  && echo "Done"


CMD [ "node" ]
