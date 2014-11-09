#!/bin/sh
set -e
cd doc
haxe build_doc.hxml || { cd ..; echo "build_doc failed"; exit 1; }
cd ..
rm thx.core.zip
zip -r thx.core.zip hxml src doc/ImportCore.hx test extraParams.hxml haxelib.json LICENSE README.md
haxelib submit thx.core.zip