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


p= length(X);

%set epsilon
epsilon = 3;

%set the heat kernel t
t=1


%generate distance matrix
% %using unweighted edges
% for i=1:p
%     for j=1:p
%         x = norm(X(:,i)-X(:,j))^2;
%         if x <= epsilon
%             W(i,j) = 1;
%         else
%             W(i,j) = 0;
%         end
%     end
% end
%using weighted edges
for i=1:p
    for j=1:p
        x = norm(X(:,i)-X(:,j));
        if x <= epsilon
            W(i,j) = exp(-x^2/t);
        else
            W(i,j) = 0;
        end
    end
end


%create D
D = zeros(p,p)
for i=1:p
    D(i,i) = sum(W(i,:));
end

%create L
L = D-W;

%generalized eigenvector problem
[evecs,evals] = eig(L,D);

%remove eigenvectors associated with zero eigenvalues
ii=1;
for i=1:p
    if evals(i,i) ~= 0
        evecsNoZero(:,ii) = evecs(:,i);
        ii=ii+1;
    end
    
end

%find y
Y = evecsNoZero';

scatter(Y(1,:),Y(2,:),'.')
text(Y(1,10),Y(2,10),'Dove, Hen, Duck, Goose, Owl, Hawk, Eagle','FontSize', 12);
text(Y(1,6),Y(2,6),'Fox, Dog, Wolf, Cat,','FontSize', 12);
text(Y(1,6),Y(2,6)-.02, ' Tiger, Lion, Horse, Zebra, Cow','FontSize', 12);





    


