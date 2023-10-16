#!/bin/sh

format="%Y-%m-%d %H:%M:%S %z %Z"

TZ=UTC              date "+  UTC | $format"
TZ=Europe/Stockholm date "+Sthlm | $format"
TZ=Asia/Tokyo       date "+Tokyo | $format"
