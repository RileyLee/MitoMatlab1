# DNN Feature Extraction
#Author: Riley Lee

OutPath = '/home/ylee3/caffe/Projects/SampleII/FeatExtract/ExtractedFeats/SampleII2_DNN12/';
RootPath = '/home/ylee3/caffe/Projects/SampleII/FeatExtract/Tasks/SampleII2_DNN10/';
DNN_root = '/home/ylee3/Mitosis/ClassifierEnsemble/ScanningWindowRF/';
imagePath = '/home/ylee3/caffe/Projects/SampleI/Data/ICPR/';
clfPath = '/home/ylee3/Mitosis/ClassifierEnsemble/RandomForestDNN/DNNBothRF783/clf_DNNBothRF.pkl';

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
from sklearn.externals import joblib

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
net12 = caffe.Net(MODEL_FILE, PRETRAINED,caffe.TEST)

MODEL_FILE = DNN_root + 'MitoDNN10_quick.prototxt'
PRETRAINED = Model_root + 'DNN10_SampleII2_iter_300000.caffemodel'
net10 = caffe.Net(MODEL_FILE, PRETRAINED,caffe.TEST)
caffe.set_mode_cpu()


# Loading Random Forest Model
clf = joblib.load(clfPath);




# Loading Image Files
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
    #list = os.listdir(Root_Path + 'H0' + str(file) + '_v2/') 
    #for x in range(0,len(list)):
    #    temp = list[x]
    #    if temp[(len(temp)-3):len(temp)] == 'bmp':
    #        FileList = FileList + [Root_Path + 'H0' + str(file) + '_v2/' + temp] 
    #        NameList = NameList + [temp[0:len(temp)-4]]

##FileList = ['/home/ylee3/caffe2/Projects/PycaffeEva/Tasks/DNN10_S32_8Map/A.png','/home/ylee3/caffe/Projects/Data/Original/A00_v2/A00_03.bmp']
#NameList = ['A00_02','A00_03']

print 'Reading Set!!'


MarginWidth = 50
count_F = 0
for i in range(26,29):
    Image_Name = FileList[i]
    Image_Ori = cv2.imread(Image_Name)
    Image_Ori = np.uint8(AddMarginMirror(Image_Ori,MarginWidth));
    ImageSet = IM_Rotation(Image_Ori);
    Result = [];
    print 'Processing Image ' + Image_Name
    for Angle in range(0,8):
        Image = ImageSet[Angle]
        print 'Processing Image No. ' + str(Angle)
        Size = Image.shape
        H = len(xrange(MarginWidth+1,Size[0]-MarginWidth,10))
        W = len(xrange(MarginWidth+1,Size[1]-MarginWidth,10))
        Res = np.zeros((H,W),dtype=np.double)
        CountPercent = round(H*W/100)
        count = 0; percent =0;
        x_count = 0 
        featCount = 0;
        Feats1 = np.zeros((H*W,200),dtype=np.float)
        for x in xrange(MarginWidth,Size[0]-MarginWidth,10):
            y_count = 0
            for y in xrange(MarginWidth,Size[1]-MarginWidth,10):
                #if (x<=MarginWidth*2) | (y<=MarginWidth*2) | (x>=Size[0]-MarginWidth*2) | (y>=Size[1]-MarginWidth*2):
                #print 'A'
                IM_Crop = Image[(x-50):(x+51),(y-50):(y+51),0:3]
                #print str([x,y])
                IM_Crop = IM_Crop- mean 
                IM_Crop = IM_Crop.transpose(2,0,1)
                out = net10.forward_all(data=np.asarray([IM_Crop]))       
                #predicted_label10 = out['prob'][0][1]
                Feats10 = net10.blobs['ip1'].data;
                out = net12.forward_all(data=np.asarray([IM_Crop]))       
                #predicted_label12 = out['prob'][0][1]
                Feats12 = net12.blobs['ip1'].data;
                Feats = np.hstack((Feats10,Feats12));
                Feats1[featCount,:] = Feats
                #temp = clf.predict_proba(Feats)
                #Res[x_count][y_count] = temp[0][1]
                featCount = featCount + 1
                y_count = y_count + 1
            x_count = x_count + 1
        Pred = clf.predict_proba(Feats1)
        Pred1 = Pred[:,1]
        x_count = 0 
        featCount = 0;
        for x in xrange(MarginWidth,Size[0]-MarginWidth,10):
            y_count = 0
            for y in xrange(MarginWidth,Size[1]-MarginWidth,10):
                Res[x_count][y_count] = Pred1[featCount]
                featCount = featCount + 1
                y_count = y_count + 1
            x_count = x_count + 1
        Res = Res * 255
        Res1 = np.uint8(Res);
        Result = Result + [Res1];
    Result = IM_ReverseRotation(Result);
    for Angle in range(0,8):
        cv2.imwrite('/home/ylee3/Mitosis/ClassifierEnsemble/ScanningWindowRF/TestResult/'+NameList[i] + '_DNNCombo_SampleII1_Map8_' + str(Angle) + '.png',Result[Angle])
    count_F = count_F + 1;
    print str(i) + ' out of 100 images    Created!!'
