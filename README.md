# macos desktop icon changer
change all your desktop icons to the existential blue pikmin and manage `Icon?` in your global gitignore!

## setup

run this to change just desktop folders:
```bash
curl -fsSL https://raw.githubusercontent.com/v-vacuum/pikminify/main/install.sh | bash
```
and run this for all desktop icons:
```bash
curl -fsSL https://raw.githubusercontent.com/v-vacuum/pikminify/main/install.sh | bash -s -- -t all
```

this downloads, runs, and cleans up automatically.

## usage

the installer runs once and cleans up. to run again, use the same install command:
```bash
curl -fsSL https://raw.githubusercontent.com/v-vacuum/pikminify/main/install.sh | bash
```

pass options to the installer:
```bash
# change all desktop items (not just folders)
curl -fsSL https://raw.githubusercontent.com/v-vacuum/pikminify/main/install.sh | bash -s -- -t all

# use custom image
curl -fsSL https://raw.githubusercontent.com/v-vacuum/pikminify/main/install.sh | bash -s -- -i ~/Pictures/my-icon.png

# skip gitignore modifications
curl -fsSL https://raw.githubusercontent.com/v-vacuum/pikminify/main/install.sh | bash -s -- --no-gitignore
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
