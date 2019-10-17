%%
%define n and p and c
p = 10;
n = 2;
c = 1;


%%
%Generate data and define initial y
% %create seperated 2D random data
%X=rand(n,p/2);
%X(1:n,p/2+1:p)=2+rand(n,p/2);
% create 2D random data
X=4*rand(n,p);

%define Y
Y = ones(5,1);
Y(6:10,1) = -1*ones(5,1);

%%
%Define the problem for quadprog
%define A
%make Y a diagonal matrix
Ydiag = zeros(p,p);
for i=1:p
    Ydiag(i,i) = Y(i);
end

A = [Ydiag*X' Y -1*eye(p,p);
zeros(p,n+1) -1*eye(p,p)];

%construct b
b = [-1*ones(p,1); zeros(p,1)];

%construct f
f = [zeros(n+1,1); c*ones(p,1)];

%construct H
H = zeros(n+p+1);
H(1:n,1:n) = eye(n);


%%
%use quadprog
x = quadprog(H,f,A,b)

%pull out variables from x
w = x(1:n);
b= x(n+1);
psi = x(n+2:n+1+p);

%%
%visualize result
hold
fplot(@(px) (-b-w(1)*px)/w(2))
fplot(@(px) (-1-b-w(1)*px)/w(2),'--')
fplot(@(px) (1-b-w(1)*px)/w(2),'--')
scatter(X(1,1:5),X(2,1:5),'r')
scatter(X(1,6:10),X(2,6:10),'b')
xlim([0 4])
ylim([0 4])

