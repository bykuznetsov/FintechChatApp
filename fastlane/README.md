fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### build_for_testing
```
fastlane build_for_testing
```
Install CocoaPods, build for testing only (does not run test)
### run_all_tests
```
fastlane run_all_tests
```
Running tests
### build_and_test
```
fastlane build_and_test
```
Build for testing and then run tests with Discord notification
### discord_success_notification
```
fastlane discord_success_notification
```
Discord success notification

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
