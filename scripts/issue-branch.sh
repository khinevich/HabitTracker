#!/usr/bin/env bash
# Create a branch for a GitHub issue, linked to it, and check it out.
#
# Name: <prefix>/<issue-number>-<title-slug>
#   prefix: bugfix if labelled "bug", else feature if labelled "feature",
#           else task if labelled "task"
#   slug:   issue title after the first ":" (e.g. "[T1.4.8] iOS: Insights loading state")
#
# Usage: scripts/issue-branch.sh <issue-number> [--dry-run]
set -euo pipefail

num="${1:?usage: issue-branch.sh <issue-number> [--dry-run]}"
dry="${2:-}"

IFS='|' read -r labels title < <(gh issue view "$num" --json labels,title \
  --jq '"\([.labels[].name] | join(","))|\(.title)"')

case ",$labels," in
  *,bug,*)     prefix=bugfix ;;
  *,feature,*) prefix=feature ;;
  *,task,*)    prefix=task ;;
  *) echo "issue #$num has no bug/feature/task label" >&2; exit 1 ;;
esac

name="${title#*:}"
slug=$(printf '%s' "$name" | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')
branch="$prefix/$num-$slug"

if [[ "$dry" == "--dry-run" ]]; then
  echo "$branch"
else
  gh issue develop "$num" --name "$branch" --checkout
fi
