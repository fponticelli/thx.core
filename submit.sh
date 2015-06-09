#!/bin/sh
set -e
cd doc
haxe build_doc.hxml || { cd ..; echo "build_doc failed"; exit 1; }
cd ..
rm -f thx.core.zip
zip -r thx.core.zip src doc/ImportCore.hx test extraParams.hxml haxelib.json LICENSE README.md -x "*/\.*"
haxelib submit thx.core.zip
