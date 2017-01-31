segPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\newBRseg\Norm\Seg\Map\';
mitosegPath = 'E:\LeeYuguang\MitosisExtraction\NucleiSegmentation\April6_Norm\png\';
outPath = 'E:\LeeYuguang\MitosisExtraction\NucleiSegmentation\April6_Norm\mitoA\';
maskPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\Masks\';
oriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')


for i = 1:50
    Name = ICPR_FileNameGenerate(i-1);
    
    disp(['Processing file ',Name])
    
    seg = imread([segPath,Name,'.png']);
    mitoseg = imread([mitosegPath,Name,'_Probabilities.png']);
    mitoseg = mitoseg(:,size(mitoseg,2)/2+1:end,2);
    
    mask = imread([maskPath,Name,'.png']);
    ori = imread([oriPath,Name,'.jpg']);
    
    labelMap = bwlabel(seg>0);
    Map = labelMap .* double(mitoseg>0);
    
    labels = unique(Map);
    labels = labels(labels~=0);
    
    
    
    newMap = zeros(size(Map,1),size(Map,2),3);
    for j = 1:length(labels)
        newMap(:,:,2) = newMap(:,:,2) + double(labelMap==labels(j))*255;
    end
    
    SE = strel('diamond',2);
    SE1 = strel('diamond',1);
    Map = imerode(newMap(:,:,2)>0,SE1);
    labelMap = bwlabel(Map);
    labelMap = imdilate(labelMap,SE1);
    labelMap = imclose(labelMap,SE);
    labelMap = imfill(labelMap,'holes');
    
    newMap(:,:,2) = uint8(labelMap>0)*255;
    newMap(:,:,3) = mask;
    
%     imshow(newMap>0);
    
    imwrite([ori,newMap],[outPath,Name,'.png']);
    save([outPath,Name,'.mat'],'labelMap')
    
end