data = imread('Penguins.jpg');

%unroll the data
X1 = reshape(data,[786432,3]);
X = double(X1');

%number of data points
p = 786432;
%data point dimension
N = 3;
%number of centers m
m = 10;

%initialize centers (randomize)
for i=1:m
    ind = floor(786432*rand);
    C(:,i) = X(:,ind);
end

%initialize error
E = 1000;

iteration=1

%TEST
%hold

while E >=630
%for iteration=1:4
    
    %compute S_i
    
    %find a distance matrix
    for i=1:m
        for n=1:p
            dist(i,n) = norm(minus(X(:,n),C(:,i)));
        end
    end
    
    %calculate the minimum distance
    [M,index] = min(dist);
    
    %find the winning indices
    for i=1:m
        for j=1:p
            comp(i,j) = isequal(i,index(j));
        end
    end
    
    %Si is X(:,find(comp(i,:)));
    
    
    %update centers and calculate i for each S
    %ci = (1/abs(si))sum(x in Si of x)
    for i=1:m
        S = X(:,find(comp(i,:)));
        C(:,i) = (1/length(S(1,:)))*(sum(S,2));
    end    
    
    E = (1/p)*sum(M.*M)
    Error(iteration) = E;
    iteration = iteration+1;
    %repeat until E(x,I) is less than desired tolerance
    
    %TEST
    %visualize the result
%     for i=1:m
%         k= find(comp(i,:));
%         for j=1:N
%             VisRaw(j,k) = C(j,i);
%         end
%     end
%     Vis = uint8(VisRaw);
%     scatter3(Vis(1,:),Vis(2,:),Vis(3,:))
    
end
