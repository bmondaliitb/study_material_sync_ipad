#!/bin/bash
userid="bmondaliitb"
passwd="Gourir@n1"
git add --all .
git commit -m "dc"
git push
expect "Username for 'https://github.com':"
send "$userid"
expect "Password for 'https://bmondaliitb@github.com':"
send "$passwd"

