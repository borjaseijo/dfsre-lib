function [ output_args ] = change_header_test( dataTrainFileName, dataTestTempFileName, dataTestFileName)
%CHANGE_HEADER_TEST Summary of this function goes here
%   Detailed explanation goes here

    fidtrain = fopen(dataTrainFileName,'r');
    fidtemptest = fopen(dataTestTempFileName,'r');
    fidtest = fopen(dataTestFileName,'w+');

    while (fidtrain==-1)
        fidtrain = fopen(dataTrainFileName,'r');
        pause(2);
    end
    while (fidtemptest==-1)
        fidtemptest = fopen(dataTestTempFileName,'r');
        pause(2);
    end
    while (fidtest==-1)
        fidtest = fopen(dataTestFileName,'w+');
        pause(2);
    end

    line = fgets(fidtrain);
    while (~strncmp(line, '@data', 5))
        fprintf(fidtest,'%s',line);
        line = fgets(fidtrain);
    end
    fprintf(fidtest,'%s',line);
    line = fgets(fidtemptest);
    
    while (~strncmp(line, '@data', 5))
        line = fgets(fidtemptest);
    end
    line = fgets(fidtemptest);
    while (~feof(fidtemptest))
        fprintf(fidtest,'%s',line);
        line = fgets(fidtemptest);
    end
    fprintf(fidtest,'%s',line);
    
    fclose(fidtrain);
    fclose(fidtemptest);
    fclose(fidtest);
    output_args = 1;
end