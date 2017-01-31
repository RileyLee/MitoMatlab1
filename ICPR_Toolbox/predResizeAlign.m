function outImage = predResizeAlign(inImage,Interv,sizeX,sizeY)

outImage = zeros(sizeX,sizeY);
IM_resize = imresize(inImage,Interv);
IM_resize = IM_resize((Interv/2+1):end,(Interv/2+1):end);

outImage(1:min(size(outImage,1),size(IM_resize,1)),1:min(size(outImage,2),size(IM_resize,2)),:) ...
    = IM_resize(1:min(size(outImage,1),size(IM_resize,1)),1:min(size(outImage,2),size(IM_resize,2)),:);


return