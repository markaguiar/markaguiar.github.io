# CLAUDE.md

Personal academic website for Mark Aguiar — Jekyll + Minimal Mistakes, published by
GitHub Pages from `main`. Serves at **https://www.markaguiar.com** (see `CNAME`);
`markaguiar.github.io` 301-redirects there.

## Open items

### 1. Replace the mislabeled "Code" link on the Mundell-Fleming entry

**Status: not done. Needs a URL from Mark.**

The 2024 conference-volume entry *"The Costs and Consequences of Sovereign Borrowing"*
(`permalink: Mundell_Fleming`) has an `other_links` entry labeled **"Code"** whose URL is
a Springer *email-tracking redirect* (`links.springernature.com/f/a/...`). Two problems:

1. It does not point at code. Decoded, it resolves to the article landing page
   `https://link.springer.com/10.1057/s41308-024-00248-9` — which is the journal link,
   already present separately in the `journal` field.
2. **It publishes Mark's email address.** The tracking token contains
   `bWFndWlhckBwcmluY2V0b24uZWR1` = `maguiar@princeton.edu`, in plain base64, on two
   public pages (`index.md` and `citation/Mundell_Fleming.md`).

Mark said the code exists and he would locate the URL in a later session.

**Prompt to use next time:**

> In `src/papers.yaml`, find the entry with `permalink: Mundell_Fleming` ("The Costs and
> Consequences of Sovereign Borrowing"). Its `other_links` has a "Code" entry pointing at
> a `links.springernature.com` tracking URL that leaks my email address and doesn't
> actually go to code. Replace that URL with the real code/replication URL:
> `<PASTE THE URL HERE>`. Verify it resolves, then re-run `src/make.jl` and confirm the
> tracking URL is gone from `index.md` and `citation/Mundell_Fleming.md`.

If no code URL turns up, delete the "Code" entry outright — leaving it is worse than
removing it, because of the email exposure.

### 2. Unreferenced files in `files/` (harmless, not yet decided)

Not linked from any page. Left in place deliberately:

- `slides_SED.pdf` — an SED deck; the keynote section links `SEDpresentation.pdf` instead
- `exp_dynamics.pdf` — the entry links `exp_dynamics_published.pdf`
- `EconomicsOfSovereignDebt.jpg` — book cover; the Books section uses Princeton's CDN image

## How the site is built

**`src/papers.yaml` is the single source of truth** for every paper. Almost nothing else
should be hand-edited.

Running `src/make.jl` regenerates, from `papers.yaml`:

- `index.md` — the research page
- `citation/<permalink>.md` — one page per paper (all except the book)
- `CV/index.md` — assembled from `src/cv_part1.md` + papers + `src/cv_part2.md`
- `src/ref_*.bib` — seven BibTeX files, split by publication type
- `src/cv.pdf` via pdflatex + bibtex, copied to `CV/cv.pdf`

```bash
cd src && julia --project=.. make.jl
```

Requires Julia (YAML package, see `Project.toml`) and a TeX installation.

**Always re-run `make.jl` after editing `papers.yaml`**, and commit the regenerated files
alongside it. They had drifted out of sync before (Sept 2026): `papers.yaml` had been
edited without regenerating, so the live site still showed PFPF as a working paper months
after it was forthcoming at *Econometrica*.

Rebuilds are deterministic **except** `cv.pdf`, which embeds a build timestamp — a
byte-diff there with identical text is expected, not a real change.

### Local preview

```bash
bundle exec jekyll serve   # then open http://localhost:4000
```

## Gotchas

- **`make.jl` only ever writes files; it never deletes.** Renaming a `permalink` or
  removing a paper leaves the old `citation/*.md` orphaned but still published and
  indexable. Check `citation/` after any permalink change. Two such orphans were deleted
  in Sept 2026 (`commitment-versus-flexibility.md`, `crisis-commitment.md`).
- **Permalinks must be unique.** Two entries once shared
  `discussion-capital-mobility`; `make.jl` wrote both to the same file, so one paper
  silently overwrote the other and became unreachable.
- **The sidebar avatar is rendered as a circle** (`border-radius: 50%` in
  `_sass/minimal-mistakes/_sidebar.scss`). `images/photo.jpg` must be **square** or it
  renders as an oval. It displays at ~284px on desktop and 50px on mobile.
  `images/aguiar_pic.jpeg` is the uncropped original; `images/photo_old.jpg` is the
  previous portrait.
- **GitHub Pages is case-sensitive.** The CV lives at `/CV/`, not `/cv/`.
- Asset links in `papers.yaml` use absolute `https://markaguiar.github.io/files/...`
  URLs. These redirect to `www.markaguiar.com` and work fine; they were deliberately
  left alone rather than rewritten en masse.
- `_site/` is a build artifact and is gitignored. Don't commit it.

## Conventions in `papers.yaml`

- `published` is one of: `journal`, `wp`, `book`, `handbook`, `conference`, `other`,
  `discussion`. It selects which section of the page and CV the entry lands in.
- `show_on_website: true` controls visibility on the site; the CV includes entries
  regardless.
- `journal` may be omitted or empty — `make.jl` guards it with `has_journal()` and simply
  omits the link. Do **not** point `journal` at the entry's own PDF.
- Every `PDF` and `other_links` URL should resolve. Before committing a new entry, check
  that any `files/*.pdf` it names actually exists.

## Checking for broken links

There is no automated checker in the repo. A useful pass: extract every markdown link
from `index.md`, `citation/*.md`, `CV/index.md`, `bio.md`, and `photo.md`; resolve any
`markaguiar.github.io`-absolute or root-relative URL against the working tree; and HTTP
check the rest. Note that publisher domains (doi.org, AEA, IMF, ScienceDirect, Zenodo,
Springer) return **403 to automated agents** — that is bot-blocking, not breakage.
