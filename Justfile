VERSION := `sed -n 's/^version: \([^ ]*\).*/\1/p' pubspec.yaml`

# Clean project
clean:
    @echo "------------------------------"
    @echo "Cleaning project......"
    @flutter clean
    @flutter pub get

# Build generated files
build-isar:
    @echo "------------------------------"
    @echo "Build Isar......."
    @flutter pub run build_runner build

# Build Android apk
build-apk:
    @echo "------------------------------"
    @echo "Building Android apk......"
    @flutter build apk

# Build Android apks
build-apks:
    @echo "------------------------------"
    @echo "Building Android apks......"
    @flutter build apk --split-per-abi
