# Pet CLI Configuration

This directory contains configuration and snippets for [pet](https://github.com/knqyf263/pet), a simple command-line snippet manager.

## Installation

### macOS (Homebrew)

```bash
brew install pet
```

### Linux (Ubuntu/Debian)

```bash
wget https://github.com/knqyf263/pet/releases/download/v0.4.0/pet_0.4.0_linux_amd64.deb
sudo dpkg -i pet_0.4.0_linux_amd64.deb
```

_Check [releases page](https://github.com/knqyf263/pet/releases) for the latest version._

## Setup

1.  **Initialize Config**

    ```bash
    pet configure
    ```

    This will open the configuration file (usually `~/.config/pet/config.toml`).

2.  **Import Snippets**
    You can symlink the `snippet.toml` in this directory to your pet configuration, or configure `pet` to use this directory.

    **Option A: Symlink (Recommended for single machine)**

    ```bash
    ln -s $(pwd)/snippet.toml ~/.config/pet/snippet.toml
    ```

    **Option B: Gist Sync (Recommended for multi-server)**
    To sync these snippets across multiple servers:

    1.  Create a standard GitHub Gist with the content of `snippet.toml`.
    2.  Get your **GitHub Personal Access Token** (with `gist` scope).
    3.  Edit `~/.config/pet/config.toml`:
        ```toml
        [Gist]
        access_token = "YOUR_ACCESS_TOKEN"
        gist_id = "YOUR_GIST_ID"
        auto_sync = true
        ```
    4.  Run `pet sync` to download/upload functionality.

## Usage

- **Search**: `pet search` (Select and copy command)
- **Execute**: `pet exec` (Select and run command)
- **Run with parameters**: `pet exec` will prompt for inputs like `<branch_name>` automatically.
