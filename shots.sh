#!/bin/bash
# Review screenshots with headless Chrome. Usage: ./shots.sh  (writes to shots/)
# ?shot turns off the scroll reveal and freezes the stars and the bead, so frames are stable.
cd "$(dirname "$0")"
CH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
shot() { perl -e 'alarm 12; exec @ARGV' "$CH" --headless=new --disable-gpu --hide-scrollbars \
  --user-data-dir=/tmp/nova-page-chrome --window-size="$2" --screenshot="$PWD/shots/$1.png" \
  "file://$PWD/index.html?shot&$3" >/dev/null 2>&1; [ -s "shots/$1.png" ] && echo "ok $1" || echo "MISSING $1"; }
rm -f shots/*.png
for t in dark light; do
  shot "hero-$t" 1400,900 "theme=$t"
  for s in does setup how install needs; do shot "$s-$t" 1400,900 "theme=$t&at=$s"; done
  shot "narrow-$t" 500,1000 "theme=$t"
  shot "narrow-install-$t" 500,1000 "theme=$t&at=install"
done
shot hero-dark-reduced 1400,900 "theme=dark&motion=reduce"
