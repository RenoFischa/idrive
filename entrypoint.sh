#!/bin/sh
# Entrypoint for idrive

service idrivecron start

# Keep container up
tail -f /dev/null