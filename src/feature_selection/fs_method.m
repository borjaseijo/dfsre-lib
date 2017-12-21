function [resSelection nomSelection] = fs_method(which, inputTrain, XTrain, YTrain, wekapath, nClasses, nAttribs)
% function [selection] = filters(which, inputTrain)
%
% Inputs:
%
%*********************** NEW ****************************%
% which - Number to select one of the following kinds of
% filters:
%
% 1 - ChiSquare
% 2 - InfoGain
% 3 - mRMR
% 4 - ReliefF
% 5 - SVM_RFE
% 6 - FSP
% 7 - CFS-BestFirst
% 8 - CFS-Forward
% 9 - CFS-Greedy-backward
%
% input - Input dataset
%
% Outputs:
%

if (isnumeric(which))
    switch(which)
        case 1, % ChiSquare
            nomSelection = 'ChiSquare';
            sprintf(nomSelection);
            s = evalc(['!java ', wekapath, ' -Xmx4g  weka.attributeSelection.AttributeSelection weka.attributeSelection.ChiSquaredAttributeEval -s "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N -1" -c last -i "', inputTrain, '"']);
            typeFilter = 1;
        case 2, % InfoGain
            nomSelection = 'InfoGain';
            sprintf(nomSelection);
            s = evalc(['!java ', wekapath, ' -Xmx4g  weka.attributeSelection.AttributeSelection weka.attributeSelection.InfoGainAttributeEval -s "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N -1" -c last -i "', inputTrain, '"']);
            typeFilter = 1;
        case 3, % mRMR
            nomSelection = 'mRMR';
            sprintf(nomSelection);
            feat_mrmr = mrmr_mid_d(XTrain,YTrain,nAttribs);
            s = feat_mrmr;
            typeFilter = 2;
        case 4, % ReliefF
            nomSelection = 'ReliefF';
            sprintf(nomSelection);
            s = evalc(['!java ', wekapath, ' -Xmx4g  weka.attributeSelection.AttributeSelection weka.attributeSelection.ReliefFAttributeEval -s "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N -1" -c last -i "', inputTrain, '"']);
            typeFilter = 1;
        case 5, % SVM_RFE
            nomSelection = 'SVMRFE';
            sprintf(nomSelection);
            s = evalc(['!java ', wekapath, ' -Xmx4g  weka.attributeSelection.AttributeSelection weka.attributeSelection.SVMAttributeEval -s "weka.attributeSelection.Ranker -T -1.7976931348623157E308 -N  -1" -c last -i "', inputTrain, '"']);
            typeFilter = 1;
        case 6, % FSP
            nomSelection = 'FSP';
            sprintf(nomSelection);
            [N, FS_P2] = FS_P(inputTrain, nClasses, nAttribs, wekapath);
            s = 'success';
            typeFilter = 3;
        case 7, % CFS-BestFirst
            nomSelection = 'CFS-BestFirst';
            sprintf(nomSelection)
            s = evalc(['!java ', wekapath, ' -Xmx8g weka.attributeSelection.AttributeSelection weka.attributeSelection.CfsSubsetEval -s "weka.attributeSelection.BestFirst -N 5" -c last -i ', inputTrain]);
            typeFilter = 1;
        case 8, % CFS-Forward
            nomSelection = 'CFS-Forward';
            sprintf(nomSelection)
            s = evalc(['!java ', wekapath, ' -Xmx8g weka.attributeSelection.AttributeSelection weka.attributeSelection.CfsSubsetEval -s "weka.attributeSelection.LinearForwardSelection -N 5" -c last -i ', inputTrain]);
            typeFilter = 1;
        case 9, % CFS-Greedy-Backward
            nomSelection = 'CFS-Greedy-Backward';
            sprintf(nomSelection)
            s = evalc(['!java ', wekapath, ' -Xmx8g weka.attributeSelection.AttributeSelection weka.attributeSelection.CfsSubsetEval -s "weka.attributeSelection.GreedyStepwise -N -1 -B" -c last -i ', inputTrain]);
            typeFilter = 1;
        otherwise
            nomSelection = 'none';
            sprintf(nomSelection);
            error('filters:incorrectFilter', 'Incorrect filter');
    end;
else
    error('filters:incorrectFilter', 'Incorrect filter');
end;
if ~isempty(findstr(s, 'Weka exception'))
    error('classifier:wekaProblem', 'Weka exception in filter');
end;

if typeFilter == 2 %mRMR
    resSelection = feat_mrmr;
elseif typeFilter == 3 % FSP
    resSelection = FS_P2;
else
    % Se descomponen la salida que devuelve weka para quedarnos solo con
    % las variables seleccionadas por el filtro
    t=findstr('Selected attributes:',s);
    result2=s([t+20:length(s)]);
    t=findstr(':',result2);
    filtervars=result2([1:t-1]);
    selection = ['[' filtervars ']'];
    resSelection = eval(selection);
end




