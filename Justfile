# VERSION := `sed -n 's/^version: \([^ ]*\).*/\1/p' pubspec.yaml`

# Run Flutter project
dev:
    @echo "------------------------------"
    @echo "Running Flutter project......"
    @flutter run

# Flutter clean
clean:
    @echo "------------------------------"
    @echo "Cleaning Flutter project......"
    @flutter clean
    @flutter pub get

# Update Flutter project
update:
    @echo "------------------------------"
    @echo "Update Flutter project......"
    @flutter pub get
    @flutter pub outdated
    @flutter pub upgrade --major-versions

# Check Flutter project
check:
    @echo "------------------------------"
    @echo "Checking Flutter project......"
    @dart format ./lib
    @flutter analyze

# Add a new package
add package:
    @echo "------------------------------"
    @echo "Add a new package: {{ package }}......"
    @flutter pub add {{ package }}

# Remove a package
rm package:
    @echo "------------------------------"
    @echo "Remove a package: {{ package }}......"
    @flutter pub remove {{ package }}

# Build generated files
isar:
    @echo "------------------------------"
    @echo "Building Isar......."
    @flutter pub run build_runner build

# Build Android apk
apk:
    @echo "------------------------------"
    @echo "Building Android apk......"
    @flutter build apk \
     --dart-define AmapAndroidApiKey=$AmapAndroidApiKey

# Build Android apks by splitting per abi
apks:
    @echo "------------------------------"
    @echo "Building Android apks......"
    @flutter build apk --split-per-abi \
     --dart-define AmapAndroidApiKey=$AmapAndroidApiKey

# Share apks with dufs
share: apks
    @echo "------------------------------"
    @echo "Share apks with dufs......"
    @cd ./build/app/outputs/flutter-apk && dufs -A
