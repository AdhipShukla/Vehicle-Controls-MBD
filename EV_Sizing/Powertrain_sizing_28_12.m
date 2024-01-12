clear;

% decalaring data for torque and power calculation
Mv=1666.5;
delta=1.097;     %mass factor of the car
M_eq=delta*Mv;
Gr=10;           %fixed gear ratio
fr=0.015;       %rolling resistyance constant
Cd=0.4;        %Aerodynamics drag
Af=1.53*1.84;           %frontal area
r=.35;%(12*0.0254+(2*0.175*0.55))/2;   % tire size 155/60R15
nu=0.90;         %efficiency
v_wind=0;

%decalaring constants
g=9.81;
rho=1.2;       %air density
grade=0.0;    % 6% grade means 6m rise in every 100 m of horizontal distance

%conversion factors
mph2mps=1.6/3.6;
kmph2mph=1/1.6;
rpm2radps=pi/30;
kmph2mps=1/3.6;

%performace data
v_safe=160*kmph2mps;     %160kmph   
vgrade=60*kmph2mps;      %60kmph           
vacc=100*1.105*kmph2mps;     %100kmph for vrated reduced to 75% increase vacc by 4.5% || for vrated reduced to 65% increase vacc by 10.5% || for vrated reduced to 50% increase vacc by 27.5%
v_rated=100*.65*kmph2mps;  %100kmph      105kmph and 73kmph
t_acc=10;

% calculating torque required at maximum aceeleration on level road
Faero=0.5*Cd*Af*rho*(vacc+v_wind)^2;
Froll=Mv*g*fr*cos(0);
Facc=M_eq*vacc/t_acc;
Fgrade=Mv*g*sin(0);

% calculating net torque 
F_max_acc_wheel=Faero+Froll+Facc+Fgrade;
T_max_acc_wheel=F_max_acc_wheel*r;
T_max_acc_motor=T_max_acc_wheel/(Gr*nu);
T_max=T_max_acc_motor;

% calculating constants
Fte=(Gr/r)*T_max*nu;
Frr=Froll;
Fg=Fgrade;
Fad_const=0.5*Cd*Af*rho;
k2=(Fte-Frr-Fg)/M_eq;      %for constant torque region
k1=(Fad_const)/M_eq;       %for constant torque and constant power region

%run for end loop for 1500 cycle
% Array difination of variables
t=linspace(0,15,151);
v=zeros(1,151);
dT=0.1;            % 0.1 sec time step

for n=1:150
    v(n+1)= v(n)+ dT*(k2-(k1*(v(n)+v_wind)^2));
    if t(n)==10
        QQ=n;
    end
end
T_fac=vacc/v(QQ);
T_max=T_max_acc_motor*T_fac;
fprintf('The torque required from the motor is %d Nm \n', T_max);


% Now calculating power, RPM and optimizing rated speed via simulations in different motor modes
% calculating constants

Fte=(Gr/r)*T_max*nu;
Frr=Mv*g*fr*cos(0);
Fg=Mv*g*sin(0);
Fad_const=0.5*Cd*Af*rho;
k2=(Fte-Frr-Fg)/M_eq;      %for constant torque region
k1=(Fad_const)/M_eq;       %for constant torque and constant power region
k2_cp=(-Frr-Fg)/M_eq;
k3=((Fte*v_rated)/M_eq);   %for contant power region torque calculation


% Array difination of variables
t_ctp=linspace(0,40,401);
v_ctp=zeros(1,401);
N=zeros(1,400);
T=zeros(1,400);
P=zeros(1,400);
a=zeros(1,400);
E=zeros(1,400);
D=zeros(1,400);
dT=0.1;            % 0.1 sec time step

for ii=1:400
    if v_ctp(ii)<v_rated  % constant torque region
        v_ctp(ii+1)=v_ctp(ii)+dT*(k2-(k1*(v_ctp(ii)+v_wind)^2));
        T(ii)=Fte*r/Gr/nu;
        P(ii)=v_ctp(ii)*Fte;
        kk=ii;
%     elseif v_ctp(ii)>=v_safe % natural characteristics region
%         velo_fac=v_ctp(ii)/v_ctp(jj); % factor by which velocity is increasing after constant power mode
%         P(ii)=P(jj)/(velo_fac)^7;
%         v_ctp(ii+1)=v_ctp(ii)+dT*((P(ii)/M_eq/v_ctp(ii))+k2_cp-(k1*(v_ctp(ii)+v_wind)^2));
%         T(ii)=P(ii)/v_ctp(ii)*r/Gr/nu; %torque decresing inversly to the velocity
       
    else  % constant power region
        v_ctp(ii+1)=v_ctp(ii)+dT*((k3/v_ctp(ii))+k2_cp-(k1*(v_ctp(ii)+v_wind)^2));
        P(ii)=P(ii-1);
        T(ii)=(P(ii)/v_ctp(ii))*r/Gr/nu;
        jj=ii;
    end
    
    N(ii)=v_ctp(ii)/r*Gr;
    a(ii)=(v_ctp(ii+1)-v_ctp(ii))/dT;
    P_ctp=[0 P];
    E(ii)=trapz(t_ctp, P_ctp);
    D(ii)=trapz(t_ctp,v_ctp);
    
end

%results
 E_ctp=[0 E]/3600000;
 E_max=E_ctp(jj);
 E_motor=E_ctp*nu;
 N=[0 N];
 N_motor=N/rpm2radps;
 fprintf('The rated motor speed must be %d RPM \n',N_motor(kk));
 fprintf('The no load motor speed must be greater than %d RPM \n',N_motor(jj));
 D_ctp=[0 D];
 a_ctp=[0 a];
 T_motor=[0 T];
 P_motor=T_motor.*N;
 P_motor_kw=P_motor*.001;
 fprintf('The maximum motor power required for this performance is %d kw \n',P_motor_kw(kk));
 fprintf('The energy required for accelerating the vehicle to maximum speed is %d kwhr \n',E_max);
 V_10s=v_ctp(100)
 
%plotting velo
figure(1);
hold on;
plot(t_ctp,v_ctp/kmph2mps);
xlabel('Time(secs)');
ylabel('velocity(kmph)');
title('velocity vs Time');
axis([0 40 0 200]);
grid on;

%plotting distance
figure(2);
hold on;
plot(v_ctp/kmph2mps,D_ctp*.001);
xlabel('velocity(kmph)');
ylabel('Distance(km)');
title('Distance vs Velocity');
axis([0 180 0 1.5]);
grid on;

%plotting acc
figure(3);
hold on;
plot(v_ctp/kmph2mps,a_ctp);
xlabel('velocity(kmph)');
ylabel('acc(mps2)');
title('Acceleration vs Velocity');
axis([0 180 0 3.2]);
grid on;

%plotting motor torque
figure(4);
hold on;
plot(N_motor,T_motor);
xlabel('Angular velocity(RPM)');
ylabel('Torque(Nm)');
title('Torque vs RPM');
axis([0 N_motor(end) 0 160]);
grid on;

%plotting motor power
figure(5);
hold on;
plot(N_motor,P_motor_kw);
xlabel('Angular velocity(RPM)');
ylabel('Power(kilo watt)');
title('Power vs RPM');
axis([0 N_motor(end) 0 120]);
grid on;

%plotting energy
figure(6);
hold on;
plot(v_ctp/kmph2mps,E_motor);
xlabel('Velocity(kmph)');
ylabel('Energy(kwhr)');
title('Energy vs Velocity');
axis([0 185 0 E_motor(end)]);
grid on;

