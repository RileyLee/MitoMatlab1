%%
% Generating LBP Map for R, B, BR bands

oriPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12_IM\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\FeatExtract\efficientLBP')
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')
outPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr_LBP\';

% Filter Info (3*3 filters)
nFiltSize=8;
nFiltRadius=1;
filtR=generateRadialFilterLBP(nFiltSize, nFiltRadius);

for file = 1:50
    Image = imread([oriPath,ICPR_FileNameGenerate(file-1),'.bmp']);
    BR = BandConversionBR(Image,0);
    R = Image(:,:,1);
    B = Image(:,:,3);
    
    effLBPR = efficientLBP(R, 'filtR', filtR, 'isRotInv', false, 'isChanWiseRot', false);
    effLBPB = efficientLBP(B, 'filtR', filtR, 'isRotInv', false, 'isChanWiseRot', false);
    effLBPBR = efficientLBP(BR, 'filtR', filtR, 'isRotInv', false, 'isChanWiseRot', false);
    
    LBPMap = zeros(size(effLBPR,1),size(effLBPR,2),3);
    LBPMap = uint8(LBPMap);
    LBPMap(:,:,1) = effLBPR;
    LBPMap(:,:,2) = effLBPB;
    LBPMap(:,:,3) = effLBPBR;
    
    imwrite(LBPMap,[outPath,ICPR_FileNameGenerate(file-1),'.png'])
end