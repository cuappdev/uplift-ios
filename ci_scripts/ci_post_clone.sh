#!/bin/sh

#  ci_post_clone.sh
#  Uplift
#
#  Created by Tiffany Pan on 10/25/23.
#  Copyright © 2023 Cornell AppDev. All rights reserved.

echo "Installing Cocoapods..."
brew install cocoapods
pod deintegrate
pod install

echo "Installing Secrets..."
brew install wget
wget -O ../Uplift/GoogleService-Info.plist "$GOOGLE_SERVICE_PLIST"

cd Uplift
touch Secrets
cd Secrets
touch Keys.plist

wget -O ../Uplift/Secrets/Keys.plist "$KEYS_PLIST"
