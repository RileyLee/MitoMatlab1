# Binaryproto to npy

import caffe
import numpy as np
import sys


def Bin2NPY(MEAN_FILE, PY_MEAN_FILE):
    blob = caffe.proto.caffe_pb2.BlobProto()
    data = open( MEAN_FILE , 'rb' ).read()
    blob.ParseFromString(data)
    arr = np.array( caffe.io.blobproto_to_array(blob) )
    out = arr[0]
    np.save( PY_MEAN_FILE , out )