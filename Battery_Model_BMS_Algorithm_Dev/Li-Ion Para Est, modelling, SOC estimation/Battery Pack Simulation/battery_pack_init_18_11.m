%intializing the battery pack simulation for 48v and 1kwhr battery
% clear;
load('SSGmodel.mat');             %cell model parameters
numpoles=3;
R0=zeros(numpoles,1);
T=40;
rt=.0008;
% cell_model.R0Param=cell_model.R0Param+rt*2;
R0Param = getParamESC('R0Param',T,cell_model);
dt=0.01;
Qgain=1; %26.33;
% simtime=length(DYNData.script1.current)*0.1;
Ns=12;
Np=7;
% out=sim('sim_cell_simulink_12_11.slx');
Z0= 0.75 + (1-0.75).*rand(1,Np);
% Z0=repmat(Z0,Ns,1);
for i1=1:Ns
    Z0(i1,:)=min(1,Z0(1,:)+0.005 + (.05-.005).*rand(1,Np));
end
%% Forward looking model
% e-Treo vehicle specs
M_k= 445; %kg (Kerb Weight)
M_P= 0; %kg (Payload Weight)%550
M=M_k+M_P; %total load
kappa=0.1; %pseudo forces constsnt
Max_P= 8000; %watts
Max_T= 42;   %Nm Motor max trq 
Grade=7;    %Percent
Max_speed= 50*5/18;  %In m/s
Batt_Ene_Cap= 7.37; %kWh
Batt_Cap=Batt_Ene_Cap*1000/48;
Range= 80; %Km
Range_claimed=120; %km
Volt=48;
cd=0.45;
rho=1.225;
g=9.81;
Mot_Eff=.9;
Trans_Eff=.95; 
Batt_Eff=.98; %charging efficiency
Af=1.4*1.6;
mu=0.016;
Re_spe_max= 50*5/18;
Re_spe_min= 0*5/18;
Ini_SOC=100;
Gr=5.75*.85;
R_w=.3048/2;
b=0.002;%.037

%Motor Plot
w_rated = 8000/42; 
w_max = Max_speed/R_w*Gr*1+5;
w_m = linspace(0,w_max,50);
% w_m(16)=400;
T_m=zeros(1,50);
for i = 1: length(w_m) 
 if (w_m(i) <= w_rated) 
     T_m(i) = 42;
     i1=i;
  elseif w_m(i) > Max_speed/R_w*Gr*0.87
      T_m(i) = 8000/w_m(i)^(i/i2);
 else
     T_m(i) = 8000/w_m(i) ;
     i2=i;
 end 
end
w_m(i1)=w_rated;
% w_m(i2+1)=Max_speed/R_w*Gr*0.9;
M_Trq=T_m;
M_w=w_m;
plot(M_w,M_Trq);
V_MIDC=[0;0;15;15;0;0;15;32;32;0;0;15;35;50;50;35;35;0;0;0;15;15;0;0;15;32;32;0;0;15;35;50;50;35;35;0;0;0;15;15;0;0;15;32;32;0;0;15;35;50;50;35;35;0;0;0;15;15;0;0;15;32;32;0;0;15;35;50;50;35;35;0;0;0;15;35;50;70;70;50;50;70;70;90;90;90;90;80;50;0;0];
T_MIDC=[0;11;15;23;28;49;55;61;85;96;117;123;134;143;155;163;178;188;195;206;210;218;223;244;250;256;280;291;312;318;329;338;350;358;373;383;390;401;405;413;418;439;445;451;475;486;507;513;524;533;545;553;568;578;585;596;600;608;613;634;640;646;670;681;702;708;719;728;740;748;763;773;780;800;806;817;827;841;891;899;968;981;1031;1066;1096;1116;1126;1142;1150;1160;1180];
T_MIDC=T_MIDC(1:72);
V_MIDC=V_MIDC(1:72);