listen() {
    args="$@"
    youtube-dl -f 251 "ytsearch:$args" -o - | mpv -
}
watchyt() {
    args="$@"
    youtube-dl "ytsearch:$args" -o - | mpv -
}
