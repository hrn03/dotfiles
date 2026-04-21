# ~/.zsh_custom/peeking_cat.zsh

peeking_cat() {
    local lines=$(tput lines)
    local col=4 
    tput civis 
    echo -ne "\n\n\n\n\n"

    # frame1
    tput cup $((lines-1)) $col; echo -n " /\\_/\\"
    sleep 0.2

    # frame2
    tput cup $((lines-2)) $col; echo -n " /\\_/\\"
    tput cup $((lines-1)) $col; echo -n "( o.o )"
    sleep 0.2

    # frame3
    tput cup $((lines-3)) $col; echo -n " /\\_/\\"
    tput cup $((lines-2)) $col; echo -n "( o.o )"
    tput cup $((lines-1)) $col; echo -n " > ^ < "
    sleep 0.2

    # frame4
    tput cup $((lines-5)) $((col+6)); echo -n " ╭─────╮ "
    tput cup $((lines-4)) $((col+6)); echo -n " │ Hi! │ "
    tput cup $((lines-3)) $((col+6)); echo -n " ╰─v───╯ "
    sleep 0.3

    # frame5
    tput cup $((lines-5)) $((col+6)); echo -n "         "
    tput cup $((lines-4)) $((col+6)); echo -n "         "
    tput cup $((lines-3)) $((col+6)); echo -n "         "
    tput cup $((lines-3)) $col; echo -n " /\\_/\\ "
    sleep 0.2

    # frame6
    tput cup $((lines-3)) $col; echo -n "       "
    tput cup $((lines-2)) $col; echo -n " /\\_/\\ "
    tput cup $((lines-1)) $col; echo -n "( o.o )"
    sleep 0.2

    # frame7
    tput cup $((lines-2)) $col; echo -n "       "
    tput cup $((lines-1)) $col; echo -n " /\\_/\\ "
    sleep 0.2

    # frame8
    tput cup $((lines-1)) $col; echo -n "       "

    clear
    tput cnorm
}
