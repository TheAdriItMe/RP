
%% %% Feature Selection
% PCA
data_norm=scalestd(dataTasmania);
proj_pca=PrincipalComponentAnalysis(data_norm,'Kaiser');
%% KW
data_norm=scalestd(dataQueenIsland);
KruskalWallisRanking(data_norm,col_names)
%% LDA
data_norm=scalestd(dataVictoria);
data_LDA=LDAReductionTo1D(data);



