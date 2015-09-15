function [reloc,Moves]=myopic_and_RI(D,maxKnown,Tstar)

%Be careful, D is the initial bay as it is view in real life. But here for
%convinience we transform D in B in order to keep indices as it is commonly
%used, e.g. B(1,1) means first column at the bottom and corresponds to 
%D(size(D,1),1).
B=zeros(size(D,1),size(D,2));
%m is the biggest container in the bay, we allow for gaps between
%containers.
m=max(D(D~=0));
%Pos record the position of each container in the Bay.
Pos=zeros(m,2);
%H gives the height of each column
H=zeros(1,size(D,2));
for j=1:size(D,2);
    for i=1:size(D,1);
        B(size(D,1)-i+1,j)=D(i,j);
        if D(i,j)~=0;
            Pos(D(i,j),1)=size(D,1)-i+1;
            Pos(D(i,j),2)=j;
            if H(j)==0;
                H(j)=size(D,1)-i+1;
            end;
        end;
    end;
end;

%reloc and Moves are the two outcomes of the algorithm.
% K=floor(per*m/100)+1;
K = maxKnown;
A=B;
for n=K+1:m;
    A(Pos(n,1),Pos(n,2))=m+1;
end;
% Finally, We create the minimum vector for the uncomplete bay A, the
% set of the "unknown columns" U and the set of empty columns E. We recall 
% that if the column is empty the minimum is m+2. And if 
% the column does not have any information the minimum is set to 
% size(A,1)*size(A,2)+1.
minimum=(m+2)*ones(1,size(A,2));
U=zeros(1,size(A,2));
for j=1:size(A,2);
    if H(j)~=0;
        for i=1:H(j);
            if A(i,j)<minimum(j);
                minimum(j)=A(i,j);
            end;
        end;
    end;
    if minimum(j)==m+1;
        U(j)=j;
    end;
end;
reloc=0;
Moves=zeros(1,2*(size(B,1)-1)*size(B,2));
T=1;

for n=min(B(B~=0)):m;
% We iterate for each container n
% First we compute its position in the bay, I and J are its coordinates
    I=Pos(n,1);
    J=Pos(n,2);
    if I~=0;
        while A(I,J)~=0;
            A;
            U;
            minimum;
            if T==Tstar;
                A=B;
                U=zeros(1,size(A,2));
            end;
    % We loop until container n is retrieved
            %D
            if I==H(J);
    % If it is available, we retrieve it and we update the bay and its feature 
    % such as height, position of n and minimum.
                A(I,J)=0;
                B(I,J)=0;
                %We update D to be able to follow the algorithm
                D(size(B,1)-I+1,J)=0;
                %We update H, Pos and minimum.
                H(J)=H(J)-1;
                Pos(n,1)=0;
                Pos(n,2)=0;
                minimum(J)=m+2;
                if I>1;
                    for i=1:I-1;
                        if minimum(J)>A(i,J);
                            minimum(J)=A(i,J);
                        end;
                    end;
                end;
                if minimum(J)==m+1;
                    U(J)=J;
                end;
            else
    % We are goign to apply the heuristic of Casserta modified to choose on which column
    % to move the top of column J denoted by r. We note this column C.
                r=A(H(J),J);
                rB=B(H(J),J);
                Ua=U(U~=0);
                Um=Ua(H(Ua)~=size(A,1));
                C=0;
                % if r is unknown then use LH
                if T<Tstar && r>maxKnown
                    bay = B;
                    bay = bay(end:-1:1,:);
                    C  = compute_min_RI2(bay,maxKnown,rB,J,Tstar,T);
                    C = C(1);
                else
                    if size(Um,2)==0;
                        q=0;
                        Q=m+3;
                        for j=1:size(A,2);
                            if j~=J;
                                if H(j)~=size(A,1);
                                    if q<minimum(j) && minimum(j)<r;
                                        C=j;
                                        q=minimum(j);
                                    end;
                                    if r<minimum(j) && minimum(j)<Q;
                                        C=j;
                                        Q=minimum(j);
                                        q=r;
                                    end;
                                end;
                            end;
                        end;
                    else
                        S=Um(H(Um)==max(H(Um)));
                        C=S(1);
                    end
                end
                %We update the bays A,B and D, H and minimum.
                if minimum(C)==m+2;
                    minimum(C)=r;
                    if r==m+1;
                        U(C)=C;
                    end;
                else
                    if minimum(C)>r;
                        minimum(C)=r;
                    end;
                    if U(C)==C && r~=m+1;
                        U(C)=0;
                    end;    
                end;
                H(C)=H(C)+1;
                A(H(C),C)=r;
                B(H(C),C)=rB;
                Pos(rB,1)=H(C);
                Pos(rB,2)=C;
                D(size(B,1)-H(C)+1,C)=rB;
                A(H(J),J)=0;
                B(H(J),J)=0;
                D(size(B,1)-H(J)+1,J)=0;
                H(J)=H(J)-1;
                %We generate our outputs, Moves and reloc.
                Moves(reloc+1)=C;
                reloc=reloc+1;
            end
        T=T+1;
        end;
    end;
end;
Moves=Moves(Moves~=0);

