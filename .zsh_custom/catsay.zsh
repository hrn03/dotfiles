catsay() {
    local msg="${1:-Meow}"
    local line=$(echo "$msg" | sed 's/./-/g')

    echo "  -$line-"
    echo " < $msg >"
    echo "  -$line-"
    echo "   \\"
    echo "    \\  /\\_/\\"
    echo "      ( o.o )"
    echo "       > ^ <"
}
