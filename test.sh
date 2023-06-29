#! /bin/bash

set -e
set -u
set -o pipefail

samlon="_build/samlon"

if [ ! -f "$samlon" ]; then
    echo "Executable not found: $samlon, run './build.sh' first"
    exit 1
fi

check_script() {
    echo "Testing $1..."
    script="$1"
    expected="$2"
    actual="$($samlon "$script")"
    diff <(echo "$expected") <(echo -e "\n$actual\n")
}

check_script "examples/hello.lox" "
PRINT
STRING(Hello, World!)
;
EOF
"

echo "All tests passed!"
