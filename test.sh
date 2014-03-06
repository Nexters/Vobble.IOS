#!/bin/sh
usages()
{
    grep -Rl "$1" * | grep -v build | grep -v *.xcodeproj | grep -v Icon*.png | grep -v Assets
    filename=$1
    extension=${filename##*.}
    filename=${filename%.*}
    grep -Rl $filename * | grep -v build | grep -v *.xcodeproj | grep -v Icon*.png | grep -v Assets
}
for f in `find * -type f -name '*.png' | grep -v 'Default*.png'`; do
  FILENAME=`basename $f`;
  FILENAME=${FILENAME/@2x/};
  NUSAGES=`usages $FILENAME | wc -l | awk '{print $1}'`;
  echo -e "\033[0;33m${FILENAME} - ${NUSAGES} 사용"
  if [ $NUSAGES = 0 ]; then
    echo -e "\033[0;31m$f 사용 안함";
  fi;
done;