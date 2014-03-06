#!/bin/sh
usages()
{
    grep -Rl "$1" * | grep -v build | grep -v BankSimple.xcodeproj | grep -v Icon*.png | grep -v Assets
    filename=$1
    extension=${filename##*.}
    filename=${filename%.*}
    grep -Rl $filename * | grep -v build | grep -v BankSimple.xcodeproj | grep -v Icon*.png | grep -v Assets
}
for f in `find Vobble_IOS/Resources -type f ! -name '*@2x.png' ! -name 'Default*.png'`; do
  FILENAME=`basename $f`;
  NUSAGES=`usages $FILENAME | wc -l | awk '{print $1}'`;
  #echo $NUSAGES
  if [ $NUSAGES = 0 ]; then
    echo $f;
  fi;
done;