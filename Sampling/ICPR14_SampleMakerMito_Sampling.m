OriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\OriginalFrames\train\x40\';
OutPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_SamplePatches\SampleIV\newTrain\mito\';
ProbMapPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\OrigDNN\Prediction_OrigDNN\RawPrediction\DNN12_ICPR14_SampleIII1\';
GT_Path = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\GroundTruth\train\relabeled_x40\';

addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\Sampling');

char = 'abcd';
Char = 'ABCD';
probstring = '_DNN12_SampleIII_Ave';

load('E:\LeeYuguang\MitosisExtraction\CodeCenter\Sampling\ICPR14split.mat')
load('E:\LeeYuguang\MitosisExtraction\CodeCenter\Sampling\FixedICPR14MitoCenter.mat')


SE = fspecial('gaussian',[5,5],1);
SE = (SE>=0.02);


% SUM = 1242298960-907488324;
% SUM = 1396350202-1019149661;

SUM = 20109104;  % sum of prob maps
% TotalSample = 347906;          %Regular set
TotalSample = 1000000;
Sum1 = 0;
total = 0;

for File = trainSet
    FileName = ['A',num2str(floor(File/100), '%02d'), '_', num2str(mod(File,100), '%02d')];
    folderName = FileName;
%     mkdir([OutPath,folderName]);
    disp(['Processing ', FileName]);
    for serial = 0:15
        FileName = [FileName, Char(floor(serial/4)+1), char(mod(serial,4)+1)];
        prob = imread([ProbMapPath, FileName, probstring,'.png']);
        OriImage = imread([OriPath, FileName, '.tiff']);
        
        maskori = imread([GT_Path, FileName, '.png']);
        % Mask1 is yellow regions in marked images
        mask1 = (maskori(:,:,1) > 235) .* (maskori(:,:,2) > 235) .* (maskori(:,:,3) < 20);
        
        mask = imerode(mask1, strel('disk', 5));
        prob = imresize(prob, size(mask)) .* uint8(mask);
        
        %% Mark Probability Map (Above distance 9, outside size 2 dilation)
        % Only mitos with certainty above 0.65 are selected.
        temp = find(Label(:,1) == File & Label(:,2) == floor(serial/4)+1 & Label(:,3) == mod(serial,4)+1 & Label(:,6) > 0.5);
        Coords = Label(temp,[5,4]);
        
        MarkImage2 = zeros(size(mask));
        for Mito = 1:size(Coords,1)
            Coord = round(Coords(Mito,:));
            MarkImage2(Coord(1), Coord(2)) = 1;
        end
        MarkImage2 = imdilate(MarkImage2, strel('disk', 20));
        MarkImage1 = (bwlabel(mask) .* MarkImage2)>0;
        
%         MarkImage1 = mask;
        
        ProbMap = (255-prob) .* uint8(MarkImage1);
        
        sumlocal = sum(sum(ProbMap));
        total = total + sumlocal;
        % end
        %     Sum1 = Sum1 + round(TotalSample/SUM*sumlocal);
        %% Create sample patches based on probability maps
        %     total = total + round(TotalSample/SUM*sumlocal);
        %SamplewProb(OriImage, ProbMap, round(TotalSample/SUM*sumlocal), [OutPath,folderName,'\'], FileName);
        SamplewProb(OriImage, ProbMap, round(TotalSample/SUM*sumlocal), OutPath, FileName);
        disp(['Sample ',FileName, ' Created...'])
        FileName = FileName(1:6);
    end
end



