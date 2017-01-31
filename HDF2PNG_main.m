h5Path = 'E:\LeeYuguang\MitosisExtraction\LBP\Seg\';
pngPath = 'E:\LeeYuguang\MitosisExtraction\LBP\Seg\';

List = dir([h5Path,'*.h5']);
List={List.name};


for i = 1:50
    
    name = List{i};
    disp(['Converting File ',name,' ....'])
    InPath = [h5Path,name];
%     OutPath = [pngPath,name(1:6),'True.png'];
%     hdf2png(InPath, OutPath,2);
%     OutPath = [pngPath,name(1:6),'False.png'];
%     hdf2png(InPath, OutPath,1);

    OutPath = [pngPath,name(1:6),'.png'];
%     hdf2pngThresh6D(InPath, OutPath)
    hdf2pngThresh(InPath, OutPath,1);
end