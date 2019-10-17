load('MNFdata.mat');


%problem 2

%construct Xs
Xs(1,:) = X(629,:);
for i=1:628;
    Xs(i+1,:) = X(i,:);
end

%construct dX
dX = X-Xs;

%construct N^TN
NtN = (1/2)*dX'*dX;


%(a)(i) eigenvector problem
[Psi0,ab0] = eig(pinv(NtN)*X'*X);
%compute basis
Phi0 = X*Psi0;
%Normalize
for i =1:4
    Phi00(:,i) = Phi0(:,i)/(sqrt((Phi0(:,i)')*Phi0(:,i)))
end

%(a)(ii) generalized eigenvector problem
[Psi1,ab1] = eig(NtN,X'*X);
%compute basis
Phi1 = X*Psi1;
%Normalize
for i =1:4
    Phi11(:,i) = Phi1(:,i)/(sqrt((Phi1(:,i)')*Phi1(:,i)))
end

%(a)(iii) gsvd
[U2,V2,X2,C2,S2] = gsvd(dX/(sqrt(2)),X);
%find Psien
Psi2 = pinv(X2');
%compute basis
Phi2 = X*Psi2;
%Normalize
for i =1:4
    Phi22(:,i) = Phi2(:,i)/(sqrt((Phi2(:,i)')*Phi2(:,i)))
end

%(b) compare the two bases

%setup and plot the first 
%phi vector
plot(Phi00(1,:)', 'o');
hold
plot(Phi11(1,:)','*');
plot(Phi22(1,:)','x');



%(c) svd of data
[U,S,V] = svd(X);

%compare the angles
for j=1:4
    for i=1:4
        angles1(i,j) = acos(U(:,j)'*Phi00(:,i))
        if angles1(i,j) > pi/2 
            angles1(i,j) = angles1(i,j)- pi/2;
        end
    end
end

%plot vectors
plot(U(:,1)) %just change 1 to 2,3,4 to compare svd basis with others
hold
for i=1:4
    plot(Phi00(:,i))
end


%(d) projections
for i=1:4
    SVDpX(:,i) = U(:,1)'*X(:,i)*U(:,1) +  U(:,2)'*X(:,i)*U(:,2)
end

%project X onto the first two basis vectors
for i=1:4
    MNFpX(:,i) = Phi00(:,1)'*X(:,i)*Phi00(:,1) +  Phi00(:,2)'*X(:,i)*Phi00(:,2);
end

%compare
plot(SVDpX(:,1)); hold; plot(MNFpX(:,1)); %SVD in blue, do for 1,2,3,4