# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Oh My Archy is a personal, idempotent Ruby-based setup for customizing Omarchy (Arch Linux + Hyprland). It keeps customizations safe from Omarchy updates by managing personal config files that are sourced after the main configs.

## Running the Setup

```bash
ruby setup.rb
```

This loads and executes all `install_*.rb` files in the repository.

## Architecture

The codebase follows a simple plugin pattern:

- **setup.rb**: Entry point that auto-loads all `install_*.rb` files using `Dir.glob`
- **install_*.rb**: Individual installer modules, each handling a specific customization area

Each installer is self-contained and runs automatically when loaded. The pattern is idempotent - running setup multiple times won't duplicate configurations.

## Adding New Customizations

Create a new file named `install_<feature>.rb`. It will be automatically picked up by `setup.rb`.

Follow the existing pattern in `install_hyprland_config.rb`:
1. Define constants for config paths and content
2. Create a class with an `apply!` method
3. Check if customizations already exist before applying (idempotency)
4. Instantiate and call `apply!` at the end of the file

## Key Paths

The installers write to `~/.config/` directories (e.g., `~/.config/hypr/bindings.conf`). These files are sourced by Omarchy's main configs but are user-owned and update-safe.
