import sys
import Image
import numpy as np
import io
import os
import cv2
from scipy.misc import imread



def IM_Rotation(Image):
    ImageSet = [];
    temp = cv2.transpose(Image);
    ImageSet = [Image]+[temp];
    Image = cv2.flip(Image,1);
    temp = cv2.flip(temp,1);
    ImageSet = ImageSet+[Image]+[temp];
    Image = cv2.transpose(Image);
    temp = cv2.transpose(temp);
    ImageSet = ImageSet+[Image]+[temp];
    Image = cv2.flip(Image,1);
    temp = cv2.flip(temp,1);
    ImageSet = ImageSet+[Image]+[temp];
    return ImageSet


def IM_Rotation_RGB(Image):
    ImageSet = [];
    temp = Image.transpose(1,0,2);
    ImageSet = [Image]+[temp];
    Image = cv2.flip(Image,1);
    temp = cv2.flip(temp,1);
    ImageSet = ImageSet+[Image]+[temp];
    Image = Image.transpose(1,0,2);
    temp = temp.transpose(1,0,2);
    ImageSet = ImageSet+[Image]+[temp];
    Image = cv2.flip(Image,1);
    temp = cv2.flip(temp,1);
    ImageSet = ImageSet+[Image]+[temp];
    return ImageSet


def IM_ReverseRotation(ImageSet):
    ImageSetR = [];
    ImageSetR = ImageSetR+[ImageSet[0]];
    ImageSetR = ImageSetR+[cv2.transpose(ImageSet[1])];
    ImageSetR = ImageSetR+[cv2.flip(ImageSet[2],1)];
    ImageSetR = ImageSetR+[cv2.transpose(cv2.flip(ImageSet[3],1))];
    ImageSetR = ImageSetR+[cv2.flip(cv2.transpose(ImageSet[4]),1)];
    ImageSetR = ImageSetR+[cv2.transpose(cv2.flip(cv2.transpose(ImageSet[5]),1))];
    ImageSetR = ImageSetR+[cv2.flip(cv2.transpose(cv2.flip(ImageSet[6],1)),1)];
    ImageSetR = ImageSetR+[cv2.transpose(cv2.flip(cv2.transpose(cv2.flip(ImageSet[7],1)),1))];
    return ImageSetR



def CoordRotation(CenterList, SizeR, SizeC):
    CoordRt = [[],[],[],[],[],[],[],[]];
    for i in range(0,len(CenterList)):
        r = CenterList[i][0]
        c = CenterList[i][1]
        r1 = SizeR - 1 - r;
        c1 = SizeC - 1 - c;    
    
        CoordRt[0] = CoordRt[0] + [[r,c]];
        CoordRt[1] = CoordRt[1] + [[c,r]];
        CoordRt[2] = CoordRt[2] + [[r,c1]];
        CoordRt[3] = CoordRt[3] + [[c,r1]];
        CoordRt[4] = CoordRt[4] + [[c1,r]];
        CoordRt[5] = CoordRt[5] + [[r1,c]];
        CoordRt[6] = CoordRt[6] + [[c1,r1]];
        CoordRt[7] = CoordRt[7] + [[r1,c1]];
    return CoordRt






