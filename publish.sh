#!/bin/bash
# Push to pypi, tag and push to bitbucket

pyver=$(python -c 'import sys; print("%s%s" % sys.version_info[:2])')
ver=$(python setup.py --version)
pkg=fastavro-${ver}-py${pyver}_0.tar.bz2


# Fail on 1'st error
set -e
set -x

make
# Yeah... we're using eggs, see
# bitbucket.org/pypa/pypi/issues/120/binary-wheels-for-linux-are-not-supported
# python3 setup.py bdist_egg upload
# python2 setup.py bdist_egg upload
python setup.py sdist upload
/opt/anaconda/bin/conda build .
/opt/anaconda/bin/anaconda upload /opt/anaconda/conda-bld/linux-64/${pkg}
rm -fr build dist fastavro.egg-info/
git tag -f $(python setup.py --version)
git push
git push --tags
