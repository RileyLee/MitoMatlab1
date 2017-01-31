function csvNorm(inTrainPath, inTestPath, outTrainPath, outTestPath)


disp('Importing Data....')
Test = csv2cell(inTestPath,'fromfile');
Train = csv2cell(inTrainPath,'fromfile');

Title = Test(1,:);
featTest = str2double(Test(2:end,2:end));
featTrain = str2double(Train(2:end,2:end));
labelTest = Test(2:end,1);
labelTrain = Train(2:end,1);

disp('Normalizing Data...')

combFeats = [featTest;featTrain];
newFeats = combFeats;
for i = 1:20
    feat = combFeats(:,i);
    feat = (feat - min(feat))/(max(feat)-min(feat));
    newFeats(:,i) = feat;
end

newTestFeats = newFeats(1:length(featTest),:);
newTrainFeats = newFeats(length(featTest)+1:end,:);


disp('Exporting Data...')
DataF = num2cell(newTestFeats);
Final = [Title;[labelTest,DataF]];
ds = cell2dataset(Final);
export(ds,'file',outTestPath,'delimiter',',')


DataF = num2cell(newTrainFeats);
Final = [Title;[labelTrain,DataF]];
ds = cell2dataset(Final);
export(ds,'file',outTrainPath,'delimiter',',')