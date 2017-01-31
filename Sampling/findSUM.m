OriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Frames\train\x40\';
OutPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_FineTune\2016_10\plus\';
ProbMapPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\OrigDNN\Prediction_OrigDNN\RawPrediction\DNN12_ICPR14_SampleIII1\';
GT_Path = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\GroundTruth\train\relabeled_x40\';

addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox');

load('ICPR14split.mat')
load('FixedICPR14MitoCenter.mat')

char = 'abcd';
Char = 'ABCD';
probstring = '_DNN12_SampleIII_Ave';

SUM = 0;
for File = trainSet
    FileName = ['A',num2str(floor(File/100), '%02d'), '_', num2str(mod(File,100), '%02d')]; 
    disp(['Processing ', FileName]);
    for serial = 0:15
        FileName = [FileName, Char(floor(serial/4)+1), char(mod(serial,4)+1)]
        prob = imread([ProbMapPath, FileName, probstring,'.png']);
        maskori = imread([GT_Path, FileName, '.png']);
        mask1 = (maskori(:,:,1) > 250) .* (maskori(:,:,2) > 250) .* (maskori(:,:,3) < 5);
        mask2 = (maskori(:,:,1) < 5) .* (maskori(:,:,2) < 5) .* (maskori(:,:,3) > 250);
        mask = 1 - imdilate((mask1 + mask2), strel('disk', 5));
        prob = imresize(prob, size(mask)) .* uint8(mask);
        
        %% Mark Probability Map (Above distance 9, outside size 2 dilation)
        temp = find(Label(:,1) == File & Label(:,2) == floor(serial/4)+1 & Label(:,3) == mod(serial,4)+1);
        Coords = Label(temp,[5,4]);
        
        
        for Mito = 1:size(Coords,1)
            Coord = round(Coords(Mito,:));
            Xmin = max((Coord(1) - 11),1);
            Xmax = min((Coord(1) + 11),size(mask,1));
            Ymin = max((Coord(2) - 11),1);
            Ymax = min((Coord(2) + 11),size(mask,2));
            MarkImage1 = 1-mask>0;
            for x = Xmin:Xmax
                for y = Ymin:Ymax
                    dist = sqrt((double(Coord(1))-double(x))^2+(double(Coord(2))-double(y))^2);
                    if dist<9
                        MarkImage1(x,y) = Mito;
                    end
                end
            end
        end
        Problabel = bwlabel(prob>0);
        Problabel1 = Problabel .* double(MarkImage1>0);
        val = unique(Problabel1);
        val = val(find(val>0));
        
        for i = 1:length(val)
            MarkImage1(find(Problabel==val(i))) = 1;
        end
        
        ProbMap = double(double(prob).*double(1-MarkImage1));
        
        SUM = SUM + sum(ProbMap(:));
        FileName = FileName(1:6);
    end
    
end

for File = trainSet
    FileName = ['A',num2str(floor(File/100), '%02d'), '_', num2str(mod(File,100), '%02d')]; 
    disp(['Processing ', FileName]);
    for serial = 0:15
        FileName = [FileName, Char(floor(serial/4)+1), char(mod(serial,4)+1)]
        prob = imread([ProbMapPath, FileName, probstring,'.png']);
        maskori = imread([GT_Path, FileName, '.png']);
        mask1 = (maskori(:,:,1) > 250) .* (maskori(:,:,2) > 250) .* (maskori(:,:,3) < 5);
        mask2 = (maskori(:,:,1) < 5) .* (maskori(:,:,2) < 5) .* (maskori(:,:,3) > 250);
        mask = 1 - imdilate((mask1 + mask2), strel('disk', 5));
        prob = imresize(prob, size(mask)) .* uint8(mask);
        
        %% Mark Probability Map (Above distance 9, outside size 2 dilation)
        temp = find(Label(:,1) == File & Label(:,2) == floor(serial/4)+1 & Label(:,3) == mod(serial,4)+1);
        Coords = Label(temp,[5,4]);
        
        
        for Mito = 1:size(Coords,1)
            Coord = round(Coords(Mito,:));
            Xmin = max((Coord(1) - 11),1);
            Xmax = min((Coord(1) + 11),size(mask,1));
            Ymin = max((Coord(2) - 11),1);
            Ymax = min((Coord(2) + 11),size(mask,2));
            MarkImage1 = 1-mask>0;
            for x = Xmin:Xmax
                for y = Ymin:Ymax
                    dist = sqrt((double(Coord(1))-double(x))^2+(double(Coord(2))-double(y))^2);
                    if dist<9
                        MarkImage1(x,y) = Mito;
                    end
                end
            end
        end
        Problabel = bwlabel(prob>100);
        Problabel1 = Problabel .* double(MarkImage1>0);
        val = unique(Problabel1);
        val = val(find(val>0));
        
        for i = 1:length(val)
            MarkImage1(find(Problabel==val(i))) = 1;
        end
        
        ProbMap = double(double(prob).*double(1-MarkImage1));
        
        SUM = SUM + sum(ProbMap(:));
        FileName = FileName(1:6);
    end
    
end