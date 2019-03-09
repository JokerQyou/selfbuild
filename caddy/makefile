install_to = /usr/local/bin/caddy
runner = $(shell whoami)

caddy:
	docker run --name=caddy_build -it \
		-v $(shell pwd):/tmp/caddy_build \
		-v $(shell pwd)/go_src_cache:/go/src \
		golang:1-stretch \
		/tmp/caddy_build/build.sh

clean:
	docker stop caddy_build > /dev/null 2>&1 || true && \
	docker rm caddy_build >/dev/null 2>&1 || true && \
	rm -f caddy >/dev/null 2>&1 || true

reset: clean
	docker run --rm \
		--name=caddy_build_reset \
		-v $(shell pwd):/tmp/caddy_build \
		golang:1-stretch \
		rm -rf /tmp/caddy_build/go_src_cache

install: caddy
ifneq ($(runner), root)
	@echo "install can only be run as root" && exit 1
endif
ifeq ($(shell uname), "Linux")
	@echo "can only install on Linux distro with systemd" && exit 1
endif

	@echo "Installing file..." && \
	cp caddy $(install_to) && \
	chown $(runner):$(runner) $(install_to) && \
	chmod 755 $(install_to) && \
	setcap 'cap_net_bind_service=+ep' $(install_to) && \
	mkdir -p /etc/caddy/ssl && \
	echo "Installing service..." && \
	cp $(shell pwd)/caddy.service /etc/systemd/system/caddy.service && \
	systemctl daemon-reload && \
	systemctl enable caddy.service && \
	echo "Done."
