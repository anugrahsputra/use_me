#!/usr/bin/env bash
flutter run --flavor macchiato -t lib/main_macchiato.dart --dart-define-from-file=.env.macchiato.json "$@"
