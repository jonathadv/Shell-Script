#!/bin/bash

# ----------------------------------------------------------------------------
# This script uses two very funny web sites to display the Cowsay (based o the
# cowsay cli program by Tony Monroe) and random commit messages.
#
# http://cowsay.morecode.org (by Jesse Chan-Norris <http://jcn.me>)
# http://whatthecommit.com (by Nick Gerakines <https://github.com/ngerakines/commitment>)
#
# Use: ./cowsay_and_whatthecommit.sh
#
# Author: Jonatha Daguere Vasconcelos <jonatha@daguerre.com.br>
# Since: 22/10/2014
# Version: 1.0
# Licence: GPL
# ----------------------------------------------------------------------------

# Use curl to get the commmit message
message=$(
        curl http://whatthecommit.com 2> /dev/null | 
        grep -i \<p\> | 
        cut -d '>' -f 2
    );

# Use curl to get the HTML with the cow and the commit message.
curl cowsay.morecode.org/say -d message="$message" -d format=text 2> /dev/null

echo