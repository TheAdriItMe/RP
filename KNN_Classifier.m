function [Mean_FPR,St_mean_FPR,Mean_FNR,St_mean_FNR]=KNN_Classifier(data,reps,folds,nNeighb)

s=size(data.X);
Erro_total_knn=zeros(reps,4);

for j =1:reps
    
    Errors = zeros(folds,2);
    indices = crossvalind('Kfold',s(2),folds);

    for i = 1:folds

        test = (indices == i); 
        train = ~test;
        ixtr=find(train==1);
        ixte=find(test==1);

        data_tr.X=data.X(:,ixtr);
        data_tr.y=data.y(ixtr);
        data_tr.dim=size(data_tr.X,1);
        data_tr.num_data=size(data_tr.X,2);
        data_tr.name='Training set';

        data_te.X=data.X(:,ixte);
        data_te.y=data.y(ixte);
        data_te.dim=size(data_te.X,1);
        data_te.num_data=size(data_te.X,2);
        data_te.name='Testing set';
    
        model = knnrule(data_tr,nNeighb);
        y_pred=knnclass(data_te.X,model);

        
        Errors(i,1) = cerror(y_pred,data_te.y,2); %FPR = FP/FP+TN
        Errors(i,2) = cerror(y_pred,data_te.y,1); %FNR = FN/FN+TP

    end

    Erro_total_knn(j,1)=mean(Errors(:,1));
    Erro_total_knn(j,2)=std(Errors(:,1));
    Erro_total_knn(j,3)=mean(Errors(:,2));
    Erro_total_knn(j,4)=std(Errors(:,2));

end
Mean_FPR = mean(Erro_total_knn(1,:));
St_mean_FPR = (sqrt(sum(Erro_total_knn(2,:).^2)))/reps;

Mean_FNR = mean(Erro_total_knn(3,:));
St_mean_FNR = (sqrt(sum(Erro_total_knn(4,:).^2)))/reps;