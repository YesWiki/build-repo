#!/bin/sh -l

set -e

COMPOSER_BIN="/usr/bin/composer"
EXTENSION_PATH=$1
OUTPUT_DIR=$2

# infered from filesystem. Eg: yeswiki-extension-test -> extension-test
EXTENSION_ID=$(basename ${1:-$GITHUB_REPOSITORY} | while read -r line; do echo "${line/yeswiki-/}"; done)

# extension name made explicit, or infered from filesystem.
EXTENSION_NAME="${3:-$EXTENSION_ID}"

# extension version passed via an argument, usually git tag
DEV_REF=$(date +%Y-%m-%d-dev)
GIT_REF="${GITHUB_REF:-DEV_REF}"
GIT_TAG="${4:-$GIT_REF}"
EXTENSION_VERSION=$(echo $GIT_TAG | sed -Ee 's/refs\/(heads|tags)\///' | sed -e 's/\//-/g')
ARCHIVE_NAME="$EXTENSION_ID-$EXTENSION_VERSION.zip"

# 1. Installs extension dependencies
$COMPOSER_BIN install --optimize-autoloader --working-dir="$EXTENSION_PATH"
$COMPOSER_BIN test --working-dir="$EXTENSION_PATH"
$COMPOSER_BIN install --quiet --no-dev --optimize-autoloader --working-dir="$EXTENSION_PATH"

# 2. Create extension version
cat $EXTENSION_PATH/composer.json |
  jq -n --arg release $EXTENSION_VERSION \
        --arg name $EXTENSION_NAME \
        '{ $release, $name }' > $EXTENSION_PATH/infos.json

# 3. Package extension
mkdir -p "$OUTPUT_DIR"
(cd $EXTENSION_PATH && zip -v -q -r $OUTPUT_DIR/$ARCHIVE_NAME . -x '*.git*')

# 4. Create integrity
MD5SUM_VALUE=$(md5sum "$OUTPUT_DIR/$ARCHIVE_NAME" | cut -f1 -d' ')
md5sum "$OUTPUT_DIR/$ARCHIVE_NAME" > "$OUTPUT_DIR/$ARCHIVE_NAME.md5"

ls -alh "$OUTPUT_DIR/$ARCHIVE_NAME" "$OUTPUT_DIR/$ARCHIVE_NAME.md5"

echo "::set-output name=md5sum::$MD5SUM_VALUE"
echo "::set-output name=archive-name::$ARCHIVE_NAME"
echo "MD5SUM=$MD5SUM_VALUE" >> variables.env
echo "ARCHIVE_NAME=$ARCHIVE_NAME" >> variables.env
echo "EXTENSION_NAME=$EXTENSION_NAME" >> variables.env
echo "EXTENSION_VERSION=$EXTENSION_VERSION" >> variables.env

