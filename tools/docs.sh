#!/usr/bin/env bash
# Assemble the MkDocs documentation tree (docs/) from the repository's
# primary documents. The assembled files are generated copies; the primary
# documents remain authoritative.
#
# The root README.md becomes the site home page (docs/index.md), because
# MkDocs excludes a README.md that coexists with index.md. Links to the root
# README.md are rewritten in the generated copies only.
#
# Local preview: tools/docs.sh && mkdocs serve
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

rm -rf docs
mkdir -p docs
rsync -a \
  --exclude '.*' \
  --exclude 'AGENTS.md' \
  --exclude '/README.md' \
  --exclude '/site/' \
  --exclude '/mkdocs.yml' \
  --exclude '/requirements-docs.txt' \
  --exclude '/tools/docs.sh' \
  ./ docs/

cp README.md docs/index.md
sed -i 's|](README\.md)|](index.md)|g' docs/index.md docs/README_CN.md
