## Resubmission
This is a resubmission. In this version I have:
* Added more description about the package in the Description field in the DESCRIPTION file;
* I was asked to remove the '\donttest{}' clause from the examples. However, the main function example increased around one minute the check time in my local machine (macos big sur with m1 chip). A full example is provided in the package README (both in the github repo and the pkg url provided in the DESCRIPTION file). If you think that its not a problem the increase time and I should remove the clause anyways, just let me know, I can do that without problems.

## Test environments
* local R installation (macos BigSur), R 4.1.0
* ubuntu 16.04 (on travis-ci), R 4.1.0
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
