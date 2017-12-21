function [result] = f2_mul (dataset, classes)
    [~, nfeats]=size(dataset);
    class = dataset(:,end);

    nclasses=length(classes);
    auxdatasets={};

    for c=1:nclasses
       auxdatasets{c}=dataset(class==classes{c},:); 
    end

    result=zeros(1, nfeats-1);
    for i=1:nfeats-1,
        for c=1:nclasses,
            datasetC=auxdatasets{c}(:,i);
            for k=(c+1):nclasses,
                datasetK=auxdatasets{k}(:,i);
                minmaxi=min(max(datasetC),max(datasetK));
                maxmini=max(min(datasetC),min(datasetK));
                maxmaxi=max(max(datasetC),max(datasetK));
                minmini=min(min(datasetC),min(datasetK));
            end
            if ( (minmaxi-maxmini) == 0 && (maxmaxi-minmini) == 0)
                result(1,i) = result(1,i) + 1;
            else result(1,i) = result(1,i) + (max(0,minmaxi-maxmini)/(maxmaxi-minmini));
            end
        end
    end
    result = (result-min(result))./(max(result)-min(result));
end

