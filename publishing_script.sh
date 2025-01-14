#!/bin/bash

rm MUJOCO_LOG.TXT
rm scene.xml
rm -rf yarok-*
rm -rf build && rm -rf dist
rm -rf yarok/comm/components/ur5e/ikfastpy


PATCH=41
VERSION="0.0."$PATCH

PREV_PATCH=
PREV_VERSION="0.0."$(($PATCH - 1))
echo "Publishing Yarok=="$VERSION

sed -i "s+[0-9]\.[0-9]\.[0-9][0-9]+$VERSION+g" yarok/__init__.py
sed -i "s+[0-9]\.[0-9]\.[0-9][0-9]+$PREV_VERSION+g" setup.py

# re-export environment.yaml
conda env export | head -n -1 > environment.yaml

git add -A
git commit -m "saving changes in preparation for version "$VERSION

bumpversion --current-version $PREV_VERSION patch setup.py

git add -A
git commit -m "updating version to "$VERSION

python3 setup.py sdist bdist_wheel
twine upload dist/*

git push origin master