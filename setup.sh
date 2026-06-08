#!/usr/bin/env bash
set -e

echo "🚀 Setting up your Flutter Flavors boilerplate..."

# Check Flutter
command -v flutter >/dev/null 2>&1 || { echo "❌ Flutter not found. Install Flutter first."; exit 1; }

# Inputs
read -r -p "Enter your base package name (e.g., com.example.myapp): " new_package
read -r -p "Enter your base app name (e.g., My App): " new_appname
read -r -p "Enter your dart project name (e.g., my_app): " new_projectname

# Confirm
echo "➡️ Base Package: $new_package (flavors will be .latte, .macchiato)"
echo "➡️ Base App name: $new_appname (flavors will append Latte, Macchiato)"
echo "➡️ Project name: $new_projectname"
read -r -p "Proceed with these values? (y/n): " confirm
[[ $confirm == [yY] ]] || exit 1

# Ensure tool is installed
echo "📦 Ensuring change_project_name is installed..."
if ! flutter pub global list | grep -q change_project_name; then
  flutter pub global activate change_project_name
fi

# Define current boilerplate placeholders
OLD_PACKAGE="com.downormal.use_me"
OLD_APPNAME="Use Me"
OLD_PROJECTNAME="use_me"

echo "📝 Creating rename.json configuration..."
cat << EOF > rename.json
{
  "name": "$new_projectname",
  "app_name": "$new_appname",
  "package_name": "$new_package",
  "custom_replacements": {
    "$OLD_PACKAGE": "$new_package",
    "$OLD_APPNAME": "$new_appname"
  },
  "options": {
    "backup": false,
    "commit": false,
    "refresh": false
  }
}
EOF

# 1. Run change_project_name to update the project using the config file
echo "🔄 Updating project names and imports..."
flutter pub global run change_project_name --config rename.json

# 2. Explicitly update configuration files using sed to ensure flavorizr has the correct inputs
echo "📝 Ensuring configuration files are updated..."
SED_OPTS=(-i '') # For macOS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SED_OPTS=(-i) # For Linux
fi

# Update flavorizr.yaml
sed "${SED_OPTS[@]}" "s/$OLD_PACKAGE/$new_package/g" flavorizr.yaml
sed "${SED_OPTS[@]}" "s/$OLD_APPNAME/$new_appname/g" flavorizr.yaml

# Update flavors.dart
sed "${SED_OPTS[@]}" "s/$OLD_APPNAME/$new_appname/g" lib/flavors.dart

# Update .env files
for flavor in latte macchiato espresso; do
  if [ -f ".env.$flavor.json" ]; then
    sed "${SED_OPTS[@]}" "s/$OLD_APPNAME/$new_appname/g" ".env.$flavor.json"
  fi
  if [ -f ".env.$flavor.json.example" ]; then
    sed "${SED_OPTS[@]}" "s/$OLD_APPNAME/$new_appname/g" ".env.$flavor.json.example"
  fi
done

# 3. Run flavorizr to apply the changes to Android/iOS native files
# We specify only the necessary processors to avoid overwriting our custom app.dart, pages/, and flavors.dart
# We MUST include assets:download and assets:extract so flavorizr has its internal templates/scripts
echo "⚙️ Running flavorizr to generate native configurations..."
dart run flutter_flavorizr -p assets:download,assets:extract,android:androidManifest,android:flavorizrGradle,android:buildGradle,android:icons,ios:podfile,ios:xcconfig,ios:buildTargets,ios:schema,ios:icons,ios:plist,ios:launchScreen,assets:clean,ide:config

# 3. Clean up
echo "🧹 Cleaning up and resolving dependencies..."
rm rename.json
flutter clean
flutter pub get

echo "✅ Setup complete! You're ready to code 🚀"
