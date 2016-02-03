function [x t Nv] = read_approx_file(training_file, N, M)
% Rohit Rawat, 2014

% The following code reads a text file and stores all the paterns in 
% an Nv by (N+M) matrix
fid = fopen(training_file, 'r');
if(fid == -1)
    fprintf('Could not open file %s\n', training_file)
end
training_file_values = fscanf(fid, '%f');
fclose(fid);

NCOLS = N+M;
Nv = numel(training_file_values)/NCOLS;
fprintf('# of patterns in %s = %d\n', training_file, Nv);
if(round(Nv)*(NCOLS) ~= numel(training_file_values))
    fprintf('N = %d, M = %d, numel(training_file_values) = %d\nNv*(N+M) ~= numel(training_file_values)\n', N, M, numel(training_file_values));
    fprintf('Could not read the file: %s\n', training_file);
end
training_file_values = reshape(training_file_values, [NCOLS Nv])';

% Store the inputs in variable x and the currect class ID in ic
x = training_file_values(:, 1:N);
t = training_file_values(:, N+1:end);
