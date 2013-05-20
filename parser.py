#!/usr/bin/env python

import numpy as np
import dicom
import sys
import os

def selectfields(dicomdir):   
    ds = dicom.read_file(dicomdir)
    pixel_data = list()

    for record in ds.DirectoryRecordSequence:
        if record.DirectoryRecordType == "IMAGE":
            path = os.path.join(*record.ReferencedFileID)
            dcm = dicom.read_file(path.lower())
            pixel_data.append(dcm)
    data = np.copy(pixel_data[1].pixel_array)
    width, height = data.shape

if __name__ == "__main__":
    dicomdir = sys.argv[1]
    select_fields(dicomdir)

