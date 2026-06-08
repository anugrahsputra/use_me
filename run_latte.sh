#!/usr/bin/env bash
flutter run --flavor latte -t lib/main_latte.dart --dart-define-from-file=.env.latte.json "$@"
