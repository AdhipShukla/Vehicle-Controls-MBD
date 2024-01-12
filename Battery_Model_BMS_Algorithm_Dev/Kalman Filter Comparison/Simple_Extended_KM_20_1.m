%Extended kalman filter
%State Equation for this model- x(k+1)=x(k)^(3/4)+u(k)+w(k)
%Output equation for this model- y(k)=(x(k)+2)^2+x(k)*u(k)+v(k)
rng(2);
X2=chi2inv(.99,1);      %calculating limit for xhir variable with 1 dof
sigmaW= .1;             % Covariance matrix of process noise
sigmaV= .5;             % Covariance matrix of sensor noise
W_mean= 0;              % white noise uncorrelated and zero mean   
V_mean= .5;              % white noise uncorrelated and zero mean
maxIter=40;             % total iteration

xtrue=3+randn(1);                % intial state value
xhat=3;                 % intial state estimation
sigmaX=.5;               % intial state estimation error covariance matrix
u=0;                    % intial value of input

xstore=zeros(maxIter+1,length(xtrue));
xstore(1,:)=xtrue;
xhatstore= zeros(maxIter,length(xhat));
sigmaXstore= zeros(maxIter,(length(xhat))^2);

i=1;
ind=[];
for ii=1:maxIter
    %calculating Ahat=d(x(k))/dx at x=xhat and Bhat d(x(k))/dw 
    Ahat=(3/4)*xhat^(-1/4); Bhat=1;
    G=1;
    if(rem(ii,41)) %rem(ii,2)
        xhat=(xhat)^(3/4)+G*u; %in LHS the xhat is prediction in RHS it is last estimate
        sigmaX=Ahat*sigmaX*Ahat'+ Bhat*sigmaW*Bhat';  %in LHS the State prediction error covariance in RHS state estimate error covariance
    end
    
    u=1+randn(1)*sin(ii*pi/2); %randam input to the system
    
    [l,d]= ldl(sigmaW);
    LDL_W=sqrt(d)*l';
    W=W_mean+LDL_W'*randn(length(xtrue));  %creating random process noises with specified covariance and mean
    [l,d]= ldl(sigmaV);
    LDL_V=sqrt(d)*l';
    V=V_mean+LDL_V'*randn(length(xtrue));  %creating random sensor noises with specified covariance and mean
    
    ytrue=(xtrue+2)^2+xtrue*u+V;      % output equationbased on last true value y(k)=(x(k)+2)^2+x(k)*u(k)+v(k)
    xtrue=xtrue^(3/4)+G*u+W;      % state equation x(k+1)=x(k)^(5/4)+u(k)+w(k) 
    %xtrue=max(xtrue,0);
    % claculating Chat=d(y(k))/dx at x=xhat and Dhat=d(y(k))/dv
    Chat=2*(xhat+2)+u; Dhat=1;
    
    yhat=(xhat+2)^2+xhat*u;  %output estimate based on input and state
    
    % calculating kalman gain
    sigmaY= Chat*sigmaX*Chat'+ Dhat*sigmaV*Dhat';
    L=sigmaX*Chat'/sigmaY;
    e2= (ytrue-yhat)'/sigmaY*(ytrue-yhat);
    if e2>X2  %chi squared
        ind=[ind;ii];
        i=i+1;
    end
    if(rem(ii,41)) %rem(ii,2)
        xhat=xhat+L*(ytrue-yhat); % updating state estimation
        xhat=max(0,xhat);        % Adding roboutness to the model
        
        sigmaX=sigmaX-L*sigmaY*L'; % updating state error estimation
        [~,SH,VH]= svd(sigmaX);    % Using Higam method to make the matrix 
        HH=VH*SH*VH';              % positive semi definite
        sigmaX=(sigmaX+sigmaX'+HH+HH')/4;
    end
    xstore(ii+1,:)=xtrue;
    xhatstore(ii,:)=xhat;
    sigmaXstore(ii,:)=sigmaX(:);
end

figure(1);
subplot(2,1,1);
plot(0:maxIter-1,xstore(1:maxIter)','k-',0:maxIter-1,xhatstore','b--',...
    0:maxIter-1,xhatstore'+3*sqrt(sigmaXstore)','m-.',0:maxIter-1,xhatstore'-3*sqrt(sigmaXstore)','m-.');
legend('true','estimate','bounds');
title('Extended Kalman Filter');
xlabel('Iteration');
ylabel('state');


subplot(2,1,2);
plot(0:maxIter-1,(xstore(1:maxIter))'-xhatstore','k-',...
    0:maxIter-1,3*sqrt(sigmaXstore)','r-.',0:maxIter-1,-3*sqrt(sigmaXstore)','r-.');
grid on;
legend('Error','Error Bounds');
title('EKF error with bounds');
xlabel('Iteration');
ylabel('Estimation Error');

err=xstore(1:maxIter)'-xhatstore';
rmserr=sqrt(mean(err.^2));
fprintf('The rms error for the system is %.3f \n',rmserr);
