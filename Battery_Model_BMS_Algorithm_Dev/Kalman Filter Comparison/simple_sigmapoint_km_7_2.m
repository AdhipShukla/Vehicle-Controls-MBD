% Example equations
%State Equation for this model- x(k+1)=x(k)^(3/4)+u(k)+w(k)
%Output equation for this model- y(k)=(x(k)+2)^2+x(k)*u(k)+v(k)
clear;
rng(2);
nx=1; %state vector
n_aug=3; %Augment state vector
ny=1; %output vector

h=sqrt(3); %central difference kalman filter
G=h;  %gamma
alpham(1)=(h^2-n_aug)/h^2;
alpham(2)=1/2/h^2;
alphac=alpham;
alpha_m=[alpham(1) repmat(alpham(2),[1 2*n_aug])]';

%intializing values
sigmaW=.1;
sigmaV=.5;
W_mean= 0;              % white noise uncorrelated and zero mean   
V_mean= .5;              % white noise uncorrelated and zero mean
maxIter=40;
xtrue=3+randn(1);
xhat=3;
sigmaX=.5;
xstore=zeros(maxIter+1,length(xtrue));
xstore(1,:)=xtrue;
xhatstore=zeros(maxIter,length(xhat));
sigmaXstore=zeros(maxIter,length(sigmaX)^2);
u=0;
%Main iterations
for k=1:maxIter
    % state prediction step
    xhat_aug=[xhat;0;0]; %considering mean of noises to be zero
    sigmaX_aug=blkdiag(sigmaX,sigmaW,sigmaV);
    l_sigmaX_aug=chol(sigmaX_aug,'lower');
    
    X=xhat_aug(:,ones([1 2*n_aug+1]))+ G*[zeros([n_aug 1]), l_sigmaX_aug, -l_sigmaX_aug]; % Sigma points
    
    X_sta=X(1,:).^(3/4)+u(:,ones([1 2*n_aug+1]))+X(2,:); %calculating state at sigma points
    xhat=X_sta*alpha_m;%weighted mean
    
    u=1+randn(1)*sin(k*pi/2);
    
    % state covariance update equation
    X_til=X_sta-xhat(:,ones([1 2*n_aug+1]));
    sigmaX=X_til*diag(alpha_m)*X_til'; %weighted covariance
    
    %calculating noises in the system
    w=W_mean+chol(sigmaW)'*randn(1);
    v=V_mean+chol(sigmaV)'*randn(1);
    
    %calculating true values
    
    ytrue=(xtrue+2)^2+xtrue*u+v;
    %ytrue=xtrue^3+v; % output base on current state
    xtrue=xtrue^(3/4)+u+w;
    %xtrue=sqrt(5+xtrue)+w+u; % next state based on current state and input
    
    % Y estimate based on x prediction
    Y=(X_sta+2).^2+X_sta*u+ X(end,:);
    yhat=Y*alpha_m; %weighted mean
    
    %calculating kalman gain
    Y_til= Y- yhat*ones([1 2*n_aug+1]);
    sigmaXY=X_til *diag(alpha_m)*Y_til'; 
    sigmaY=Y_til *diag(alpha_m)*Y_til';
    L=sigmaXY/sigmaY;
    
    %estimating x and sigmaX
    
    xhat= xhat + L*(ytrue-yhat);
    %xhat=max(-1,xhat); % so that square root remains positive
    
    sigmaX=sigmaX - L*sigmaY*L';
    
    %higum method for robustness
    [~,S,V]=svd(sigmaX);
    HH=V*S*V';
    sigmaX=(sigmaX+sigmaX'+HH+HH')/4;
    
    %storing the info
    xstore(k+1,:)=xtrue;
    xhatstore(k,:)=xhat;
    sigmaXstore(k,:)=(sigmaX(:))';
      
end
figure(2)
subplot(2,1,1);
grid on;
plot(0:maxIter-1,xstore(1:maxIter),'k-',0:maxIter-1,xhatstore,'b--',...
    0:maxIter-1,xhatstore+3*sqrt(sigmaXstore),'m-.',0:maxIter-1,xhatstore-3*sqrt(sigmaXstore),'m-.');
legend('true','estimate','bounds');
title('Sigma-point kalman filter');
xlabel('Iteration');
ylabel('State');


subplot(2,1,2);
plot(0:maxIter-1,xstore(1:maxIter)-xhatstore,'k-',0:maxIter-1,...
    3*sqrt(sigmaXstore),'r--',0:maxIter-1,-3*sqrt(sigmaXstore),'r--');
grid on;
legend('Error','bounds');
title('SPKF error with bounds');
xlabel('Iteration');
ylabel('Estimation Error');

err=xstore(1:maxIter)-xhatstore;
rmserr=sqrt(mean(err.^2));
fprintf('The rms error for the system is %.3f \n',rmserr);
