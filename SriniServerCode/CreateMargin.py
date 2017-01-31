import argparse
import os
import time
import cv2
import PIL.Image
import numpy as np
import scipy.misc



def AddMarginMirror(Image, MarginWidth):
    
    Size = np.shape(Image);
    if len(Size) == 2:
        Size = [Size[0],Size[1],1];
    ImageOut= np.zeros([Size[0]+2*MarginWidth,Size[1]+2*MarginWidth,Size[2]],dtype=np.float16);
    ImageOut[MarginWidth:MarginWidth+Size[0],MarginWidth:MarginWidth+Size[1],0:Size[2]] = Image;

    FlipImage = Image[0:MarginWidth,0:Size[1]];
    ImageOut[0:MarginWidth,MarginWidth:Size[1]+MarginWidth] = mirrorHorizon(FlipImage);

    FlipImage = Image[Size[0]-1-MarginWidth:Size[0],0:Size[1]];
    ImageOut[Size[0]-1+MarginWidth:Size[0]+2*MarginWidth,MarginWidth:Size[1]+MarginWidth] = mirrorHorizon(FlipImage);

    Size = np.shape(ImageOut);
    if len(Size) == 2:
        Size = [Size[0],Size[1],1];

    FlipImage = ImageOut[0:Size[0],MarginWidth:2*MarginWidth,0:Size[2]];
    ImageOut[0:Size[0],0:MarginWidth,0:Size[2]] = mirrorVertical(FlipImage);
    
    FlipImage = ImageOut[0:Size[0],Size[1]-2*MarginWidth:Size[1]-MarginWidth,0:Size[2]];
    ImageOut[0:Size[0],Size[1]-MarginWidth:Size[1],0:Size[2]] = mirrorVertical(FlipImage);

    return ImageOut

def mirrorVertical(Image):
    Size = np.shape(Image);
    ImageOut = np.zeros(Size,dtype=np.float16)
    for x in range(0,Size[1]):
        ImageOut[0:Size[0],Size[1]-x-1,0:Size[2]] = Image[0:Size[0],x,0:Size[2]];
    return ImageOut


def mirrorHorizon(Image):
    Size = np.shape(Image);
    ImageOut = np.zeros(Size,dtype=np.float16)
    for x in range(0,Size[0]):
        ImageOut[Size[0]-x-1,0:Size[1],0:Size[2]] = Image[x,0:Size[1],0:Size[2]];
    return ImageOut