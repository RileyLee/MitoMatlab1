import sys
import caffe
import Image
import numpy as np
import lmdb
import io
import os
import cv2
from scipy.misc import imread


def Detector(image_path, net, Mean_Path, X_Intv, Y_Intv):
    mean = np.load(Mean_Path)
    Image = cv2.imread(image_path)
    Image = Image.transpose(2,0,1)
    IM_Crop = np.zeros((101,101,3),dtype=np.uint8)
    Size = Image.shape
    H = len(xrange(50,Size[1]-51,X_Intv))
    W = len(xrange(50,Size[2]-51,Y_Intv))
    Res = np.zeros((H,W),dtype=np.double)
    CountPercent = round(H*W/100)
    count = 0; percent =0;
    x_count = 0
    print image_path + '     Task in Progress...' 
    for x in xrange(51,Size[1]-50,X_Intv):
        y_count = 0
        for y in xrange(51,Size[2]-50,Y_Intv):
            IM_Crop = Image[0:3,(x-50):(x+51),(y-50):(y+51)]
            IM_Crop = IM_Crop- mean
            out = net.forward_all(data=np.asarray([IM_Crop]))        
            predicted_label = out['prob'][0].argmax(axis=0)
            Res[x_count,y_count] = predicted_label
            y_count = y_count + 1
            count = count + 1
            if count == CountPercent:
                count = 0
                percent = percent + 1;
        x_count = x_count + 1
    return Res

