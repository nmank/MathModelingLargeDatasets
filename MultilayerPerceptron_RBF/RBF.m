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


%LGB clustering
%X is data
%m is number of centers
%p is number of data pts
% function C = LGB(X,m,p) 
% 
% 
% %initialize centers
% C = datasample(X,m,'Replace',false);
% 
% C = C';
% X = X';
% 
% E = 1000;
% 
% iteration=1;
% 
% %TEST
% %hold
% 
% while E >=630
% %for iteration=1:4
%     
%     %compute S_i
%     
%     %find a distance matrix
%     for i=1:m
%         for n=1:p
%             dist(i,n) = norm(minus(X(:,n),C(:,i)));
%         end
%     end
%     
%     %calculate the minimum distance
%     [M,index] = min(dist);
%     
%     %find the winning indices
%     for i=1:m
%         for j=1:p
%             comp(i,j) = isequal(i,index(j));
%         end
%     end
%     
%     %Si is X(:,find(comp(i,:)));
%     
%     
%     %update centers and calculate i for each S
%     %ci = (1/abs(si))sum(x in Si of x)
%     for i=1:m
%         S = X(:,find(comp(i,:)));
%         C(:,i) = (1/length(S(1,:)))*(sum(S,2));
%     end    
%     
%     E = (1/p)*sum(M.*M);
%     Error(iteration) = E;
%     iteration = iteration+1;
%     %repeat until E(x,I) is less than desired tolerance
%     
%     %TEST
%     %visualize the result
% %     for i=1:m
% %         k= find(comp(i,:));
% %         for j=1:N
% %             VisRaw(j,k) = C(j,i);
% %         end
% %     end
% %     Vis = uint8(VisRaw);
% %     scatter3(Vis(1,:),Vis(2,:),Vis(3,:))
%     
% end
% 
% end
