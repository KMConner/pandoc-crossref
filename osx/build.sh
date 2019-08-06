#!/bin/bash

[ "$TRAVIS_BRANCH" = "pandoc_master" ] && git clone --depth=1 https://github.com/jgm/pandoc.git

export PANDOC="$HOME/.cabal/bin/pandoc"
export PANDOC_CROSSREF="$HOME/.cabal/bin/pandoc-crossref"
cabal new-update
cabal new-install exe:pandoc exe:pandoc-crossref $CABAL_OPTS --overwrite-policy=always
cp "$(realpath "$PANDOC_CROSSREF")" ./
if [ -n "$RUN_UPX" ]; then
  upx --ultra-brute --best pandoc-crossref
fi
$PANDOC -s -t man docs/index.md -o pandoc-crossref.1
PANDOCVER=$($PANDOC --version | head -n1 | cut -f2 -d' ' | tr '.' '_')
echo "Pandoc exe version is:"
$PANDOC --version
tar czf "macos-pandoc_$PANDOCVER.tar.gz" ./pandoc-crossref ./pandoc-crossref.1
./inttest.sh
