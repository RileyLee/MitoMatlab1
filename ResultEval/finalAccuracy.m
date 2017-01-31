load('ICPR14_SampleIII1_pt5_orilabel.mat')
PredictionFinal = PredictionFinal{1};
UnrecordedPredFinal = UnrecordedPredFinal{1};
load('ICPR14split.mat')
load('labelsICPR14csv.mat');
%load('E:\LeeYuguang\MitosisExtraction\DeepLearning\ICPR14_FineTune\fixedLabels_ICPR2014.mat')
table = [Label(:,6), PredictionFinal(:,6:9)];

groupID = 4;

TP = sum(table(:,1)>0 & table(:,5)>0);
FP = sum(table(:,1)==0 & table(:,5)>0) + length(UnrecordedPredFinal);
FN = sum(table(:,1)>0.2 & table(:,5)==0);
Prec = TP / (TP + FP);
Recall = TP / (TP + FN);
F_meas = 2 * Prec * Recall / (Prec + Recall);

list = zeros(0,1);
for i=1:length(UnrecordedPredFinal)
    if (sum(UnrecordedPredFinal(i,1)==testSet)>0 & floor(UnrecordedPredFinal(i,1)/100)==groupID)
        list = [list, i];
    end
end

TP1 = sum(floor(Label(testList,1)/100)==groupID & table(testList,1)>0 & table(testList,5)>0);
FP1 = sum(floor(Label(testList,1)/100)==groupID & table(testList,1)==0 & table(testList,5)>0) + length(list);
FN1 = sum(floor(Label(testList,1)/100)==groupID & table(testList,1)>0.2 & table(testList,5)==0);
Prec1 = TP1 / (TP1 + FP1);
Recall1 = TP1 / (TP1 + FN1);
F_meas1 = 2 * Prec1 * Recall1 / (Prec1 + Recall1);

list = zeros(0,1);
for i=1:length(UnrecordedPredFinal)
    if (sum(UnrecordedPredFinal(i,1)==testSet)>0)
        list = [list, i];
    end
end

TP2 = sum(table(testList,1)>0 & table(testList,5)>0);
FP2 = sum(table(testList,1)==0 & table(testList,5)>0) + length(list);
FN2 = sum(table(testList,1)>0.2 & table(testList,5)==0);
Prec2 = TP2 / (TP2 + FP2);
Recall2 = TP2 / (TP2 + FN2);
F_meas2 = 2 * Prec2 * Recall2 / (Prec2 + Recall2);

