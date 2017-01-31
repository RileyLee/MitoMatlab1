OriginPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM\';
ResultPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ExperimentRedo\SampleII2_Prediction\ProbMap8\DNN10\';
OutPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ExperimentRedo\SampleII2_Prediction\Mark\DNN10\';
Model = '_SampleII2_DNN10_'



ResultFile = dir([ResultPath,'*.png']);
Name = {ResultFile.name};


for i = 45
    clc
    disp(['Processing Image ',num2str(i), ' out of ', num2str(50), '..'])
    %Layer Prep
    tempName = ICPR_FileNameGenerate(i-1);
    Path = [OriginPath,tempName(1:6),'.csv'];
    Center = ICPR_csv2Coords(Path);
    
    Path = [OriginPath,ICPR_FileNameGenerate(i-1),'.bmp'];
    oriImage = imread(Path);
    
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
    
    
    for Angle = 0:7
        disp(['Processing Angle ',num2str(Angle+1),'...'])
        Name = [ICPR_FileNameGenerate(i-1),'_DNN10_SampleII2',num2str(Angle),'.png'];
        Path = [ResultPath,Name];
        predImage = double(imread(Path));
        
        
        % for i = 4:size(Name,2)
        %     %Layer Prep
        %     tempName = Name{i};
        %     Path = [OriginPath,tempName(1:6),'.csv'];
        %     Center = ICPR_csv2Coords(Path);
        %
        %     Path = [OriginPath,ICPR_FileNameGenerate(i),'.bmp'];
        %     oriImage = imread(Path);
        %     Path = [ResultPath,Name{i}];
        %     predImage = imread(Path);
        
        predImage = predResizeAlign(predImage,10,size(oriImage,1),size(oriImage,2));
        
        [errorMap,ConfMat] = RawDNNpred2ErrorMap(predImage, groundThruth, 127);
        
        imwrite(uint8(errorMap),[OutPath, tempName(1:6),Model,'_',num2str(Angle),'.png']);
        save([OutPath, tempName(1:6),Model,'_',num2str(Angle),'.mat'],'ConfMat');
        
    end
    
end