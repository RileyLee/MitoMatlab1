maskPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\Masks\';
predPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\SegmentedImage\SampleMorph2_1201\Prediction\mat\sefF(setF)\';
segPath = 'E:\LeeYuguang\MitosisExtraction\MitoOnlyPixel_0202\finalMap_setF\Map\';
outPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\SegmentedImage\SampleMorph2_1201\Prediction\map\sefF(setF)\';
oriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox');

mkdir(outPath)

TestNo = [1,9,15,17,20,21,22,24,28,31,32,35,44,48,50];

for i = [1:50]
    if sum(TestNo==i)>0
    Path = [predPath,ICPR_FileNameGenerate(i-1),'.mat'];
    load(Path);
    pos = find(pred(:,3)>0.5);
    
    Path = [segPath,ICPR_FileNameGenerate(i-1),'.png'];
    seg = imread(Path);
    label = bwlabel(seg(:,:,1)>0);
    
    
    
    Image = uint8(zeros(size(seg,1),size(seg,2),3));
    Image(:,:,3) = seg(:,:,1);
    for j = pos'
        Image(:,:,3) = Image(:,:,3) - uint8(label==j)*255;
        Image(:,:,1) = Image(:,:,1) + uint8(label==j)*255;
    end
    
    
    Path = [maskPath,ICPR_FileNameGenerate(i-1),'.mat'];
    load(Path);
    
%     Image(:,:,3) = Image(:,:,3) - uint8(mask>0)*255;
    Image(:,:,2) = Image(:,:,2) + uint8(mask>0)*255;
    
    Path = [oriPath,ICPR_FileNameGenerate(i-1),'.bmp'];
    oriImage = imread(Path);
    Image = [Image,oriImage];
    
    
    imwrite(Image,[outPath,ICPR_FileNameGenerate(i-1),'.png'])
    end
end
