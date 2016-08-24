# Shell Script

> Repository for some useful shell scripts which I've done to solve problems or make things...

---
**Table of Contents**  

- [install_flash_player.sh](#install_flash_player)
- [kdialog_progbar_helper](#kdialog_progbar_helper)
- [cowsay_and_whatthecommit.sh](#cowsay_and_whatthecommit)
- [fix_icc_profile_bug.sh](#fix_icc_profile_bug)
- [safe_rm](#safe_rm)



---
## install_flash_player
Script to install Adobe Flash Player in GNU/Linux machines with Mozilla Firefox. It finds the latest plugin version and downloads the tarball direct from Adobe web site.

**Requires:**
* curl
* wget

**Usage:** `sudo ./install_flash_player.sh`

---

## kdialog_progbar_helper
This script is a helper to simplify the creation and update of KDialog progress bar with d-bus.

**Requires:**
* kdialog
* d-bus


**Usage:** `source ./kdialog_progbar_helper`

#### To see the help

Call the function `kdialog_progbar_help`


#### Creating a dialog with cancel button
`progress_bar_create "<Title>" "<Text>" true`

It returns a string with the d-bus instance


#### Updating the bar to 20%
`progress_bar_update "${instance}" 20`

#### Checking if it was canceled
`progress_bar_was_canceled ${instance}`

#### Closing progress bar
`progress_bar_exit ${instance}`

#### Running tests
There is a test to create a dialog with a cancel button. To run it, call the function `test01`

---


## cowsay_and_whatthecommit

This script uses two very funny web sites to display the Cowsay (based o the cowsay cli program by Tony Monroe) and random commit messages. The result is basically a cow saying a funny commit message.

**Requires:**
* curl

**Usage:** `./cowsay_and_whatthecommit.sh`


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
## fix_icc_profile_bug
This script is a workaround to prevent some pictures to be displayed with wrong colors. 

Source forum that this fix was suggested: https://bugs.launchpad.net/ubuntu/+source/eog/+bug/938751

Put this file in startup folder in your graphical environment. Since I use KDE I put the script to start with KDE in $HOME/.kde/Autostart.

#### What it runs
`xprop -root -remove _ICC_PROFILE`

---

## safe_rm
 This script prevents accidental deletions by sending files to Trash.
 
 If `gvfs-trash` command is available in the system, it will be used, otherwise, a folder called `.trash` will be created inside `${HOME}` directory and the files will be moved to there.

 The best way to use this function is to source it in `.bashrc` file.
 
**WARNING:** This approach doesn't work with `sudo` command or when using different user accounts.
 
**Requires:**
* rm

**Optional:**
* gvfs-trash

**Usage:** `source safe_rm`

#### Result with gvfs-trash
```
$ rm folder*
--- safe rm (gvfs 1.22.2) ---
File(s) [folder1 folder2 folder3 folder4] sent to trash.
------------------------------
```

#### Result without gvfs-trash
```
$ rm folder*
--- safe rm ---
“folder1” -> “/home/user/.trash/folder1.1472009967”
“folder2” -> “/home/user/.trash/folder2.1472009967”
“folder3” -> “/home/user/.trash/folder3.1472009968”
“folder4” -> “/home/user/.trash/folder4.1472009968”

Trash size: 20K /home/user/.trash
---------------

```

---