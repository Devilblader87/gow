#!/bin/bash
mkdir -p /run/dbus
dbus-daemon --system --fork
