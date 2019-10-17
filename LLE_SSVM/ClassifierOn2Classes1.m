
%import data
data = load('IP2classes.mat');
dX = data.X;
dY = data.Y;

%define training data
halfX = floor(size(dX,2)/2);
halfY = floor(size(dY,2)/2);

trSet(:,1:halfX) = dX(:,1:halfX);
trSet(:,halfX+1 :halfX + halfY) = dY(:,1:halfY);
 
%define n and p and c
p = halfX + halfY;
n = size(trSet(:,1),1);
c =1;

%define Y
%X is positive Y is negative
Y = -1*ones(halfX,1);
Y((halfX + 1):(halfX + halfY),1) =  ones(halfY,1);

Ydiag = zeros(p,p);
for i=1:p
    Ydiag(i,i) = Y(i);
end

A = [Ydiag*trSet' Y -1*eye(p,p);
zeros(p,n+1) -1*eye(p,p)];

%construct b
b = [-1*ones(p,1); zeros(p,1)];

%construct f
f = [zeros(n+1,1); c*ones(p,1)];

%construct H
H = zeros(n+p+1);
H(1:n,1:n) = eye(n);

%use quadprog
x = quadprog(H,f,A,b)

%pull out variables from x
w = x(1:n);
b= x(n+1);
psi = x(n+2:n+1+p);

%create confusion matrix store as Conf
Conf = zeros(2);
bonus = 0;
for i=halfX + 1: size(dX,2)
    if w'*dX(:,i)+b > 0
        Conf(2,2) = Conf(2,2)+1;
    elseif w'*dX(:,i)+b < 0
        Conf(2,1) = Conf(2,1)+1;
    else
        bonus = bonus +1;
    end
end

for i=halfY + 1: size(dY,2)
    if w'*dY(:,i)+b > 0
        Conf(1,2) = Conf(1,2)+1;
    elseif w'*dY(:,i)+b < 0
        Conf(1,1) = Conf(1,1)+1;
    else
        bonus = bonus +1;
    end
end
    





