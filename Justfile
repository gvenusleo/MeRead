VERSION := `sed -n 's/^version: \([^ ]*\).*/\1/p' pubspec.yaml`

# Build generated files
build-isar:
    @echo "------------------------------"
    @echo "Build Isar......."
    @flutter pub run build_runner build

# Build Linux deb package
build-deb: build-isar
    @echo "------------------------------"
    @echo "Building for Linux......"
    @dart pub global activate flutter_distributor
    @export PATH="$PATH":"$HOME/.pub-cache/bin" && flutter_distributor package --platform linux --targets deb

# Build Android apk
build-apk:
    @echo "------------------------------"
    @echo "Building for Android......"
    @flutter build apk
    @flutter build apk --split-per-abi

# Install Linux deb package
install-deb: build-deb
    @echo "------------------------------"
    @echo "Installing for Linux......"
    @sudo dpkg -i ./dist/{{VERSION}}/meread-{{VERSION}}-linux.deb
