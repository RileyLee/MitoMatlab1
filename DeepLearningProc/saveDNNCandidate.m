maskPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\Masks\';
ResultPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ExperimentRedo\SampleII2_Prediction\ProbMap8\DNN12\';
segPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\BR_Segmentation\Orig\';
OutPath = 'E:\LeeYuguang\MitosisExtraction\SuperClassifier\DNN_Candidate\pt';
Model = '_SampleII2_DNN10'
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox\');

FeatsTest = zeros(0,11);
FeatsTrain = zeros(0,11);

TestNo = [1,9,15,17,20,21,22,24,28,31,32,35,44,48,50];
for pt = 5
    PathOut = [OutPath,'5\'];
    mkdir(PathOut)
for i = 1:50
    %Layer Prep
    clear pred;
    Path = [maskPath,ICPR_FileNameGenerate(i-1),'.png'];
    mask1 = imread(Path);
    
    Path = [maskPath,ICPR_FileNameGenerate(i-1),'.mat'];
    load(Path)
    mask = mask .* double(mask1);
    
    for j = 0:7
        Path = [ResultPath,ICPR_FileNameGenerate(i-1),'_DNN12_SampleII2_',num2str(j),'.png'];
        pred(:,:,j+1) = imread(Path);
    end
    
    pred = mean(double(pred),3);
    pred_full = imresize(uint8(pred),10);
    pred_full = pred_full(1:size(mask,1),1:size(mask,2));

    seg = imread([segPath,ICPR_FileNameGenerate(i-1),'_Probabilities.png']);
    seg = seg(:,size(seg,2)/2+1:end,1)>0;
    
    label = bwlabel(seg);

    idx = unique(double(pred_full>pt/10*255).*label);
    idx = idx(2:end);
   
    finalSeg = zeros(size(seg));
    
    for j = idx'
        finalSeg = finalSeg + double(label == j);
    end
    
    imwrite(finalSeg>0,[PathOut,ICPR_FileNameGenerate(i-1),'.png']);
    
    disp([num2str(i), ' out of 50 images done..'])
end
end



