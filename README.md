# Library of Things Launch Plan (prototype)

A guided workbook for housing developers in Shareable's Library of Things
Co-Lab. It asks a few questions per section, drafts that part of a launch plan
from Shareable's [Library of Things Toolkit 2.0](https://www.shareable.net/toolkit/library-of-things/),
and links every idea back to the place in the toolkit it came from. Like [Knowy](https://knowy.org), the Outer Sunset's neighborhood agent,
it answers only from its notes, cites, and says when it does not know. Unlike
Knowy, the person is always working on their own plan, not asking questions.

Made by the Relational Tech Project as a taste of what is possible for
Shareable, November 2026.

## Two versions

- **The workbook** (`/`, `index.html`): a few questions per section, then a
  draft of that section to edit.
- **The conversation** (`/chat`, `chat.html`): one question at a time. The
  guide reacts with something from the toolkit, suggests what to lock in, and
  parks what is not known yet. Locked decisions collect on a board, and the
  plan is written from the board at the end.

The conversation version also carries four ideas drawn from the Relational Tech
Project's builder practices (https://relationalbuilder.org/knowledge/):

- **Every parked question gets a person.** "Who would know?" turns unknowns
  into "conversations to have this week", grouped by who to ask.
- **A one-pager for residents.** A printable invitation and short survey made
  from what was locked in, with space for a neighbor's drawing. Paper is
  relational tech, and the first job is neighbors saying yes.
- **A decision log.** What was locked in, when, and who was in the room.
- **The cohort wall** (`/wall`, `wall.html`): a team posts the question it is
  stuck on, and other teams say what they decided. Stored in the `lot_wall`
  table (`supabase/migrations/`), reached only through the function.

All pages use the same server function and the same stylesheet (`style.css`).

## Pieces

- `index.html`: the whole page. No build step. Its look follows shareable.net
  and the toolkit cover (their colours, DM Sans and Source Serif 4); the cover
  image is loaded from Shareable's site, not copied here. Answers and drafts are kept in
  the browser (localStorage).
- `supabase/functions/lot-plan/`: the only thing that talks to a model. It owns
  the toolkit search and the prompts; the page sends answers, never a prompt.
- `build-toolkit.py`: turns a saved copy of the toolkit web page into
  the function's `toolkit.json` (334 passages, each with its section, chapter, heading and a
  link back to that spot on Shareable's page).

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
project. Two files, from `supabase/functions/lot-plan/`:

```bash
curl -X POST -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
  -F 'metadata={"name":"lot-plan","entrypoint_path":"index.ts","verify_jwt":false};type=application/json' \
  -F 'file=@index.ts;type=application/typescript' \
  -F 'file=@toolkit.json;type=application/json' \
  "https://api.supabase.com/v1/projects/$SUPABASE_PROJECT_REF/functions/deploy?slug=lot-plan"
```

If the function moves, change `API` at the top of the script in `index.html`.

## Limits worth knowing

- It runs on RTP's community Anthropic key (the `ANTHROPIC_COMMUNITY_KEY`
  secret on that Supabase project). The guards are an origin allowlist,
  input caps, 40 drafts per address per hour and 600 calls a day, counted in
  memory. Enough for a demo and a workshop, not for a public launch.
- Search is keyword search, not embeddings. Fine at 67,000 words.
- Citations point to sections of the web toolkit, not PDF page numbers.

## License

The code is under the license in `LICENSE`. The toolkit text is Shareable's and
is not covered by it.
