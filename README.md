## KittyBack

A lightweight ZSH plugin to automatically update and modify the background image of the Kitty terminal emulator from a specified image.

To put it simply, this ZSH plugin is for people who love to change wallpapers per month or weak. However, background images in terminal emulators might cause troubles due to low contrast.
Thus we are forced to darken the image or use a monotone color scheme for the image. And well, this plugin essentially helps to make it easy and fast using CLI, if this option is prefered.

### Features

- modifies the resolution, brightness, and color scheme of the background image
- changes the background image in the current session via kitty's remote control
- saves the background image via background.conf included in kitty.conf for more efficient and clean image loading during the initialization of a new kitty instance

## Installation

You'll need to install [Image Magick](https://github.com/ImageMagick/ImageMagick) beforehand.
```bash
sudo apt install ImageMagick
```

### Using a Plugin Manager

#### Zinit
```bash
zinit light pickle-slime/kittyback
```
Create a new kitty instance (reload the terminal) for loading the background.conf.

#### Oh My Zsh
Clone into the custom plugins directory:
```bash
git clone https://github.com/pickle-slime/kittyback ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kittyback
```

Then add kitty-bg-switcher to your plugin list in .zshrc:
```bash
plugins=(git kittybask)
```

And source the .zshrc file
```bash
source ~/.zshrc
```

Create a new kitty instance (reload the terminal) for loading the background.conf.

### Manual Installation
```bash
git clone https://github.com/pickle-slime/kittyback ~/.kittyback
```

Add this line to .zshrc file.
```bash
source ~/.kittyback/kittyback.plugin.zsh
```

And source the .zshrc file
```bash
source ~/.zshrc
```

Create a new kitty instance (reload the terminal) for loading the background.conf.

## Usage

To load image to buffer.
```bash
kittyback path/to/image
```

To preview the image in the terminal.
```bash
kittyback preview
```

To disable the preview.
```bash
kittyback disable_preview
```

To reset all changes on the image.
```bash
kittyback reset
```

To apply changes.
```bash
kittyback apply
```

### Image Modifiers

Darken the image (expects a percentage as an argument):
```bash
kittyback -d 20
kittyback --darken 20
```

Shift RGB colors (expects a float; values below 1 darken, above 1 lighten):
```bash
kittyback -s 0.2
kittyback --shift_rgb
```

Discolor the image (converts to grayscale and overlays a tint):
```bash
kittyback -c '#1e1e1e'
kittyback --discolor '#1e1e11e'
```

Pixelize the image (expects a percentage; lower values increase pixelation):
```bash
kittyback -p 80
kittyback --pixilize 80
```

## Usage Example

Upload an image and preview it right in the terminal.
```bash
kittyback ~/Downloads/thumb-1920-1348376.png
kittyback preview
```
![Screenshot from 2025-04-10 17-22-21](https://github.com/user-attachments/assets/abb794cb-27a3-4bc8-ac1e-4dc0c7664278)

Use the default flag in order to adjust the image.
```bash
kittyback -D
kittyback preview
```
![Screenshot from 2025-04-10 17-25-54](https://github.com/user-attachments/assets/bc80286c-c156-4998-a1ed-937ba4fc3831)

## Requirements

- Kitty terminal emulator
- Zsh (Bourne Again Shell)

## License

- MIT License
