VERSION := `sed -n 's/^version: \([^ ]*\).*/\1/p' pubspec.yaml`

# Build generated files
build-isar:
    @echo "------------------------------"
    @echo "Build Isar......."
    @flutter pub run build_runner build

# Build Android apk
build-apk:
    @echo "------------------------------"
    @echo "Building for Android......"
    @flutter build apk
    @flutter build apk --split-per-abi

