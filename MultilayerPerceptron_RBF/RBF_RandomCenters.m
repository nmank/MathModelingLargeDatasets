T = 10; %define time lag T
iteration = 10;
for iteration=1:100
Nc = iteration; %define number of centers Nc
%alpha = 2; %defin alpha for RBF must be bigger than 0

%import data
data = load('FoCOwxSept.mat');
X = data.Temp;
n = size(X);

%create time lagged data using T
for i=1+2*T:n
    Z(:,i-2*T) = [X(i); X(i-T); X(i-2*T)];
end

%number of time lagged data points is p
p = length(Z);
%training data Ptr, validation data Pv, test data sizes Pts
% Ptr= floor((p-500)/2); %as half
% Pv=p-500-Ptr; %as half
Ptr= 614*4; %as half
Pv=p-500-Ptr; %as half
Pts=500; %prescribed in problem
Z = Z'; %make the data tall

%choose centers
%randomly
C = datasample(Z,Nc,'Replace',false);
%lgb Clustering
%Centers = LGB(Z(1:Ptr,:),Nc,Ptr); 
[E(iteration,1),w] = trRBF(X,Z,Ptr,Nc,C,T);
E(iteration,2) = valRBF(X,Z,Ptr,Pv,Nc,C,w,T);

%clean up
clearvars -except E iteration T
end

plot(E(:,1))
title('Error of Training Set')
xlabel('Number of Centers') % x-axis label
ylabel('Error') % y-axis label

plot(E(:,2))
title('Error of Validation Set')
xlabel('Number of Centers') % x-axis label
ylabel('Error') % y-axis label

%training
function [E,w,Pv] = trRBF(X,Z,Ptr,Nc,C,T)
%TRAINING
%Construct Phi
for i=1:Ptr
    for j=1:Nc+1
        if j==1
           Phi(i,j) = 1;
        else
            Phi(i,j) = phi(norm(Z(i,:) - C(j-1,:)));
        end
    end
end

%do svd on Phi
[U,Sigma,V] = svd(Phi);

%find W using trainig set
for i=1:Ptr
    y(i,1) = X(i+T);
end

%find w
w = V*pinv(Sigma)*U'*y;

%compute training error
for i=1:Ptr
    for j=1:Nc+1
        if j==1
           PhiV(i,j) = 1;
        else
            PhiV(i,j) = phi(norm(Z(i,:) - C(j-1,:)));
        end
    end
end

%compute ybar
ybarV = PhiV*w;

%find validation Y
yV = X(1+T:Ptr+T);

%compute error
E = (norm(yV - ybarV)^2)/(norm(yV'-mean(Z(1:Ptr))*ones(1,Ptr)))
end

%validation
function E = valRBF(X,Z,Ptr,Pv,Nc,C,w,T)
%VALIDATION
%Construct Phi
for i=Ptr+1:Ptr+Pv
    for j=1:Nc+1
        if j==1
           PhiV(i-Ptr,j) = 1;
        else
            PhiV(i-Ptr,j) = phi(norm(Z(i,:) - C(j-1,:)));
        end
    end
end

%compute ybar
ybarV = PhiV*w;

%find validation Y
yV = X(Ptr+1+T:Ptr+Pv+T);

%compute error
E = (norm(yV - ybarV)^2)/(norm(yV'-mean(Z(Ptr+1:Ptr+Pv))*ones(1,Pv)))
end

%define the RBF
function y = phi(r)
y=r; %identity
%y = exp(-r^2/alpha^2) %exponential
%y = r^2 * ln(r) %natural log
%y = r^3 %cubic
end
