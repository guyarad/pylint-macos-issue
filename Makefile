
SOURCES_ROOT ?= $(shell pwd)

.PHONY: build, bug_repro, verify_resolution

bug_repro: build
	docker run --rm -v "${SOURCES_ROOT}":/mounted_code pylint-bug

verify_resolutions: build
	docker run --rm pylint-bug /code/verify-resolutions

build:
	docker build -t pylint-bug .

test: build
	docker run --rm pylint-bug python main.py
