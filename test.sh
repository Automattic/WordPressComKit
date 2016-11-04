#!/bin/bash
export LC_CTYPE="en_US.UTF-8"

echo "- Building WordPressComKit"

set -o pipefail &&
    xcodebuild -workspace 'WordPressComKit.xcworkspace' \
    -scheme 'WordPressComKit' \
    clean build test \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY= \
    PROVISIONING_PROFILE= | \
    tee ./xcode_raw_build.log | \
    xcpretty --color --report junit --output ./xcode/results_unit.xml
