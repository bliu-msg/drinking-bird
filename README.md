# 🐦 Drinking Bird

> *"To Start Press Any Key. Where's the Any Key?"*
> — Homer J. Simpson, S7E7 "King-Size Homer"

<p align="center">
  <img src="https://www.capsnlock.com/cdn/shop/articles/TheSimpsonskKeyboardPecker_c270039b-f8c3-44e5-8afe-3ff8fcbe392e.gif?v=1673306378&width=500" alt="Homer's Drinking Bird" width="400">
</p>

<p align="center">
  <a href="https://www.capsnlock.com/blogs/news/simpsons-keyboard-bird">The iconic scene that inspired this script</a>
</p>

Auto-accepts [Claude Code](https://github.com/anthropics/claude-code) permission prompts so you can go get donuts.

## What it does

- Scans all Terminal.app windows/tabs for Claude permission prompts
- Reads the actual options to determine if "2" means "Allow all" or "Type here" (reject)
- Presses the right key (1 for yes, 2 for allow-all when available)
- Tracks prompts by hash so it won't spam the same one twice

## Usage

```bash
# Download
curl -O https://raw.githubusercontent.com/bliu-msg/drinking-bird/main/drinking_bird.sh
chmod +x drinking_bird.sh

# Run in a separate terminal
./drinking_bird.sh
```

## Requirements

- macOS (uses AppleScript to read Terminal.app)
- Terminal.app (not iTerm2 - PRs welcome!)
- Claude Code CLI

## Output

```
🐦 DRINKING BIRD activated
       .---.
      ( o o )  *dip*
       \ < /
        | |
       /   \
      |_____|

   Press Ctrl+C to stop the bird

21:45:01 *dip* Window 2 Tab 1 → '1'
   Bash(npm install)...
21:45:03 *dip* Window 1 Tab 1 → '2'
   Bash(git status)...
```

## Disclaimer

Use at your own risk. This is like putting a drinking bird on your keyboard - convenient but maybe don't leave it running while `rm -rf` commands are flying around.

## License

MIT - Do whatever you want, just don't blame me when Claude deletes your production database.
