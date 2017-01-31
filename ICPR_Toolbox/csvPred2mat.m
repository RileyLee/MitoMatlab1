labelPath = 'E:\LeeYuguang\MitosisExtraction\MitoOnlyPixel_0202\finalMap_setF\ShapeLabel\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox');

testPred = csvread('E:\LeeYuguang\MitosisExtraction\PreliminaryResults\SegmentedImage\SampleMorph2_1201\Prediction\TrainsetFPlus_TestsetF.csv');
trainPred = csvread('E:\LeeYuguang\MitosisExtraction\MitoOnlyPixel_0202\finalMap_setA\Prediction\setATrain.csv');

outPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\SegmentedImage\SampleMorph2_1201\Prediction\mat\sefF(setF)\';


TestNo = [1,9,15,17,20,21,22,24,28,31,32,35,44,48,50];

for i = [1:50]
    Path = [labelPath,ICPR_FileNameGenerate(i-1),'.mat'];
    load(Path);
    label = cell2mat(labelInfo(:,1));
    
    
    if sum(TestNo == i) > 0
        pred =  testPred(1:length(label),:);
        testPred = testPred(length(label)+1:end,:);
        save([outPath,ICPR_FileNameGenerate(i-1),'.mat'],'pred')
    else
%         pred =  trainPred(1:length(label),:);
%         trainPred = trainPred(length(label)+1:end,:);
    end
    
%     save([outPath,ICPR_FileNameGenerate(i-1),'.mat'],'pred')
    
end