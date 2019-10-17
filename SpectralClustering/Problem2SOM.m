%initialize data array
X = [0.34 0.12 0.73 0.97 0.07 0.56]; %switch .07 with .27

p = length(X);

%Initialize centers
nCenters = 6;
C = rand(1,nCenters);

%Initialize index set
A = [1;2;3;4;5;6];

%Initialize distance matrix
%Using clock metric
for i=1:nCenters
    for j=1:nCenters
            D(i,j) = min(mod(A(i)-A(j),6),mod(A(j)-A(i),6));
    end
end

%Using euclidean metric
% for i=1:nCenters
%     for j=1:nCenters
%             D(i,j) = abs(A(i)-A(j));
%     end
% end

T = 10000; %total number of times running algorithm
alpha = .9;

%initialize R (and epsilon = r)
for n = 1:T-1
    epsilon(n) = .9*(1-n/T);
end

for n = 1:T-1
    
    for mu=1:p
        
        %distances between centers and data point
        for k = 1:nCenters
            dist(k) = abs(C(k)-X(mu));
        end 
        
        %Determine the winning center
        %by finding the winning indices
        [M,j] = min(dist);
        
        %update centers
        for i = 1:nCenters
            h= exp(-D(i,j)^2/((alpha*epsilon(n))^2));
            C(i) = C(i)+ epsilon(n)*h*(X(mu)-C(i));
        end
        
    end
    
end


%c1 should be smallest or largest data point, c2 should be the next largest
%or next smallest respectively

scatter(1:6,X)
hold
scatter(1:6,C)
title('SOM Result Using The Clock Metrix')
xlabel('coordinate')
ylabel('value')

%checking h:
% alpha=.9;
% for i=1:100
% Y(i) = exp(-1/(alpha*(1-i/100)^2));
% end
% plot(Y(:))


