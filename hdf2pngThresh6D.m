function hdf2pngThresh6D(InPath, OutPath)

h5Info = hdf5info(InPath);



ProbMap = hdf5read(h5Info.GroupHierarchy.Datasets(1));

Map1 = ProbMap(1,:,:,:);
Map1 = permute(Map1,[2,3,4,1]);
Map1 = uint8(double(Map1(:,:,1))*255);%>127;
Map2 = ProbMap(1,:,:,:);
Map2 = permute(Map2,[2,3,4,1]);
Map2 = uint8(double(Map2(:,:,2))*255)<127;

finalMap = Map1 .* Map2;
imwrite(uint8(finalMap')*255,OutPath)