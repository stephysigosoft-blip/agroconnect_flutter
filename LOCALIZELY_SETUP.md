# Localizely SDK Setup Guide

This project uses Localizely SDK for full localization management. Follow these steps to set it up:

## Prerequisites

1. Create a Localizely account at [https://localizely.com](https://localizely.com)
2. Create a new project in Localizely
3. Get your Project ID and SDK Token from the Localizely dashboard

## Setup Steps

### 1. Configure Localizely Credentials

Open `lib/config/localizely_config.dart` and replace the placeholder values:

```dart
class LocalizelyConfig {
  static const String sdkToken = 'YOUR_SDK_TOKEN';        // Replace with your SDK Token
  static const String distributionId = 'YOUR_DISTRIBUTION_ID';  // Replace with your Distribution ID
}
```

**How to get these values:**
- **SDK Token**: Go to Localizely Dashboard > Settings > SDK tokens > Create new token
- **Distribution ID**: Go to Localizely Dashboard > Distributions > Create/Select distribution > Copy Distribution ID

### 2. Configure localizely.yml

Open `localizely.yml` in the project root and replace `YOUR_PROJECT_ID` with your actual Localizely Project ID:

```yaml
config_version: 1.0
project_id: YOUR_PROJECT_ID  # Replace with your Localizely Project ID
file_type: flutter_arb
branch: main
```

**How to get Project ID:**
- Go to Localizely Dashboard > Your Project > Settings > General > Copy Project ID

### 3. Upload Translation Files to Localizely

You can either:
- **Option A**: Upload manually via Localizely dashboard
  1. Go to your Localizely project dashboard
  2. Upload your existing ARB files (`app_en.arb`, `app_fr.arb`, `app_ar.arb`)
  3. Make sure the locale codes match: `en`, `fr`, `ar`

- **Option B**: Upload via CLI (after configuring localizely.yml)
  ```bash
  dart run localizely_sdk:upload
  ```

4. Create a Distribution in the Distributions section
5. Publish your translations to the distribution

### 4. Generate Localizely Localization Files

Run the following command to generate localization files from Localizely:

```bash
dart run localizely_sdk:generate
```

This will generate `LocalizelyLocalizations` class that will be used by the app.

### 5. Install Dependencies

Run the following command to install the Localizely SDK:

```bash
flutter pub get
```

### 6. Build and Run

```bash
flutter run
```

The app will automatically:
- Initialize Localizely SDK on startup
- Load translations from Localizely cloud via the Distribution
- Use Localizely translations (which override local ARB files)

## Features

### Over-the-Air Updates
- Translations are synced from Localizely cloud
- No app update required for translation changes
- Automatic sync on app startup and language change

### In-Context Editing (Optional)
- Enable `enableInContextEditing` in `localizely_config.dart`
- Connect your device to Localizely dashboard
- Edit translations directly on the device

### Language Switching
- Users can switch languages in the Profile screen
- Language preference is saved locally
- Translations are synced when language changes

## How It Works

1. **Initialization**: Localizely SDK initializes in `main()` function with `Localizely.init(SDK_TOKEN, DISTRIBUTION_ID)`
2. **Generation**: `dart run localizely_sdk:generate` creates `LocalizelyLocalizations` from your Localizely project
3. **Over-the-Air Updates**: `Localizely.updateTranslations()` is called on app startup and when language changes to fetch latest translations
4. **Override**: Localizely translations override local ARB files when available
5. **Persistence**: Selected language is saved using SharedPreferences
6. **RTL Support**: Arabic (ar) automatically enables RTL layout
7. **Fallback**: If Localizely is not configured, the app falls back to local ARB files

## Troubleshooting

### Translations not updating?
- Check your SDK Token and Distribution ID are correct
- Verify translations are published to the Distribution in Localizely dashboard
- Run `dart run localizely_sdk:generate` to regenerate localization files
- Check device internet connection
- Review console logs for errors
- Ensure the Distribution is active and published

### SDK not initializing?
- Ensure `WidgetsFlutterBinding.ensureInitialized()` is called before initialization
- Check that Project ID is not empty
- Verify SDK token is valid (if using)

### Need to use local translations only?
- Comment out Localizely initialization in `main.dart`
- The app will fall back to local ARB files automatically

## Migration from ARB Files

The existing ARB files (`app_en.arb`, `app_fr.arb`, `app_ar.arb`) are still used as:
- Fallback when Localizely is not available
- Source for generating `AppLocalizations` class
- Base translations that can be overridden by Localizely

## Support

For Localizely SDK documentation, visit:
- [Localizely Flutter SDK](https://pub.dev/packages/localizely_sdk)
- [Localizely Documentation](https://docs.localizely.com/flutter-sdk/overview/)
