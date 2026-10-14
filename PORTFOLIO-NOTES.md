# Offline Clone — Session Context & File Usage

Notes for starting a new session to tweak this offline clone into a personal portfolio.

## 1. What it is

A fully offline mirror of `https://landonorris.com/` (35.8 MB, 360 files). All remote
assets were downloaded to `assets/<host>/<path>` and every URL in `index.html` was
rewritten to **root-relative** (`/assets/...`). It is a **static snapshot**, not a live
site: no Webflow backend, no CMS, no form processing.

## 2. How to run / verify

- Launch: double-click `Open Offline Clone.bat` -> starts `python -m http.server 8100`
  in this folder and opens `http://127.0.0.1:8100/index.html`.
- Stop: close the minimized `clone-server` console window.
- `serve.ps1` is the same server as a script (`-Port` param, default 8099) if you prefer
  PowerShell.
- **Must be served over HTTP.** Opening `index.html` via `file://` will fail
  (root-relative refs + fetch/CORS restrictions).
- Requires Python on PATH (verified 3.13.3 at
  `...\Programs\Python\Python313\python.exe`).

## 3. Folder map / file usage

| Path | Role | Edit for portfolio? |
|---|---|---|
| `index.html` | The whole page: markup, text, nav, sections, inline styles. Webflow export (~330 KB). | **Primary edit surface** — text, titles, meta, links |
| `index.html.bak` | Original downloaded copy (pre-edits). | Reference/restore only |
| `index.html.pre-rewrite` | Before URL-rewrite script. | Reference only |
| `index.html.pre-glfix` | Before the DOM-snapshot artifact fix. | Reference only |
| `Open Offline Clone.bat` | Launcher (port 8100). | Change port/startup wait |
| `serve.ps1` | Alt server launcher (port 8099). | Optional |
| `download_log.txt`, `download_new_log.txt` | Asset download logs. | Ignore/delete |
| `assets/cdn.prod.website-files.com/...` | **Site images, fonts, main CSS + Webflow JS.** Images = `.webp`/`.svg`/`.png`; `css/*.css` = site styles; `js/*.js` = Webflow runtime. | **Images + CSS** |
| `assets/lando.itsoffbrand.io/gl/...` | **3D assets**: `.glb` models, `.ktx2`/`.webp` textures, `draco`/`basis` decoders, `.hdr` env, msdf fonts. | Advanced/optional |
| `assets/lando.itsoffbrand.io/dev-js/` + `assets/assets.itsoffbrand.io/.../dev-js/` | **Custom app bundles** (~1.3 MB each): drive the intro/transition, Rive, 3D scene. | Advanced |
| `assets/.../rive/*.riv` + `page-transition.riv` | **Rive animations** (lime intro, footer, collabs). | Advanced |
| `assets/cdn.jsdelivr.net` + `assets/unpkg.com` | `@rive-app/canvas-lite` runtime + `.wasm`. | Keep |
| `assets/d3e54v103j8qbb.cloudfront.net`, `cdn.prod.website-files.com/*/js` | Webflow/jQuery runtime. | Keep |
| `assets/cdn.iubenda.com`, `cs.iubenda.com`, `static.klaviyo.com`, `player.vimeo.com` | Consent/analytics/Vimeo — **already de-referenced** in HTML (leftover files can be deleted). | Safe to delete |
| `assets/.../fonts/*.woff2` | `Brier-Bold`, `MonaSans` variable font. | Replace for custom branding |

Key file types: 228 `.webp`, 44 `.svg`, 19 `.ktx2`, 18 `.js`, 8 `.riv`, 8 `.glb`,
7 `.wasm`, 6 `.hdr`, 6 `.png`, 2 `.css`, 2 `.woff2`.

## 4. Critical gotchas (learned the hard way)

- **`index.html` is a post-JS DOM snapshot**, so it once contained two baked artifacts
  that broke the intro. Both are already fixed:
  - (A) a `.transition-w` overlay with inline `visibility:hidden` that hid the lime
    intro (inline styles removed);
  - (B) an injected `<canvas class="gl" data-engine="three.js r174">` that duplicated
    the WebGL canvas (removed).
  Don't reintroduce inline render-state on these nodes.
- **Root-relative paths** -> always serve each copy from its own web root.
- Background colors: `body = rgb(40,44,32)` dark-green; `.transition-w` overlay =
  lime `(198,255,45)`; footer `rgb(244,244,237)`.
- Editing tools in this environment: `rg` unavailable; minified lines break the grep
  tool — use small Python scripts for searching large files.

## 5. Tweaking it into a personal portfolio

Simplest path (recommended):

1. Copy the folder (see section 6), rename it.
2. Edit text/meta/links **directly in `index.html`** (it's plain HTML).
3. Swap images under `assets/cdn.prod.website-files.com/67b5a02dc5d338960b17a7e9/` —
   keep the same filenames to avoid touching references, or update the `src`/`srcset`
   paths.
4. Replace fonts in `.../fonts/` (keep names, or update the `@font-face` in `css/*.css`).
5. Update `<title>` and meta/OpenGraph tags in the `index.html` head.

To de-brand / simplify (optional): strip the custom `dev-js` bundle `<script>`, the Rive
`.riv` loaders, and the 3D GL block — the page will fall back to a static, mostly-working
layout. This is the fastest way to get a clean personal site without the F1-specific 3D
intro.

## 6. Can you just copy the folder and tweak the copy?

**Yes.** It's fully self-contained; copy the entire folder anywhere and you have an
independent clone. Caveats:

- Serve **each copy from its own root** on **a different port** — the `.bat` hardcodes
  `8100`, so if you run two copies at once, edit `set PORT=8100` in the second copy's
  `.bat` (e.g. 8101). Running them one at a time on 8100 is fine.
- Keep the `assets` folder **next to** `index.html` (the relative structure is what
  matters). Don't move `index.html` out and leave `assets` behind.
- No absolute machine paths are hardcoded in the HTML, so portability across
  folders/machines works.
- Copying does **not** carry any runtime state — it's pure static files, so every copy is
  a clean starting point.
