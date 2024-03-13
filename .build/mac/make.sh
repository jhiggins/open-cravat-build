#!/usr/bin/env bash
# conda should be installed.
# python3.10 environment should be setup.
# Change the variables below as needed.
set -ex

CONDADIR=`realpath ../../miniconda`
ENVNAME=py3
APPDIR=./OpenCRAVAT.app
LAUNCHDIR=./launchers

if [ -z $1 ]; then
	echo "What is the version of open-cravat?"
	exit
fi

source $CONDADIR/etc/profile.d/conda.sh
conda activate $ENVNAME

pip uninstall open-cravat -y
pip install open-cravat==$1

ENVDIR=$CONDADIR/envs/$ENVNAME
RESDIR=$APPDIR/Contents/Resources
rm -rf $RESDIR/bin $RESDIR/conda-meta $RESDIR/include $RESDIR/lib $RESDIR/bin $RESDIR/man $RESDIR/share $RESDIR/ssl
cp -R $ENVDIR/* $RESDIR/
cp -R $LAUNCHDIR $RESDIR/

cp $APPDIR/Contents/Info.plist $RESDIR/Info.plist.bak

plutil -replace CFBundleShortVersionString -string $1 $APPDIR/Contents/Info.plist

cd $RESDIR/bin
sed -i '' "s=${ENVDIR}/bin/python=/usr/bin/env python -I=g" oc
