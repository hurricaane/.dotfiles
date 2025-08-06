#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./git-clone-bare-for-worktrees.sh git@github.com:user/repo.git [optional-dir]

url="${1:?You must provide a Git repository URL}"
basename="${url##*/}"
name="${2:-${basename%.git}}"

if [ -e "$name" ]; then
  echo "Error: directory '$name' already exists." >&2
  exit 1
fi

mkdir "$name"
cd "$name"

# Clone in bare mode
git clone --bare "$url" .bare

# Make this directory a git repo that points to the bare directory
echo "gitdir: ./.bare" >.git

# Ensure we fetch remote branches
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

# Fetch all branches
git fetch origin

echo "Repository cloned in bare mode for worktrees in '$name/'."
echo "You can now create worktrees using:"
echo "  git worktree add <dir> <branch>"
