# Library of Things Launch Plan (an experiment)

A guided workbook for housing developers in Shareable's Library of Things
Co-Lab. People write their own launch plan a section at a time, and the
workbook shows them what Shareable's [Library of Things Toolkit 2.0](https://www.shareable.net/toolkit/library-of-things/)
says about what they wrote, quoted word for word with links. Like
[Knowy](https://knowy.org), the Outer Sunset's neighborhood agent, it works
only from its notes and says when they do not cover something.

Made by the Relational Tech Project as a taste of what is possible for
Shareable, November 2026.

## How it works now

After feedback from Shareable (November 2026), the workbook stopped writing
anything on a person's behalf. Each section is three numbered steps, about
three minutes in all, so the whole plan fits in half an hour:

1. **First thoughts.** One box for quick notes. The section's questions sit
   above it as nudges.
2. **Things to consider.** Three or four toolkit passages quoted word for word,
   with links, chosen for those notes. The server checks every quote against
   the toolkit and drops any that is not exact. Each has a one-line note,
   labelled as AI, on why it was picked; the note is not part of the plan.
3. **Your plan, in your words.** The first thoughts are copied in, so nobody
   types twice, and the person changes them after reading. Beside it sits
   "Still to figure out", a notepad only the person writes in. The tool can
   suggest questions the passages raise, and a tap adds one.

The final plan is the person's step 3 words, the passages they kept and their
open questions, section by section. No sentence in it is
written by AI. Every page carries an "experiment" label.

## Changing the questions

`sections.json` is the one file that sets what the workbook asks: the project
fields, the sections, their order, and the nudges in each (the `questions`
list: keep to three or four short ones). Edit it, push,
and run `./deploy.sh` so the server reads the same file.

## Pieces

- `index.html`: the workbook. No build step. Its look follows shareable.net
  and the toolkit cover (their colours, DM Sans and Source Serif 4); the cover
  image is loaded from Shareable's site, not copied here.
- `sections.json`: sections and questions (see above).
- `supabase/functions/lot-plan/`: the only thing that talks to a model. It owns
  the toolkit search and the instructions; the page sends answers, never a
  prompt. The workbook uses its `guide` action.
- `build-toolkit.py`: turns a saved copy of the toolkit web page into
  the function's `toolkit.json` (334 passages, each with its section, chapter,
  heading and a link back to that spot on Shareable's page).
- `deploy.sh`: deploys the function with the toolkit and `sections.json`.

## Earlier experiments, parked

Still in the repo and reachable by address, but no longer linked from the
workbook, because they have the model write in the person's voice:

- **The conversation** (`/chat`): one question at a time, with decisions the
  guide suggests locking in, a one-pager for residents, and a decision log.
- **The cohort wall** (`/wall`): teams post what they are stuck on.

## The toolkit text is not in this repo

The toolkit is Shareable's, under CC BY-NC-ND 4.0. `toolkit.json` is ignored by
git. It is uploaded with the function at deploy time and lives only inside it.
To rebuild it:

```bash
curl -sSL -A "Mozilla/5.0" -o /tmp/lot-page.html https://www.shareable.net/toolkit/library-of-things/
python3 build-toolkit.py /tmp/lot-page.html supabase/functions/lot-plan/toolkit.json
```

## Deploying

**The page (Vercel).** New project, import this repo, framework "Other", no build
command. Name it `lot-launch`. The function already accepts any `lot-launch*.vercel.app`
address; a custom domain goes in the `LOT_PLAN_ORIGINS` secret.

**The function (Supabase).** It runs on the Relational Tech Project's Supabase
project. With `SUPABASE_ACCESS_TOKEN` and `SUPABASE_PROJECT_REF` set:

```bash
./deploy.sh
```

If the function moves, change `API` at the top of the script in `index.html`.

## Limits worth knowing

- It runs on RTP's community Anthropic key (the `ANTHROPIC_COMMUNITY_KEY`
  secret on that Supabase project). The guards are an origin allowlist,
  input caps, 400 calls per address per hour (counted in memory) and 3,000
  calls a day (counted in the `lot_usage` table, so a restart does not reset
  it).
- Search is keyword search, not embeddings. Fine at 67,000 words.
- Citations point to sections of the web toolkit, not PDF page numbers.

## License

The code is under the license in `LICENSE`. The toolkit text is Shareable's and
is not covered by it.
