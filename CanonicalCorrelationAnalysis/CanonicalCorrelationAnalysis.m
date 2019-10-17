load('MardiaExamData.mat')

X1= EXAMS(:,1:2);
Y1 = EXAMS(:,3:5);

%mean subtract X and Y
mX = mean(X1);
mY = mean(Y1);
X(:,1) = X1(:,1) - mX(1,1)*ones(88,1);
X(:,2) = X1(:,2) - mX(1,2)*ones(88,1);
Y(:,1) = Y1(:,1) - mY(1,1)*ones(88,1);
Y(:,2) = Y1(:,2) - mY(1,2)*ones(88,1);
Y(:,3) = Y1(:,3) - mY(1,3)*ones(88,1);

%problem1: (computing canonical vectors, etc)

%QR decomposition
[Qx,Rx] = qr(X,0);
[Qy,Ry] = qr(Y,0);

%svd Q
[U1,S1,V1] = svd((Qx')*(Qy));

%find A and B
A = pinv(Rx)*U1;
B = pinv(Ry)*V1;

%part a
%a1,2 b1,2
a1 = A(:,1);
a2 = A(:,2);

b1 = B(:,1);
b2 = B(:,2);

%part b
%find alpha and beta
alpha = a1' * X';
beta = b1' * Y';

%scatter alpha and beta
scatter(beta,alpha); xlabel("\beta"); ylabel("\alpha") %beta vs alpha
scatter(alpha,beta) %alpha vs beta

%part c
%find u and v
u = Qx*U1;
v = Qy*V1;

%u1,2 and v1,2
u1 = u(:,1);
u2 = u(:,2);
v1 = v(:,1);
v2 = v(:,2);

plot(u1); hold; plot(u2);
plot(v1); hold; plot(v2);

%part d
%verify angle between u1,v1 is arccos(sigma1) 
acos(u1'*v1) %angle u1v1
acos(S1(1,1)) %arccos(sigma1) 



