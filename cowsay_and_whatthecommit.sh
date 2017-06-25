#!/usr/bin/env bash
#
# Name: Cowsay and WhatTheCommit
# Author: Jonatha Daguere Vasconcelos <jonatha@daguerre.com.br>
# Version: 1.1
# Licence: MIT
#
#                  DESCRIPTION
#
# This script uses two very funny web sites to display the Cowsay (based o the
# cowsay cli program by Tony Monroe) and random commit messages.
#
# http://cowsay.morecode.org (by Jesse Chan-Norris <http://jcn.me>)
# http://whatthecommit.com (by Nick Gerakines <https://github.com/ngerakines/commitment>)
#
# Usage:
# ./cowsay_and_whatthecommit.sh
#
#              CHANGE HISTORY
# 1.1 (25 Jun 2017) - Removed HTML parsing and using raw text instead.
# 1.0 (22 Oct 2014) - Initial version.
#

# Use curl to get the commmit message
message=$(curl -s http://whatthecommit.com/index.txt);

if [[ -z "${message}" ]]; then
    message='This is a empty message'
fi

# Use curl to get the HTML with the cow and the commit message.
curl -s cowsay.morecode.org/say -d message="$message" -d format=text

# Break a line
echo