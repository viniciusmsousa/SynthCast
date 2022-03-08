## Bump Patch Version
This is a submission of a patch version release. In this version I have:
* Fixed the function `prepare_dataset()` that was causing a bug;
* Factored error messages when functions failed;
* Exports internal (documented) functions to NAMESPACE.

## Test environments
Github Actions
* macOS-latest,   r: 'release';
* windows-latest, r: 'release';
* windows-latest, r: '3.6';
* ubuntu-18.04,   r: '3.6'.

## R CMD check results

0 errors | 0 warnings | 0 note

* This is a new release.
