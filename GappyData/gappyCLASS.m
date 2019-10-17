%rank 2 data matrix
X = [1 1 2 -1; 2 -1 1 4; 3 -2 1 7; 4 1 5 2]

%pattern 
x = (X(:,1)+5*X(:,2))

%mask
m = [1 1 0 1]';
%gappy version of pattern
xg = x.*m

%get basis U
[U S V] = svd(X)

%solve Ma = f (a = hat(alpha)).

%compute M in linear system
for i = 1:4
    for j = 1:4
        M(i,j) = (U(:,i).*U(:,j))'*m;
    end
end

for i = 1:4
    f(i) = (xg.*U(:,i))'*m;
end
f = f';


%1D reconstruction of xg
M(1,1)
f(1)
a=f(1)/M(1,1)
xapp1 = a*U(:,1)

%2D reconstruction of xg
D=2
M(1:D,1:D)
f(1:D)
a = M(1:D,1:D)\f(1:D)
xapp2 = a(1)*U(:,1)+a(2)*U(:,2)

%COMMENT THIS CODE DOES NOT KEEP
%THE non-gappy components of X 
%in general you will need to do this.
