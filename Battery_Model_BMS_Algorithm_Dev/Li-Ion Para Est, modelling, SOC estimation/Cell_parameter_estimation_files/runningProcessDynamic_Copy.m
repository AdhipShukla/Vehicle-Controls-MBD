% runningProcessDynamicOCV.m
% Loads data from the OCVDYN lab tests done for several cells at different
% temperatures

clear 
cellIDs = {'SSG', 'LG'};
temps = {[-20 -10 0 10 25 40]...  % SSG
         [-20 -10 0 10 25 40]};   % LG
numpoles = 3; % number of RC pairs in final model
for indID = 1:length(cellIDs)
    cellID = cellIDs{indID};    
  
% Read cell_model OCV file
  cell_modelFile = sprintf('Data_Values/%scell_model-ocv.mat',cellID);
  if ~exist(cell_modelFile,'file')
    error(['File "%s" not found.\n' ...
      'Please change folders so that "%s" points to a valid model '...
      'file and re-run runProcessDynamic.'],cell_modelFile,cell_modelFile); 
  end
 load(cell_modelFile);

for theID = 1:length(cellIDs)


    dirname = cellIDs{theID}; cellID = dirname;
    ind = find(dirname == '_'); 
   if ~isempty(ind), dirname = dirname(1:ind-1); end
   DYNDir = sprintf('%s_DYN',dirname);
   if ~exist(DYNDir,'dir')
    error(['Folder "%s" not found in current folder.\n' ...
      'Please change folders so that "%s" is in the current '...
      'folder and re-run runningProcessDynamic.'],DYNDir,DYNDir);
   end
   
   filetemps = temps{theID}(:);
   numtemps = length(filetemps);
   data = zeros([0 numtemps]);
   
   for k = 1:numtemps
       if filetemps(k) < 0
           DYNPrefix = sprintf('OCV_DYN_FILES/%s/%s_DYN_N%02d.mat',...
            DYNDir,cellID,abs(filetemps(k)));
       else
           DYNPrefix = sprintf('OCV_DYN_FILES/%s/%s_DYN_P%02d.mat',...
               DYNDir,cellID,abs(filetemps(k)));
       end
       
       load(DYNPrefix);
       data(k).temp = filetemps(k);
       data(k).script1 = DYNData.script1;
       data(k).script2 = DYNData.script2;
   end
   cell_model = processDyn(data,cell_model,numpoles,0);
   cell_modelFile = sprintf('%smodel.mat',cellID);
   save(cell_modelFile,'cell_model');
   
  figure(10+indID);
  indTemps = find(temps{theID} == 25);
  [vk,rck,hk,zk,sik,OCV] = simCell(data(indTemps).script1.current,...
    temps{theID}(indTemps),0.1,cell_model,1,zeros(numpoles,1),0);
  tk = (1:length(data(indTemps).script1.current))-1;
  plot(tk,data(indTemps).script1.voltage,tk,vk);
  verr = data(indTemps).script1.voltage - vk';
  v1 = OCVfromSOCtemp(0.95,temps{theID}(indTemps),cell_model);
  v2 = OCVfromSOCtemp(0.05,temps{theID}(indTemps),cell_model);
  N1 = find(data(indTemps).script1.voltage<v1,1,'first'); 
  N2 = find(data(indTemps).script1.voltage<v2,1,'first');
  if isempty(N1), N1=1; end; if isempty(N2), N2=length(verr); end
  rmserr=sqrt(mean(verr(N1:N2).^2));
  fprintf('RMS error of simCell @ 25 degC = %0.2f (mv)\n',rmserr*1000);
   
end
end