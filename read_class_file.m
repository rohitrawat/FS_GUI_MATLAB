function [x ic Nv] = read_class_file(training_file, N, M)
% Rohit Rawat, 2014

% The following code reads a text file and stores all the paterns in 
% an Nv by (N+1) matrix
fid = fopen(training_file, 'r');
if(fid == -1)
    error('Could not open file %s\n', training_file)
end
training_file_values = fscanf(fid, '%f');
fclose(fid);
Nv = numel(training_file_values)/(N+1);
fprintf('read_class_file: Nv = %d\n', Nv);
if(round(Nv)*(N+1) ~= numel(training_file_values))
    fprintf('N = %d, M = %d, numel(training_file_values) = %d\nNv*(N+1) ~= numel(training_file_values)\n', N, M, numel(training_file_values));
    fprintf('Could not read the file: %s\n', training_file);
end
training_file_values = reshape(training_file_values, [(N+1) Nv])';

% Store the inputs in variable x and the currect class ID in ic
x = training_file_values(:, 1:N);
ic = round(training_file_values(:, N+1));
