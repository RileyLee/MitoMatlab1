load('MitoDNNv2_SampleIVplus2_revised_pt5_orilabel.mat')
PredictionFinal = PredictionFinal{1};
UnrecordedPredFinal = UnrecordedPredFinal{1};
load('ICPR14split.mat')
load('labelsICPR14csv.mat');
%load('E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_FineTune\fixedLabels_ICPR2014.mat')
table = [Label(:,6), PredictionFinal(:,6:9)];

groups = [3, 4, 5, 7, 10, 11, 12, 14, 15, 17, 18];

groupID = 3;


    
TP = sum(table(:,1)>0 & table(:,5)>0);
FP = sum(table(:,1)==0 & table(:,5)>0) + length(UnrecordedPredFinal);
FN = sum(table(:,1)>0.2 & table(:,5)==0);
Prec = TP / (TP + FP);
Recall = TP / (TP + FN);
F_meas = 2 * Prec * Recall / (Prec + Recall);

idx = 1;
for groupID = groups
list = zeros(0,1);
for i=1:length(UnrecordedPredFinal)
    if (sum(UnrecordedPredFinal(i,1)==testSet)>0 & floor(UnrecordedPredFinal(i,1)/100)~=groupID)
        list = [list, i];
    end
end


TP_group(idx) = sum(floor(Label(testList,1)/100)~=groupID & table(testList,1)>0 & table(testList,5)>0);
FP_group(idx) = sum(floor(Label(testList,1)/100)~=groupID & table(testList,1)==0 & table(testList,5)>0) + length(list);
FN_group(idx) = sum(floor(Label(testList,1)/100)~=groupID & table(testList,1)>0.2 & table(testList,5)==0);
Prec_group(idx) = TP_group(idx) / (TP_group(idx) + FP_group(idx));
Recall_group(idx) = TP_group(idx) / (TP_group(idx) + FN_group(idx));
F_meas_group(idx) = 2 * Prec_group(idx) * Recall_group(idx) / (Prec_group(idx) + Recall_group(idx));

list = zeros(0,1);
for i=1:length(UnrecordedPredFinal)
    if (sum(UnrecordedPredFinal(i,1)==testSet)>0)
        list = [list, i];
    end
end
idx = idx + 1;
end

TP2 = sum(table(testList,1)>0 & table(testList,5)>0);
FP2 = sum(table(testList,1)==0 & table(testList,5)>0) + length(list);
FN2 = sum(table(testList,1)>0.2 & table(testList,5)==0);
Prec2 = TP2 / (TP2 + FP2);
Recall2 = TP2 / (TP2 + FN2);
F_meas2 = 2 * Prec2 * Recall2 / (Prec2 + Recall2);

