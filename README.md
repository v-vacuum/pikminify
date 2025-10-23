# macos desktop icon changer

change all your desktop icons to the existential blue pikmin and manage `Icon?` in your global gitignore.

## setup

clone the repository:
```bash
git clone https://github.com/yourusername/pikminify.git
cd pikminify
```

run the script:
```bash
bash icon-changer.sh
```

## usage

```bash
# use default torturedpikmin.png in same directory
bash icon-changer.sh

# use custom image
bash icon-changer.sh -i ~/Pictures/my-icon.png

# change all desktop items (not just folders)
bash icon-changer.sh -t all

# skip gitignore modifications
bash icon-changer.sh --no-gitignore
```

## options

- `-i, --image PATH` - path to icon image (default: torturedpikmin.png)
- `-t, --type TYPE` - target: `folders` or `all` (default: folders)
- `-n, --no-gitignore` - skip gitignore setup
- `-h, --help` - show help

## what it does

converts your image (default blue pikmin) to macos icon format and applies it to desktop items. also adds `Icon?` to your global gitignore (creates one if you don't have it).

## troubleshooting

if icons don't appear, refresh finder with `cmd+r` or:
```bash
killall Finder
```

## reverting

to restore default icons: right-click item → get info → click icon preview → press delete. if you must. there is no script to reverse because blue pikmin are forever. you must manually regret each and every pikmin you wipe off the face of earth.
