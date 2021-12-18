# catan_master

CatanMaster data manager

## Building release

1. Update version and build number in `pubspec.yaml`
2. Build the app bundle and apks

```
fvm flutter clean
fvm flutter build appbundle
fvm flutter build apk --split-per-abi
```
