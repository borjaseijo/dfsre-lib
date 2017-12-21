function [result] = fmulc(dataset, classes)
% fisher discrimant ratio for multiple classes


[nsamples, nfeats] = size(dataset);
class = dataset(:,end);

if (nfeats==1)
    result = 9999999;
else



    nclasses = length(classes);



    f_feats = zeros(1,nfeats-1);

    auxdatasets = {};
    samples_per_class = zeros(1,nclasses); 
    proportions = zeros(1,nclasses);


    for c=1:nclasses
        auxdatasets{c} = dataset(class==classes{c},:);
        samples_per_class(c) = size(auxdatasets{c},1);
        proportions(c) = samples_per_class(c)/nsamples;
    end


    for i=1:nfeats-1,


    sumMean = 0;
    sumVar = 0;


        for c=1:nclasses,

            datasetC = auxdatasets{c}(:,i);

            for k=(c+1):nclasses,

                datasetK = auxdatasets{k}(:,i);

                sumMean = sumMean + (((mean(datasetC) - mean(datasetK))^2) * proportions(c) * proportions(k));

            end

            sumVar = sumVar + (var(datasetC) * proportions(c));
        end

        f_feats(i) = sumMean/sumVar;

    end



    %We return 1/f such that a small value represents an easy problem
    result= 1./f_feats;
    %result = 1/max(f_feats);
end
    
   


end

