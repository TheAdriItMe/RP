T=readtable('C:\Users\natib\OneDrive\Documentos\4º ano 2 semestre\RP\weatherAUS.csv');
%exclude the variable RISK_MM
T.RISK_MM=[];
% not consider features that has more than 20% of missing values
size_T=size(T);
eliminate=zeros(1,23);
thresh=0.2*size_T(1);
for i=3:size_T(2)-1
    count=0;
    do=1;
    while do==1
        for j=1:size_T(1)
            if isequal(T{j,i}{1},'NA')
                count=count+1;
                if count>= thresh
                    eliminate(i)=1;
                    do=0;
                elseif count + (size_T(1)-j)<thresh
                    do=0;
                end
                
            end
        end
    end
end

%eliminate=[6,7,18,19]
Tnew=T;
index=find(eliminate==1);
Tnew(:,index)=[];

%% eliminate measurements (patterns) that has at least one missing value.
remove_pat=[];
size_nT=size(Tnew);
for k = 1:size_nT(1)
    
    search=1;
    while search==1
        for l =2:size_nT(2)
            if isequal(Tnew{k,l}{1},'NA')
                remove_pat=[remove_pat k];
                search=0;
            
            elseif l==size_nT(2)
                search=0;
            end
        end
    end
end
%%
T_final=Tnew;
remove_pat=unique(remove_pat); 
T_final(remove_pat,:)=[];

%% Convert categorical variables into numerical
s=size(T_final);
s1=s(1);
s2=s(2);
Data = string(zeros(s1,s2));
for i = 1:s2
    c=string(T_final.(i));
    Data(:,i)=c;
end

WindGustDir=Data(:,6);
WindDir9am=Data(:,8);
WindDir3pm=Data(:,9);

Data(:,6)=convertToDegree(WindGustDir);
Data(:,8)=convertToDegree(WindDir9am);
Data(:,9)=convertToDegree(WindDir3pm);

%Convert raintToday and tomorrow to binary
raintoday = Data(:,18);
raintommorw = Data(:,19);

for i = 1:s1
    if isequal(raintoday(i),'No')
        raintoday(i)=0;
    else
        raintoday(i)=1;
    end
    
    if isequal(raintommorw(i),'No')
        raintommorw(i)=0;
    else
        raintommorw(i)=1;
    end
end

Data(:,18)=raintoday;
Data(:,19)=raintommorw ;

%eliminate date and location
Data(:,[1 2])=[];

% Convert table into numerical matrix
Data=double(Data);

%% Create data structure
data.X=Data(:,1:end-1)';
data.y=Data(:,end)'; 
data.dim=size(data.X,1); 
data.num_data=size(data.X,2); 
data.name='weatherAUS';

col_names=string(T_final.Properties.VariableNames);
col_names=col_names(3:end);

