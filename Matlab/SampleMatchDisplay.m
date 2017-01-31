function MatchList = SampleMatchDisplay(DirList)

File = cell(0);
for i = 1:length(DirList)
    temp = DirList{i};
    temp = dir(temp);
    temp = temp(3:end);
    temp = {temp.name};
    File = [File;temp];
end

return




