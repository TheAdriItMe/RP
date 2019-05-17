function proj_pca=PrincipalComponentAnalysis(data_norm,criterio)

proj_pca=data_norm;
model=pca(data_norm.X);
proj=data_norm;
proj.X=linproj(data_norm.X,model);
figure
scatter(1:data_norm.dim,model.eigval,'.','LineWidth',4)
hold on
line([0 20], [1 1])
title('Valores Próprios')
total_variance = sum(model.eigval);

if(isequal(criterio,'Kaiser'))
    %Kaiser Criterion
    featuresToEliminateK=find(model.eigval<1);
    dimKC= length(model.eigval)-length(featuresToEliminateK);
    var_KC =  sum(model.eigval(1:dimKC))/total_variance *100;
    fprintf('Nova dimensão segundo critério de Kaiser: %f\n',dimKC)
    fprintf('Percentagem de variância preservada: %f\n',var_KC)
    
    model_final=pca(data_norm.X,dimKC);
    proj_pca=data_norm;
    proj_pca.X=linproj(data_norm.X,model_final);
    proj_pca.dim=dimKC;
    proj_pca.name=strcat('Reduction to',num2str(dimKC),'dim with PCA');
    
end

if(isequal(criterio,'Scree'))
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
    if (i~=length(model.eigval))
        featuresToEliminateS=i:length(model.eigval);
        dimST= length(model.eigval)-length(featuresToEliminateS);
        var_ST=  sum(model.eigval(1:dimST))/total_variance *100;
        fprintf('Nova dimensão segundo teste de Scree: %f\n',dimST)
        fprintf('Percentagem de variância preservada: %f\n',var_ST)
        
        model_final=pca(data_norm.X,dimST);
        proj_pca=data_norm;
        proj_pca.X=linproj(data_norm.X,model_final);
        proj_pca.dim=dimST;
        proj_pca.name=strcat('Reduction to',num2str(dimST),'dim with PCA');
        
    end
end
