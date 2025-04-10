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
![The initial image](https://private-user-images.githubusercontent.com/98887497/432341478-0d586e62-1a3a-4812-8b75-3f9a1cd757b7.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDQyOTYzNjYsIm5iZiI6MTc0NDI5NjA2NiwicGF0aCI6Ii85ODg4NzQ5Ny80MzIzNDE0NzgtMGQ1ODZlNjItMWEzYS00ODEyLThiNzUtM2Y5YTFjZDc1N2I3LnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA0MTAlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDEwVDE0NDEwNlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWRlZGQ0OGZmNzU0MmEyYmM1YTQxZTU4Y2UyMGEyODA0ZTk1ZTU2OWQ1NTQ5OTU2YWFiMTEwNWE2NTE0ZjYyZjMmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.dzr5W-Rfmv4r5VgKGnhRCycpNIBVyowoKp_ccNeurfI)

Use the default flag in order to adjust the image.
```bash
kittyback -D
kittyback preview
```
![The outcome image](https://private-user-images.githubusercontent.com/98887497/432341717-5151d0a0-a76a-4e61-b9fe-d928acb5f879.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDQyOTY4NzcsIm5iZiI6MTc0NDI5NjU3NywicGF0aCI6Ii85ODg4NzQ5Ny80MzIzNDE3MTctNTE1MWQwYTAtYTc2YS00ZTYxLWI5ZmUtZDkyOGFjYjVmODc5LnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA0MTAlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDEwVDE0NDkzN1omWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPWQ3ZTA2NzE3ZWI4MDc0ZDdmOWZjYThjYTRlZTBlMzQyNTVmN2EwMGM5ZTA4NjdiZTIxNjk2N2IwMTc5YTdmYzQmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.MDyIzFg2fqB6N4P1ZUAK6DNHEALIV7DDre6SrXNlIvA)

## Requirements

- Kitty terminal emulator
- Zsh (Bourne Again Shell)

## License

- MIT License
