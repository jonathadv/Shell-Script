# Shell Script

Repository for some useful shell scripts which I've done to solve problems or make things...

---

### install_flash_player.sh
Script to install Adobe Flash Player in GNU/Linux machines with Mozilla Firefox. It finds the latest plugin version and downloads the tarball direct from Adobe web site.

**Usage:** ``sudo ./install_flash_player.sh``

**Requires:**
* curl
* wget

---

### kdialog_progbar_helper
This script is a helper to simplify the creation and update of KDialog progress bar with d-bus.


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
