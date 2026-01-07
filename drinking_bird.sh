#!/bin/bash
# 🐦 DRINKING BIRD - Homer Simpson Productivity Enhancement Device
#
#       .---.
#      ( o o )    *dip* *dip* *dip*
#       \ < /     "Y" "Y" "Y" "Y"
#        | |
#       /   \
#      |_____|
#
# "To Start Press Any Key. Where's the Any Key?"
#                    - Homer J. Simpson, S7E7 "King-Size Homer"
#
# Auto-accepts Claude prompts so you can go get donuts

CACHE_FILE="/tmp/drinking-bird-$$"
touch "$CACHE_FILE"
trap "rm -f $CACHE_FILE" EXIT

echo "🐦 DRINKING BIRD activated"
echo '       .---.'
echo '      ( o o )  *dip*'
echo '       \ < /'
echo '        | |'
echo '       /   \'
echo '      |_____|'
echo ""
echo "   Press Ctrl+C to stop the bird"
echo ""

get_key_for_content() {
    local content="$1"

    # Check if option 2 is "Allow all" or similar
    if echo "$content" | grep -qE "2\. (Always )?[Aa]llow"; then
        echo "2"
    else
        # Default to 1 (Yes) - safest choice
        echo "1"
    fi
}

scan_and_accept() {
    osascript <<'EOF'
        tell application "Terminal"
            set promptWindows to {}
            repeat with w from 1 to (count of windows)
                repeat with t from 1 to (count of tabs of window w)
                    set tabContent to contents of tab t of window w
                    if tabContent contains "Do you want to proceed?" or tabContent contains "Esc to cancel" or tabContent contains "› 1. Yes" then
                        set end of promptWindows to {w, t}
                    end if
                end repeat
            end repeat
            return promptWindows
        end tell
EOF
}

accept_prompt() {
    local win="$1"
    local tab="$2"
    local prompt_id="w${win}t${tab}"

    # Get content and hash
    content=$(osascript -e "tell application \"Terminal\" to return contents of tab $tab of window $win" 2>/dev/null)
    current_hash=$(echo "$content" | tail -20 | md5)
    cache_key="${prompt_id}_${current_hash}"

    # Skip if already accepted this exact prompt
    if grep -q "^${cache_key}$" "$CACHE_FILE" 2>/dev/null; then
        return
    fi

    # Determine which key based on actual options shown
    KEY=$(get_key_for_content "$content")

    # Extract what we're approving for logging
    cmd_desc=$(echo "$content" | grep -E "Bash|Edit|Write|Read" | tail -1 | cut -c1-70)

    echo "$(date +%H:%M:%S) *dip* Window $win Tab $tab → '$KEY'"
    echo "   $cmd_desc..."

    # Switch to that window/tab and accept
    osascript <<EOF
        tell application "Terminal"
            activate
            delay 0.1
            set index of window $win to 1
            set selected of tab $tab of front window to true
        end tell
        delay 0.3
        tell application "System Events"
            tell process "Terminal"
                keystroke "$KEY"
                delay 0.1
                keystroke return
            end tell
        end tell
EOF

    # Record in cache
    echo "$cache_key" >> "$CACHE_FILE"
    echo "$(date +%H:%M:%S) ✓ Accepted with '$KEY'"
}

while true; do
    result=$(scan_and_accept)

    if [[ "$result" != "{}" && -n "$result" ]]; then
        pairs=$(echo "$result" | tr -d '{}' | tr ',' '\n' | paste - - | while read w t; do
            echo "$w $t"
        done)

        while read -r win tab; do
            [[ -n "$win" && -n "$tab" ]] && accept_prompt "$win" "$tab"
        done <<< "$pairs"
    fi

    sleep 1
done
