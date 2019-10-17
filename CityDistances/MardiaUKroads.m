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
    vSquiggle(:,i) = fixedL(i)*fixedV(:,i);
end

%make a matrix with rows as first two coords of matrix
scatter(vSquiggle(:,1),vSquiggle(:,2))

%Verify that the mean of the configuration is zero
mean(vSquiggle)

