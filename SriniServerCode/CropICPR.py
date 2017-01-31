import csv
import numpy as np
import cv2
import scipy.misc
from Toolbox.CreateMargin import *
from Toolbox.Rotation import *


def CropICPRwMargin(ImagePath, CenterList, Size):
    Image = cv2.imread(ImagePath);
    addWidth = (Size-1)/2
    Image = AddMarginMirror(Image,addWidth);
    Corners = np.zeros([4],np.dtype('double'));
    ImageList = list();
    #ImageList = np.arrange(len(CenterList)).reshape(81,81,3);
    for i in range(0,len(CenterList)):
        Corners[0] = CenterList[i,0];
        Corners[1] = CenterList[i,1];
        Corners[2] = CenterList[i,0] + 2*addWidth;
        Corners[3] = CenterList[i,1] + 2*addWidth;
        ImageCrop = Image[Corners[0]:Corners[2]+1,Corners[1]:Corners[3]+1,:];
        ImageList = ImageList + [ImageCrop];
        #ImageList = ImageList.insert(i+1,ImageCrop);
    return ImageList


def CropICPRwMarginMap8(ImagePath, CenterList, Size):
    Image = cv2.imread(ImagePath);
    CenterList = CoordRotation(CenterList, Image.shape[0], Image.shape[1])
    Imageset = IM_Rotation_RGB(Image);
    addWidth = (Size-1)/2
    ImageList = [[],[],[],[],[],[],[],[]];
    for IM in range(0,8):
        Image = Imageset[IM];
        Image = AddMarginMirror(Image,addWidth);
        Corners = np.zeros([4],np.dtype('double'));
        for i in range(0,len(CenterList[0])):
            Corners[0] = CenterList[IM][i][0];
            Corners[1] = CenterList[IM][i][1];
            Corners[2] = CenterList[IM][i][0] + 2*addWidth;
            Corners[3] = CenterList[IM][i][1] + 2*addWidth;
            ImageCrop = Image[Corners[0]:Corners[2]+1,Corners[1]:Corners[3]+1,:];
            ImageList[IM] = ImageList[IM] + [ImageCrop];
    return ImageList