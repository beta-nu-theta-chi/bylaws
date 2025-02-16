#!/usr/bin/env bash

nix bundle --experimental-features "nix-command flakes" .#deploy