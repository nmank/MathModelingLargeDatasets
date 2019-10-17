
%define T
t = 2;
%number of nodes in hidden layer
Nh = 30;
%learning rate
epsilon = .000001;
%number of training data points
ptr=10;

%import data
data0 = load('FoCOwxSept.mat');
data = data0.Temp;

[X,Y] = TLD(data,t);

[E,out]= TrainMLP(X,Y,epsilon,Nh,p);






function [X,Y] = TLD(data,T)
n = size(data);

%create time lagged data using t
for i=1+2*T:n-T
    X(i-2*T,:) = [data(i); data(i-T); data(i-2*T)];
    Y(i-2*T,1) = data(i+T);
end
end


function [E,out] = TrainMLP(X,Y,epsilon, Nh,p)


n = size(X,2);

X = X(1:p,:);
Y = Y(1:p,:);

%%
%TRAINING

%randomize W1
for i=1:Nh-1
    for j=1:n+1
        W1(i,j) = rand(1);
    end
end
%randomize W2
for i=1:Nh
    W2(1,i) = rand(1);
end

%online updating
k=1;
mu=1
%for mu=1:p
    for k=1:100
        %layer 1 state
        s1(1,1) = 1;
        s1(2:n+1,1) = X(mu,:);
        %layer 1 to layer 2
        p2(1) = 1;
        p2(2:Nh,1) = W1*s1;
        %apply sigma (relu) to layer 2
        for i=1:Nh
            if p2(i) <=0
                s2(i,1) = 0;
            else
                s2(i,1) = p2(i);
            end
        end
        %layer 2 to layer 3
        p3 = W2*s2;
        %apply sigma (relu) to layer 3
        if p3 <=0
            s3 = 0;
        else
            s3 = p3;
        end
        
        %backpropogation
        %define Deltas
        if p3 <= 0
            Delta2 = 0;
        else
            Delta2 = -(Y(mu)-s3);
        end
        if p2 <= 0
            Delta1 = zeros(Nh,1);
        else
            Delta1 = W2'*Delta2;
        end
        
        %Define new weights
        for i=1:Nh-1
            for j=1:n+1
                W1(i,j) = W1(i,j) - epsilon*Delta1(i)*s1(j);
            end
        end
        for j=1:Nh
            W2(1,j) = W2(j) - epsilon*Delta2*s2(j);
        end
        
        %layer 1
        s1(1,1) = 1;
        s1(2:n+1,1) = X(mu,:);
        %layer 1 to layer 2
        p2(1) = 1;
        p2(2:Nh,1) = W1*s1;
        %apply sigma (relu) to layer 2
        for i=1:Nh
            if p2(i) <=0
                s2(i,1) = 0;
            else
                s2(i,1) = p2(i);
            end
        end
        %layer 2 to layer 3
        p3 = W2*s2;
        %apply sigma (relu) to layer 3
        if p3 <=0
            s3 = 0;
        else
            s3 = p3;
        end
        
        
        %calculate error
        E(mu,k) = 1/2*abs(Y(mu)-s3);
    end
    out(mu) = s3;
%end

end


function [E,out] = TestMLP(X,Y,epsilon, Nh,p,W1,W2)
n = size(X,2);

X = X(1:p,:);
Y = Y(1:p,:);

s1(1,1) = 1;
s1(1,1) = 1;
s1(2:n+1,1) = X(mu,:);
%layer 1 to layer 2
p2(1) = 1;
p2(2:Nh,1) = W1*s1;
%apply sigma (relu) to layer 2
for i=1:Nh
    if p2(i) <=0
        s2(i,1) = 0;
    else
        s2(i,1) = p2(i);
    end
end
%layer 2 to layer 3
p3 = W2*s2;
%apply sigma (relu) to layer 3
if p3 <=0
    s3 = 0;
else
    s3 = p3;
end

end