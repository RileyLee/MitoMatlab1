function [OBJ, Labels] = ReadMat2WekaOBJ(FeatMatFile, LabelMatFile, TitleCSV)

load(FeatMatFile);
load(LabelMatFile);
Title = csv2cell(TitleCSV,'fromfile');
Title = [Title(2:end),Title(1)];
OBJName = 'TestData';

LabelInfo = cell2mat(LabelInfo(:,1));
Label = cell(length(LabelInfo),1);
Label(find(LabelInfo==0)) = {'Non'};
Label(find(LabelInfo==1)) = {'Mito'};
CellData = [num2cell(HCfeats)];%,Label];
OBJ = matlab2weka(OBJName,Title(1:end-1),CellData,size(CellData,2));

Labels = [num2cell(LabelInfo),Label];

return