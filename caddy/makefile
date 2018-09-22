caddy:
	docker run --name=caddy_build \
		-v $(shell pwd):/tmp/caddy_build \
		-v $(shell pwd)/go_src_cache:/go/src \
		golang:1-stretch \
		/tmp/caddy_build/build.sh

clean:
	docker stop caddy_build > /dev/null 2>&1 || true && \
	docker rm caddy_build >/dev/null 2>&1 || true && \
	-rm -f caddy >/dev/null 2>&1 || true

reset: clean
	docker run --rm \
		--name=caddy_build_reset \
		-v $(shell pwd):/tmp/caddy_build \
		golang:1-stretch \
		rm -rf /tmp/caddy_build/go_src_cache

