%description of the data: M(i,j) = attribute i, animal j   
%i=1:13

%j=1:16
%Dove 	 
%Hen 	 
%Duck 	 
%Goose 	 
%Owl 	 
%Hawk 	 
%Eagle 	 
%Fox 	 
%Dog 	 
%Wolf 	 
%Cat 	 
%Tiger 	 
%Lion 	 
%Horse 	 
%Zebra 	 
%Cow

%rows: 
%small size
%medium size
%large size
%2 legs
%4 legs
%hair
%hooves
%mane
%feathers
%hunts
%runs
%flys
%swims

%the number one indicates that animal j possesses attribute i and zero indicates it does not.

X = [1 	1 	1 	1 	1 	1 	0 	0 	0 	0 	1 	0 	0 	0 	0 	0;
0 	0 	0 	0 	0 	0 	1 	1 	1 	1 	0 	0 	0 	0 	0 	0;
0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	1 	1 	1 	1 	1;
1 	1 	1 	1 	1 	1 	1 	0 	0 	0 	0 	0 	0 	0 	0 	0;
0 	0 	0 	0 	0 	0 	0 	1 	1 	1 	1 	1 	1 	1 	1 	1;
0 	0 	0 	0 	0 	0 	0 	1 	1 	1 	1 	1 	1 	1 	1 	1;
0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	1 	1 	1;
0 	0 	0 	0 	0 	0 	0 	0 	0 	1 	0 	0 	1 	1 	1 	0;
1 	1 	1 	1 	1 	1 	1 	0 	0 	0 	0 	0 	0 	0 	0 	0;
0 	0 	0 	0 	1 	1 	1 	1 	0 	1 	1 	1 	1 	0 	0 	0;
0 	0 	0 	0 	0 	0 	0 	0 	1 	1 	0 	1 	1 	1 	1 	0;
1 	0 	0 	1 	1 	1 	1 	0 	0 	0 	0 	0 	0 	0 	0 	0;
0 	0 	1 	1 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0];

p = length(X);

%Initialize centers
nCenters = 16;
C = rand(13,nCenters),0;

%Initialize index set
A = [1 1; 1 2; 1 3; 1 4; 2 1; 2 2; 2 3; 2 4; 3 1; 3 2; 3 3; 3 4; 4 1; 4 2; 4 3; 4 4;];
A = A';
%Initialize distance matrix
%Using clock metric
% for i=1:nCenters
%     for j=1:nCenters
%             D(i,j) = min(mod(A(i)-A(j),6),mod(A(j)-A(i),6));
%     end
% end

%Using euclidean metric
for i=1:nCenters
    for j=1:nCenters
            D(i,j) = norm(A(:,i)-A(:,j));
    end
end

T = 1000; %total number of times running algorithm
alpha = .9;

%initialize R (and epsilon = r)
for n = 1:T-1
    R(n) = alpha*(1-n/T);
end

for n = 1:T-1
    
    for mu=1:p
        
        %distances between centers and data point
        for k = 1:nCenters
            dist(k) = norm(C(:,k)-X(:,mu));
        end 
        
        %Determine the winning center
        %by finding the winning indices
        [M,j] = min(dist);
        
        %update centers
        for i = 1:nCenters
            h = exp(-D(i,j)^2/(R(n)^2));
            C(:,i) = C(:,i)+ R(n)*h*(X(:,mu)-C(:,i));
        end
        
    end
    
end

%visualize result (map pattern to center to index)
hold

for mu= 1:p
    
    %distances between centers and data point
    for k = 1:nCenters
        dist(k) = norm(C(:,k)-X(:,mu));
    end
    
    %Determine the winning center
    %by finding the winning indices
    [M,j] = min(dist);

    scatter(A(1,j),A(2,j))
    xlim([0 4])
    ylim([0 4])
    if mu ==15
        text(A(1,j)+.17,A(2,j)+.03,num2str(mu),'FontSize', 12)
    elseif mu == 4
        text(A(1,j)+.15,A(2,j)+.03,num2str(mu),'FontSize', 12)
    elseif mu == 7
        text(A(1,j)+.15*2,A(2,j)+.03,num2str(mu),'FontSize', 12)
    elseif mu == 6
        text(A(1,j)+.15,A(2,j)+.03,num2str(mu),'FontSize', 12)
    else
        text(A(1,j)+.03,A(2,j)+.03,num2str(mu),'FontSize', 12)
    end
    drawnow
    %pause(3)
end

