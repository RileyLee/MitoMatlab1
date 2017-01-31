function hdf2pngThresh(InPath, OutPath, FeatIdx)

h5Info = hdf5info(InPath);
ProbMap = hdf5read(h5Info.GroupHierarchy.Datasets(1));
ProbMap = permute(ProbMap,[2,3,1]);
ProbMap = uint8(ProbMap(:,:,FeatIdx) * 255);

imwrite(ProbMap,OutPath)