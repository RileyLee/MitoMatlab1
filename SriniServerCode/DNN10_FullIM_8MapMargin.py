#Mitosis detector on Full images
#Mito Lab _ Lee Yuguang


import sys
import caffe
import Image
import numpy as np
import lmdb
import io
import os
import cv2
from scipy.misc import imread
from Toolbox.MeanConversion import *
from Toolbox.Rotation import *
from Toolbox.CreateMargin import *


caffe_root = '../'
DNN_root = '/home/ylee3/caffe/Projects/SampleII/DNN10_Map8_Testing/'
Model_root = '/home/ylee3/caffe/Projects/SampleII/DNN10_Map8_Testing/'
MEAN_FILE = '/home/ylee3/caffe/Projects/SampleII/DNN10_Map8_Testing/SampleII1_mean.binaryproto'
PY_MEAN_FILE = "/home/ylee3/caffe/Projects/SampleII/DNN10_Map8_Testing/SampleII1_mean.npy"

Bin2NPY(MEAN_FILE, PY_MEAN_FILE);
    
mean = np.load(PY_MEAN_FILE)
#mean = cv2.imread(PY_MEAN_FILE)
mean = mean.transpose(1,2,0)
MarginWidth = 50;

MODEL_FILE = DNN_root + 'MitoDNN10_quick.prototxt'
PRETRAINED = Model_root + 'DNN10_SampleII1_iter_30001.caffemodel'
net = caffe.Net(MODEL_FILE, PRETRAINED,caffe.TEST)
caffe.set_mode_cpu()


print 'Reading Image Lists...'
Root_Path = '/home/ylee3/caffe2/Projects/Data/Original_icpr/'
FileList = []; NameList = [];
for file in range(0,5):
    list = os.listdir(Root_Path + 'A0' + str(file) + '_v2/')
    for x in range(0,len(list)):
        temp = list[x]
        if temp[(len(temp)-3):len(temp)] == 'bmp':
            FileList = FileList + [Root_Path + 'A0' + str(file) + '_v2/' + temp] 
            NameList = NameList + [temp[0:len(temp)-4]]
    list = os.listdir(Root_Path + 'H0' + str(file) + '_v2/') 
    for x in range(0,len(list)):
        temp = list[x]
        if temp[(len(temp)-3):len(temp)] == 'bmp':
            FileList = FileList + [Root_Path + 'H0' + str(file) + '_v2/' + temp] 
            NameList = NameList + [temp[0:len(temp)-4]]

##FileList = ['/home/ylee3/caffe2/Projects/PycaffeEva/Tasks/DNN10_S32_8Map/A.png','/home/ylee3/caffe/Projects/Data/Original/A00_v2/A00_03.bmp']
#NameList = ['A00_02','A00_03']

print 'Reading Set!!'

count_F = 0
for i in range(0,33):
    Image_Name = FileList[i]
    Image_Ori = cv2.imread(Image_Name)
    Image_Ori = np.uint8(AddMarginMirror(Image_Ori,MarginWidth));
    ImageSet = IM_Rotation(Image_Ori);
    Result = [];
    for Angle in range(0,8):
        Image = ImageSet[Angle]
        #print 'Image No. ' + str(Angle)
        
        Size = Image.shape
        H = len(xrange(MarginWidth+1,Size[0]-MarginWidth,10))
        W = len(xrange(MarginWidth+1,Size[1]-MarginWidth,10))
        Res = np.zeros((H,W),dtype=np.double)
        CountPercent = round(H*W/100)
        count = 0; percent =0;
        x_count = 0
        for x in xrange(MarginWidth,Size[0]-MarginWidth,10):
            y_count = 0
            for y in xrange(MarginWidth,Size[1]-MarginWidth,10):
                #if (x<=MarginWidth*2) | (y<=MarginWidth*2) | (x>=Size[0]-MarginWidth*2) | (y>=Size[1]-MarginWidth*2):
                #print 'A'
                IM_Crop = Image[(x-50):(x+51),(y-50):(y+51),0:3]
                #print str([x,y])
                IM_Crop = IM_Crop- mean
                    
                IM_Crop = IM_Crop.transpose(2,0,1)
                out = net.forward_all(data=np.asarray([IM_Crop]))       
                predicted_label = out['prob'][0][1]
                Res[x_count,y_count] = predicted_label
                #print str([x_count, y_count, predicted_label])
                y_count = y_count + 1
            x_count = x_count + 1
        Res = Res * 255
        Res1 = np.uint8(Res);
        Result = Result + [Res1];
        print 'Image No. ' + str(Angle)

    Result = IM_ReverseRotation(Result);
    
    for Angle in range(0,8):
        cv2.imwrite('/home/ylee3/caffe/Projects/SampleII/SampleII1_Prediction/SampleIIAug1/DNN10/'+NameList[i] + '_DNN10_SampleII1_Map8_' + str(Angle) + '.png',Result[Angle])
    count_F = count_F + 1;
    print str(i) + ' out of 100 images    Created!!'




