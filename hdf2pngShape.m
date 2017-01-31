function hdf2pngShape(InPath, OutPath, FeatIdx)

h5Info = hdf5info(InPath);
ProbMap = hdf5read(h5Info.GroupHierarchy.Datasets);
ProbMap = permute(ProbMap,[3,4,1,2]);
ProbMap = ProbMap(:,:,:,1);
ProbMap = uint8(ProbMap(:,:,1)==FeatIdx)*255;

imwrite(ProbMap,OutPath)