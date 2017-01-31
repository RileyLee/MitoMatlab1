% This code just simply run the SVM on the example data set "heart_scale",
% which is scaled properly. The code divides the data into 2 parts
% train: 1 to 200
% test: 201:270
% Then plot the results vs their true class. In order to visualize the high
% dimensional data, we apply MDS to the 13D data and reduce the dimension
% to 2D

clear
clc
close all

% addpath to the libsvm toolbox
addpath('C:\Program Files\libsvm-3.20\matlab');

% addpath to the data
dirData = 'C:\Program Files\libsvm-3.20'; 
addpath(dirData);

DataPath = 'C:\Users\ylee3\Desktop\training_proc20k.csv';

test_Path = 'E:\LeeYuguang\M_Cells\PreliminaryResults\Morpho_ICPR\MorphTask\Results\FinalResults\testing_proc.csv';

data = csvread( DataPath ,1 ,0 );
test  = csvread(test_Path);
trainLabel = data(1:end,1);
trainData = data(1:end,2:end);
testLabel = test(1:end,1);
testData = test(1:end,2:end);

% read the data set
% [heart_scale_label, heart_scale_inst] = libsvmread(fullfile(dirData,'heart_scale'));
[N D] = size(trainData);

% Determine the train and test index
trainLabel(find(trainLabel==0)) = -1;
testLabel(find(testLabel==0)) = -1;


% Train the SVM
model = svmtrain(trainLabel, trainData, '-c 1 -t 1 -g 0.07 -b 1 -w1 50 -w-1 1');
% Use the SVM model to classify the data
[predict_label, accuracy, prob_values] = svmpredict(testLabel, testData, model, '-b 1'); % run the SVM model on the test data

