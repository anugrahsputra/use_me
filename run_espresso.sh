#!/usr/bin/env bash
flutter run --flavor espresso -t lib/main_espresso.dart --dart-define-from-file=.env.espresso.json "$@"
