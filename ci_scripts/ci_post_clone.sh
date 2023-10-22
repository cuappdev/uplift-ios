#!/bin/sh

#  ci_post_clone.sh
#  Uplift
#
#  Created by Tiffany Pan on 10/22/23.
#  Copyright © 2023 Cornell AppDev. All rights reserved.

echo "Installing Cocoapods..."
brew install cocoapods
pod deintegrate
pod install

echo "Installing Secrets..."
brew install wget
wget -O ../Uplift/GoogleService-Info.plist "$GOOGLE_SERVICE_PLIST"
wget -O ../Uplift/Keys.plist "$KEYS_PLIST"

# Don't run this during index builds
if [ $ACTION = "indexbuild" ]; then exit 0; fi

SCRIPT_PATH="${PODS_ROOT}/Apollo/scripts"
cd "${SRCROOT}/${TARGET_NAME}"
"${SCRIPT_PATH}"/run-bundled-codegen.sh codegen:generate --target=swift --includes=./**/*.graphql --localSchemaFile="../schema.graphql" API.swift