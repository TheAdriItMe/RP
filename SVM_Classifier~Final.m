function [FP,FN]=SVM_Classifier(data,n_runs)

%Model Parameters tuning
c_pot=[-25 -15];%Exponent values for the cost
C=2.^c_pot;%Define different costs as powers of 2 

err=zeros(n_runs,numel(C));%define testing error matrix
models=cell(n_runs,numel(C));%define cell array to store the models

%Run models
for n=1:n_runs
    %===========Select random datasets==============
    ix=randperm(data.num_data);
    p_trn=0.5;%Percentage of training patterns
    n_trn_samp=ceil(data.num_data*p_trn);%Number of training patterns
    trn.X=data.X(:,ix(1:n_trn_samp));
    trn.y=data.y(ix(1:n_trn_samp));
    trn.dim=size(trn.X,1);
    trn.num_data=n_trn_samp;
    trn.name='Training';
    tst.X=data.X(:,ix(n_trn_samp+1:end));
    tst.y=data.y(ix(n_trn_samp+1:end));
    tst.dim=size(tst.X,1);
    tst.num_data=data.num_data-n_trn_samp;
    tst.name='Testing';
    for co=1:numel(C) %Test different costs 
        disp(sprintf('===========\nRun=%d\nCost=%f\n===========',n,C(co)));
        %============TRAIN SVM=================
        disp('Let''s Train');
        model = smo(trn,struct('ker','linear','C',C(co)));
        ypred = svmclass( tst.X, model );        
        err(n,co)=cerror( ypred, tst.y )*100;%Evaluate and store testing error
        models{n,co}=model;
    end
end


if n_runs>1
    merr=mean(err);
    serr=std(err);
else
    merr=err;
    serr=zeros(1,numel(err));
end
figure;plot(c_pot,merr,'o')
ylabel('Testing Error (%)')
set(gca,'xtick',c_pot)
set(gca,'xticklabel',strcat('2^',cellfun(@num2str,num2cell(c_pot),'UniformOutput',0)))
hold on
errorbar(c_pot,merr,serr)
axis([c_pot(1) c_pot(end) 0 100])

%Inspect for a best Classifier
%===================Inspect for a best Classifier=======================
ix=find(merr==min(merr));
disp(sprintf('\nAverage Best C value=2^%d\n',c_pot(ix)));
ix_min_err=find(err(:,ix)==min(err(:,ix)));%find the best model by finding the minimum error for the selected Cost
if numel(ix_min_err)>1%If there are more than one classifier associated with the minimum error then select the one with smaller number os SV
    sel_class=models(ix_min_err,ix);
    nsvs=zeros(1,numel(ix_min_err));
    for m=1:numel(ix_min_err)
       nsvs(m)=sel_class{m}.nsv;
    end
    ix_min_nsv=find(nsvs==min(nsvs));
    best=sel_class{ix_min_nsv};
else
    best=models{ix_min_err,ix};
end

[ypred,dfce] = svmclass( tst.X, best);
[FP,FN]=roc(dfce,tst.y); %False positive rate - FP ;  False positive rate - FN

figure;plot(FP,1-FN)%display ROC for best



