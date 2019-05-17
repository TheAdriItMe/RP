function [FPR,FNR]=MohalanobisDistanceClass(data)

ix_w0=find(data.y==2);
ix_w1=find(data.y==1);

m0 = mean(data.X(:,ix_w0),2);
m1 = mean(data.X(:,ix_w1),2);

C1=cov(data.X(:,ix_w0)');
C2=cov(data.X(:,ix_w1)');

C=(C1+C2)/2;
C_inv=C^-1;

%Compute errors - Mahalanobis
 c2=zeros(1,data.num_data);
 for i=1:data.num_data
     g1=m0'*C_inv*data.X(:,i)-0.5*m0'*C_inv*m0;
     g2=m1'*C_inv*data.X(:,i)-0.5*m1'*C_inv*m1;
     if(g1>=g2)
         c2(i)=2;
     else
         c2(i)=1;
     end
     
 end

FPR=cerror(c2,data.y,2);
FNR=cerror(c2,data.y,1);
