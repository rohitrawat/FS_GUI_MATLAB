function [selected_subset] = training_program_interface(training_file, N, M, Nh, Nit, validation_file, file_type, Extra)
%TRAINING_PROGRAM_INTERFACE Wrapper for the training program.
%
%  This program is a wrapper for the real training program. It receives
%  input from the GUI and uses them to call the training code. This allows
%  the same GUI to be used with different kinds of training algorithms by
%  simply modifying this file.
%
%  See also RESOURCES, RUN_TRAINING.

%  Rohit Rawat (rohitrawat@gmail.com), 08-23-2015
%  $Revision: 1 $ $Date: 23-Aug-2015 15:50:31 $

if(strcmp(validation_file, 'SPLIT_IT'))
    disp('Splitting the trainng file to create a validation file.');
    if(file_type == 1)
        [x t Nv] = read_approx_file(training_file, N, M);
    else
        [x t Nv] = read_class_file(training_file, N, M);
    end
    ratio = 0.7;
    Nvt = round(Nv*ratio);
    training_file = 'temp_trg.tra';
    validation_file = 'temp_val.val';
    dlmwrite(training_file, [x(1:Nvt,:) t(1:Nvt,:)], '\t');
    dlmwrite(validation_file, [x(Nvt+1:end,:) t(Nvt+1:end,:)], '\t');
end

if(isunix)
    platform = 'lnx64';
else
    platform = 'win64.exe';
end

if(file_type == 1)
    % call the program for regression case here:
    command = sprintf('./fsbin/fs_reg_%s \"%s\" \"%s\" %d %d %d', platform, training_file, validation_file, N, M, 0);
    system(command);
else
    % call the program for classification case here:
    command = sprintf('./fsbin/fs_class_%s \"%s\" \"%s\" %d %d %d', platform, training_file, validation_file, N, M, 1);
    system(command);
end

if(exist('final_feature_order.txt', 'file'))
    selected_subset = dlmread('final_feature_order.txt')';
else
    selected_subset = [];
end

% selected_subset = [];
