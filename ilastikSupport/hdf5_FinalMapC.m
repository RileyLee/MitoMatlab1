%% 
% Feb 15
% Code used to create setC, setD


clear all
BR_segPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\BR_Segmentation\Orig\';
segPath = 'E:\LeeYuguang\MitosisExtraction\MitoOnlyPixel_0202\finalMap_setC\Map\';
outPath = 'E:\LeeYuguang\MitosisExtraction\MitoOnlyPixel_0202\finalMap_setD\Map\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')

totalNum = 0;

mkdir(outPath);

for File = 0:49
    disp (['Processing file ',num2str(File),'...'])
    segBR = imread([BR_segPath,ICPR_FileNameGenerate(File),'_Probabilities.png']);
%     dset = hdf5read(f.GroupHierarchy.Datasets(1));
%     segBR = permute(dset,[2,3,1]);
    segBR = segBR(:,size(segBR,2)/2+1:end,1);
    label = bwlabel(segBR>=127);

    f = hdf5info([segPath,ICPR_FileNameGenerate(File),'_Probabilities.h5']);
    dset = hdf5read(f.GroupHierarchy.Datasets(1));
    prob = permute(dset,[2,3,1]);
    prob = prob(:,:,2);
    seg = uint8(prob>0.6) * 255;
    
    idx = unique(double(seg>0).*label);
    labelSegBR = double(seg>0).*label;
    finalSeg = zeros(size(seg));
    idx = idx(2:end);
    
    Area = regionprops(labelSegBR,'Area');
    Area = [Area.Area];
    
    
    for i = idx'
        if Area(i) > 5
            finalSeg = finalSeg + double(label == i)*255;
        end
    end
    
%     imshow(uint8(finalSeg))
    imwrite(uint8(finalSeg),[outPath,ICPR_FileNameGenerate(File),'.png']);
%     totalNum = totalNum + max(max(bwlabel(finalSeg>5)));
end

totalNum = 0;
for File = 0:49
    IM = imread([outPath,ICPR_FileNameGenerate(File),'.png']);
    num = max(max(bwlabel(IM(:,:,1)>0)));
    totalNum = totalNum + num;
end