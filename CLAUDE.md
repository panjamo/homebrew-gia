# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Homebrew tap repository (`panjamo/gia`). Homebrew taps are third-party repositories containing formulae (package definitions). This tap follows the naming convention `homebrew-<tapname>`, referenced as `panjamo/gia`.

## Repository Structure

- `Formula/` - Homebrew formula files (`.rb` files)
- `.github/workflows/tests.yml` - Runs `brew test-bot` on pull requests and main branch pushes (Ubuntu 22.04, macOS 15 Intel, macOS 26 ARM)
- `.github/workflows/publish.yml` - Triggered when PR is labeled with `pr-pull`; runs `brew pr-pull` to merge and publish bottles

## Testing Formulae

```bash
# Test tap syntax
brew test-bot --only-tap-syntax

# Test formulae (on PRs, CI runs this)
brew test-bot --only-formulae

# Audit a formula
brew audit --strict Formula/<formula>.rb

# Install and test locally
brew install --build-from-source Formula/<formula>.rb
brew test <formula>
```

## Installation (User Perspective)

```bash
# Install with full tap path
brew install panjamo/gia/<formula>

# Or tap first, then install
brew tap panjamo/gia
brew install <formula>
```

## CI/CD Workflow

1. **Pull Request Flow**: CI builds bottles on Ubuntu + macOS (Intel + ARM)
2. **Publishing**: Label PR with `pr-pull` to trigger automatic merge and bottle publication
3. **Test Matrix**: All formulae tested on ubuntu-22.04, macos-15-intel, and macos-26
