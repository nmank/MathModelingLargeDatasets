%description of the data: M(i,j) = attribute i, animal j   
%i=1:13

%j=1:16
%Dove 	 
%Hen 	 
%Duck 	 
%Goose 	 
%Owl 	 
%Hawk 	 
%Eagle 	 
%Fox 	 
%Dog 	 
%Wolf 	 
%Cat 	 
%Tiger 	 
%Lion 	 
%Horse 	 
%Zebra 	 
%Cow

%rows: 
%small size
%medium size
%large size
%2 legs
%4 legs
%hair
%hooves
%mane
%feathers
%hunts
%runs
%flys
%swims

%the number one indicates that animal j possesses attribute i and zero indicates it does not.

X = [1 	1 	1 	1 	1 	1 	0 	0 	0 	0 	1 	0 	0 	0 	0 	0;
0 	0 	0 	0 	0 	0 	1 	1 	1 	1 	0 	0 	0 	0 	0 	0;
0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	1 	1 	1 	1 	1;
1 	1 	1 	1 	1 	1 	1 	0 	0 	0 	0 	0 	0 	0 	0 	0;
0 	0 	0 	0 	0 	0 	0 	1 	1 	1 	1 	1 	1 	1 	1 	1;
0 	0 	0 	0 	0 	0 	0 	1 	1 	1 	1 	1 	1 	1 	1 	1;
0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	1 	1 	1;
0 	0 	0 	0 	0 	0 	0 	0 	0 	1 	0 	0 	1 	1 	1 	0;
1 	1 	1 	1 	1 	1 	1 	0 	0 	0 	0 	0 	0 	0 	0 	0;
0 	0 	0 	0 	1 	1 	1 	1 	0 	1 	1 	1 	1 	0 	0 	0;
0 	0 	0 	0 	0 	0 	0 	0 	1 	1 	0 	1 	1 	1 	1 	0;
1 	0 	0 	1 	1 	1 	1 	0 	0 	0 	0 	0 	0 	0 	0 	0;
0 	0 	1 	1 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0 	0];

p = length(X);


%create c and ci (the inverses of the elements of c)
for i=1:p
    for j=1:p
        for k=1:p
            c(j,k,i) = ((X(:,i) - X(:,j))'*(X(:,i) - X(:,k)));
        end
    end
end

for i=1:p
    WhtT(:,i) = pinv(c(:,:,i))*ones(p,1);
end
Wht = WhtT';

for i=1:p
    for j=1:p
        W(i,j) = Wht(i,j)/norm(Wht(i,:));
    end
end



M = (eye(p)-W)'*(eye(p)-W);

[Yt,Lambda] = eig(M);

%%%%%%%%%%%%%%%%%%%
%FIX! deal with evals
%%%%%%%%%%%%%%%%

Y = Yt';

hold
scatter(Y(1,:),Y(2,:),'.');
for i=1:p
%     if i ==14
%         text(Y(1,i)+.01,Y(2,i)+.02,num2str(i),'FontSize', 12)
%     elseif i ==11
%         text(Y(1,i)+.01,Y(2,i)+.02,num2str(i),'FontSize', 12)
%     elseif i ==16
%         text(Y(1,i)+.006,Y(2,i)+.02,num2str(i),'FontSize', 12)
%     elseif i ==9
%         text(Y(1,i)+.02,Y(2,i)+.04,num2str(i),'FontSize', 12)
%     else
        text(Y(1,i),Y(2,i),num2str(i),'FontSize', 12);
%     end
end


