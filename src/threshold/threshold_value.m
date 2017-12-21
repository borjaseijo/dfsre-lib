function [ numFinalFeatures nomThreshold typeThreshold] = ...
    threshold_value( which, featuresNumber, featsRanking, FisherTrainValue, ...
                     OverlapTrainValue, EfficiencyTrainValue )
% Inputs:
% which - Number to select one of the following kinds of
% thresholds:
%
% 1 - Fisher discrimination ratio
% 2 - log2(n) value
% 3 - 10%
% 4 - 25%
% 5 - 50%
% 6 - 100%

    fisherAlfa = 0.75;
    overlapAlfa = 0.75;
    efficiencyAlfa = 0.75;
    fisherAcum = Inf;
    overlapAcum = Inf;
    efficiencyAcum = Inf;
    
    if (isnumeric(which))
        switch(which)
            case 1, % Fisher discrimination ratio
                nomThreshold = 'Fisher';
                fisherAux = FisherTrainValue(:,featsRanking);
                for f=1:featuresNumber
                    auxFeaturesNumber = f/featuresNumber;
                    fisherMin = fisherAlfa*fisherAux(f) + (1-fisherAlfa)*auxFeaturesNumber;
                    if ( (mod(f,5) == 0) && (fisherMin > fisherAcum) )
                        break;
                    end
                    if (fisherMin < fisherAcum)
                        fisherAcum = fisherMin;
                    end
                end
                numFinalFeatures = f;
                typeThreshold = 1;
            case 2, % Fisher Borja
                nomThreshold = 'Fisher Borja';
                % Se cogen grupos de tantas caracteristicas como marca "log2(n)"
                numElementsGroup = round(log2(featuresNumber));
                fisherAux = FisherTrainValue(:,featsRanking);
                fisherAVG = 0;                
                for f=1:featuresNumber
                    auxFeaturesNumber = f/featuresNumber;
                    fisherAVG = fisherAVG + fisherAlfa*fisherAux(f) + (1-fisherAlfa)*auxFeaturesNumber;
                    if (mod(f,numElementsGroup) == 0)
                        if ( (fisherAVG/numElementsGroup) > (fisherAcum/(f-numElementsGroup)) )
                            break;
                        end
                        if (f == numElementsGroup)
                            fisherAcum = fisherAVG;
                        else
                            fisherAcum = fisherAcum + fisherAVG;
                        end
                        fisherAVG = 0;
                    end
                end
                numFinalFeatures = (f-numElementsGroup);
                typeThreshold = 1;
            case 3, % Overlap region
                nomThreshold = 'Overlap';
                overlapAux = OverlapTrainValue(:,featsRanking);
                for f=1:featuresNumber
                    auxFeaturesNumber = f/featuresNumber;
                    overlapMin = overlapAlfa*overlapAux(f) + (1-overlapAlfa)*auxFeaturesNumber;
                    if ( (mod(f,5) == 0) && (overlapMin > overlapAcum) )
                        break;
                    end
                    if (overlapMin < overlapAcum)
                        overlapAcum = overlapMin;
                    end
                end
                numFinalFeatures = f;
                typeThreshold = 1;
            case 4,  % Overlap Borja
                nomThreshold = 'Overlap Borja';
                % Se cogen grupos de tantas caracteristicas como marca "log2(n)"
                numElementsGroup = round(log2(featuresNumber));
                overlapAux = OverlapTrainValue(:,featsRanking);
                overlapAVG = 0;
                for f=1:featuresNumber
                    auxFeaturesNumber = f/featuresNumber;
                    overlapAVG = overlapAVG + overlapAlfa*overlapAux(f) + (1-overlapAlfa)*auxFeaturesNumber;
                    if (mod(f,numElementsGroup) == 0)
                        if ( (overlapAVG/numElementsGroup) > (overlapAcum/(f-numElementsGroup)) )
                            break;
                        end
                        if (f == numElementsGroup)
                            overlapAcum = overlapAVG;
                        else
                            overlapAcum = overlapAcum + overlapAVG;
                        end
                        overlapAVG = 0;
                    end
                end
                numFinalFeatures = (f-numElementsGroup);
                typeThreshold = 1;
            case 5, % maxfeaeff
                nomThreshold = 'Max Feature Efficiency';
                % Se cogen grupos de tantas caracteristicas como marca "log2(n)"
                numElementsGroup = round(log2(featuresNumber));
                efficiencyAux = EfficiencyTrainValue(:,featsRanking);
                efficiencyAVG = 0;
                for f=1:featuresNumber
                    auxFeaturesNumber = f/featuresNumber;
                    efficiencyAVG = efficiencyAVG + efficiencyAlfa*efficiencyAux(f) ...
                                    + (1-efficiencyAlfa)*auxFeaturesNumber;
                    if (mod(f,numElementsGroup) == 0)
                        if ( (efficiencyAVG/numElementsGroup) > (efficiencyAcum/(f-numElementsGroup)) )
                            break;
                        end
                        if (f == numElementsGroup)
                            efficiencyAcum = efficiencyAVG;
                        else
                            efficiencyAcum = efficiencyAcum + efficiencyAVG;
                        end
                        efficiencyAVG = 0;
                    end
                end
                numFinalFeatures = (f-numElementsGroup);
                typeThreshold = 1;
            case 6, % log2(n) value
                nomThreshold = 'log2';
                numFinalFeatures = round(log2(featuresNumber));
                typeThreshold = 2;
            case 7, % 10%
                nomThreshold = '10%';
                numFinalFeatures = round(0.1*featuresNumber);
                typeThreshold = 3;
            case 8, % 25%
                nomThreshold = '25%';
                numFinalFeatures = round(0.25*featuresNumber);
                typeThreshold = 3;
            case 9, % 50%
                nomThreshold = '50%';
                numFinalFeatures = round(0.50*featuresNumber);
                typeThreshold = 3;
            case 10, % 100%
                nomThreshold = '100%';
                numFinalFeatures = featuresNumber;
                typeThreshold = 3;
            otherwise
                nomThreshold = 'none';
                sprintf(nomThreshold);
                error('threhold:incorrect', 'Incorrect threshold value');
        end;
    else
        error('threhold:incorrect', 'Incorrect threshold value');
    end;

end

