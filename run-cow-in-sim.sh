#!/usr/bin/env bash

function cleanup {
  if [ -n "$tmpdir" -a -d "$tmpdir" ]; then
    echo "Cleaning up tmpdir" >&2
    rm -fR $tmpdir
  fi
  if [ -n "$uuid" ]; then
    echo "Cleaning up simulator" >&2
    xcrun simctl shutdown $uuid 2>/dev/null
    xcrun simctl delete $uuid
  fi
}

trap cleanup EXIT

tmpdir=$(mktemp -d)

nix-build -A cowsay -o $tmpdir/cowsay
nix-build -A populate -o $tmpdir/populate

uuid=$(xcrun simctl create cowsay com.apple.CoreSimulator.SimDeviceType.iPhone-7 com.apple.CoreSimulator.SimRuntime.iOS-10-0)
xcrun simctl boot $uuid
xcrun simctl spawn $uuid $tmpdir/populate/bin/populate-cow
xcrun simctl spawn $uuid $tmpdir/cowsay/bin/cowsay-haskell "I'm in iOS"
