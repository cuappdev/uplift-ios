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

cd ..
mkdir Secrets
ls
cd Secrets
touch Keys.plist

wget -O ../Secrets/Keys.plist "$KEYS_PLIST"

# Path to your .graphql files
GRAPHQL_FILES_PATH="../Uplift/graphql"

# Output directory for generated Swift files
OUTPUT_DIRECTORY="../Uplift/"

apollo schema:download --endpoint=$PROD_ENDPOINT ../Uplift/graphql/schema.json
apollo codegen:generate --localSchemaFile="$GRAPHQL_FILES_PATH/schema.json" --target=swift --includes="$GRAPHQL_FILES_PATH/*.graphql" --output="$OUTPUT_DIRECTORY"

