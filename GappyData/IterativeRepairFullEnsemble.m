clear

% the setup
M=64;
P=64;
N=3;
for m=1:M
    xm = (m-1)*2*pi/M;
    for mu=1:P
        tmu = (mu-1)*2*pi/P;
        f1=0;
        for k=1:N
            f1 = (1/k)*sin(k*(xm-tmu))+f1;
        end
        f(m,mu) = N*f1;
    end
end

%svd of f
[U,S,V] = svd(f);

%the percent mask
pct = .7

%generate the mask
mask = rand(64,64)>= pct;

%take the first pattern and make it gappy using mask
fg = f.*mask;

%compute svd
[fU,fS,fV] = svd(fg);

fr = fg;

E(1) = 1; 
K=2;

while E(K-1) >= 0.01
    for k = 1:64
        
        %compute svd for first iteration
        if k == 1
            [fU,fS,fV] = svd(fg);
            S(:,1) = diag(fS);
        end
        
        %compute M in linear system
        for i = 1:64
            for j = 1:64
                M(i,j) = (fU(:,i).*fU(:,j))'*mask(:,k);
            end
        end
        
        for i = 1:64
            f0(i) = (fr(:,k).*fU(:,i))'*mask(:,k);
        end
        
        f0 = f0';
        
        %NOTE: use D=6 for repair 6D reconstruction of xg
        D=6;
        M(1:D,1:D);
        f0(1:D);
        a = inv(M(1:D,1:D))*f0(1:D);
        xapp = a(1)*fU(:,1)+a(2)*fU(:,2)+a(3)*fU(:,3)+a(4)*fU(:,4)+a(5)*fU(:,5)+a(6)*fU(:,6);
        
        %create a repair vector
        for i=1:64
            if mask(i,k) == 0
                fr(i,k) = xapp(i);
            else
                fr(i,k) = fg(i,k);
            end
        end
        
        %clear some variables
        clr = {'f0','a','xapp','M'};
        clear(clr{:});
        
        %begin the reconstruction matrix
        fapp(:,1:k) = fr(:,1:k);
        
        if k ~= 64
            fapp(:,k+1:64) = fr(:,k+1:64);
        end
        
        %compute svd
        [fU,fS,fV] = svd(fr);
        S(:,K) = diag(fS);
        
    end
    %calculate the error
    E(K) = 0;
    for i=1:6
        E(K) = E(K)+(S(i,K)^2-S(i,K-1)^2)^2;
        i
    end
    E(K) = E(K)^(1/2)
    K=K+1
end