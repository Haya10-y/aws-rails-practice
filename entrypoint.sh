#!/bin/bash
set -e

# Rails の server.pid を削除
rm -f /webapp/tmp/pids/server.pid

# 本来のコマンドを実行
exec "$@"
