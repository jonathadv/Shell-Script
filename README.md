# Shell Script

> Repository for some useful shell scripts which I've done to solve problems or make things...

---
**Table of Contents**  

- [install_flash_player.sh](#install_flash_player.sh)
- [kdialog_progbar_helper](#kdialog_progbar_helper)
- [cowsay_and_whatthecommit.sh](#cowsay_and_whatthecommit.sh)
- [fix_icc_profile_bug.sh](#fix_icc_profile_bug)



---
## install_flash_player.sh
Script to install Adobe Flash Player in GNU/Linux machines with Mozilla Firefox. It finds the latest plugin version and downloads the tarball direct from Adobe web site.

**Requires:**
* curl
* wget

**Usage:** ``sudo ./install_flash_player.sh``

---

## kdialog_progbar_helper
This script is a helper to simplify the creation and update of KDialog progress bar with d-bus.

**Requires:**
* kdialog
* d-bus


**Usage:** ``source ./kdialog_progbar_helper``

#### To see the help

Call the function ``kdialog_progbar_help``


#### Creating a dialog with cancel button
``progress_bar_create "<Title>" "<Text>" true``

It returns a string with the d-bus instance


#### Updating the bar to 20%
``progress_bar_update "${instance}" 20``

#### Checking if it was canceled
``progress_bar_was_canceled ${instance}``

#### Closing progress bar
``progress_bar_exit ${instance}``

#### Running tests
There is a test to create a dialog with a cancel button. To run it, call the function ``test01``

---


## cowsay_and_whatthecommit.sh

This script uses two very funny web sites to display the Cowsay (based o the cowsay cli program by Tony Monroe) and random commit messages. The result is basically a cow saying a funny commit message.

**Requires:**
* curl

**Usage:** ``./cowsay_and_whatthecommit.sh``


#### APIs

http://cowsay.morecode.org (by Jesse Chan-Norris <http://jcn.me>)

http://whatthecommit.com (by Nick Gerakines <https://github.com/ngerakines/commitment>)


#### Result
```
$ ./cowsay_and_whatthecommit.sh
  _______________________________________
/ fixed some minor stuff, might need some \
\ additional work.                        /
  ---------------------------------------
         \   ^__^ 
          \  (oo)\_______
             (__)\       )\/\
                 ||----w |
                 ||     ||
    
```

---
## fix_icc_profile_bug.sh
This script is a workaround to prevent some pictures to be displayed with wrong colors. 

Source forum that this fix was suggested: https://bugs.launchpad.net/ubuntu/+source/eog/+bug/938751

Put this file in startup folder in your graphical environment. Since I use KDE I put the script to start with KDE in $HOME/.kde/Autostart.

#### What it runs
``xprop -root -remove _ICC_PROFILE``

---