# NeovideProject

A macOS application that manages Neovide instances per Git repository, providing a seamless project-based editing experience.

![Screencast of NeovideProject](./assets/NeovideProject.gif)

As you can see in the screencast included, this can be used in association with any of several [Raycast](https://www.raycast.com/) extensions, or any other workflow management tool that can call `open`. My favorite is in combination with [Zoxide Git Projects](https://www.raycast.com/theherk/zoxide-git-projects), with which you can easily fuzzy find from all previously opened git projects.

View a longer [Introductory video in the wiki](https://github.com/theherk/NeovideProject/wiki/Usage).

## Features

- Single instance per Git repository
- Seamless switching between instances
- File/directory dropping support

## Requirements

- macOS 10.15 or later
- Neovide
- Neovim
- Git

## Installation

1. Download the latest release from the Releases page.
2. Move NeovideProject.app to your Applications folder.
3. (Optional) Set as default application for opening directories.

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

- Drag and drop folders or files onto the application.
- Use "Open With" in Finder.
- Double-click Git repositories to open them in Neovide.

## License

MIT License - See LICENSE file for details

