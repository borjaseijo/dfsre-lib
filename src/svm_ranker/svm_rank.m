function [ output_rank ] = svm_rank( input_ranks, rootDir, cParam )

trainFile = [rootDir filesep 'svm_ranker' filesep 'svmrank_train.dat'];
testFile = [rootDir filesep 'svm_ranker' filesep 'svmrank_test.dat'];
modelFile = [rootDir filesep 'svm_ranker' filesep 'svmrank_model.dat'];
predictionsFile = [rootDir filesep 'svm_ranker' filesep 'svmrank_predictions.dat'];

N_nodes = length(input_ranks);
N_features = length(input_ranks{1});

fid = fopen(trainFile, 'w');
% fid = 1;
sprintf('Create Train file %d', fid)
for r = 1:N_nodes
    sprintf('Train N_nodes %d', r)
    %str_aux = sprintf('# Node %d\n', r);
    fprintf(fid, '# Node %d\n', r);
    for k = N_features:-1:1
        str_aux = sprintf('%d qid:%d ', k, r);
        %fprintf(fid, '%d qid:%d ', k, r);
        for l = 1:N_features
            %fprintf(fid, '%d:', l);
            if l == input_ranks{r}(N_features-k+1)
                str_aux = sprintf('%s%d:1', str_aux, l);
                %fprintf(fid, '1');
            else
                str_aux = sprintf('%s%d:0', str_aux, l);
                %fprintf(fid, '0');
            end
            if l == N_features
                str_aux = sprintf('%s\n', str_aux);
                %fprintf(fid, '\n');
            else
                str_aux = sprintf('%s ', str_aux);
                %fprintf(fid, ' ');
            end
        end
        fprintf(fid, '%s', str_aux);
    end
end
fclose(fid);
sprintf('Close Train file')

fid = fopen(testFile, 'w');
% fid = 1;
sprintf('Create Test file %d', fid)
fprintf(fid, '# Test file\n');

for k = N_features:-1:1
    %fprintf(fid, '%d qid:%d ', k, N_nodes+1);
    str_aux = sprintf('%d qid:%d ', k, N_nodes+1);
    for l = 1:N_features
        %fprintf(fid, '%d:', l);
        if l == N_features-k+1
            str_aux = sprintf('%s%d:1', str_aux, l);
            %fprintf(fid, '1');
        else
            str_aux = sprintf('%s%d:0', str_aux, l);
            %fprintf(fid, '0');
        end
        if l == N_features
            str_aux = sprintf('%s\n', str_aux);
            %fprintf(fid, '\n');
        else
            str_aux = sprintf('%s ', str_aux);
            %fprintf(fid, ' ');
        end
    end
    fprintf(fid, '%s', str_aux);
end
sprintf('Close Test file')
fclose(fid);

s = evalc(['!"' rootDir filesep 'svm_ranker' filesep 'svm_rank_learn" -c ' int2str(cParam) ' "' trainFile '" "' modelFile '"']);
s = evalc(['!"' rootDir filesep 'svm_ranker' filesep 'svm_rank_classify" "' testFile '" "' modelFile '" "' predictionsFile '"']);


fid = fopen(predictionsFile, 'r');
sprintf('Open Prediction file %d', fid)
values = zeros(N_features,1);
k = 1;
while 1
    line = fgetl(fid);
    if ~ischar(line)
        break;
    end
    values(k) = str2double(line);
    k = k+1;
end
sprintf('Close Prediction file')
fclose(fid);

[aux,output_rank] = sort(values, 1, 'descend');

delete (trainFile);
delete (testFile);
delete (predictionsFile);
end

