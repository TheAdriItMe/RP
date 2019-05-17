function [stotal,redundant]=KruskalWallisRanking(data,col_names)

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
        redundant=[redundant;num2str(r(i))+" and"+ num2str(c(i))];
    end
end

fprintf('Redundant features: ')
redundant