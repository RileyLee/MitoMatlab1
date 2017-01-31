rootPath = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\ICPR14\mitosis\train\csv\';
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox')


list = rdir([rootPath,'**\*.csv']);
list = {list.name};

Char = ['A','B','C','D'];
char = ['a','b','c','d'];

Label = [];

for i = 1:length(list)
    fullPath = list{i};
    temp = find(fullPath=='\');
    Name = fullPath(temp(end)+1:end);
    try
    Data = csvread(fullPath);
    Idx = str2num(Name(2:3))*100 + str2num(Name(5:6));
    Data = [ones(size(Data,1),1)*Idx,ones(size(Data,1),1)*find(Char==Name(7)),ones(size(Data,1),1)*find(char==Name(8)),Data];
    Label = [Label;Data];
    catch exception
        A = 0;
    end
end