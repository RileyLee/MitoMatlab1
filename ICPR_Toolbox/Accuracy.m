Path = 'E:\LeeYuguang\MitosisExtraction\MitoOnlyPixel_0202\';
% load('E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12\Supplimentary\EvaListIII.mat')
addpath('E:\LeeYuguang\MitosisExtraction\Toolbox\ICPR_Toolbox\')

TestNo = [1,9,15,17,20,21,22,24,28,31,32,35,44,48,50];
% TestNo = [1,9,15,17,20,21,22,24,28,31,32,35,48,50];

% List = ['A00_01';'A00_08';'A01_04';'A01_06';'A01_09';'A02_00';'A02_01';'A02_03';...
%     'A02_07';'A03_00';'A03_01';'A03_04';'A04_03';'A04_07';'A04_09';'H00_00';'H00_08';'H01_04';'H01_06';...
%     'H01_09';'H02_00';'H02_01';'H02_03';'H02_07';'H03_00';'H03_01';'H03_04';'H04_03';'H04_07';'H04_09'];
%  list = char(0);
% 
% File = dir(Path);
% File = File(3:end);
% 
Conf = zeros(2,2);
for i = 1:50
    if sum(i == TestNo) == 1
%        Name = [ICPR_FileNameGenerate(i-1),'_SampleII_DNNBothAve_pt5.mat'];
%         Name = [ICPR_FileNameGenerate(i-1),'_SampleII2_DNN12Ave.mat'];
#        load([Path,Name]);
        Acc = ConfMat;
        Conf = Conf + Acc;
    end
end

Precision = Conf(1,1) / (Conf(1,1)+Conf(1,2));
Recall = Conf(1,1) / (Conf(1,1)+Conf(2,1));
F1 = 2 * Precision * Recall / (Precision + Recall);
