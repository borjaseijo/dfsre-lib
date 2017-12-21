function [suO, indO] = FS_P(inputTrain, nClasses, nAttribs, wekapath)

s = evalc(['!java ', wekapath, ' -Xmx4g  weka.classifiers.functions.MultilayerPerceptron -L 0.3 -M 0.2 -N 500 -V 0 -S 0 -E 20 -H 0 -R -t "', inputTrain, '"']);

result = cell(1,nClasses);
   
for n = 1:nClasses-1

    i = findstr(['Sigmoid Node ',int2str(n-1)],s);
    aux = s([i+14:length(s)]);
    in = findstr('    Attrib',aux);
    f = findstr('Sigmoid',aux);
    result{n} = aux([in(1):f(1)-1]);
%     fid = fopen(['PesosClase',int2str(n),'.txt'], 'w');
%     fprintf(fid,result);
%     fclose(fid);

end

% For the last class

i = findstr(['Sigmoid Node ',int2str(nClasses-1)],s);
aux = s([i+14:length(s)]);
in = findstr('    Attrib',aux);
f = findstr('Class',aux);
result{nClasses} = aux([in(1):f(1)-1]);
% fid = fopen(['PesosClase',int2str(nClasses),'.txt'], 'w');
% fprintf(fid,result);
% fclose(fid);


a = zeros(nAttribs,nClasses);


% Do the sum
for n = 1:nClasses
    a(:,n) = sscanf(result{n}, ' Attrib at%*d %g');
%     a{n} = reshape(a{n},2,[]);
end

su = sum(abs(a),2);

[suO, indO] = sort(su,1,'descend');
% Do the transposed matrix
indO = indO';