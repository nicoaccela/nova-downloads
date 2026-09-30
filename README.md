# Nova page

A public info and installer page for Nova. One self-contained `index.html` plus `assets/` (the Nova marks, favicon, and a bundled Plus Jakarta Sans subset under the SIL Open Font License).

- Open `index.html` in a browser. It follows the system light or dark setting, has a toggle, and respects reduced motion.
- `?theme=light` or `?theme=dark` forces a theme. `?motion=reduce` forces reduced motion.
- `./shots.sh` writes review screenshots to `shots/` with headless Chrome. `?shot&at=<section>` is the still frame mode it uses.
