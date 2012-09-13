#!/bin/bash

valac --pkg gtk+-3.0 --pkg libnotify owncloud_mount.vala mounting.vala secretfileact.vala -o owncloud_mount
