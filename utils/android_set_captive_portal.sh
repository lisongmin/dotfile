#!/usr/bin/env bash

adb shell settings put global captive_portal_use_https 1
adb shell settings put global captive_portal_https_url https://connect.rom.miui.com/generate_204
adb shell settings put global captive_portal_http_url http://connect.rom.miui.com/generate_204
adb shell settings put global captive_portal_mode 0
