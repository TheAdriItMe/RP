function var = convertToDegree(var)

for i = 1:length(var)
    if(isequal(var(i),'N'))
        var(i)=0.0; 
    
    elseif(isequal(var(i),'NNE'))
        var(i)=22.5000;  
    
    elseif(isequal(var(i),'NE'))
        var(i)=2*22.5000;
        
    elseif(isequal(var(i),'ENE'))
        var(i)=3*22.5000;
        
    elseif(isequal(var(i),'E'))
        var(i)=4*22.5000;
        
    elseif(isequal(var(i),'ESE'))
        var(i)=5*22.5000;
        
    elseif(isequal(var(i),'SE'))
        var(i)=6*22.5000;
        
    elseif(isequal(var(i),'SSE'))
        var(i)=7*22.5000;
    
    elseif(isequal(var(i),'S'))
        var(i)=8*22.5000;
        
    elseif(isequal(var(i),'SSW'))
        var(i)=9*22.5000;   
    
    elseif(isequal(var(i),'SW'))
        var(i)=10*22.5000;
        
    elseif(isequal(var(i),'WSW'))
        var(i)=11*22.5000; 
        
    elseif(isequal(var(i),'W'))
        var(i)=12*22.5000;
        
    elseif(isequal(var(i),'WNW'))
        var(i)=13*22.5000;   
        
    elseif(isequal(var(i),'NW'))
        var(i)=14*22.5000;
        
    elseif(isequal(var(i),'NNW'))
        var(i)=15*22.5000;           
    end
end

