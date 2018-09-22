#!/usr/bin/env bash

# Fetch Caddy server source code
echo 'Fetching source code...'
go get github.com/mholt/caddy/caddy
go get github.com/caddyserver/builds

# Turn off telemetry by modifying source code
echo 'Turning off telemetry...'
cd $GOPATH/src/github.com/mholt/caddy/caddy/caddymain && \
    sed -i 's/EnableTelemetry = true/EnableTelemetry = false/g' run.go

# Fill list of plugins
echo 'Adding plugins...'
awk '/This is where other plugins get plugged in/ { print; print "//CADDY_PLUGIN"; next }1' run.go > run.go.temp && \
    mv run.go.temp run.go
while read p; do
    awk -v plugin="$p" \
        '/\/\/CADDY_PLUGIN/ { print; print "_ \""plugin"\" //CADDY_PLUGIN"; next }1' \
        run.go > run.go.temp && \
    mv run.go.temp run.go
    go get $p
    echo "Added plugin $p"
done <$(dirname $0)/plugins.txt

# Build Caddy server
echo 'Building...'
cd $GOPATH/src/github.com/mholt/caddy/caddy && \
    go run build.go

# Copy build result to mounted volume
cp caddy /tmp
echo 'Done.'
