#!/bin/bash

mkdir -p ~/.venv
cd ~/.venv/
python3 -m venv mov-cli-venv
source ~/.venv/mov-cli-venv/bin/activate
pip install mov-cli
pip install mov-cli-youtube
# mov-cli -e
cat > ~/.config/mov-cli/config.toml << EOF
# Confused?
# Check out the WIKI on configuration: https://github.com/mov-cli/mov-cli/wiki/Configuration

[mov-cli]
version = 1
debug = false
player = "mpv"
quality = "auto"
# parser = "lxml"
# editor = "nano"
skip_update_checker = false
auto_try_next_scraper = true
hide_ip = true

# [mov-cli.quality]
# resolution = 720

[mov-cli.ui]
# fzf = true
# limit = 20
preview = true
watch_options = true
display_quality = false

[mov-cli.plugins] # E.g: namespace = "package-name"
youtube = "mov-cli-youtube"

[mov-cli.scrapers]
default = "youtube"
#test = "test.DEFAULT"

[mov-cli.http] # Don't mess with it if you don't know what you are doing!
timeout = 15
# headers = { User-Agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/117.0" }

[mov-cli.downloads] # Do not use backslashes use forward slashes
save_path = "~/Downloads"
yt_dlp = true

[mov-cli.subtitles] # See this page: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes
language = "pt_BR"
EOF