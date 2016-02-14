function start()
%RUN_TRAINING A GUI for training a neural network.
%
%  This program is a graphical user interface for running various neural
%  network training program from the Image Processing and Neural Networks
%  Lab (IPNNL) at The University of Texas at Arlington.
% 
%  This program launches appropriate training software supplied with this
%  package. Please locate and read the documentation supplied with those 
%  programs.
%
%  See also RESOURCES, RUN_TESTING.

%  Rohit Rawat (rohitrawat@gmail.com), 08-23-2015
%  $Revision: 1 $ $Date: 23-Aug-2015 15:50:31 $

p = fileparts(mfilename('fullpath'));
cd(p);

required_modules = {'training_gui', 'resources', 'training_program_interface'};
for f=1:length(required_modules)
    if(~exist(fullfile(pwd, [required_modules{f} '.m']), 'file') && ~exist(fullfile(pwd, [required_modules{f} '.p']), 'file'))
        message = {['Missing module: ' required_modules{f}]; 
            'Please ensure that you unzipped all the files in the archive';
            'The current folder is:';
            pwd;
            'Please change the current folder to where all the files exist.'};
        disp(message);
        msgbox(message);
        return;
    end
end

code_directory = fullfile(pwd,resources('CodeDirectory'));
if(exist(code_directory, 'dir'))
    addpath(code_directory);
else
    message = {['Missing folder: ' resources('CodeDirectory')]; 
        'Please ensure that you unzipped all the files in the archive';
        'The current folder is:';
        pwd;
        'Please change the current folder to where all the files exist.'};
    disp(message);
    msgbox(message);
    return;
end

training_gui();
