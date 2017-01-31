function OutMat = HaraCoFilter(InMat)

temp = InMat(:,:,1); temp(1,:) = 0; temp(:,1) = 0; OutMat(:,:,1) = temp;
temp = InMat(:,:,2); temp(1,:) = 0; temp(:,1) = 0; OutMat(:,:,2) = temp;
temp = InMat(:,:,3); temp(1,:) = 0; temp(:,1) = 0; OutMat(:,:,3) = temp;
temp = InMat(:,:,4); temp(1,:) = 0; temp(:,1) = 0; OutMat(:,:,4) = temp;


return