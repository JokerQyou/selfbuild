#!/usr/bin/env bash
CADDY_VERSION=v0.11.5

# Fetch Caddy server source code
echo 'Fetching source code...'
go get github.com/mholt/caddy/caddy
go get github.com/caddyserver/builds

if [ -d $GOPATH/src/github.com/mholt/caddy/caddy/caddymain ]; then
    echo 'Reverting last build state...'
    cd $GOPATH/src/github.com/mholt/caddy/caddy/caddymain && \
    git checkout run.go || true
    echo "Checking out caddy@$CADDY_VERSION..."
    cd $GOPATH/src/github.com/mholt/caddy/caddy && \
    git fetch --tags --force && \
    git checkout $CADDY_VERSION
fi

# Turn off telemetry by modifying source code
echo 'Turning off telemetry...'
cd $GOPATH/src/github.com/mholt/caddy/caddy/caddymain && \
    sed -i 's/EnableTelemetry = true/EnableTelemetry = false/g' run.go

# Fill list of plugins
echo 'Adding plugins...'
awk '/This is where other plugins get plugged in/ { print; print "//CADDY_PLUGINS"; next }1' run.go > run.go.temp && \
    mv run.go.temp run.go
while read p; do
    awk -v plugin="$p" \
        'FNR==NR{ if (/\/\/CADDY_PLUGINS/) p=NR; next} 1; FNR==p{ print "_ \""plugin"\"" }' \
        run.go run.go > run.go.temp && \
    mv run.go.temp run.go
    go get $p
    echo "Added plugin $p"
done <$(dirname $0)/plugins.txt

# Build Caddy server
echo 'Building...'
cd $GOPATH/src/github.com/mholt/caddy/caddy && \
    go run build.go

# Copy build result to mounted volume
cp caddy /tmp/caddy_build
echo 'Done.'
