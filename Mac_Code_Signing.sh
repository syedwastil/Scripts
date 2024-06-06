We are using this script to sign our apps write a readme about it In first step we change variables of sign.sh and run it signs all apps and then there are instructions which we follow to create keychain and then create dmg and notarize it Be to the point don"t need extra elaborations just to the point guide on signing. Here is script: 
#!/usr/bin/env bash
# Signs the application binary using the appropiated signer depending on the distribution channel
# PARAMETERS

# This script is original chromium signing scrip. But we are not using that anymore  for our signing process
# "/Volumes/CA/Asil/src/out/release_arm64/Kahf_Browser_Packaging/sign_chrome.py"  --input /Volumes/CA/Asil/src/out/release_arm64 --output /Volumes/CA/Asil/src/out/signed --identity 'Developer ID Application: HALALZ E-TICARET TEKSTIL VE SANAYI LIMITED SIRKETI (2DVSJM88ZU)' --development --disable-packaging

# Fail in case something goes wrong
set -o xtrace
set -o errexit
set -o pipefail
set -o nounset


    # Declare global variables
     SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )" #get path of script
     CERTIFICATE_NAME="Developer ID Application: HALALZ E-TICARET TEKSTIL VE SANAYI LIMITED SIRKETI (2DVSJM88ZU)" #add full name of cert like it's in keychain
     ID="co.asil.browser" #this needs to be added to the apple account as a proj and id copied from there
     BROWSER_NAME="Kahf Browser" #add name
     CHROMIUM_VERSION="121.1.62.163" #add version
     BUILDROOT=( "/Volumes/CA/Asil/src/out/release_arm64" ) #change path to app relative to script path
     cd "$BUILDROOT"
     APP_PATH="$BUILDROOT/$BROWSER_NAME.app"
     HELPER_ID="$ID.helper"
     HELPER_RENDERER_ID="$ID.helper.renderer"
     HELPER_PLUGIN_ID="$ID.helper.plugin"
     HELPER_ALERTS_ID="$ID.framework.AlertNotificationService"
     APP_LOADER_ID="app_mode_loader"
     FRAMEWORK_ID="$ID.framework"
     LIBEGL_ID="libEGL"
     LIBGLE2_ID="libGLESv2"
     RELATIVE_FRAMEWORK="$BUILDROOT/$BROWSER_NAME.app/Contents/Frameworks/$BROWSER_NAME Framework.framework/Versions/$CHROMIUM_VERSION"
     RELATIVE_LIBRARY="$BUILDROOT/$BROWSER_NAME.app/Contents/Library"

    # Paths
     RELATIVE_APP_PATH="$BUILDROOT/$BROWSER_NAME.app"
     MacOS_EXECUTABLE_PATH="$RELATIVE_APP_PATH/Contents/MacOS/$BROWSER_NAME"
     MAIN_FRAMEWORK_EXECUTABLE_PATH="$RELATIVE_FRAMEWORK/$BROWSER_NAME Framework"
     RELATIVE_LIBEGL="$RELATIVE_FRAMEWORK/Libraries/libEGL.dylib"
     RELATIVE_LIBGLE2="$RELATIVE_FRAMEWORK/Libraries/libGLESv2.dylib"
     RELATIVE_LIBVK_SW="$RELATIVE_FRAMEWORK/Libraries/libvk_swiftshader.dylib"
     RELATIVE_APP_FRAMEWORK="$RELATIVE_FRAMEWORK"
     RELATIVE_SPARKLE_FRAMEWORK="$RELATIVE_FRAMEWORK/Frameworks/Sparkle.framework"
     RELATIVE_APP_HELPER_PATH="$RELATIVE_FRAMEWORK/Helpers/$BROWSER_NAME Helper.app"
     RELATIVE_APP_HELPER_GPU_PATH="$RELATIVE_FRAMEWORK/Helpers/$BROWSER_NAME Helper (GPU).app"
     RELATIVE_APP_HELPER_GPU_EXE_PATH="$RELATIVE_APP_HELPER_GPU_PATH/Contents/MacOS/$BROWSER_NAME Helper (GPU)"
     RELATIVE_APP_HELPER_PLUGIN_PATH="$RELATIVE_FRAMEWORK/Helpers/$BROWSER_NAME Helper (Plugin).app"
     RELATIVE_APP_HELPER_RENDERER_PATH="$RELATIVE_FRAMEWORK/Helpers/$BROWSER_NAME Helper (Renderer).app"
     RELATIVE_APP_HELPER_ALERTS_PATH="$RELATIVE_FRAMEWORK/Helpers/$BROWSER_NAME Helper (Alerts).app"
     RELATIVE_CRASHPAD_PATH="$RELATIVE_FRAMEWORK/Helpers/chrome_crashpad_handler"
     RELATIVE_APP_MODE_LOADER_PATH="$RELATIVE_FRAMEWORK/Helpers/app_mode_loader"
     RELATIVE_libGLESv2="$RELATIVE_FRAMEWORK/Libraries/libGLESv2.dylib"

     RELATIVE_APP_LIBRARY_HELPER="$RELATIVE_LIBRARY/LaunchServices/org.chromium.Chromium.UpdaterPrivilegedHelper"
     RELATIVE_AUTOUPDATE_FLIPFLOP="$RELATIVE_SPARKLE_FRAMEWORK/Versions/A/Resources/Autoupdate.app/Contents/MacOS/fileop"
     RELATIVE_AUTOUPDATE_UPDATE="$RELATIVE_SPARKLE_FRAMEWORK/Versions/A/Resources/Autoupdate.app/Contents/MacOS/Autoupdate"

    #  EXTENSION_CRX="$RELATIVE_FRAMEWORK/extensions/extension.crx"
