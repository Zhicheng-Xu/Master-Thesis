function [dist lag gain] = supercorr(A,B)

L1=length(A);
L2=length(B);

if L1>L2;   
    % B is short;
    K=zeros(length(A),1);

    for ind0=1:(1+length(A)-length(B));
        ind=ind0:(ind0-1+length(B));
        K(ind0)=dot(B,A(ind))/(norm(B)*norm(A(ind))); % cosine similarity
    end
    [cs ind0]=max(K);
    if cs==0&&ind0~=1
        ind=ind0-1:(ind0-2+length(B));
    else
        ind=ind0:(ind0-1+length(B));
    end
    gain=1/(B\A(ind));
    lag=-(ind0-1);
    
else
% A is short;

K=zeros(length(B),1);

for ind0=1:(1+length(B)-length(A));
   ind=ind0:(ind0-1+length(A));
   K(ind0)=dot(A,B(ind))/(norm(A)*norm(B(ind))); % cosine similarity
end

    [cs ind0]=max(K);
    if cs==0&&ind0~=1
        ind=ind0-1:(ind0-2+length(A));
    else
        ind=ind0:(ind0-1+length(A));
    end
    gain=A\B(ind);    
    lag=ind0-1;

end


dist=1-cs;




