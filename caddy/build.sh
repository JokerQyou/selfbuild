#!/usr/bin/env bash
export GO111MODULE=on
export CADDY_VERSION=v1.0.0
SELFDIR=$(dirname $0)
CWD=/tmp/build
mkdir -p $CWD
# Prepare main module source code file
cd $CWD
cp $SELFDIR/main.go.template main.go

# Fill list of plugins
echo 'Adding plugins...'
while read p; do
    awk -v plugin="$p" \
        'FNR==NR{ if (/\/\/CADDY_PLUGINS/) p=NR; next} 1; FNR==p{ print "	_ \""plugin"\"" }' \
        main.go main.go > main.go.temp && \
    mv main.go.temp main.go
    echo "Added plugin $p"
done <$SELFDIR/plugins.txt
# Remove the indicator line
sed -i '/\/\/CADDY_PLUGINS/d' main.go
cat $CWD/main.go

# Build Caddy server
echo 'Init modules...'
[[ -f "go.mod" ]] && rm go.mod
[[ -f "go.sum" ]] && rm go.sum
go mod init caddy
echo 'Building...'
go build

# Remove used main module source code file
rm main.go

# Copy build result to mounted volume
cp caddy /tmp/caddy_build
echo 'Done.'
