KITTY_BUFFER_INIT_IMG="/tmp/.kittyback_imgs/init_img.png"
KITTY_BUFFER="/tmp/.kittyback_imgs/buffer.png"
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

_shift_rgb() {
	local factor="$1"
	"$IM_CMD" "$KITTY_BUFFER" -brightness-contrast "-${factor}x0" "$KITTY_BUFFER"
}

_darken() {
	local factor="$1"
	"$IM_CMD" "$KITTY_BUFFER" -evaluate Multiply "$factor" "$KITTY_BUFFER"
}

_discolor() {
	local color="$1"
	"$IM_CMD" "$KITTY_BUFFER" -colorspace Gray \( -clone 0 -fill "$color" -colorize 80 \) -compose Multiply -composite "$KITTY_BUFFER"
}

_pixelize() {
	local scale="$1"
  	local width height
	read width height <<< $(identify -format "%w %h" "$KITTY_BUFFER")

	"$IM_CMD" "$KITTY_BUFFER" \
		-filter point \
		-scale "$scale%" \
		-resize "${width}x${height}!" \
		"$KITTY_BUFFER"
}

_load_image() {
	local input="$1"

	if [[ ! -f "$input" ]]; then
		echo "File not found: $input"
		return 1
	fi

	if [[ ! -d /tmp/.kittyback_imgs/ ]]; then
		mkdir /tmp/.kittyback_imgs/ 
	fi

	cp "$input" "$KITTY_BUFFER"
	cp "$input" "$KITTY_BUFFER_INIT_IMG"
	export KITTY_INIT_IMG="$input"
}

_reset() {
	cp "$KITTY_BUFFER_INIT_IMG" "$KITTY_BUFFER"
}

_check_kitty_socket() {
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

_preview() {
	_check_kitty_socket || return 1
	kitty @ set-background-image "$KITTY_BUFFER" &> /dev/null
}

_disable_preview() {
	kitty @ set-background-image none
}

_apply() {
	_preview

	if [[ -z "$KITTY_INIT_IMG" ]]; then
		echo "error: KITTY_INIT_IMG is not set. please load an image first using 'kittyback path/to/image'."
		return 1
	fi

	cp "$KITTY_BUFFER" "$KITTY_INIT_IMG"
}

kittyback() {
	if [[ "$1" == "apply" ]]; then
	        _apply || return 1
	        return 0
	elif [[ "$1" == "reset" ]]; then
	        _reset || return 1
	        return 0
	elif [[ "$1" == "load_image" ]]; then
	        _load_image || return 1
	        return 0
	elif [[ "$1" == "preview" ]]; then
	        _preview || return 1
	        return 0
	elif [[ "$1" == "disable_preview" ]]; then
	        _disable_preview || return 1
	        return 0
	fi

	local -a darken_opt discolor_opt pixelize_opt shift_rgb_opt

	zparseopts -D -E \
		d:=darken_opt  -darken:=darken_opt \
        	c:=discolor_opt  -discolor:=discolor_opt  \
        	p:=pixelize_opt  -pixelize:=pixelize_opt  \
		s:=shift_rgb_opt -shift_rgb:=shift_rgb_opt \
		D=default_opt  -default=default_opt

	if [[ -z "$1" && -z "${discolor_opt[1]}" && -z "${pixelize_opt[1]}" && -z "${darken_opt[1]}" && -z "$default_opt" && -z "${shift_rgb_opt[1]}" ]]; then
		echo "Usage: kittyback [--darken 100] [--discolor \"#f6f6f6\"] [--pixelize 100] [path_to_image]"
	        return 1
	fi

	while [[ "$1" == -* ]]; do shift; done
	[[ -n "$1" ]] && _load_image "$1"

	if [[ -n "${default_opt[1]}" ]]; then
		_discolor "#1e1e1e"
		_pixelize "100"
		_shift_rgb "10"
	else
		[[ -n "${discolor_opt[1]}" ]] && _discolor "${discolor_opt[2]}"
		[[ -n "${pixelize_opt[1]}" ]] && _pixelize "${pixelize_opt[2]}"
		[[ -n "${darken_opt[1]}" ]] && _darken "${darken_opt[2]}"
		[[ -n "${shift_rgb_opt[1]}" ]] && _darken "${shift_rgb_opt[2]}"
	fi
}

typeset -f +H _apply &> /dev/null
typeset -f +H _check_kitty_socket &> /dev/null
typeset -f +H _load_image &> /dev/null
typeset -f +H _reset &> /dev/null
typeset -f +H _preview &> /dev/null
typeset -f +H _darken &> /dev/null
typeset -f +H _discolor &> /dev/null
typeset -f +H _pixelize &> /dev/null
typeset -f +H _shift_rgb &> /dev/null
typeset -f +H _disable_preview &> /dev/null

