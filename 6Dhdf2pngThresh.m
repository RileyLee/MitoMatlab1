function 6Dhdf2pngThresh(InPath, OutPath)

h5Info = hdf5info(InPath);



ProbMap = hdf5read(h5Info.GroupHierarchy.Datasets(1));

Map1 = ProbMap(1,:,:,:);
Map1 = permute(Map1,[2,3,4,1]);
Map2 = ProbMap(2,:,:,:);
Map2 = permute(Map2,[2,3,4,1]);

finalMap = uint8(Map1>127) .* uint8(Map2>127);
imwrite(ProbMap,OutPath)