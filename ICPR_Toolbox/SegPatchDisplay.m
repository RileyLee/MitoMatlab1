function SegPatchDisplay(ImageList,MapList,Label,Score,Size,OutPath)


numRows = ceil(double(size(MapList,1)/17));
DisplayImage = uint8(ones((Size+13)*numRows,Size*17,3)*255);

Row = 1; Col = 1;
for Patch = 1:size(ImageList,1)
    if Patch == 1
        Image = imread(ImageList{Patch,2});
        load(MapList{Patch,2});
        LabelMap = bwlabel(Map1>0);
    elseif ImageList{Patch-1,1} == ImageList{Patch,1}
        Image = imread(ImageList{Patch,2});
        load(MapList{Patch,2});
        LabelMap = bwlabel(Map1);
    end
    
    Mask = (LabelMap==Label(Patch));
    Mask = imdilate(Mask,[0 1 0;1 1 1;0 1 0]);
    [X,Y] = find(Mask);
    Mask = Mask(min(X):max(X),min(Y):max(Y));
    ImagePatch1 = Image(min(X):max(X),min(Y):max(Y),:);
    ImagePatch1(:,:,1) = ImagePatch1(:,:,1) .* uint8(Mask);
    ImagePatch1(:,:,2) = ImagePatch1(:,:,2) .* uint8(Mask);
    ImagePatch1(:,:,3) = ImagePatch1(:,:,3) .* uint8(Mask);
    
    X = size(Mask,1);Y = size(Mask,2);
    X = (Size+1)/2-ceil(X/2);
    Y = (Size+1)/2-ceil(Y/2);
    ImagePatch = uint8(zeros(Size,Size,3));
    ImagePatch(X:X+size(Mask,1)-1,Y:Y+size(Mask,2)-1,:) = ImagePatch1;
    
    if isempty(Score) == 1
        StartR = (Row - 1)*Size + 1;
    else
        StartR = (Row - 1)*(Size+13) + 1;
    end
    StartC = (Col - 1)*Size + 1;
    ImagePatch(1,:,:) = 0;
    ImagePatch(end,:,:) = 0;
    ImagePatch(:,1,:) = 0;
    ImagePatch(:,end,:) = 0;
    DisplayImage(StartR:StartR+size(ImagePatch,1)-1,StartC:StartC++size(ImagePatch,2)-1,:) = ImagePatch;

    if isempty(Score) == 0
        Text = num2str(Score(Patch));
        H = vision.TextInserter(Text);
        H.Color = [0 0 0];
        H.FontSize = 10;
        H.Location = [StartC+20, StartR+82];
        DisplayImage = step(H, DisplayImage);
    end
    
    Col = Col + 1;
    if Col == 18
        Col = 1; Row = Row + 1;
    end    
    
    if floor(Patch/10)*10 == Patch
        disp([num2str(Patch),' out of ',num2str(size(ImageList,1)),' images are processed...'])
    end
end


imwrite(DisplayImage,OutPath);
