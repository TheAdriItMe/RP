function data_norm=scalestd(data)
    
    data_norm=data;

    no_features=data.dim;
    features=data.X;
    norm=zeros(no_features,data.num_data);
    
    for i=1:no_features
        
        dp=std(features(i,:));
        m=mean(features(i,:));
        col=(features(i,:)-m)./dp;
        norm(i,:)=col;
        
    end
    data_norm.X=norm;

end