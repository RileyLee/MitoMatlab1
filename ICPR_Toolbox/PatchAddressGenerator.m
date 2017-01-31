function [PathList,Center, ScoreOut] = PatchAddressGenerator(Score,Label,Info, Mode, OriPath)

addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox');
%Mode -- 1.Generating TP   2. Generating FN   3. Generating FP

PathList= cell(0,2);
Center = zeros(0,2);

switch Mode
    case 1
        Idx = find(Score>=0.5&Label>0);
    case 2
        Idx = find(Score<0.5&Label>0);
    case 3
        Idx = find(Score>=0.5&Label==0);
end

Info = Info(Idx,:);

for i = 1:size(Info,1)
    PathList = [PathList;[{Info(i,1)-1},{[OriPath,ICPR_FileNameGenerate(Info(i,1)-1),'.bmp']}]];
    Center = [Center;[round(Info(i,3)+Info(i,5)/2),round(Info(i,4)+Info(i,6)/2)]];
end

ScoreOut = Score(Idx);


