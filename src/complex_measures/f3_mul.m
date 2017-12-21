function [result] = f3_mul(dataset, classes)
    [~, nfeats]=size(dataset);
    class = dataset(:,end);

    nclasses=length(classes);
    auxdatasets={};

    for c=1:nclasses
       auxdatasets{c}=dataset(class==classes{c},:); 
    end

    result=zeros(1, nfeats-1);
    for i=1:nfeats-1,
        efficiency = [];
        for c=1:nclasses,
            datasetC=auxdatasets{c}(:,i);
            for k=(c+1):nclasses,
                datasetK=auxdatasets{k}(:,i);
                minmaxi=min(max(datasetC),max(datasetK));
                maxmini=max(min(datasetC),min(datasetK));
                outoverlap = sum([sum((datasetC<maxmini) | (datasetC>minmaxi)) ...
                                 sum((datasetK<maxmini) | (datasetK>minmaxi))]);
                efficiency = [efficiency outoverlap/(nfeats-1)];
            end
        end
        result(1,i) = max(efficiency);
    end
    result = 1-result;
end

