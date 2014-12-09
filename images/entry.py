#!/usr/bin/env python3

import pygame
import os
import threading
from PIL import Image
from math import pi
from time import time

IMAGE = 'image'
COLLECTION = 'collection'
NOTE = 'note'
orientation2angle = {
    1: 0,
    2: 0,
    3: 180,
    4: 180,
    5: 270,
    6: 270,
    7: 90,
    8: 90,
}

class Entry:
    def __init__(self, filename=None, from_dict=None):
        self.filename = filename
        self.filename_thumb = str(filename) + '.thumbnail'
        self.filename_preview = str(filename) + '.preview'
        self.categories = ""
        self.angle = 0
        self.height = 0
        self.width = 0
        self.comment = None
        self.modified = 0.0
        if filename and filename.endswith('.collection'):
            self.entry_type = COLLECTION
        elif filename and filename.endswith('.note'):
            self.entry_type = NOTE
        else:
            self.entry_type = IMAGE
        self.content = None
        self.name = None
        
        if not from_dict is None:
            self.from_dict(from_dict)

    def __repr__(self):
        return "<Entry '%s' %s>" % (self.entry_type, self.filename)

    def read_exif(self, basepath):
        infile = os.path.join(basepath, self.filename)
        im = Image.open(infile)
        exif = im._getexif()
        orientation = exif.get(274)
        old_angle = self.angle
        self.angle = orientation2angle[int(orientation)]
        if old_angle != self.angle:
            self.modified = time()

    def create_thumbnail(self, basepath, override=False):
        infile = os.path.join(basepath, self.filename)
        outfile = os.path.join(basepath, self.filename_thumb)
        if os.path.exists(outfile) and not override:
            print("Thumbnail already exists")
            return
        try:
            im = Image.open(infile)
            with open(outfile, 'w') as out:
                w = 200
                h = 200
                self._resize(im, (w, h), True, out)
                print("Created thumbnail", outfile)
        except ValueError:
            print("Cannot create thumbnail for '%s' (ValueError)" % infile)
        except OSError:
            print("Cannot create thumbnail for '%s' (OSError)" % infile)
        
    def export(self, basepath, longest_edge, output_dir, output_filename):
        infile = os.path.join(basepath, self.filename)
        rotate = True
        if not os.path.exists(infile):
            infile = os.path.join(basepath, self.filename_preview)
            rotate = False
        outfile = os.path.join(output_dir, output_filename)
        try:
            im = Image.open(infile)
            with open(outfile, 'w') as out:
                self.width, self.height = im.size
                if self.width > self.height:
                    scale = float(longest_edge) / float(self.width)
                else:
                    scale = float(longest_edge) / float(self.height)
                w = int(self.width * scale)
                h = int(self.height * scale)
                self._resize(im, (w, h), False, out, rotate)
                print("Created image", outfile)
        except ValueError:
            print("Cannot export '%s' -> '%s' (ValueError)" % (infile, outfile))
        except OSError:
            print("Cannot export '%s' -> '%s' (OSError)" % (infile, outfile))

    def to_dict(self):
        return {
            'filename': self.filename,
            'categories': self.categories,
            'angle': self.angle,
            'height': self.height,
            'width': self.width,
            'comment': self.comment,
            'type': self.entry_type,
            'name': self.name,
            'thumb': self.filename_thumb,
            'modified': self.modified,
        }

    def from_dict(self, d):
        self.filename = d.get('filename', '')
        self.filename_thumb = d.get('thumb') or (self.filename + '.thumbnail')
        self.filename_preview = d.get('preview') or (self.filename + '.preview')
        self.categories = d.get('categories', "")
        self.angle = d.get('angle', 0)
        self.height = d.get('height', 0)
        self.width = d.get('width', 0)
        self.comment = d.get('comment', None)
        self.entry_type = d.get('type', IMAGE)
        self.name = d.get('name', None)
        self.modified = float(d.get('modified', 0.0))

    def rotate(self, delta):
        self.angle += delta
        if self.angle < 0:
            self.angle = 270
        elif self.angle >= 360:
            self.angle = 0

    def angle(self, angle):
        self.angle = angle
        self.zoom(1)

    def toggle_category(self, category, directory=None):
        category = category.upper()
        self.categories = ''.join(self.categories)
        p = self.categories.find(category)
        if p != -1:
            self.categories = self.categories[:p] + self.categories[p+1:]
        else:
            self.categories += category
            if not directory is None:
                catdesc = directory.settings.get('categories', {}).get(category, {})
                rplc = catdesc.get('replace', '')
                for r in rplc:
                    if r in self.categories:
                        self.toggle_category(r)
        self.categories = ''.join(sorted(self.categories))
        self.modified = time()
        return self.categories

    def _resize(self, img, box, fit, out, rotate=True):
        '''Downsample the image.
        @param img: Image -  an Image-object
        @param box: tuple(x, y) - the bounding box of the result image
        @param fit: boolean - crop the image to fill the box
        @param out: file-like-object - save the image into the output stream
        '''
        #preresize image with factor 2, 4, 8 and fast algorithm
        factor = 1
        bw, bh = box
        iw = self.width
        ih = self.height
        while (iw*2/factor > 2*bw) and (ih*2/factor > 2*bh):
            factor *=2
        factor /= 2
        if factor > 1:
            img.thumbnail((iw/factor, ih/factor), Image.NEAREST)

        #calculate the cropping box and get the cropped part
        if fit:
            x1 = y1 = 0
            x2, y2 = img.size
            wRatio = 1.0 * x2/box[0]
            hRatio = 1.0 * y2/box[1]
            if hRatio > wRatio:
                y1 = int(y2/2-box[1]*wRatio/2)
                y2 = int(y2/2+box[1]*wRatio/2)
            else:
                x1 = int(x2/2-box[0]*hRatio/2)
                x2 = int(x2/2+box[0]*hRatio/2)
            img = img.crop((x1,y1,x2,y2))

        #Resize the image with best quality algorithm ANTI-ALIAS
        img.thumbnail(box, Image.ANTIALIAS)
        if self.angle and rotate:
            img = img.rotate(self.angle)

        #save it into a file-like object
        img.save(out, "JPEG", quality=75)

    def delete_from_disk(self, basepath):
        print("Deleting image %s" % self.filename)
        thumb_filename = os.path.join(basepath, self.filename_thumb)
        preview_filename = os.path.join(basepath, self.filename_preview)
        filename = os.path.join(basepath, self.filename)
        print("Deleting", thumb_filename)
        if os.path.exists(thumb_filename):
            os.remove(thumb_filename)
        print("Deleting", preview_filename)
        if os.path.exists(preview_filename):
            os.remove(preview_filename)
        print("Deleting", filename)
        if os.path.exists(filename):
            os.remove(filename)
        print("Deleted image %s" % self.filename)
