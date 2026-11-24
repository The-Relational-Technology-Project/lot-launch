#!/usr/bin/env bash
# Deploys the lot-plan function with the toolkit and the current sections.json.
# Needs SUPABASE_ACCESS_TOKEN and SUPABASE_PROJECT_REF in the environment.
set -euo pipefail
cd "$(dirname "$0")"
fn=supabase/functions/lot-plan
[ -f "$fn/toolkit.json" ] || { echo "Missing $fn/toolkit.json. See the README to rebuild it."; exit 1; }
cp sections.json "$fn/sections.json"
cd "$fn"
curl -sS --fail-with-body -X POST -H "Authorization: Bearer $SUPABASE_ACCESS_TOKEN" \
  -F 'metadata={"name":"lot-plan","entrypoint_path":"index.ts","verify_jwt":false};type=application/json' \
  -F 'file=@index.ts;type=application/typescript' \
  -F 'file=@toolkit.json;type=application/json' \
  -F 'file=@sections.json;type=application/json' \
  "https://api.supabase.com/v1/projects/$SUPABASE_PROJECT_REF/functions/deploy?slug=lot-plan" | head -c 160
echo
