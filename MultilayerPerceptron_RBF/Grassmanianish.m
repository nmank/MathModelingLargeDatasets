%load data
data = load('IP2classes.mat');

%set n
n=25;
%set k
k=1;

%build grassmanian
for i=1:n
    for j=1:k
        X(:,j,i) = data.X(:,i+j-1);
        Y(:,j,i) = data.Y(:,i+j-1);
    end
end

%compute mean of subspaces
for i=1:k
	mX(:,i) = mean(X(:,i,:),3);
    mY(:,i) = mean(Y(:,i,:),3);
end

%build chordal distance matrix
A = X;
A(:,:,n+1:2*n) = Y;
A(:,:,2*n+1) = mX;
A(:,:,2*n+2) = mY;
for i=1:2*n+2
    for j=1:2*n+2
        [U,S,V] = svd(A(:,:,i)'*A(:,:,j));
        S1 = S/max(diag(S));
        D(i,j) = trace(eye(k) - S1.*S1);
    end
end

%do mds on chordal distance matrix
vis = MDS(D);

%visualize the data
hold
scatter(vis(1:25,1),vis(1:25,2))
scatter(vis(26:50,1),vis(26:50,2))
scatter(vis(51,1),vis(51,2),'b','filled')
scatter(vis(52,1),vis(52,2),'r','filled')



function X = MDS(D)
%make p the rank of D
p = rank(D);

%make A
A = (-1/2)*D.*D;

%make H
H = eye(p)-(1/p)*ones(p);

%compute B
B = H*A*H;

%eigenvectors and eigenvalues
[V,L] = eig(B);
dL = diag(L);

%throw away negative eigenvalues
i=1;
for k=1:p
    if dL(k) >=0
        fixedL(i) = L(k,k);
        fixedV(:,i) = V(:,k);
        i = i+1
    end
end

%vsquiggle
SfixedL = sqrt(fixedL);
for i=1:size(SfixedL,2)
    vSquiggle(:,i) = SfixedL(i)*fixedV(:,i);
end

%make a matrix with rows as first two coords of matrix
%scatter(vSquiggle(:,1),vSquiggle(:,2))
size(vSquiggle)
%rotate and reflect vSquiggle to the proper orientaion
X = [vSquiggle(:,1),vSquiggle(:,2)];
end
