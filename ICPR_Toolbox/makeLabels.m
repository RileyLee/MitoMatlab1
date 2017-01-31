close all
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox\');

segPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\SegmentedImage\SampleMorph2_1201\BR_PNG\';
mitoMapPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM\';

outPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\SegmentedImage\SampleMorph2_1201\Temp\';

for i = 1:50
    Name = ICPR_FileNameGenerate(i-1);
    oriIM = imread([Image_map,Name,'.jpg']);
    mapBR = imread([BR_Map,Name,'_Probabilities.png']);
    mapBR = mapBR(:,(size(mapBR,2)/2+1):end,:);
    mapBR = double(mapBR(:,:,2))/255;

    mapOri = Out_lb;
    segBR = mapBR > 0.6;
    segOri = Out_lb > 0;
    
    GT = (oriIM(:,:,1)>200) .* (oriIM(:,:,2)>200) .* (oriIM(:,:,3)<50);
    
    Image = uint8(zeros(size(mapBR,1),size(mapBR,2),3));
    Image(:,:,1) = uint8(segBR) * 255;
    Image(:,:,2) = uint8(segOri) * 255;
    Image(:,:,3) = uint8(GT) * 255;
    
    imwrite(Image,[outPath,Name,'.png'])
%     Image(:,:,1) = uint8(segBR) * 255;
    
    
end