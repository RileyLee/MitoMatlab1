maskPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\Masks\';
ResultPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\ExperimentRedo\SampleII2_Prediction\ProbMap8\DNN12\';
segPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\BR_Segmentation\Orig\';
outPath = 'E:\LeeYuguang\MitosisExtraction\DeepLearning\histPred\';
Model = '_SampleII2_DNN10'
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox\');



TestNo = [1,9,15,17,20,21,22,24,28,31,32,35,44,48,50];
for i = 1:50
    if sum(TestNo==i)>0
        FeatsTest = zeros(0,10);
        idxPos = zeros(0);
        %Layer Prep
        clear pred;
        Path = [maskPath,ICPR_FileNameGenerate(i-1),'.mat'];
        load(Path);
        mask = imerode(mask,[0 1 0;1 1 1;0 1 0]);
        
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
        
        idx = unique(double(pred_full>0).*label);
        idx = idx(2:end);
        
        
        
        finalSeg = zeros(size(seg));
        
        for j = idx'
            patch = pred_full.*uint8(label == j);
            [X,Y] = find(label == j);
            patch = double(patch(min(X):max(X),min(Y):max(Y)))/255;
            feat = hist(patch(:),[0.1:0.1:1]);
            if sum(feat(2:10)>0)
                feat(1) = sum(sum(label == j));
                FeatsTest = [FeatsTest;feat];
                idxPos = [idxPos;j];
            end
        end
        
        pred = predict(Mdl,FeatsTest);
        
        Image = zeros(size(seg));
        for j = find(pred==1)'
            Image = Image + (label==idxPos(j));
        end
        
        imwrite(Image,[outPath,ICPR_FileNameGenerate(i-1),'.png']);
        
        disp([num2str(i), ' out of 50 images done..'])
        
        
        
    end

end