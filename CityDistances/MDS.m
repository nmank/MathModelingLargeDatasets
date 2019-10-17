%Inverness, Glasgow, Newcastle, Carlisle, Leeds, Hull
%Norwich, Aberystwyth, London, Dover, Brighton, Exeter.

M = [0 244 218 284 197 312 215 469 166 212 253 270; 
    0 0 350 77 167 444 221 583 242 53 325 168;
    0 0 0 369 347 94 150 251 116 298 57 284;
    0 0 0 0 242 463 263 598 257 72 340 164;
    0 0 0 0 0 441 279 598 269 170 359 277;
    0 0 0 0 0 0 245 169 210 392 143 378;
    0 0 0 0 0 0 0 380 55 168 117 143;
    0 0 0 0 0 0 0 0 349 531 264 514;
    0 0 0 0 0 0 0 0 0 190 91 173;
    0 0 0 0 0 0 0 0 0 0 273 111;
    0 0 0 0 0 0 0 0 0 0 0 256;
    0 0 0 0 0 0 0 0 0 0 0 0]

D = M+M';

save Distances D

%make p the rank of D
p = rank(D);

%make A
A = (-1/2)*D.*D;

%make H
H = eye(12)-(1/p)*ones(12);

%compute B
B = H*A*H;

%eigenvectors and eigenvalues
[V,L] = eig(B);
dL = diag(L);

%throw away negative eigenvalues
i=1
for k=1:p
    if dL(k) >=0
        fixedL(i) = L(k,k);
        fixedV(:,i) = V(:,k);
        i = i+1
    end
end

%vsquiggle
SfixedL = sqrt(fixedL);
for i=1:9
    vSquiggle(:,i) = SfixedL(i)*fixedV(:,i);
end

%make a matrix with rows as first two coords of matrix
%scatter(vSquiggle(:,1),vSquiggle(:,2))

%rotate and reflect vSquiggle to the proper orientaion
X = [-vSquiggle(:,2),vSquiggle(:,1)]

%scale X
scatter(X(:,1),X(:,2),'filled')

%label the points
% text(vSquiggle(1,1),vSquiggle(1,2),'Aberystwyth');
% text(vSquiggle(2,1),vSquiggle(2,2),'Brighton');
% text(vSquiggle(3,1),vSquiggle(3,2),'Carlisle');
% text(vSquiggle(4,1),vSquiggle(4,2),'Dover');
% text(vSquiggle(5,1),vSquiggle(5,2),'Exeter');
% text(vSquiggle(6,1),vSquiggle(6,2),'Glasgow');
% text(vSquiggle(7,1),vSquiggle(7,2),'Hull');
% text(vSquiggle(8,1),vSquiggle(8,2),'Inverness');
% text(vSquiggle(9,1),vSquiggle(9,2),'Leeds');
% text(vSquiggle(10,1),vSquiggle(10,2),'London');
% text(vSquiggle(11,1),vSquiggle(11,2),'Newcastle');
% text(vSquiggle(12,1),vSquiggle(12,2),'Norwich');

text(X(1,1),X(1,2),'Aberystwyth');
text(X(2,1),X(2,2),'Brighton');
text(X(3,1),X(3,2),'Carlisle');
text(X(4,1),X(4,2),'Dover');
text(X(5,1),X(5,2),'Exeter');
text(X(6,1),X(6,2),'Glasgow');
text(X(7,1),X(7,2),'Hull');
text(X(8,1),X(8,2),'Inverness');
text(X(9,1),X(9,2),'Leeds');
text(X(10,1),X(10,2),'London');
text(X(11,1),X(11,2),'Newcastle');
text(X(12,1),X(12,2),'Norwich');


%Verify that the mean of the configuration is zero
mean(vSquiggle)

