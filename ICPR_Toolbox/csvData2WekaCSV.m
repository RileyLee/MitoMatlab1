function csvData2WekaCSV(inPath,outPath,ifNorm)

Data = csvread(inPath);
feat = Data(:,2:size(Data,2));
label = Data(:,1);

for i = 2:21
    feat = totalFeats(:,i);
    feat = (feat - min(feat))/(max(feat)-min(feat));
    newFeats(:,i) = feat;
end

newTestFeats = newFeats(1:length(testFeats),:);
newTrainFeats = newFeats(length(testFeats)+1:end,:);


Label = cell(length(label),1);
Label(label==1) = {'Mito'};
Label(label==0) = {'Non'};

Title = cell(1,21);
Title(1) = {'Category'};
for i = 1:20
    Title(i+1) = {['A',num2str(i)]};
end

DataF = num2cell(feat);

Final = [Title;[Label,DataF]];

ds = cell2dataset(Final);
export(ds,'file',outPath,'delimiter',',')
