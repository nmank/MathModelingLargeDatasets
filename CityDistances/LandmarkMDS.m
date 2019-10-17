%Aberystwyth, Brighton, Carlisle, Dover, Exeter, Glasgow, 
%Hull, Inverness, Leeds, Newcastle upon Tyne, Norwich 

M = [0 244 218 284 197 312 215 469 166 253 270; 
    0 0 350 77 167 444 221 583 242 325 168;
    0 0 0 369 347 94 150 251 116 57 284;
    0 0 0 0 242 463 263 598 257 340 164;
    0 0 0 0 0 441 279 598 269 359 277;
    0 0 0 0 0 0 245 169 210 143 378;
    0 0 0 0 0 0 0 380 55 117 143;
    0 0 0 0 0 0 0 0 349 264 514;
    0 0 0 0 0 0 0 0 0 91 173;
    0 0 0 0 0 0 0 0 0 0 256;
    0 0 0 0 0 0 0 0 0 0 0]

D = M+M';

%new city is London
ya = [212; 53; 298; 72; 170; 392; 168; 531; 190; 273; 111]

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
for i=1:8
    vSquiggle(:,i) = SfixedL(i)*fixedV(:,i);
end

%calculate delta_a
da = ya.*ya;

%calculate delta_mu
dmu = mean(D.*D,2);

%make transpose of pseudoinverse of Vsquiggle (aka Lsharp)
for i=1:8
    Lsharp(i,:) = fixedV(:,i)'/SfixedL(i);
end

%reconstruct ya
xa = (-1/2)*Lsharp*(da-dmu);

%test mutha fluka
for i=1:11
    X(:,i) = Lsharp*(B(:,i)-dmu);
end

%crude plot of data (in proper orientation)
scatter(-vSquiggle(:,2),-vSquiggle(:,1));
hold
scatter(-xa(2),-xa(1));

