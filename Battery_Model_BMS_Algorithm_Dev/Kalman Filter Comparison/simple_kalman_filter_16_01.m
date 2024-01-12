%kalman filter
rng(0);
X2=chi2inv(.99,1);
sigmaW= .1;             % Covariance matrix of process noise
sigmaV= .5;            % Covariance matrix of sensor noise
W_mean= 0;              % white noise uncorrelated and zero mean   
V_mean= 0;              % white noise uncorrelated and zero mean
A=1; B=1; C=1; D=1;     % matrices in state equation and output equation 
maxIter=40;             % total iteration
xtrue=0;                % intial state value
xhat=0;                 % intial state estimation
sigmaX=.5;              % intial state estimation error covariance matrix
u=0;                    % intial value of input
xstore=zeros(length(xtrue),maxIter+1);
xstore(:,1)=xtrue;
xhatstore= zeros(length(xhat),maxIter);
sigmaXstore= zeros((length(xhat))^2,maxIter);
i=1;
ind=[];
for ii=1:maxIter
   
    if(rem(ii,41)) %rem(ii,2)
        xhat=A*xhat+B*u; %in LHS the xhat is prediction in RHS it is last estimate
        sigmaX=A*sigmaX*A'+ sigmaW;  %in LHS the State prediction error covariance in RHS state estimate error covariance
    end
    u=1+randn(1)*sin(ii*pi/2);
    [l,d]= ldl(sigmaW);
    LDL_W=sqrt(d)*l';
    W=W_mean+LDL_W'*randn(length(xtrue));  %creating random process noises with specified covariance and mean
    [l,d]= ldl(sigmaV);
    LDL_V=sqrt(d)*l';
    V=V_mean+LDL_V'*randn(length(C*xtrue));  %creating random sensor noises with specified covariance and mean
    
    ytrue=C*xtrue+D*u+V;      % output equationbased on last true value
    xtrue=A*xtrue+B*u+W;      % state equation  
    
    yhat=C*xhat+D*u;  %output estimate based on input and state
    
    % calculating kalman gain
    sigmaY= C*sigmaX*C'+ sigmaV;
    L=sigmaX*C'/sigmaY;
    e2= (ytrue-yhat)'/sigmaY*(ytrue-yhat);
    if e2>X2
        ind=[ind;ii];
        i=i+1;
    end
    if(rem(ii,41)) %rem(ii,2)
        xhat=xhat+L*(ytrue-yhat); % updating state estimation
        sigmaX=sigmaX-L*sigmaY*L'; % updating state error estimation
    end
    xstore(:,ii+1)=xtrue;
    xhatstore(:,ii)=xhat;
    sigmaXstore(:,ii)=sigmaX(:);
end

figure(3);
subplot(2,1,1);
plot(0:maxIter-1,xstore(1:maxIter)','k-',0:maxIter-1,xhatstore','b--',...
    0:maxIter-1,xhatstore'+3*sqrt(sigmaXstore)','m-.',0:maxIter-1,xhatstore'-3*sqrt(sigmaXstore)','m-.');
grid on;
legend('true','estimate','bounds');
title('Kalman Filter example');
xlabel('Iteration');
ylabel('state');


subplot(2,1,2);
plot(0:maxIter-1,(xstore(1:maxIter))'-xhatstore','k-',...
    0:maxIter-1,3*sqrt(sigmaXstore)','r-.',0:maxIter-1,-3*sqrt(sigmaXstore)','r-.');
grid;
legend('Error','Error Bounds');
title('error with bounds');
xlabel('Iteration');
ylabel('Estimation Error');

err=xstore(1:maxIter)'-xhatstore';
rmserr=sqrt(mean(err.^2));
fprintf('The rms error for the system is %.3f \n',rmserr);
