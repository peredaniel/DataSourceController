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
or alternatively using `brew cask install fastlane`

# Available Actions
### deploy_pod
```
fastlane deploy_pod
```
Deploys the podspec file to Trunk

Usage example: fastlane deploy_pod
### build_framework
```
fastlane build_framework
```
Builds the framework. This lane is to make sure that the framework builds correctly and there are no breaking changes.

Usage example: fastlane build_framework
### build_example_app
```
fastlane build_example_app
```
Builds the example app for the specified iOS version.

This lane is to make sure that the example app builds correctly and that breaking API changes are detected before deployment.

Usage example: fastlane build_example_app ios_version:'12.4'

----

## iOS
### ios test
```
fastlane ios test
```
Runs framework's unit tests in the specified device.

Usage example: fastlane ios test device:'iPhone 8' ios_version:'12.4'

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
