#!/usr/bin/env python3

import math
import threading
import os.path
import json

class Browser:
    def __init__(self, directory):
        self.directory = directory
        self.entries = []
        self.block_size = 200
        self.border = 5
        self.name = "Unititled collection"
        self.show_info = False
        self.filename = None

    def __repr__(self):
        return "<Browser %s>" % self.name

    def save(self, filename=None):
        filepath = (filename or self.filename)
        if not filepath.endswith(".collection"): filepath += ".collection"
        filepath = os.path.join(self.directory.basepath, filepath)
        print("Saving collection as", filepath)
        with open(filepath, 'w') as f:
            f.write(json.dumps({"name": self.name, "entries": list(self.get_filtered_keys(''))}, indent=2))

    def load(self, filename):
        filepath = os.path.join(self.directory.basepath, filename)
        print("Loading collection", filepath)
        with open(filepath, 'r') as f:
            self.filename = filename
            data = json.load(f)
            self.name = data.get('name', self.name)
            self.use_keys(data.get('entries', []))

    @property
    def title_msg(self):
        return "%s - %i items" % (self.name, len(self.entries))

    def get_filtered(self, incl='', excl=''):
        incl = incl.upper()
        excl = excl.upper()
        for entry in self.entries:
            ok = True
            for f in incl:
                if not f in entry.categories:
                    ok = False
                    break
            for f in excl:
                if f in entry.categories:
                    ok = False
                    break
            if ok: yield entry

    def get_filtered_keys(self, incl='', excl=''):
        incl = incl.upper()
        excl = excl.upper()
        for entry in self.get_filtered(incl=incl, excl=excl):
            yield entry.filename

    def use_keys(self, keys):
        self.entries = [self.directory[key] for key in keys if key in self.directory.entries.keys()]
