#!/bin/bash

git add --all .
git commit -m "dc"
git push
expect - <<EOF
expect "Username for 'https://github.com':"
send "bmondaliitb"
expect "Password for 'https://bmondaliitb@github.com':"
send "Gourir@n1"
EOF

