#!/usr/bin/env python

import numpy as np
import dicom
import sys
import os
import copy
import csv

def select_fields(dicomdir):
    ds = dicom.read_file(sys.argv[1])
    data_sheet = open('data-sheet.csv', 'w+')
    # header
    data_sheet.write('Patient Birth Date, \t')
    data_sheet.write('Study Date, \t')
    data_sheet.write('View Position, \t')
    data_sheet.write('Patient Sex, \t')
    data_sheet.write('Bits Stored, \t')
    data_sheet.write('Bits Allocated, \t')
    data_sheet.write('Code, \t')
    data_sheet.write('File Name\n')

    pixel_data = list()

    for record in ds.DirectoryRecordSequence:
        if record.DirectoryRecordType == "IMAGE":
            path = os.path.join(*record.ReferencedFileID)
            data = dicom.read_file(path.lower())
            d = copy.copy(data)
            pixel_data.append(data)

            # diagnosis
            data_sheet.write('%s, \t' % data.PatientBirthDate)
            data_sheet.write('%s, \t' % data.StudyDate)
            data_sheet.write('%s, \t' % data.ViewPosition)
            data_sheet.write('%s, \t' % data.PatientSex)
            data_sheet.write('%s, \t' % data.BitsStored)
            data_sheet.write('%s, \t' % data.BitsAllocated)

            name = data.ImageType.pop() + '-' + data.ViewCodeSequence[0].CodeMeaning
            name = name.lower() + '.dcm'

            data_sheet.write('%s, \t' % data.ViewCodeSequence[0].CodeMeaning)
            data_sheet.write('%s, \n' % name)

            # delete fields
            tags_to_keep = set([
                '(7fe0, 0010)', # pixel data
                '(0028, 0103)', # pixel representation, unsigned
                '(0028, 0010)', # rows
                '(0028, 0011)', # columns
                '(0028, 0100)', # bits allocated
                '(0028, 0101)' # bits stored
                ])

            for tag in list(data.keys()):
                if str(tag) not in tags_to_keep:
                    del data[tag]
            
            # save new dicom file
            data.save_as(name)

    return data, d
            
if __name__ == "__main__":
    dicomdir = sys.argv[1]
    data, d = select_fields(dicomdir)
