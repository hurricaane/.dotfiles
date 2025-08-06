#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./git-init-bare-for-worktrees.sh my-repo
#   => Creates:
#      my-repo/
#        ├── .bare/
#        ├── .git  (points to .bare)
#        └── main/ (git worktree on branch 'main')

name="${1:?You must provide a repository name}"

# Create and enter the repo directory
mkdir "$name"
cd "$name"

# Init a bare repo in .bare and use it as gitdir
git init --bare .bare
echo "gitdir: ./.bare" >.git

# Set HEAD to refs/heads/main
git --git-dir=.bare symbolic-ref HEAD refs/heads/main

# Create orphan worktree on main
git worktree add --orphan ./main

echo "Initialized repo with orphaned worktree 'main/' on branch 'main'."
