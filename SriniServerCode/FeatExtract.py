# DNN Feature Extraction
#Author: Riley Lee

OutPath = '/home/ylee3/caffe/Projects/SampleII/FeatExtract/ExtractedFeats/SampleII2_DNN12/';
RootPath = '/home/ylee3/caffe/Projects/SampleII/FeatExtract/Tasks/SampleII2_DNN10/';
DNN_root = '/home/ylee3/caffe/Projects/SampleII/TrainedModel/SampleII2/DNN12/';
imagePath = '/home/ylee3/caffe/Projects/SampleI/Data/ICPR/';

import sys
import caffe
import Image
import numpy as np
import lmdb
import io
import os
import cv2
from Toolbox.CropICPR import *
from Toolbox.ICPR_Index import *
from Toolbox.DNNFeats import *

csvPath = RootPath + 'CenterInfo.csv';
caffe_root = '../';
Model_root = DNN_root;
MEAN_FILE = RootPath + 'SampleII2_mean.binaryproto';
PY_MEAN_FILE = RootPath + 'SampleII2_mean.npy';



# Loading DNN Models
mean = np.load(PY_MEAN_FILE)
mean = mean.transpose(1,2,0)
MODEL_FILE = DNN_root + 'MitoDNN12_quick.prototxt'
PRETRAINED = Model_root + 'DNN12_SampleII2_iter_300000.caffemodel'
net = caffe.Net(MODEL_FILE, PRETRAINED,caffe.TEST)
caffe.set_mode_cpu()




# Loading Patch Centers
with open(csvPath) as File:
    Content = File.readlines()

Values = np.zeros([len(Content),6],np.dtype('double'));
for i in range(0,len(Content)):
    Line = Content[i];
    Line = Line[0:len(Line)-1];
    Values[i] = Line.split(',');

Coords = np.zeros([len(Content),4],np.dtype('double'));
Coords[:,0] = Values[:,0];
Coords[:,1] = np.floor(Values[:,3] + Values[:,5]/2);
Coords[:,2] = np.floor(Values[:,2] + Values[:,4]/2);
Coords[:,3] = Values[:,1];




#DNN Feature Extraction
Size = 101
for File in range(0,50):
    os.system('clear')
    Temp = 'Processing Image ' + str(File+1) + ' ...'
    print Temp
    Idx = np.where(Coords[:,0] == (File));
    Idx = Idx[0];
    fileStart = Idx[0];  
    fileEnd = Idx[len(Idx)-1]
    CoordsLocal = Coords[fileStart:fileEnd+1,1:3];
    Path = ''.join([imagePath,ICPR_NameGenerator(File),'.bmp'])
    ImageList = CropICPRwMarginMap8(Path , CoordsLocal , Size)

    FeatsFile = np.zeros([8,len(ImageList[0]),101],np.dtype('float'));
    for Layer in range(0,8):
        for Patch in range(0,len(ImageList[0])):
            IM = ImageList[Layer][Patch];
            IM = IM - mean
            IM = IM.transpose(2,0,1)
            out = net.forward_all(data=np.asarray([IM]))
            predicted_label = out['prob'][0][1]
            Feats = net.blobs['ip1'].data;
            FeatsFile[Layer][Patch][0:100] = Feats;
            FeatsFile[Layer][Patch][100] = predicted_label;

        Temp = 'Orientation No. ' + str(Layer + 1) + ' Processed...'
        print Temp
    
    Path = str(File)+'.npy'
    np.save(str(File)+'.npy',FeatsFile)

