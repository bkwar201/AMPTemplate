#!/bin/bash
set -e

INSTANCE_DIR="$(pwd)"
BASE_DIR="$INSTANCE_DIR/730"

if [ ! -d "$BASE_DIR/game/csgo" ]; then
  echo "Base CS2 install not found at $BASE_DIR/game/csgo"
  echo "Run the normal AMP Update (SteamCMD) first."
  exit 1
fi

KUS_REPO_URL="${KusRepoUrl:-https://github.com/kus/cs2-modded-server.git}"
KUS_REPO_BRANCH="${KusRepoBranch:-main}"

if [ ! -d "$INSTANCE_DIR/cs2-modded-server" ]; then
  git clone --branch "$KUS_REPO_BRANCH" "$KUS_REPO_URL" "$INSTANCE_DIR/cs2-modded-server"
else
  cd "$INSTANCE_DIR/cs2-modded-server"
  git fetch origin
  git checkout "$KUS_REPO_BRANCH"
  git pull --ff-only origin "$KUS_REPO_BRANCH"
  cd "$INSTANCE_DIR"
fi

KUS_DIR="$INSTANCE_DIR/cs2-modded-server"

mkdir -p "$INSTANCE_DIR/custom_files"
mkdir -p "$INSTANCE_DIR/custom_files_example"
mkdir -p "$INSTANCE_DIR/game"
mkdir -p "$INSTANCE_DIR/script"

sync_dir() {
  local src="$1"
  local dst="$2"
  if [ -d "$src" ]; then
    mkdir -p "$dst"
    rsync -a --delete "$src"/ "$dst"/
  fi
}

sync_dir "$KUS_DIR/custom_files" "$INSTANCE_DIR/custom_files"
sync_dir "$KUS_DIR/custom_files_example" "$INSTANCE_DIR/custom_files_example"
sync_dir "$KUS_DIR/game" "$INSTANCE_DIR/game"
sync_dir "$KUS_DIR/script" "$INSTANCE_DIR/script"

echo "Kus modded server files updated from Git."
