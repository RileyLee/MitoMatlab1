function PatchDisplay(PathList,Center,Score,Size,OutPath, NumCol)

if size(PathList,1) ~= 0 
numRows = ceil(double(size(Center,1)/NumCol));
DisplayImage = uint8(ones((Size+NumCol)*numRows,Size*NumCol,3)*255);

Row = 1; Col = 1;
for Patch = 1:size(PathList,1)
    if Patch == 1
        Image = imread(PathList{Patch,2});
    elseif PathList{Patch-1,1} ~= PathList{Patch,1}
        Image = imread(PathList{Patch,2});
    end
    Corners = zeros(1,4);
    Corners(1) = max(floor(Center(Patch,1)-(Size-1)/2),1);
    Corners(2) = min(floor(Center(Patch,1)+(Size-1)/2),size(Image,2));
    Corners(3) = max(floor(Center(Patch,2)-(Size-1)/2),1);
    Corners(4) = min(floor(Center(Patch,2)+(Size-1)/2),size(Image,1));
    ImagePatch = Image(Corners(3):Corners(4),Corners(1):Corners(2),:);
    
    if isempty(Score) == 1
        StartR = (Row - 1)*Size + 1;
    else
        StartR = (Row - 1)*(Size+NumCol) + 1;
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
    if Col == (NumCol+1)
        Col = 1; Row = Row + 1;
    end    
    
%     if floor(Patch/10)*10 == Patch
%         disp(['    ',num2str(Patch),' out of ',num2str(size(PathList,1)),' images are processed...'])
%     end
end

imwrite(DisplayImage,OutPath);



end





