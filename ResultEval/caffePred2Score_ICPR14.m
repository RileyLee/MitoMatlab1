clear
OriginPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\normFrames_Reinhard\train\x40\';
ResultPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\OrigDNN\Prediction_OrigDNN\RawPrediction\MitoDNN12_SampleIII_1plus_revised\Train\';
ProposalPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\Prediction\NucleiSegment\train\x40\'
OutPath = 'E:\LeeYuguang\MitosisExtraction\CodeCenter\Histop\ICPR14only\';
 load('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox\labelsICPR14csv.mat');
%load('E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_FineTune\fixedLabels_ICPR2014.mat')
load('ICPR14split.mat')
Model = '_MitoDNN12_SampleIII1plus2'


%%  Input Parameters
thresholdList = [0.2,0.5,0.6,0.7,0.75,0.8,0.85,0.9,0.95]*255;
interval = 1;


%%
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
Char = 'ABCD'; char = 'abcd'; ScoreCode = [0,0.2,0.65,0.8,1];

Name = dir([ResultPath,'*.png']);
Name = {Name.name};

SE = strel('disk',10);


UnrecordedPredFinal = cell(0);
PredictionFinal = cell(0);

temp = Label(:,4:5);
temp(temp==0) = 1;
Label(:,4:5) = temp;

for threshold = thresholdList(2)
    totalTP=0;totalFN=0;totalFP=0;
    Prediction = zeros(0,9);
    UnrecordedPred = zeros(0,6);
for i = 1:size(Name,2)
    
    fileName = Name{i};
    disp(['Processing file ',fileName(1:8),'......'])
    idx = str2num(fileName(2:3))*100+str2num(fileName(5:6));
    if sum(testSet==idx)>0
        test = 1;
    else
        test=0;
    end
    idxCode = [find(Char == fileName(7)),find(char == fileName(8))];
    Records = Label(find(Label(:,1)==idx&Label(:,2)==idxCode(1)&Label(:,3)==idxCode(2)),:);
    predLocal = zeros(size(Records,1),1);
    imageOri = imread([OriginPath,fileName(1:8),'.tiff']);
    Proposal = imread([ProposalPath,fileName(1:8),'_Simple Segmentation.png']);
    Proposal = Proposal ==2;
    GTimage = zeros(size(imageOri,1),size(imageOri,2),2);
    
    Records = round(Records);
    for j = 1:size(Records,1)
        GTimage(Records(j,5),Records(j,4),1) = j;
        GTimage(Records(j,5),Records(j,4),2) = find(ScoreCode==Records(j,6));
    end
    
    GTimage = imdilate(GTimage,SE);
    
    predImageOri = imread([ResultPath,fileName]);
    predImageOri = imresize(predImageOri,interval);
    predImageOri = predImageOri(1:size(GTimage,1),1:size(GTimage,2));
    predImage = double(predImageOri>threshold);
    
    PropLabel = bwlabel(Proposal);
    tempIdx = unique(PropLabel.*predImage);
    tempIdx = tempIdx(tempIdx~=0);
    
    predImage = zeros(size(predImage));
    predImage(find(ismember(PropLabel,tempIdx))) = 1;
    
    PredTrueIdx = unique(bwlabel(GTimage(:,:,2)>1).*predImage);
    PredTrueIdx = PredTrueIdx(PredTrueIdx~=0);
    
    newMap = zeros(size(predImage));
    for j = 1:size(PredTrueIdx,1)
        newMap(bwlabel(GTimage(:,:,2)>1)==PredTrueIdx(j)) = PredTrueIdx(j);
    end
    
    
    predLocal(PredTrueIdx) = 1;
    RecordsNew = [Records,predLocal,ones(size(Records,1),1)*test];
    
    labelPredImage = bwlabel(predImage);
    Cent = regionprops(labelPredImage,newMap,'Centroid','Area','MaxIntensity');
    Area = [Cent.Area];
    Max = [Cent.MaxIntensity];
    Cent = {Cent.Centroid};
    predIdx = unique(labelPredImage); predIdx = predIdx(predIdx~=0);
    RecodedIdx = unique(labelPredImage.*double(GTimage(:,:,1)>0));
    
    RecodedIdx = RecodedIdx(RecodedIdx~=0);
%     Area()
    PredFalseIdx = setdiff(predIdx,RecodedIdx);
    recordLocal=[];
    if size(PredFalseIdx,2)>0
        for j = PredFalseIdx'
            centLocal = Cent{j};
            numPixel = sum(sum(double((uint8(labelPredImage==j) .* predImageOri)>threshold)));
            recordLocal = [recordLocal;idx,idxCode,centLocal(1),centLocal(2),numPixel];
        end
    end
    RecordsNew = [RecordsNew,zeros(size(RecordsNew,1),1)];
    for j = 1:size(Max,2)
        if Max(j)~=0
            RecordsNew(Max(j),9) = Area(j);
        end
    end
    Prediction = [Prediction;RecordsNew];
    UnrecordedPred = [UnrecordedPred;recordLocal];
end
PredictionFinal = [PredictionFinal,{Prediction}];
UnrecordedPredFinal = [UnrecordedPredFinal,{UnrecordedPred}];
end
save('MitoDNN12_SampleIII1plus_revised_pt5_orilabel.mat','thresholdList','interval','PredictionFinal','UnrecordedPredFinal')