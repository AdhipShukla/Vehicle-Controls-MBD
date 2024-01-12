
% decalaring data for torque and power calculation
Mv=1310;
delta=1.08; %mass factor of the car
m_eq=delta*Mv;
Gr=9; %fixed gear ratio
fr=0.015; %rolling resistyance constant
Cd=0.25; %Aerodynamics drag
Af=2; %frontal area
r=(15*0.0254+(2*0.155*0.6))/2; % tire size 155/60R15
nu=0.9; %efficiency

%decalaring constants
g=9.81;
rho=1.2; %air density
grade=0.06; % 6% grade means 6m rise in every 100 m of horizontal distance

%conversion factors
mph2mps=1.6/3.6;
kmph2mph=1/1.6;
rpm2radps=pi/30;
kmph2mps=1/3.6;

%performace data
vmax=160*kmph2mps;
vgrade=60*kmph2mps;
vacc=100*kmph2mps;
t=12;

% calculating torque required at maximum aceeleration
Faero=0.5*Cd*Af*rho*(vacc)^2;
Froll=Mv*g*fr*cos(0);
Facc=m_eq*vacc/t;
Fgrade=Mv*g*sin(0);

% calculating net torque and power from motor
F_max_acc_wheel=Faero+Froll+Facc+Fgrade;
T_max_acc_wheel=F_max_acc_wheel*r;
T_max_acc_motor=T_max_acc_wheel/(Gr*nu);
n_max_acc_motor=(vacc/r*Gr);
P_max_acc_motor=T_max_acc_motor*n_max_acc_motor;

% calculating torque required at maximum Velocity
Faero=0.5*Cd*Af*rho*(vmax)^2;
Froll=Mv*g*fr*cos(0);
Facc=0;
Fgrade=Mv*g*sin(0);

% calculating net torque and power from motor
F_max_vel_wheel=Faero+Froll+Facc+Fgrade;
T_max_vel_wheel=F_max_vel_wheel*r;
T_max_vel_motor=T_max_vel_wheel/(Gr*nu);
n_max_vel_motor=(vmax/r*Gr);
P_max_vel_motor=T_max_vel_motor*n_max_vel_motor;

% calculating torque required at maximum Gradebality
Faero=0.5*Cd*Af*rho*(vgrade)^2;
Froll=Mv*g*fr*cos(atan(grade));
Facc=0;
Fgrade=Mv*g*sin(atan(grade));

% calculating net torque and power from motor
F_grade_wheel=Faero+Froll+Facc+Fgrade;
T_grade_wheel=F_grade_wheel*r;
T_grade_motor=T_grade_wheel/(Gr*nu);
n_grade_motor=(vgrade/r*Gr);
P_grade_motor=T_grade_motor*n_grade_motor;

%maximum power


%maximum values

[T_max,I_maxT]= max([T_max_acc_motor,T_max_vel_motor,T_grade_motor]);
[n_max,I_maxn]= max([n_max_acc_motor/rpm2radps n_max_vel_motor/rpm2radps n_grade_motor/rpm2radps]);
[P_max,I_maxP]= max([P_max_acc_motor P_max_vel_motor P_grade_motor]);

%results
Tmax_motor=fprintf('Tmax_motor=%d Nm\n',T_max);
nmax_motor=fprintf('nmax_motor=%d rpm\n',n_max);
P_max_kw=P_max*.001;
Pmax_motor=fprintf('Pmax_motor=%d kw\n',P_max_kw);


%Battery sizing

% declaring the known

V_max=124;
V_nom=106;
Range=105;

%running our vehicle model calculate the avg consumption of energy per km
%for WLTP3 cycle
%run('C:\Users\hp\Desktop\Project\skill_Lync\complete_vehicle_simple_forward_reverse_23_12_20.slx');
%Avg=Avg_cons;
Avg=170;
fprintf('Energy consumed per km = %d W-hr/km\n',Avg);
E_total=Avg*Range;

%designong the battery module
cell_Vnom=3.6;
cell_capacity=3.2;
cell_energy= cell_Vnom*cell_capacity;
N_series=V_nom/cell_Vnom;
Energy_series=N_series*cell_energy;
N_parallel=E_total/Energy_series;
capacity_battery=N_parallel*cell_capacity;
Energy_total=capacity_battery*V_nom;
N_total=N_series*N_parallel;

fprintf('Energy of the battery pack= %d W-hr\n',Energy_total);
fprintf('capacity of battery pack= %d A-hr\n',capacity_battery);
fprintf('number of cells = %d \n',N_total);











