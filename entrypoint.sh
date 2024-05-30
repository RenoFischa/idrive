#!/bin/sh
# Entrypoint for idrive

TARGET_DIR="/opt/IDriveForLinux/idriveIt"
SOURCE_DIR="/opt/IDriveForLinux/idriveIt-orig"

if [ ! -d "$TARGET_DIR" ] || [ -z "$(ls -A $TARGET_DIR)" ]; then
    echo "Directory $TARGET_DIR does not exist or is empty. Copying from $SOURCE_DIR..."
    mkdir -p "$TARGET_DIR"
    SRC_PERMS=$(stat -c %a "$SOURCE_DIR")
    chmod $SRC_PERMS "$TARGET_DIR"
    cp -a "$SOURCE_DIR/"* "$TARGET_DIR/"
else
    echo "$TARGET_DIR exists and is not empty."
fi

service idrivecron start

# Keep container up
tail -f /dev/null