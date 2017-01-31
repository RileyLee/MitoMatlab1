function ImageOut = Overlay_Display(ImageIn, Display)

    Image = ImageIn(1:size(ImageIn,1),1:size(ImageIn,2)/2,:);
    Mask = ImageIn(1:size(ImageIn,1),(size(ImageIn,2)/2+1):end,1);
    Mask = (double(Mask)+125)/(125+255)*255;
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