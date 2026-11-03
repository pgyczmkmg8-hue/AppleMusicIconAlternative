#!/bin/sh
# Builds build/MusicLauncher.ipa: an app that opens Apple Music through music://.
# The result is only ad-hoc signed, so sign it again (Feather, AltStore, Sideloadly...) before installing.
#
#   ./build.sh                          # bundle id com.MACHU.MusicLauncher
#   BUNDLE_ID=com.example.Music ./build.sh
set -e
cd "$(dirname "$0")"

BUNDLE_ID="${BUNDLE_ID:-com.MACHU.MusicLauncher}"
MIN_IOS="16.0"
OUT=build
APP="$OUT/Payload/MusicLauncher.app"
ICONSET="$OUT/Assets.xcassets/AppIcon.appiconset"

rm -rf "$OUT"
mkdir -p "$APP" "$ICONSET" "$OUT/partial"

# icon set (light, dark, tinted) from icons/
cp icons/AppIcon-Light-1024.png "$ICONSET/icon.png"
cp icons/AppIcon-Dark-1024.png "$ICONSET/icon_dark.png"
cp icons/AppIcon-Tinted-1024.png "$ICONSET/icon_tinted.png"
cat > "$ICONSET/Contents.json" <<'JSON'
{
  "images" : [
    { "filename" : "icon.png", "idiom" : "universal", "platform" : "ios", "size" : "1024x1024" },
    {
      "appearances" : [ { "appearance" : "luminosity", "value" : "dark" } ],
      "filename" : "icon_dark.png", "idiom" : "universal", "platform" : "ios", "size" : "1024x1024"
    },
    {
      "appearances" : [ { "appearance" : "luminosity", "value" : "tinted" } ],
      "filename" : "icon_tinted.png", "idiom" : "universal", "platform" : "ios", "size" : "1024x1024"
    }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
JSON
echo '{ "info" : { "author" : "xcode", "version" : 1 } }' > "$OUT/Assets.xcassets/Contents.json"

SDK=$(xcrun --sdk iphoneos --show-sdk-path)
xcrun --sdk iphoneos swiftc -parse-as-library -O \
	-target "arm64-apple-ios$MIN_IOS" -sdk "$SDK" \
	Sources/main.swift -o "$APP/MusicLauncher"

xcrun actool "$OUT/Assets.xcassets" --compile "$APP" \
	--platform iphoneos --minimum-deployment-target "$MIN_IOS" \
	--app-icon AppIcon --output-partial-info-plist "$OUT/partial/partial.plist" \
	--target-device iphone --target-device ipad > /dev/null

# Info.plist = Resources/Info.plist plus the icon keys actool produced
python3 - "$BUNDLE_ID" "$OUT/partial/partial.plist" "$APP/Info.plist" <<'PY'
import plistlib, sys
bundle_id, partial, out = sys.argv[1:4]
info = plistlib.load(open("Resources/Info.plist", "rb"))
info.update(plistlib.load(open(partial, "rb")))
info["CFBundleIdentifier"] = bundle_id
plistlib.dump(info, open(out, "wb"), fmt=plistlib.FMT_BINARY)
PY

# app name per language (Korean shows 음악)
cp -R Resources/*.lproj "$APP/"
printf 'APPL????' > "$APP/PkgInfo"
chmod 755 "$APP/MusicLauncher"
codesign --force --sign - --timestamp=none "$APP"

(cd "$OUT" && zip -qry MusicLauncher.ipa Payload)
echo "Built $OUT/MusicLauncher.ipa ($BUNDLE_ID)"
