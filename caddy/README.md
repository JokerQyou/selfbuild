# Selfbuild Caddy server

## Requirements

- make
- docker

## Commands

- `make` or `make caddy` to build Caddy server.
  Source code will be cached at `./go_src_cache` directory. If nothing goes wrong,
  the `caddy` binary should show up at `./caddy`.
- `make clean` removes the `./caddy` binary from last build (if any), but
  preserve the source code cache. You should run this command if you want to
  try again after a failed build.
removes `./go_src_cache` cache directory and the `./caddy` binary
  from last build.
- `make reset` reset all build state, thus removing `./go_src_cache` and
  `./caddy`. The next time you build, all source code will be fetched again.
- `make install` installs all systemd service file for Caddy server to
  `/etc/systemd/system/caddy.service`. Use with caution. It is only tested on
  AMD64 Linux platform. You might also want to modify the installed service file
  to add your own customizations.
