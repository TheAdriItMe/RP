%% Classifiers

%% Compute errors -Euclidian
[FPR_euc,FNR_euc]=EuclidianDistanceClass(data);
fprintf('Euclidian Minimum Distance Classifier\n')
fprintf('FPR : %f\n',FPR_euc*100)
fprintf('FNR : %f\n',FNR_euc*100)



%% Mohalanobis
[FPR_moh,FNR_moh]=MohalanobisDistanceClass(data);
fprintf('Mohalanobis Minimum Distance Classifier\n')
fprintf('FPR : %f\n',FPR_moh*100)
fprintf('FNR : %f\n',FNR_moh*100)


%% Fisher
% generate train and test sets using k-folds
[Mean_FPR,St_mean_FPR,Mean_FNR,St_mean_FNR]=FisherLinearDiscriminant(dataKW,30,10);

fprintf('Fisher Linear Discriminant with 30 reps and using 10-folds cross validation\n')
fprintf('Mean FPR: %f +/- %f\n',Mean_FPR*100,St_mean_FPR*100)
fprintf('Mean FNR: %f +/- %f\n',Mean_FNR*100,St_mean_FNR*100)
