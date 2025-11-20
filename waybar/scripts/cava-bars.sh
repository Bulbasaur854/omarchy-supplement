#!/usr/bin/env bash

# # Run cava and read raw data
# cava -p ~/.config/cava/config | while read -r line; do
#     bars=($line)  # split into array
#
#     out=""
#     for value in "${bars[@]}"; do
#         # Convert 0–255 to 0–7 block character
#         level=$((value / 32))
#         case $level in
#             0) char="▁" ;;
#             1) char="▂" ;;
#             2) char="▃" ;;
#             3) char="▄" ;;
#             4) char="▅" ;;
#             5) char="▆" ;;
#             6) char="▇" ;;
#             7) char="█" ;;
#         esac
#         out="$out$char"
#     done
#
#     echo "$out" || break
# done

# Unicode bars for visualizing levels (0..7)
BAR_CHARS=(▂ ▃ ▄ ▅ ▆ ▇ █)

# Find cava binary
CAVA_BIN="$(command -v cava || true)"
if [ -z "$CAVA_BIN" ]; then
    >&2 echo "cava: binary not found in PATH"
    exit 1
fi

# Create a temporary cava config
CONFIG_FILE="$(mktemp /tmp/waybar_cava_config.XXXXXX)"
cleanup() {
    rm -f "$CONFIG_FILE"
}
trap cleanup EXIT

cat > "$CONFIG_FILE" <<EOF
[general]
bars = 20

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Run cava with the temp config. It emits ascii digits 0..7 per frame.
# We map those digits to Unicode bar glyphs and print a single horizontal string.
"$CAVA_BIN" -p "$CONFIG_FILE" | while IFS= read -r line || [ -n "$line" ]; do
    # Remove semicolons and spaces, then map each character
    line="${line//;/}"
    line="${line// /}"
    out=""
    MAX_LEN=20
    for ((i=0; i<${#line} && ${#out}<MAX_LEN; i++)); do
        idx="${line:i:1}"
        if [[ "$idx" =~ [0-7] ]]; then
            out+="${BAR_CHARS[$idx]}"
        else
            out+="$idx"
        fi
    done
    # printf "%s\n" "$out"

    if [ -z "$out" ]; then
      echo "▂"
    else
      printf "%s\n" "$out"
    fi
done
