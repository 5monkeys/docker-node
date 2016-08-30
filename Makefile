.PHONY: image
image:
	docker build -t 5monkeys/node:$(shell git describe --always --dirty) .
