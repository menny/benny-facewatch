find . -name '*.mc' ! -type d -exec bash -c 'expand -t 4 "$0" > /tmp/e && mv /tmp/e "$0"' {} \;
find . -name '*.mc' ! -type d -exec sed -i 's/[[:blank:]]*$//' "$0" {} \;