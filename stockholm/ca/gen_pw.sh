#!/usr/bin/env bash
echo "Generating secure passwordfile, stored in password.txt"
openssl rand -base64 512 | colrm 513 > password.txt
