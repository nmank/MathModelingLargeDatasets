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

k = 1; %user chooses number of nearest neighbors for NNk


NbrInd = kNN(X,k,p);
[W, ci] = constructW(X,NbrInd,k,p);
M = (eye(p)-W)'*(eye(p)-W); %generate M
[Yt,Lam] = eig(M); %the eigenvector problem (sln to min cost fxn)
Y = Tt' %find Y as transpose





%k nearest neighbors
%input data, p and k
%output a matrix of nearest neighbors and a matrix of indeces
%of nearest neighbors
function NbrInd = kNN(X,k,p)
for i=1:p
    for j=1:p
        if i == j
            D(i,j) = 100;
        else
            D(i,j) = norm(X(:,i)-X(:,j));
        end
        
    end
end

[NbrDist,NbrInd] = mink(D,k,1);
end

%generate W (encoding of the geometric structure of X)
%input indices for neighbors,p and k
%output W
function [W,ci] = constructW(X,NbrInd,k,p)

for i=1:p
    for j=1:p
        for m=1:k
            if i ~= j 
                ci(i,j,m) = ((X(:,i) - X(:,j))'*(X(:,i) - X(:,NbrInd(m,i))))^(-1);
            else
                ci(i,j,m) = 0;
            end
        end
    end
end

for i=1:p
    for j=1:p
        W(i,j) = sum(ci(i,j,:),3)/sum(sum(ci(i,:,:),3),2);
    end
end

end
