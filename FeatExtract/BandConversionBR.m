function [ BR ] = BandConversionBR( IM, Display )

R = IM(:,:,1);
G = IM(:,:,2);
B = IM(:,:,3);

HSV_IM = rgb2hsv(IM);
H = HSV_IM(:,:,3);

LAB_IM = colorspace(['lab','<-RGB'],IM);  
La = LAB_IM(:,:,1);

Luv_IM = colorspace(['Luv','<-RGB'],IM);  
Lu = Luv_IM(:,:,1);

BR = (100*double(B))./(1+double(R)+double(G)) * 256 ./(1 + double(R) + double(G) + double(B));

if Display == 1
    
    figure;subplot(1,2,1);
    imshow(IM)
    subplot(1,2,2);
    imshow(uint8(H*255));
    
    figure;subplot(1,2,1);
    imshow(IM)
    subplot(1,2,2);
    imshow(uint8(La));

    figure;subplot(1,2,1);
    imshow(IM)
    subplot(1,2,2);
    imshow(uint8(Lu*2.55));
    
    figure;subplot(1,2,1);
    imshow(IM)
    subplot(1,2,2);
    imshow(uint8(BR*2.55));
    
end

end

