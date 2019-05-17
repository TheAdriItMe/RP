function [FPR,FNR]=EuclidianDistanceClass(data)

ix_w0=find(data.y==2);
ix_w1=find(data.y==1);

m0 = mean(data.X(:,ix_w0),2);
m1 = mean(data.X(:,ix_w1),2);

cl=zeros(1,data.num_data);
 for i=1:data.num_data
     g1=m0'*data.X(:,i)-0.5*m0'*m0;
     g2=m1'*data.X(:,i)-0.5*m1'*m1;
     if(g1>=g2)
         cl(i)=2;
     else
         cl(i)=1;
     end
     
 end

FPR=cerror(cl,data.y,2);
FNR=cerror(cl,data.y,1);
