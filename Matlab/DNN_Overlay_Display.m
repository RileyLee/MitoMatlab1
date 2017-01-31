function ImageOut = DNN_Overlay_Display(DNN_Res, Image, stepSize, StartingPts, Display)

    Mask = zeros(size(Image,1),size(Image,2));
    temp = imresize(DNN_Res,stepSize);
    Mask(StartingPts(1):StartingPts(1)+size(temp,1)-1,StartingPts(2):StartingPts(2)+size(temp,2)-1) = temp;
    Mask = (double(Mask)+64) /(64+255)*255;
    ImageOut = Image;
    ImageOut(:,:,1) = uint8(double(ImageOut(:,:,1)) .* double(Mask) / 255);
    ImageOut(:,:,2) = uint8(double(ImageOut(:,:,2)) .* double(Mask) / 255);
    ImageOut(:,:,3) = uint8(double(ImageOut(:,:,3)) .* double(Mask) / 255);
    
    if Display == 1
        NewIM = uint8(zeros(size(Image,1),size(Image,2)*2,3));
        NewIM(1:size(Image,1),1:size(Image,2),:) = Image;
        NewIM(1:size(Image,1),(size(Image,2)+1):end,:) = ImageOut;
        figure;imshow(NewIM)
    end
return