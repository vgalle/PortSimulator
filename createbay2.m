% function [bays25 indexSimilarType375 indexSimilarType50 indexSimilarType625 indexSimilarType75] =...
function bays25 = createbay2(numRow , numCol , numConfig)
% info25 = 6 containers
% info37.5 = 8 containers
% info50 = 11 containers
% info62.5 = 14 containers
% info75 = 16 containers

numContainer = (numRow-1)*numCol;
bays25 = zeros(numRow,numCol,numConfig);

for s = 1 : numConfig
    randVector = randperm(numContainer);
    temp = zeros(numRow-1,numCol);
    temp(1:end) = randVector;
    bays25 (:,:,s) = [zeros(1,numCol); temp];
end

% for i=1:numConfig
%     % check types for info = 50
%     locs_78(i,:) = find(((bays25(:,:,i) == 7)  + (bays25(:,:,i) == 8))==1);
%    
%     locs_7to11(i,:) = find(((bays25(:,:,i) == 7)  + (bays25(:,:,i) == 8) + ...
%                       (bays25(:,:,i) == 9)  + (bays25(:,:,i) == 10) + (bays25(:,:,i) == 11))==1);
%     
%     locs_7to14(i,:) = find(((bays25(:,:,i) == 7)  + (bays25(:,:,i) == 8) + ...
%                     (bays25(:,:,i) == 9)  + (bays25(:,:,i) == 10) + ...
%                     (bays25(:,:,i) == 11) + (bays25(:,:,i) == 12) +... 
%                     (bays25(:,:,i) == 13) + (bays25(:,:,i) == 14))==1);
%     
%     locs_7to16(i,:) = find(((bays25(:,:,i) == 7)  + (bays25(:,:,i) == 8) + ...
%                      (bays25(:,:,i) == 9)  + (bays25(:,:,i) == 10) + ...
%                      (bays25(:,:,i) == 11) + (bays25(:,:,i) == 12) +... 
%                      (bays25(:,:,i) == 13) + (bays25(:,:,i) == 14) + ...
%                      (bays25(:,:,i) == 15) + (bays25(:,:,i) == 16))==1);
% end
% display('end')
% 

