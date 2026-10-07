# use_me justfile
# https://github.com/casey/just

# default to fvm, but allow override
flutter := "fvm flutter"
dart := "fvm dart"

# List all commands
default:
    @just --list

# Run latte (development) flavor
[group('run')]
latte *args:
    {{ flutter }} run --flavor latte -t lib/main_latte.dart --dart-define-from-file=.env.latte.json {{ args }}

# Run macchiato (staging) flavor
[group('run')]
macchiato *args:
    {{ flutter }} run --flavor macchiato -t lib/main_macchiato.dart --dart-define-from-file=.env.macchiato.json {{ args }}

# Run espresso (production) flavor
[group('run')]
espresso *args:
    {{ flutter }} run --flavor espresso -t lib/main_espresso.dart --dart-define-from-file=.env.espresso.json {{ args }}

# Run pub get
[group('pub')]
get:
    {{ flutter }} pub get

# Add dependencies
[group('pub')]
add *args:
    {{ flutter }} pub add {{ args }}

# Add dev dependencies
[group('pub')]
add-dev *args:
    {{ flutter }} pub add --dev {{ args }}

# Clean
[group('pub')]
clean:
    {{ flutter }} clean

# Run build_runner code generation once
[group('codegen')]
build:
    {{ dart }} run build_runner build

# Run build_runner code generation with active file watching
[group('codegen')]
watch:
    {{ dart }} run build_runner watch

# Analyze code quality
[group('qc')]
analyze:
    {{ flutter }} analyze

# Run all unit and widget tests
[group('qc')]
test *args:
    {{ flutter }} test {{ args }}

# Run tests and generate HTML coverage report
[group('qc')]
coverage:
    {{ flutter }} test --coverage
    genhtml coverage/lcov.info -o coverage/html

# Generate app icons for Android and iOS using flavorizr
[group('assets')]
icons:
    {{ dart }} run flutter_flavorizr -p android:icons,ios:icons

# Run the project setup script
[group('setup')]
setup:
    ./setup.sh

[group('devices')]
devices:
    {{ flutter }} devices
