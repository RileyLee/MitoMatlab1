clear all

FeatFolder = 'E:\LeeYuguang\MitosisExtraction\PreliminaryResults\Morpho_ICPR\MorphTask\Results\Features\';
EvaListFile = 'E:\LeeYuguang\MitosisExtraction\Original Datasets\icpr12\EvaImageMark.mat';


load(EvaListFile);
[TrainFeats, TestFeats, Stats] = SampleFeatsMergeMat(FeatFolder,EvaImageMark);

csvwrite('TrainFeats.csv',TrainFeats);
csvwrite('TestFeats.csv',TestFeats);
save('MorphStats.mat','Stats')