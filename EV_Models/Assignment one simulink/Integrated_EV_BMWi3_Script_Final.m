%% Test Data
%Vehicle Parameters
clearvars -except Results;
WOT=0;
vehicle.Mv=1500;            %Mass of vehicle in kg
vehicle.fr=0.015;           %Rolling resistance coefficient
vehicle.Cd=0.3;             %Coefficient of drag
vehicle.Af=1.8;             %Frontal area in m^2
vehicle.r=0.35;             %Radius of wheel in m
vehicle.Gr=9.7;             %Gear ratio
% delta=1.097;        
% m_eq=delta*Mv;
 
g=9.81;             %Gravitational constant (m/s^2)
rho=1.2;            %Air density kg/m^3
Grade=0;            %grage is taken 0% by default

%Motor Parameters
Motor.J=1.7;              %Moment of inertia of vehicle
Motor.b=0.0001;           %Damping coefficient (Nm/m/s)
Motor.ke=0.33;            %Back emf constant V/rad/s
Motor.kt=0.33;            %Torque constant Nm/A
Motor.R=0.55;            %Resistance ohms
Motor.L=9e-5;             %Inductance (H)

%Battery parameters
Battery.Vnom=360;      %Battery normalized voltage
Battery.Qmax=120;           %Battery capacity
Battery.Initial_SOC=1;      %Inital SOC at time of start
%Voltage vs SOC lookup table data
Battery.SOC=0:.1:1;
Battery.normalized_voltage=[0; 0.35; 0.8; 0.95; 1; 1.02; 1.06; 1.09; 1.12; 1.15; 1.18];

%Brake Parameters
Brake.BF_max=3000;        %Maximum Brake Force (N)  
Brake.Regen_eff=1;        %Regen efficiency (regen monitor)

%DC-DC converter Parameters
DCDC.Conv_eff=0.8;       %DC-DC Coneverter efficiency

%PI Controller
PID.kp=0.3;             %Tuned proportional
PID.ki=0.05;            %Tuned integral
PID.kd=0;               %Tuned differential

%%
in=input(' 1->US06 cycle\n 2->US06 range\n 3->UDDS cycle\n 4->UDDS range\n 5->WLTP3 cycle\n 6->WLTP3 range\n 7->HWFET cycle\n 8->HWFET range\n 9->NYCC cycle\n 10->NYCC range\n 11->Wide Open Throttle\n'); 
switch (in)
    %US06 for PID      
    case 1
        load US06;
        Gain=1;
        drivecycle='US06';
    %US06 for Range
    case 2 
        load US06;
        US=cyc_mph;
        US_loop=US;
        for n=1:1:40
            US_loop=[US_loop;US(:,1)+601*n,US(:,2)];
        end
        cyc_mph=US_loop;
        Gain=1;
        drivecycle='US06';
    %UDDS for PID 
    case 3
        load UDDS;
        Gain=1;
        drivecycle='UDDS';
    %UDDS for Range
    case 4
        load UDDS;
        UDDS=cyc_mph;
        UDDS_loop=UDDS;
        for n=1:1:40
            UDDS_loop=[UDDS_loop;UDDS(:,1)+1370*n,UDDS(:,2)];
        end
        cyc_mph=UDDS_loop;
        Gain=1;
        drivecycle='UDDS';
    %WLTP3 for PID 
    case 5
        load WLTP3;
        Gain=1*0.621371;
        drivecycle='WLTP3';
    %WLTP3 for Range
    case 6
        load WLTP3;
        WLTP3=cyc_mph;
        WLTP3_loop=WLTP3;
        for n=1:1:40
            WLTP3_loop=[WLTP3_loop;WLTP3(:,1)+1800*n,WLTP3(:,2)];
        end
        cyc_mph=WLTP3_loop;
        Gain=1*0.621371;
        drivecycle='WLTP3';
    %HWFET for PID 
    case 7
        load HWFET;
        Gain=1;
        drivecycle='HWFET';
    %HWFET for Range
    case 8
        load HWFET;
        HWFET=cyc_mph;
        HWFET_loop=HWFET;
        for n=1:1:40
            HWFET_loop=[HWFET_loop;HWFET(:,1)+766*n,HWFET(:,2)];
        end
        cyc_mph=HWFET_loop;
        Gain=1;
        drivecycle='HWFET';
    %NYCC for PID 
    case 9
        load NYCC;
        Gain=1;
        drivecycle='NYCC';
    %NYCC for Range 
    case 10
        load NYCC;
        NYCC=cyc_mph;
        NYCC_loop=NYCC;
         for n=1:1:80
            NYCC_loop=[NYCC_loop;NYCC(:,1)+599*n,NYCC(:,2)];
        end
        cyc_mph=NYCC_loop;
        Gain=1;
        drivecycle='NYCC';
    case 11
        WOT=1;
        cyc_mph=zeros(50,2);
        drivecycle='WOT';
end
%The script itself calls the model and runs it. Make sure to save the
%script in the same folder as model
simtime=cyc_mph(:,1);
Time = length(simtime);
cyc_mps=0.44704*cyc_mph(:,2);
sim('Simulink_model_Assignment.slx');
%% returning values
Velocity=ans.Velocity;
SOC=ans.SOC;

if~(rem(in,2))
    Range=ans.Distance(end);
    fprintf('Range of the vehicle in %s drivecycle is %.3f\n',drivecycle,Range);
    Results.range.(sprintf('%s',drivecycle))= Range;
elseif in==11   
    Acceleration=ans.acc;
    temp=find(Velocity>100);
    t_min=ans.tout(temp(1));
    fprintf('Maximum Acceleration of the vehicle in %s condition is %.3f m/s \n',drivecycle,max(Acceleration));
    fprintf('The minimum time to reach 100km/hr velocity is %d sec \n',t_min);
    Results.max_acc= max(Acceleration);
    Results.kmph100_time= t_min;
else
    RMSerr=sqrt(mean((ans.error).^2));
    fprintf('Root mean squared error for PID performance for %s drivecycle is %.3f\n',drivecycle,RMSerr);
    Results.rmserr.(sprintf('%s',drivecycle))= RMSerr;
end






