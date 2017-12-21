function [outputARFF] = mat2arff(rootDir, name, matInput, path)
%function [outputARFF] = mat2arff(name,matInput)


outputCSV = [rootDir filesep 'auxcsv.csv'];
outputARFF = name;

[x, y] = size(matInput);

fid = fopen(outputCSV, 'w');
% Se intenta volver a abrir el fichero si fallo la linea anterior.
while (fid == -1)
    pause(1);
    fid = fopen(outputCSV, 'w');
end

%Primera fila, en la que ira la cabecera
for i=1:(y-1)
    r = strcat('at', int2str(i));
    fprintf(fid,'%s,',r);
end
fprintf(fid,'%s\n','class');

%Comprobamos si la clase es numerica. En caso de que lo sea, habra que
%pasarla a nominal
class = matInput(1,y);
isclassnum = isnumeric(class);



for i=1:x
    for j=1:y
        aux = matInput(i,j);
        if j==y
            if isclassnum
                aux = int2str(aux);
                s = strcat('class', aux);
                fprintf(fid,'%s\n',s);
            else
                fprintf(fid,'%s\n',aux);
            end
        else
            fprintf(fid,'%g',aux);
            fprintf(fid,',');
        end
    end
end

fclose(fid);

% Pasamos el fichero .csv a .arff
stringeval=strcat( ['!java ', path, ' -Xmx4g weka.core.converters.CSVLoader "', outputCSV, '" > "',outputARFF, '"']);
s = evalc(stringeval);
delete(outputCSV);