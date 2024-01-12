%% Load model file corresponding to a cell of this type

load('OCV_DYN_FILES/SSG_DYN/SSG_DYN_P25.mat');  %data at 25 deg 
load('SSG_UDDS_2poles_model.mat'); 
T=25;
numpoles=2;
soc     = cell_model.SOC;
OCV1    = cell_model.OCV0;
dZ = soc(2) - soc(1);
dUdZ = diff(OCV1)/dZ;
dOCV0 = ([dUdZ(1) dUdZ] + [dUdZ dUdZ(end)])/2;

soc     = cell_model.SOC;
OCV2    = cell_model.OCVrel;
dZ = soc(2) - soc(1);
dUdZ = diff(OCV2)/dZ;
dOCVrel = ([dUdZ(1) dUdZ] + [dUdZ dUdZ(end)])/2;

cell_model.dOCV0 = dOCV0;
cell_model.dOCVrel = dOCVrel;

%% EKF Simulation
%etaParam = cell_model.etaParam(6);
etaParam = 1;
etaik = DYNData.script1.current; 
etaik(etaik<0)= etaParam*etaik(etaik<0);
Z = 1 - cumsum([0,etaik(1:end-1)])*0.1/(2.8724*3600); 
OCV = OCVfromSOCtemp(Z(:),40,cell_model);
tk = ((1:length(DYNData.script1.current))-1)*0.1;
tk = tk';
%plot(tk,Z);
deltat = tk(2)-tk(1);

% Covariance values
%SigmaX0 = diag([1e-4 1e-6 2e-2]); % uncertainty of initial state for 1 NP
SigmaX0 = diag([1e-4 1e-6 2e-2 2e-2]); % uncertainty of initial state for 2 NP
%SigmaX0 = diag([.01 .01 .01 2e-4 .01]); % uncertainty of initial state for 3 NP
SigmaV = 2.5; % Uncertainty of voltage sensor, output equation
SigmaW = 1; % Uncertainty of current sensor, state equation

% Create ekfData structure and initialize variables using first
% voltage measurement and first temperature measurement
current = DYNData.script1.current(:); % discharge > 0; charge < 0.
voltage = DYNData.script1.voltage(:);
soc = Z';
% Reserve storage for computed results, for plotting
sochat = zeros(size(soc));
socbound = zeros(size(soc));

%ekfData = initEKF(voltage(1),T,SigmaX0,SigmaV,SigmaW,cell_model); %for 1NP
%ekfData = initializeEKF(voltage(1),T,SigmaX0,SigmaV,SigmaW,cell_model); %for 2NP
ekfData = initializeEKF_3NP(voltage(1),T,SigmaX0,SigmaV,SigmaW,cell_model,numpoles); %for 3NP

% Now, enter loop for remainder of time, where we update the SPKF
% once per sample interval
hwait = waitbar(0,'Computing...'); 
for k = 1:length(voltage)
  vk = voltage(k); % "measure" voltage
  ik = current(k); % "measure" current
  Tk = T;          % "measure" temperature
  
  % Update SOC (and other model states)
  %[sochat(k),socbound(k),ekfData] = iterEKF(vk,ik,Tk,deltat,ekfData); %1NP
  %[sochat(k),socbound(k),ekfData] = iterationEKF(vk,ik,Tk,deltat,ekfData); %2NP
  [sochat(k),socbound(k),ekfData] = iterationEKF_3NP(vk,ik,Tk,deltat,ekfData); %3NP
  % update waitbar periodically, but not too often (slow procedure)
  if mod(k,1000)==0
    waitbar(k/length(current),hwait);
  end
end
close(hwait);

%% Plot estimate of SOC
figure(1); clf; plot(tk/60,100*soc,'k',tk/60,100*sochat,'m'); hold on
plot([tk/60; NaN; tk/60],[100*(sochat+socbound); NaN; 100*(sochat-socbound)],'m');
title('SOC estimation using EKF');
xlabel('Time (min)'); ylabel('SOC (%)');
legend('Truth','Estimate','Bounds'); ylim([0 120]); grid on

% Display RMS estimation error to command window
fprintf('RMS SOC estimation error = %g%%\n',sqrt(mean((100*(soc-sochat)).^2)));

% Plot estimation error and bounds
figure(2); clf; plot(tk/60,100*(soc-sochat),'m'); hold on
h = plot([tk/60; NaN; tk/60],[100*socbound; NaN; -100*socbound],'b');
title('SOC estimation errors using EKF');
xlabel('Time (min)'); ylabel('SOC error (%)'); ylim([-6 6]); 
set(gca,'ytick',-6:2:6);
legend('Error','Bounds','location','northwest'); 
grid on

% Display bounds errors to command window
ind = find(abs(soc-sochat)>socbound);
fprintf('Percent of time error outside bounds = %g%%\n',...
        length(ind)/length(soc)*100);