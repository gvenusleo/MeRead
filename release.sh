dart pub global activate flutter_distributor
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutter_distributor package --platform linux --targets deb
flutter build apk
flutter build apk --split-per-abi