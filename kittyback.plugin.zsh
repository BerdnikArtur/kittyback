KITTY_BUFFER="/tmp/.kittyback_imgs/buffer.png"
KITTY_FINAL="$HOME/.config/kitty/background.png"
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
PLUGIN_NAME="KittyBack"

if command -v magick &> /dev/null; then
	IM_CMD="magick"
elif command -v convert &> /dev/null; then
	IM_CMD="convert"
else
	case "$(command -v dnf || command -v apt || command -v yum || command -v pacman || command -v zypper || command -v brew)" in
		*/dnf)
			PACKAGE_MANAGER="  sudo dnf install imagemagick"
			;;
		*/apt)
			PACKAGE_MANAGER="  sudo apt install ImageMagick"
			;;
		*/yum)
			PACKAGE_MANAGER="  sudo yum install ImageMagick"
			;;
		*/pacman)
			PACKAGE_MANAGER="  sudo pacman -S imagemagick"
			;;
		*/zypper)
			PACKAGE_MANAGER="  sudo zypper install ImageMagick"
			;;
		*/brew)
			PACKAGE_MANAGER="  brew install imagemagick"
			;;
		*)
			PACKAGE_MANAGER="  Please refer to your distribution's documentation to install ImageMagick"
	esac

	echo "ImageMagick is not found. Please install it with $PACKAGE_MANAGER"
	return 1
fi

if ! command -v kitty &> /dev/null; then
	echo "Kitty terminal not available."
	return 1
fi

if [[ ! -f "$KITTY_CONF" ]]; then
  KITTY_CONF=$(find $HOME -name "kitty.conf" -print -quit)
    	if [[ -z "$KITTY_CONF" ]]; then
		echo "kitty.conf not found on your system. Please check the configuration."
    	    	return 1
    	fi
fi

if ! grep -Eq '^\s*allow_remote_control\s+socket-only' "$KITTY_CONF"; then
	echo "$PLUGIN_NAME: The kitty remote control is disabled. Do you want to enable it (y/n)?"
	read -q "REPLY?Your choice: "
	echo
	if [[ $REPLY =~ ^[yY]$ ]]; then
		echo "allow_remote_control socket-only" >> "$KITTY_CONF"
	    	echo "listen_on unix:/tmp/kitty_remote.sock" >> "$KITTY_CONF"
	    	echo "Added remote control settings to $KITTY_CONF"
	else
		return 1
	fi
fi

load_image() {
	local input="$1"

	if [[ ! -f "$input" ]]; then
		echo "File not found: $input"
		return 1
	fi

	cp "$input" "$KITTY_BUFFER"
}

darken() {
	local factor="$1"
	"$IM_CMD" "$KITTY_BUFFER" -brightness-contrast "-${factor}x0" "$KITTY_BUFFER"
}

discolor() {
	local color="$1"
	"$IM_CMD" "$KITTY_BUFFER" -colorspace Gray \( -clone 0 -fill "$color" -colorize 80 \) -compose Multiply -composite "$KITTY_BUFFER"
}

pixilize() {
	local scale="$1"
  	"$IM_CMD" "$KITTY_BUFFER" -scale "$scale%" -scale 1000% "$KITTY_BUFFER"
}

check_kitty_socket() {
	found_socket=false
  	
  	for sock in /tmp/kitty_remote.sock-*; do
		[[ -S "$sock" ]] && found_socket=true && break
  	done
  	
  	if ! $found_socket; then
		echo "Kitty remote control not available. Adjust the kitty.conf file with following:"
  		echo "  allow_remote_control socket-only"
  		echo "  listen_on unix:tmp/kitty_remote.sock"
  		return 1
  	fi
}

_apply() {
	check_kitty_socket
	cp "$KITTY_BUFFER" "$KITTY_FINAL"
	kitty @ set-background-image "$KITTY_FINAL"
}

kittyback() {
	if [[ "$1" == "apply" ]]; then
		_apply
		return
	fi

	local -a darken_opt discolor_opt pixilize_opt

	zparseopts -D -E \
		d:=darken_opt  -darken:=darken_opt \
        	c:=discolor_opt  -discolor:=discolor_opt  \
        	p:=pixilize_opt  -pixilize:=pixilize_opt  \
		D=default_opt  -default=default_opt

	if [[ -z "$1" && -z "${discolor_opt[1]}" && -z "${pixilize_opt[1]}" && -z "${darken_opt[1]}" && -z "$default_opt" ]]; then
		echo "Usage: kittyback [--darken 100] [--discolor \"#f6f6f6\"] [--pixilize 100] [path_to_image]"
	        return 1
	fi

	if [[ ! -d /tmp/.kittyback_imgs/ ]]; then
		mkdir /tmp/.kittyback_imgs/ 
	fi

	if [[ -z "$input_image" ]]; then
		input_image="$KITTY_BUFFER"
	fi

	while [[ "$1" == -* ]]; do shift; done
	[[ -n "$1" ]] && load_image "$1"

	if [[ -n "${default_opt[1]}" ]]; then
		discolor "#1e1e1e"
		pixilize "100"
		darken "10"
	else
		[[ -n "${discolor_opt[1]}" ]] && discolor "${discolor_opt[2]}"
		[[ -n "${pixilize_opt[1]}" ]] && pixilize "${pixilize_opt[2]}"
		[[ -n "${darken_opt[1]}" ]] && darken "${darken_opt[2]}"
	fi
}

typeset -f +H _apply &> /dev/null
