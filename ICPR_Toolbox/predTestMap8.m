OriginPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM\';
ResultPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\MergedSlidingWindow\Map8Raw\';
OutPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\MergedSlidingWindow\MarkMap8\';
Model = '_SampleII_DNNBothAve'



ResultFile = dir([ResultPath,'*.png']);
Name = {ResultFile.name};
Disk = strel('disk',10);
Disk = Disk.getnhood();

for i = 31:50
    %Layer Prep
    tempName = ICPR_FileNameGenerate(i-1);
    Path = [OriginPath,tempName(1:6),'.csv'];
    Center = ICPR_csv2Coords(Path);
    
    Path = [OriginPath,ICPR_FileNameGenerate(i-1),'.bmp'];
    oriImage = imread(Path);
    Name = [ICPR_FileNameGenerate(i-1),'_DNNCombo_SampleII1_Map8_0.png'];
    Path = [ResultPath,Name];
    predImage = double(imread(Path));
    predImageAve = zeros(size(predImage,1),size(predImage,2));
    for Angle = 0:7
        Name = [ICPR_FileNameGenerate(i-1),'_DNNCombo_SampleII1_Map8_',num2str(Angle),'.png'];
        Path = [ResultPath,Name];
        predImageAve = predImageAve+double(imread(Path));
    end
    predImage = uint8(predImageAve/8);
    
    
    predImage = predResizeAlign(predImage,10,size(oriImage,1),size(oriImage,2));
    
    groundThruth = zeros(size(oriImage,1),size(oriImage,2));
    
    MitoNum = size(Center,2);
    for Mito = 1:MitoNum
        Coords = Center{Mito};
        for j = 1:size(Coords,1)
            groundThruth(Coords(j,1),Coords(j,2)) = Mito;
            CenterX = mean(Coords(j,1)); CenterY = mean(Coords(j,2));
            for x = -9:9
                for y=-9:9
                    dist = sqrt(x^2+y^2);
                    if dist <= 9 && CenterX + x>0 && CenterX + x<size(oriImage,1)&&CenterY + y>0 && CenterY + y<size(oriImage,2)
                        groundThruth(CenterX + x, CenterY+y) = Mito;
                    end
                end
            end
        end
    end
    
    [errorMap,ConfMat] = RawDNNpred2ErrorMap(predImage, groundThruth, 127);
    
    imwrite(uint8(errorMap),[OutPath, tempName(1:6),Model,'_pt5.png']);
    save([OutPath, tempName(1:6),Model,'_pt5.mat'],'ConfMat');
    
    [num2str(i), ' out of ', num2str(50), 'images done..']
end