# UpdaterPrivilegedHelper="$BROWSER_NAME.app/Contents/Library/LaunchServices/org.chromium.Chromium.UpdaterPrivilegedHelper"

    # Entitlements
    RELATIVE_ENTITLEMENTS_APP_PATH="$SCRIPT_PATH/app-entitlements.plist"
    RELATIVE_ENTITLEMENTS_HELPER_PATH="$SCRIPT_PATH/helper-entitlements.plist"
    RELATIVE_ENTITLEMENTS_HELPER_RENDERER_PATH="$SCRIPT_PATH/helper-renderer-entitlements.plist"
    RELATIVE_ENTITLEMENTS_HELPER_GPU_PATH="$SCRIPT_PATH/helper-gpu-entitlements.plist"
    RELATIVE_ENTITLEMENTS_HELPER_PLUGIN_PATH="$SCRIPT_PATH/helper-plugin-entitlements.plist"

    # Code sign files 
    #  codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "extension_crx"' --timestamp --options runtime,restrict,library,kill --force "$EXTENSION_CRX"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "chrome_crashpad_handler"' --timestamp --options runtime,restrict,library,kill --force "$RELATIVE_CRASHPAD_PATH"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "APP_LOADER_ID"' --timestamp --options runtime,restrict,library,kill --force "$RELATIVE_APP_MODE_LOADER_PATH"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "libvk_swiftshader"' --timestamp --force "$RELATIVE_LIBVK_SW"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$HELPER_ID"'"' --timestamp --options restrict,kill,runtime --force --entitlements "$RELATIVE_ENTITLEMENTS_HELPER_GPU_PATH" "$RELATIVE_APP_HELPER_GPU_PATH"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$HELPER_ID"'"' --timestamp --options restrict,kill,runtime --force --entitlements "$RELATIVE_ENTITLEMENTS_HELPER_GPU_PATH" "$RELATIVE_APP_HELPER_GPU_EXE_PATH"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$HELPER_RENDERER_ID"'"' --timestamp --options restrict,kill,runtime --force --entitlements "$RELATIVE_ENTITLEMENTS_HELPER_RENDERER_PATH" "$RELATIVE_APP_HELPER_RENDERER_PATH"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$HELPER_PLUGIN_ID"'"' --timestamp --options restrict,kill,runtime --force --entitlements "$RELATIVE_ENTITLEMENTS_HELPER_PLUGIN_PATH" "$RELATIVE_APP_HELPER_PLUGIN_PATH"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$HELPER_ALERTS_ID"'"' --timestamp --options runtime,restrict,library,kill --force "$RELATIVE_APP_HELPER_ALERTS_PATH"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$LIBGLE2_ID"'"' --timestamp --force "$RELATIVE_LIBGLE2"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$LIBEGL_ID"'"' --timestamp --force "$RELATIVE_LIBEGL"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "app_mode_loader"' --timestamp --options runtime,restrict,library,kill --force "$RELATIVE_APP_MODE_LOADER_PATH"
    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$HELPER_ID"'"' --timestamp --options runtime,restrict,kill  --force --entitlements "$RELATIVE_ENTITLEMENTS_HELPER_PATH" "$RELATIVE_APP_HELPER_PATH"
    #  codesign --entitlements "$RELATIVE_ENTITLEMENTS_APP_PATH" -s "$CERTIFICATE_NAME" -f --strict --timestamp --options=runtime --deep -v "$UpdaterPrivilegedHelper"
    # Sign org.chromium.Chromium.UpdaterPrivilegedHelper
    codesign -s "$CERTIFICATE_NAME" --timestamp --options runtime,restrict,library,kill --deep --force --entitlements "$RELATIVE_ENTITLEMENTS_APP_PATH" "$RELATIVE_APP_LIBRARY_HELPER"
    # Sign fileop
    codesign -s "$CERTIFICATE_NAME" --timestamp --options runtime,restrict,library,kill --deep --force --entitlements "$RELATIVE_ENTITLEMENTS_APP_PATH" "$RELATIVE_AUTOUPDATE_FLIPFLOP"
    # Sign Autoupdate
    codesign -s "$CERTIFICATE_NAME" --timestamp --options runtime,restrict,library,kill  --deep --force --entitlements "$RELATIVE_ENTITLEMENTS_APP_PATH" "$RELATIVE_AUTOUPDATE_UPDATE"

    codesign -s "$CERTIFICATE_NAME" --requirements '=designated => identifier "'"$FRAMEWORK_ID"'"' --timestamp --force "$RELATIVE_APP_FRAMEWORK"
    codesign -s "$CERTIFICATE_NAME" --timestamp --options runtime,restrict,library,kill --deep --force --entitlements "$RELATIVE_ENTITLEMENTS_APP_PATH" "$MAIN_FRAMEWORK_EXECUTABLE_PATH"
    codesign -s "$CERTIFICATE_NAME" --timestamp --options runtime,restrict,library,kill --deep --force --entitlements "$RELATIVE_ENTITLEMENTS_APP_PATH" "$MacOS_EXECUTABLE_PATH"
    codesign -s "$CERTIFICATE_NAME" --timestamp --options runtime,restrict,library,kill --deep --force --entitlements "$RELATIVE_ENTITLEMENTS_APP_PATH" "$RELATIVE_APP_PATH"


  
    #verify code sign
    codesign --display --verbose=5 --requirements - "$RELATIVE_CRASHPAD_PATH"
    codesign --verify --verbose=6 --deep "$RELATIVE_CRASHPAD_PATH"
    codesign --display --verbose=5 --requirements - "$APP_PATH"
    codesign --verify --verbose=6 --deep --no-strict "$APP_PATH"
    codesign --display --verbose=5 --requirements - "$RELATIVE_APP_FRAMEWORK"
    codesign --verify --verbose=6 --deep --no-strict "$RELATIVE_APP_FRAMEWORK"
    codesign --display --verbose=5 --requirements - "$RELATIVE_APP_HELPER_GPU_PATH"
    codesign --verify --verbose=6 --deep "$RELATIVE_APP_HELPER_GPU_PATH"
    codesign --display --verbose=5 --requirements - "$RELATIVE_APP_HELPER_RENDERER_PATH"
    codesign --verify --verbose=6 --deep "$RELATIVE_APP_HELPER_RENDERER_PATH"
    codesign --display --verbose=5 --requirements - "$RELATIVE_APP_HELPER_PLUGIN_PATH"
    codesign --verify --verbose=6 --deep "$RELATIVE_APP_HELPER_PLUGIN_PATH"
    codesign --display --verbose=5 --requirements - "$RELATIVE_APP_HELPER_ALERTS_PATH"
    codesign --verify --verbose=6 --deep "$RELATIVE_APP_HELPER_ALERTS_PATH"
    codesign --display --verbose=5 --requirements - "$RELATIVE_LIBGLE2"
    codesign --verify --verbose=6 --deep "$RELATIVE_LIBGLE2"
    codesign --display --verbose=5 --requirements - "$RELATIVE_LIBEGL"
    codesign --verify --verbose=6 --deep "$RELATIVE_LIBEGL"
    codesign --display --verbose=5 --requirements - "$RELATIVE_APP_MODE_LOADER_PATH"
    codesign --verify --verbose=6 --deep "$RELATIVE_APP_MODE_LOADER_PATH"
    codesign --display --verbose=5 --requirements - "$RELATIVE_APP_HELPER_PATH"
    codesign --verify --verbose=6 --deep "$RELATIVE_APP_HELPER_PATH"
    codesign --display --requirements - --verbose=5 "$APP_PATH"
    spctl --assess -vv "$APP_PATH"



