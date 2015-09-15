function [N,D, col, tier, n_container, T_max]=Casserta(B)

% Casserta is a function which solve the CRP problem with full information.
% Its only entry is a bay B and it returns N the number of relocations
% needed and D the delays of each container.

% First we compute the numbers of containers, the position of every container
% the height and the minimum of every column of the bay.
% By convienience, is the column is empty, we set the minimum at m+1, where
% m is the number of containers.
m=0;
P=zeros(size(B,1)*size(B,2),2);
H=zeros(1,size(B,2));
for j=1:size(B,2);
    for i=1:size(B,1);
        if B(i,j)~=0;
            m=m+1;
            P(B(i,j),1)=i;
            P(B(i,j),2)=j;
            if H(j)==0;
                H(j)=i;
            end;
        end;
    end;
end;

Pos=P(1:m,1:2);

minimum=(m+1)*ones(1,size(B,2));
for j=1:size(B,2);
    if H(j)~=0;
        for i=H(j):size(B,1);
            if minimum(j)>B(i,j);
                minimum(j)=B(i,j);
            end;
        end;
    end;
end;
N=0;
counter_ret=1;
counter_rel=1;
counter_vnt=1;
% N is the number of "improductive" relocations
D=zeros(1,m);
% D is the list of the delays of all containers. We suppose that each
% truck i arrive at time i
T=1;
% T is the time step we are in

position(:,:,T)=Pos;
for n=1:m;
% We iterate for each container n
% First we compute its position in the bay, I and J are its coordinates
    I=Pos(n,1);
    J=Pos(n,2);
    while B(I,J)~=0;
% We loop until container n is retrieved
        if I==H(J);
% If it is available, we retrieve it and we update the bay and its feature 
% such as height, position of n and minimum.
            D(n)=T-n;
            B(I,J)=0;
            if H(J)==size(B,1);
                H(J)=0;
            else
                H(J)=H(J)+1;
            end;
            Pos(n,1)=0;
            Pos(n,2)=0;
            minimum(J)=m+1;
            if I<size(B,1);
                for i=I+1:size(B,1);
                    if minimum(J)>B(i,J);
                        minimum(J)=B(i,J);
                    end;
                end;
            end;
            
%            fprintf('retrieve container %d at time %d from column %d and tier %d \n',n , T, J, size(B,1)-I+1); 
           
           retrieval(counter_ret,1) = n; retrieval(counter_ret,2) = T; 
           retrieval(counter_ret,3) = J; retrieval(counter_ret,4) = size(B,1)-I+1;
           counter_ret=counter_ret+1;
           position(:,:,T+1) = Pos;
%            keyboard
           
        else
% We are goign to apply the heuristic of Casserta to choose on which column
% to move the top of column J denoted by r. We note this column C.
            r=B(H(J),J);
            q=0;
            Q=m+2;
            for j=1:size(B,2);
                if j~=J;
                    if H(j)~=1;
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
             
            destination_tier = find(B(:,C)~=0,1) - 1;
            if (isempty(find(B(:,C)~=0,1))) 
                destination_tier=size(B,1); 
            end
%             fprintf('relocate container %d at time %d from column %d and tier %d to column %d and tier %d \n ',r , T, J, size(B,1)-H(J)+1, C, size(B,1) - destination_tier + 1);
           relocation(counter_rel,1) = r; relocation(counter_rel,2) = T; 
           relocation(counter_rel,3) = J; relocation(counter_rel,4) = size(B,1)-H(J)+1;
           relocation(counter_rel,5) = C; relocation(counter_rel,6) = size(B,1) - destination_tier + 1;
           counter_rel=counter_rel+1;
           pos_temp = Pos;
           pos_temp(r,1)=destination_tier;
           pos_temp(r,2)=C;
           position(:,:,T+1) = pos_temp;
% And we move the top of column J on the top of column C and we update all
% the features of the bay (position, minimum and height)
            if minimum(C)==m+1;
                minimum(C)=r;
            else
                if minimum(C)>r;
                    minimum(C)=r;
                end;
            end;
            if H(C)==0;
                H(C)=size(B,1);
            else
                H(C)=H(C)-1;
            end;
            B(H(C),C)=r;
            Pos(r,1)=H(C);
            Pos(r,2)=C;
            B(H(J),J)=0;
            H(J)=H(J)+1;
% Finally we count this as a relocation
            N=N+1;
        end;
% We update the time
    T=T+1;
    end;
end;


col=size(B,2);tier=size(B,1);

n_container = m;
T_max = T-1;

counter = 1;
for t=1:T_max
    for n = 1: n_container
        if (position(n,1,t)~=0)
            index_bijnt(counter) = (t-1)*col*tier*n_container + col*tier*(n-1) + col*(tier - position(n,1,t)) + position(n,2,t) - 1;
            counter = counter+1;
        end
    end
end




for ret = 1:size(retrieval,1)
    index_ret(ret) = col*tier*n_container*T_max + n_container*T_max + col*tier*col*tier*n_container*T_max + ...
                     (retrieval(ret,2)-1)*col*tier*n_container + (retrieval(ret,1)-1)*col*tier + (retrieval(ret,4)-1)*col +  retrieval(ret,3) -1 ;    
    for t=retrieval(ret,2)+1:T_max
        index_vnt(counter_vnt) = col*tier*n_container*T_max + (t-1)*n_container + retrieval(ret,1)-1;      
        counter_vnt = counter_vnt+1;
    end
end

all_index = horzcat(index_bijnt,index_vnt,index_ret);
if counter_rel>1
    for rel = 1:size(relocation,1)
        index_rel(rel) = col*tier*n_container*T_max + n_container*T_max + (relocation(rel,2)-1)*col*col*tier*tier*n_container + (relocation(rel,1)-1)*col*col*tier*tier + ...
                    (relocation(rel,6)-1)*col*tier*col + (relocation(rel,5)-1)*col*tier + (relocation(rel,4)-1) * col + relocation(rel,3) -1 ;
    end
    all_index = horzcat(index_bijnt,index_vnt,index_rel,index_ret); 

end

num_one_vars = size(all_index,2);

num_vars =  2*(col*tier*n_container*T_max) + n_container*T_max + col*tier*col*tier*n_container*T_max;

all_index = horzcat(num_vars , num_one_vars, all_index);

index_vnt ;
    
index_bijnt;

index_ret;



