.PHONY: image
image:
	docker build -t 5monkeys/node:$(shell git describe --always --dirty) .


.PHONY: tag
set-version:
ifndef v
	@echo "Usage: make $@ v=your.version" > /dev/fd/2 && exit 1
else
	$(eval VERSION := $(v))
	cp Dockerfile Dockerfile.master \
		&& cat Dockerfile.master \
			| sed -e 's/\(NODE_VERSION \).*$$/\1$(VERSION)/' \
			> Dockerfile \
		&& rm Dockerfile.master
endif
