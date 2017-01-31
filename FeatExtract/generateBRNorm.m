inPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr_normalized\';
outPath = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\BR_norm\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')


for i = 1:50
    Name = ICPR_FileNameGenerate(i-1);
    Image = imread([inPath,Name,'.png']);
    BR = BandConversionBR(Image,0);
    imwrite(uint8(BR/100*255),[outPath,Name,'.png'])
end