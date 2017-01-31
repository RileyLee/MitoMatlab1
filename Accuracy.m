Path = 'C:\Users\Sevanilee\Desktop\MitoDNN_Project\ImageFile\ProcAccu\DNN12_B32_Map8\';

% List = ['A00_01';'A00_09';'A01_00';'A01_08';'A02_02';'A03_02';'A04_00';'H00_01';'H00_09';...
%     'H01_08';'H02_02';'H03_05';'H04_00'];
 list = char(0);

File = dir(Path);
File = File(3:end);

Conf = zeros(2,2);
for i = 1:size(File,1)
    if File(i).name(end-2:end) == 'mat'
%         for j = 1:size(List,1)
%             if File(i).name(1:6) == List(j,:)
                load([Path,File(i).name]);
                Acc = ConfMat;
                Conf = Conf + Acc;
%             end
%         end
    end
end

Precision = Conf(1,1) / (Conf(1,1)+Conf(1,2));
Recall = Conf(1,1) / (Conf(1,1)+Conf(2,1));
F1 = 2 * Precision * Recall / (Precision + Recall);
