%K-Nearest-Neighbor

function [best_nvalue,fpr]=KNN_getBestNeighbSize(data,n_value)
a=length(n_value);
err=zeros(1,a);
models=[];

best_nvalue=randperm(data.num_data);
p_train=0.5;%percentage of training
n_train_samp=data.num_data*p_train;%number of training samples

%Define training dataset
data_tr.X=data.X(:,best_nvalue(1:n_train_samp));
data_tr.y=data.y(best_nvalue(1:n_train_samp));
data_tr.dim=4;
data_tr.num_data=data.num_data-n_train_samp;
data_tr.name='Training';

%Define testing dataset
data_te.X=data.X(:,best_nvalue(n_train_samp+1:end));
data_te.y=data.y(best_nvalue(n_train_samp+1:end));
data_te.dim=4;
data_te.num_data=data.num_data-n_train_samp;
data_te.name='Testing';

%Find the best number of neighbors
for i=n_value
    model = knnrule(data_tr,i);
    models=[models model];
    ypred=knnclass(data_te.X,model);
    err(1,i)= cerror(ypred,data_te.y,2)*100;%FPR = FP/FP+TN
    fprintf('n:%d ',i) 

end


%med_err=mean(err,1);
%std_err=std(err,[],1);
best_nvalue=find(err==min(err));
fpr=med_err(best_nvalue);

figure; errorbar(1:n_value,med_err,std_err)
hold on
xlabel('Número de Vizinhos')
ylabel('Erro em teste')
hold on
plot(best_nvalue(1),min(med_err),'ro')

