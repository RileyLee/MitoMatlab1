OriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\OriginalFrames\train\x40\';
OutPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_SamplePatches\SampleVI\non\';
ProbMapPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_Prediction\ICPR12_FT_Fast\';
GT_Path = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\GroundTruth\train\relabeled_x40_v2\';

addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox');
addpath('E:\LeeYuguang\MitosisExtraction\CodeCenter\Histop\ICPR14only')

load('E:\LeeYuguang\MitosisExtraction\CodeCenter\Sampling\ICPR14split.mat')

char = 'abcd';
Char = 'ABCD';
probstring = '_DNN12_FT_Ave';
%probstring = '_DNN12_SampleIII_Ave';

load('FixedICPR14MitoCenter.mat')

SE = fspecial('gaussian',[5,5],1);
SE = (SE>=0.02);

% SUM = 1242298960-907488324;  %Aug set
% SUM = 1396350202-1019149661;
SUM = 100244098;   % ICPR14_SampleIIIplus from DNN12_FT_Ave
% TotalSample = 347906;          %Regular set
TotalSample = 4000000;
Sum1 = 0;
total = 0;

for File = [700, 701, 702, 703, 704]
    FileName = ['A',num2str(floor(File/100), '%02d'), '_', num2str(mod(File,100), '%02d')];
    folderName = FileName;
    mkdir([OutPath,folderName]);
    disp(['Processing ', FileName]);
    for serial = 0:15
        FileName = [FileName, Char(floor(serial/4)+1), char(mod(serial,4)+1)];
        prob = imread([ProbMapPath, FileName, probstring,'.png']);
        OriImage = imread([OriPath, FileName, '.tiff']);
        
        maskori = imread([GT_Path, FileName, '.png']);
        mask1 = (maskori(:,:,1) > 235) .* (maskori(:,:,2) > 235) .* (maskori(:,:,3) < 20);
        mask2 = (maskori(:,:,1) < 20) .* (maskori(:,:,2) < 20) .* (maskori(:,:,3) > 235);
        mask = 1 - imdilate((mask1 + mask2), strel('disk', 10));
        prob = imresize(prob, size(mask)) .* uint8(mask);
        
        %% Mark Probability Map (Above distance 9, outside size 2 dilation)
        temp = find(Label(:,1) == File & Label(:,2) == floor(serial/4)+1 & Label(:,3) == mod(serial,4)+1);
        Coords = Label(temp,[5,4]);
        
        MarkImage1 = zeros(size(mask));
        for Mito = 1:size(Coords,1)
            Coord = round(Coords(Mito,:));
            Xmin = max((Coord(1) - 25),1);
            Xmax = min((Coord(1) + 25),size(mask,1));
            Ymin = max((Coord(2) - 25),1);
            Ymax = min((Coord(2) + 25),size(mask,2));
            MarkImage1 = 1-mask>0;
            for x = Xmin:Xmax
                for y = Ymin:Ymax
                    dist = sqrt((double(Coord(1))-double(x))^2+(double(Coord(2))-double(y))^2);
                    if dist<23
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
        %     ProbMap(1:20,:) = 0; ProbMap(size(OriImage,1)-19:size(OriImage,1),:) = 0;
        %     ProbMap(:,1:20) = 0; ProbMap(:,size(OriImage,2)-19:size(OriImage,2)) = 0;
        %     ProbMap(1:80,1:80) = 0; ProbMap(1:80,size(OriImage,2)-79:size(OriImage,2)) = 0;
        %     ProbMap(size(OriImage,1)-79:size(OriImage,1),1:80) = 0; ProbMap(size(OriImage,1)-79:size(OriImage,1),size(OriImage,2)-79:size(OriImage,2)) = 0;
        
        % if sum(File==TrainFiles)==1 || sum(File==ValFiles)==1
        sumlocal = sum(sum(ProbMap));
        % end
        %     Sum1 = Sum1 + round(TotalSample/SUM*sumlocal);
        %% Create sample patches based on probability maps
             total = total + round(TotalSample/SUM*sumlocal);
        SamplewProbMat(OriImage, ProbMap, round(TotalSample/SUM*sumlocal), [OutPath,folderName,'\'], FileName);
        disp(['Sample ',FileName, ' Created...'])
        FileName = FileName(1:6);
    end
end



