function data_LDA=LDAReductionTo1D(data)

data_LDA=data;
model_lda = lda(data,1);
proj = linproj(data, model_lda);
data_LDA.X=proj.X;
data_LDA.dim=1

figure;ppatterns(data_LDA)
title('LDA reduction to 1D')
