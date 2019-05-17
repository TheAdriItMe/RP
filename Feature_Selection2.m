%% Feature Selection and Reduction
%% normalize data features and perform PCA

data_norm=scalestd(data);

model=pca(data_norm.X);
proj=data_norm;
proj.X=linproj(data_norm.X,model);

figure
scatter(1:16,model.eigval,'.','LineWidth',4)
hold on
line([0 20], [1 1])
title('Valores Próprios')

figure
ppatterns(data_norm)
title('Dados normalizados (2 dimensões)')

%Reduction to 1D with PCA
model1=pca(data_norm.X,1);
proj1=data_norm;
proj1.X=linproj(data_norm.X,model1);
figure
ppatterns(proj1)
title('Redução a 1 dimensão com PCA')

%Reduction to 2D with PCA
model2=pca(data_norm.X,2);
proj1=data_norm;
proj1.X=linproj(data_norm.X,model2);
figure
ppatterns(proj1)
title('Redução a 2 dimensões com PCA')

%Reduction to 3D with PCA
model3=pca(data_norm.X,3);
proj1=data_norm;
proj1.X=linproj(data_norm.X,model3);
figure
ppatterns(proj1)
title('Redução a 3 dimensões com PCA')

%Kaiser Criterion
featuresToEliminateK=find(model.eigval<1);
dimKC= length(model.eigval)-length(featuresToEliminateK);
total_variance = sum(model.eigval);
var_KC =  sum(model.eigval(1:dimKC))/total_variance *100;
fprintf('Nova dimensão segundo critério de Kaiser: %f\n',dimKC)
fprintf('Percentagem de variância preservada: %f\n',var_KC)

%Scree Test
i=1;
dif=1;
while dif>0.01
    if (i==length(model.eigval))
        sprintf('EigenValues Never esabilized')
        break
    end
    dif = abs(model.eigval(i+1)-model.eigval(i));
    i=i+1; 
end
featuresToEliminateS=i:length(model.eigval);
dimST= length(model.eigval)-length(featuresToEliminateS);

% What is the minimum dimension that allows a variance preservation of more than 97%?
var =0;
dimensoes=1;
while var<97
    var =  sum(model.eigval(1:dimensoes))/total_variance *100;
    dimensoes=dimensoes+1;
end
fprintf('Dimensão mínima que permite preservar a variance em mais de 97: %f\n',dimensoes)

%Escolhemos utlizar o critério de Kaiser e reduzir a 4 dimensões
model_final=pca(data_norm.X,4);
proj_pca=data_norm;
proj_pca.X=linproj(data_norm.X,model_final);


%% Kruskal Wallis test
Ranked = cell(2, data.dim);
for i =1:data.dim
    [P, ATAB] = kruskalwallis(data.X(i,:),data.y,'off'); %qto maior for o valor do qui-squared mais discriminativa é a feature
    Ranked{i,1}=col_names{i};
    Ranked{i,2}=ATAB{2,5};   
end

[F,H]=sort([Ranked{:,2}],2,'descend');
stotal=[sprintf('K-W Feature ranking: \n')];
for j =1:data.dim
    stotal=[stotal, sprintf('%s-->%.2f\n',Ranked{H(j),1},Ranked{H(j),2})];
end
disp(stotal)

%Assessing redundancy
C=corrcoef(data.X');
[r,c]=find(C>=0.9);
redundant=[];
for i=1:length(c)
    if r(i)~=c(i)
        redundant=[redundant;r(i) c(i)];
    end
end

%The highly correlated variables are MaxTemp(2) with Temp3pm(15) and
%Pressure9am(12) with Pressure3pm(13)

disc1=[F(find(H==2)) F(find(H==15))];
disc2=[F(find(H==12)) F(find(H==13))];

get_least1=find(disc1==min(disc1));
get_least2=find(disc2==min(disc2));
eliminate=[];

if (get_least1==1)
    eliminate=[eliminate 2];
else
    eliminate=[eliminate 15];
end
    
if (get_least2==1)
    eliminate=[eliminate 12];
else
    eliminate=[eliminate 13];
end
       
%Decidiu-se cortar na 9 feature da lista ordenada
H(9:end)=[];
%Eliminar redundantes
H(find(H==eliminate(1)))=[];
H(find(H==eliminate(2)))=[];

dataKW=data;
dataKW.X=data.X(H,:);
dataKW.dim=size(dataKW.X,1); 
dataKW.num_data=size(dataKW.X,2);    
dataKW.name='weatherAUS_KWreduction';


%% Linear Discriminant Anlysis
x1=find(data_norm.y==0);x2=find(data_norm.y==1);

%Para 1D - como é um problema binário só se pode ter no máximo 2-1=1
%dimensões

model_lda = lda(data_norm,1);
DataLDA1out =data_norm;
proj= linproj(data, model_lda);
DataLDA1out.X=proj.X;

figure
scatter(DataLDA1out.X(1,x1),zeros(1,length(x1)),'or')
hold on
scatter(DataLDA1out.X(1,x2),zeros(1,length(x2)),'xb')
title('LDA reduction to 1D')






