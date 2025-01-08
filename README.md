# NeovideProject

A macOS application that manages Neovide instances per Git repository, providing a seamless project-based editing experience.

## Features

- Single instance per Git repository
- Automatic session management
- File/directory dropping support
- Seamless switching between instances

## Requirements

- macOS 10.15 or later
- Neovide
- Neovim
- Git

## Installation

1. Download the latest release from the Releases page
2. Move NeovideProject.app to your Applications folder
3. (Optional) Set as default application for opening directories

## Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/theherk/NeovideProject
   ```

2. Run the build script:
   ```bash
   ./build.sh
   ```

3. The built application will be in `build/NeovideProject.app`

## Usage

- Drag and drop folders or files onto the application
- Use "Open With" in Finder
- Double-click Git repositories to open them in Neovide

## License

MIT License - See LICENSE file for details

