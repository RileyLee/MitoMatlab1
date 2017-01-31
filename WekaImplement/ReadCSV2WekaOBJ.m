function OBJ = ReadCSV2WekaOBJ(CSVPath, OBJname)

disp('Reading CSV File...')
CellData = csv2cell(CSVPath,'fromfile');
ValueData = csvread(CSVPath,1,1);

disp('Converting Data Format...')
Data = num2cell(ValueData);
Data = [CellData(2:end,1),Data];

disp('Building Weka Object...')
OBJ = matlab2weka(OBJname,CellData(1,1:end),Data,size(CellData,2));

return