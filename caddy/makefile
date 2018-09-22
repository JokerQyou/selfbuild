caddy:
	docker run --name=caddy_build \
		-v $(shell pwd):/tmp/caddy_build \
		golang:1-stretch \
		/tmp/caddy_build/build.sh

clean:
	docker stop caddy_build > /dev/null 2>&1 || true && \
	docker rm caddy_build >/dev/null 2>&1 || true && \
	rm caddy >/dev/null 2>&1 || true

