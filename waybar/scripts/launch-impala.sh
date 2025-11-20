#!/usr/bin/env bash

exec setsid xdg-terminal-exec --app-id=Impala -e impala "$@"
