clear;
clc;
close all;

%% taking drivecycle data from excel file
drivecycle={'US06','NYCC','HWFET','UDDS','WLTP3'};

for ii=1:length(drivecycle)
fprintf('loading data for %s \n', drivecycle{ii});    
cyc_mph=xlsread('Drivecycle',ii);
save(sprintf('%s',drivecycle{ii}),'cyc_mph')
end
clear;
