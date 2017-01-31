function [ FileName ] = ICPR_FileNameGenerate( FileNo )

FileName = 'A0';
if FileNo >= 50
    FileName = 'H0';
    FileNo = FileNo - 50;
end
Folder = floor(FileNo/10);
FileName = [FileName,num2str(Folder),'_0'];
File = FileNo - Folder *10;
FileName = [FileName,num2str(File)];


end