# pwd
# open sign.sh in text editor and change the details that is different. 
#you must change location of BUILDROOT, & maybe ID, browser_name
# nano ./chrome/installer/mac/Chromium-Mac-Signing-Alignment-Notarization-DMG/sign.sh
# then run script
# sh ./chrome/installer/mac/Chromium-Mac-Signing-Alignment-Notarization-DMG/sign.sh



: ' 
Create a KeyChain Pair

 security create-keychain "$HOME/Library/Keychains/loginKahf.keychain-db" 
 security unlock-keychain ~/Library/Keychains/loginKahf.keychain-db
     #  you need to replace the APPLE_APP_SPECIFIC_PASSWORD with apple app specific password
 xcrun notarytool store-credentials --keychain "~/Library/Keychains/loginKahf.keychain-db" --apple-id "denizegencay@gmail.com" --team-id "2DVSJM88ZU" --password "rdme-ncoe-eeam-gqvs" "Developer ID Application: HALALZ E-TICARET TEKSTIL VE SANAYI LIMITED SIRKETI (2DVSJM88ZU)"
 
 security find-certificate -c "Hal" -p | openssl x509 -inform pem -noout -subject
' 

: ' 
# make dmg and notorise it
  npm i -g create-dmg
  create-dmg out/release_arm64/Kahf\ Browser.app out/release_dmg 
  xcrun notarytool submit --wait --keychain "~/Library/Keychains/loginKahf.keychain-db" --keychain-profile "Developer ID Application: HALALZ E-TICARET TEKSTIL VE SANAYI LIMITED SIRKETI (2DVSJM88ZU)" out/release_dmg/Kahf\ Browser\ 121.1.62.163.dmg
'

