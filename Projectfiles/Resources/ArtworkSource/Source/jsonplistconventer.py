#!/usr/bin/env python

import plistlib
import json

file_to_open = "dungeon.json"
file_to_write = "../../dungeon_tileset_scheme.plist"
converted_dict = json.load(open(file_to_open))
plistlib.writePlist(converted_dict, file_to_write)
