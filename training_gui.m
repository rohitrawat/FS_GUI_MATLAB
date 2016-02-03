function training_gui
% FS GUI
% Rohit Rawat
% Feb 2, 2016
% rohitrawat@gmail.com
close all;

   training_file = '';
   validation_file = '';
   testing_file = '';
   weights_file = '';
   lastDir = '';
   
   pre_fill = false;
   if(exist('history.mat', 'file'))
       load('history.mat');
       pre_fill = true;
   else
       lastDir = pwd;
   end
 
   vOrigin = 15;
   vHeight = 25;
   vGap = 10;
   hOrigin = 10;
   hGap = 10;
   hTotalWidth = 800;
   vTotalHeight = 600;
   
   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[10,10,hTotalWidth,vTotalHeight],'Name',resources('TrainTitle'),'NumberTitle','off','Menubar','none','Color',[0.8 0.8 0.8]);
   
   labelWidths = 150;
   buttonWidths = 150;
   
    function [h tr bl] = makeControl(tl, sz, style, string, callback)
        if(nargin < 5)
            callback = [];
        end
        if(numel(sz)==1)
            sz = [sz vHeight];
        end
        if(strcmpi(style, 'edit'))
            color = [1 1 1];
        else
            color = [0.8 0.8 0.8];
        end
        h = uicontrol('Style',style,'String',string,...
          'Position',[tl(1),vTotalHeight-tl(2)-sz(2),sz(1),sz(2)],...
          'Callback',callback,'BackgroundColor',color);
        tr = tl+[sz(1)+hGap 0];
        bl = tl+[0 sz(2)+vGap];
    end
   
   row = 1;
   tl = [hOrigin vOrigin+(row-1)*vHeight];
   [htextTrgFile tr bl] = makeControl(tl, labelWidths, 'text', 'Training File');
   [heditTrgFile tr bl] = makeControl(tr, 3*labelWidths, 'edit', '');
   [hbuttonBrowseTrgFile tr bl] = makeControl(tr, buttonWidths, 'pushbutton', 'Select File..', @browse_Callback);
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [hcheckValFile tr bl] = makeControl(tl, round(labelWidths), 'checkbox', 'Use Validation File', @valfileOn_Callback);
   [heditValFile tr bl] = makeControl(tr, 3*labelWidths, 'edit', '');
   [hbuttonBrowseValFile tr bl] = makeControl(tr, buttonWidths, 'pushbutton', 'Select File..', @browse_Callback);
   set(hcheckValFile, 'Value', 1);
   
   if(resources('DisableValidation'))
       set(hcheckValFile,  'Visible', 'off');
       set(heditValFile,  'Visible', 'off');
       set(hbuttonBrowseValFile,  'Visible', 'off');
       valfileOn = false;
       validation_file = '';
       set(hcheckValFile, 'Value', 0);
       set(heditValFile,  'String', '');
   end
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextType tr bl] = makeControl(tl, labelWidths, 'text', 'File Type');
%    bg = uibuttongroup('Visible', 'off', 'Units', 'pixels', 'Position',[[tr(1) vTotalHeight-tr(2)] 3*labelWidths vHeight*2]);
   bg = uibuttongroup('Visible', 'off', 'Units', 'pixels', 'Position',[0 0 1 1]); % did not work at correct locations
   [hradioTypeReg tr bl] = makeControl(tr, labelWidths, 'radiobutton', 'Regression');
   [hradioTypeCls tr bl] = makeControl(tr, buttonWidths, 'radiobutton', 'Classification');
   set(hradioTypeReg, 'parent', bg);
   set(hradioTypeReg, 'Value', 1);
   set(hradioTypeCls, 'Value', 0);
   set(hradioTypeCls, 'parent', bg);
   set(bg, 'Visible', 'on');
   if(resources('FixedType')==1)
       set(hradioTypeReg, 'Enable', 'off');
       set(hradioTypeCls, 'Enable', 'off');
   elseif(resources('FixedType')==2)
       set(hradioTypeReg, 'Value', 0);
       set(hradioTypeCls, 'Value', 1);
       set(hradioTypeReg, 'Enable', 'off');
       set(hradioTypeCls, 'Enable', 'off');
   end
       
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextInputs tr bl] = makeControl(tl, labelWidths, 'text', resources('N'));
   [heditInputs tr bl] = makeControl(tr, labelWidths, 'edit', '');
   if(length(resources('N'))==0)
       set(htextInputs, 'Visible', 'off');
       set(heditInputs, 'Visible', 'off');
       set(heditInputs, 'String', '0');
   end
 
   [htextOutputs tr bl] = makeControl(tr, labelWidths, 'text', resources('M'));
   [heditOutputs tr bl] = makeControl(tr, labelWidths, 'edit', '');
   if(length(resources('M'))==0)
       set(htextOutputs, 'Visible', 'off');
       set(heditOutputs, 'Visible', 'off');
       set(heditOutputs, 'String', '0');
   end
   
   [hbuttonTrain tr bl] = makeControl(tr, buttonWidths - hOrigin, 'pushbutton', 'START', @train_Callback);
   [htextStatus1 tr bl] = makeControl(tr, round(labelWidths/2), 'text', 'Status:');
   [htextStatus tr bl] = makeControl(tr, labelWidths, 'text', 'Ready.');
   set(htextStatus, 'HorizontalAlignment', 'left');
   set(hbuttonTrain, 'FontWeight', 'bold');

 
   row = row+2;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextTrgErr tr bl] = makeControl(tl, labelWidths, 'text', 'Best subset size:');
   [heditTrgErr tr bl0] = makeControl(tr, labelWidths, 'edit', '');
   set(heditTrgErr, 'Enable', 'off');
   tlPlot = tr;
 
   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [htextValErr tr bl] = makeControl(bl, labelWidths, 'text', 'Selected columns:');

   row = row+1;
   tl = [hOrigin vOrigin+(row-1)*(vHeight+vGap)];
   [heditValErr tr bl] = makeControl(tl, [labelWidths*2 200], 'edit', '');
   set(heditValErr, 'Enable', 'off');
 
   [hbuttonHelp tr bl] = makeControl(bl, buttonWidths, 'pushbutton', 'Show table', @help_Callback);

   [hbuttonHelp tr bl] = makeControl(bl, buttonWidths, 'pushbutton', 'Help', @help_Callback);

%    message = [{'Image Processing and Neural Networks Lab'; 'The University of Texas at Arlington'; ''}; resources('Info'); {''; 'GUI Author: Rohit Rawat'}];
%    [htextInfo tr bl] = makeControl(tlPlot, [350 200], 'text', message);
   
   tl = tlPlot;
   sz = [400 300];
   hPlot = axes('Units','pixels', 'Position', [tl(1)+50,vTotalHeight-tl(2)-sz(2),sz(1),sz(2)]);
   tr = tl+[sz(1)+hGap 0];
   bl = tl+[0 sz(2)+vGap];
   axis([1 10 0 100]);
   xlabel('Subset size (N_1)')
%    ylabel('Accuracy');
   
   
   % dummies
   Nh = 0;
   Nit = 0;
   Extra = 0;
   [heditNh tr bl] = makeControl(tr, labelWidths, 'edit', '');
   [heditNit tr bl] = makeControl(tr, labelWidths, 'edit', '');
   [heditExtra tr bl] = makeControl(tr, labelWidths, 'edit', '0');
   set(heditNh, 'Visible', 'off');
   set(heditNit, 'Visible', 'off');
   set(heditExtra, 'Visible', 'off');


   if(pre_fill)
       set(heditTrgFile, 'String', training_file);
       set(heditValFile, 'String', validation_file);
       if(resources('FixedType')==0)
           if(file_type == 1)
               set(hradioTypeReg, 'Value', 1);
               set(hradioTypeCls, 'Value', 0);
           else
               set(hradioTypeReg, 'Value', 0);
               set(hradioTypeCls, 'Value', 1);
           end
       end
       
       set(heditInputs, 'String', num2str(N));
       set(heditOutputs, 'String', num2str(M));
%        set(heditNh, 'String', num2str(Nh));
%        set(heditNit, 'String', num2str(Nit));
       set(hcheckValFile, 'Value', valfileOn);
       valfileOn_Callback();
   end
 
   % Initialize the GUI.
   % Change units to normalized so components resize 
   % automatically.
   % set([f,ha,hsurf,hmesh,hcontour,htext,hpopup],'Units','normalized');
   
   % Move the GUI to the center of the screen.
   movegui(f,'center')
   % Make the GUI visible.
   set(f,'Visible','on');
 
   %  Callbacks for simple_gui. These callbacks automatically
   %  have access to component handles and initialized data 
   %  because they are nested at a lower level.
 
   %  Browse button callback.
      function browse_Callback(source,eventdata) 
         % Determine the browse button
         switch source;
         case hbuttonBrowseTrgFile
            dtitle = 'Select training file..';
         case hbuttonBrowseValFile
            dtitle = 'Select validation file..';
         end
         [FileName,PathName] = uigetfile(fullfile(lastDir,'*.*'), dtitle); %lastDir
         if(FileName==0)
             return;
         end
         lastDir = PathName;
         filename = fullfile(PathName,FileName);
         switch source;
         case hbuttonBrowseTrgFile
            training_file = filename;
            set(heditTrgFile, 'String', filename);
         case hbuttonBrowseValFile
            validation_file = filename;
            set(heditValFile, 'String', filename);
         end
      end
  
    function valfileOn_Callback(source,eventdata)
        valfileOn = get(hcheckValFile, 'Value');
        if(valfileOn)
            set(heditValFile, 'Visible', 'on');
            set(hbuttonBrowseValFile, 'Visible', 'on');
        else
            set(heditValFile, 'Visible', 'off');
            set(hbuttonBrowseValFile, 'Visible', 'off');
        end
    end
  
   % Train button callback.
 
   function train_Callback(source,eventdata) 
        training_file = get(heditTrgFile, 'String');
        if(exist(training_file, 'file') == 0)
            msgbox(sprintf('Training file does not exist:\n%s', training_file));
            return;
        end
        
        valfileOn = get(hcheckValFile, 'Value');
        if(valfileOn)
            validation_file = get(heditValFile, 'String');
            if(exist(validation_file, 'file') == 0)
                msgbox(sprintf('Validation file does not exist:\n%s', validation_file));
                return;
            end
        else
            validation_file = 'SPLIT_IT';
        end
        
        file_type = get(hradioTypeReg, 'Value');
        strN = get(heditInputs, 'String');
        N = str2double(strN);
        if(~isempty(resources('N')) && (isnan(N) || N<1 || N>10000))
            msgbox(sprintf('N is invalid:\n%d', N));
            return;
        end
        strM = get(heditOutputs, 'String');
        M = str2double(strM);
        if(~isempty(resources('M')) && (isnan(M) || M<1 || M>10000))
            msgbox(sprintf('M is invalid:\n%d', M));
            return;
        end
%         strNh = get(heditNh, 'String');
%         Nh = str2double(strNh);
%         if(~isempty(resources('Nh')) && (isnan(Nh) || Nh<1 || Nh>10000))
%             msgbox(sprintf('Nh is invalid:\n%d', Nh));
%             return;
%         end
%         strNit = get(heditNit, 'String');
%         Nit = str2double(strNit);
%         if(~isempty(resources('Nit')) && (isnan(Nit) || Nit<1 || Nit>10000))
%             msgbox(sprintf('Nit is invalid:\n%d', Nit));
%             return;
%         end
%         strExtra = get(heditExtra, 'String');
%         Extra = str2double(strExtra);
%         if(~isempty(resources('Extra')) && isnan(Extra))
%             msgbox(sprintf('%s is invalid:\n%d', resources('Extra'), Extra));
%             return;
%         end
        
        weights_file = resources('weights_file');

        save('history.mat', 'training_file', 'N', 'M', 'Nh', 'Nit', 'validation_file', 'lastDir', 'file_type', 'valfileOn', 'testing_file', 'weights_file');
        
%         if(file_type == 1)
%             set(htextTrgErr, 'String', 'Training Error (MSE)');
%             set(htextValErr, 'String', 'Validation Error (MSE)');
%         else
%             set(htextTrgErr, 'String', 'Training Error (% error)');
%             set(htextValErr, 'String', 'Validation Error (% error)');
%         end
        
%         old_path = path;
%         addpath(fullfile('..','hwo_molf_pruning'));
        set(htextStatus, 'String', 'Working...');
        drawnow;
        try
            delete('plnSelectionResults.txt')
            delete('plnValidationResults.txt')
            delete('final_feature_order.txt')
            [selected_subset] = training_program_interface(training_file, N, M, Nh, Nit, validation_file, file_type, Extra);
            set(htextStatus, 'String', 'Ready.');
            set(heditTrgErr, 'String', length(selected_subset));
            set(heditValErr, 'String', sprintf('%d, ', selected_subset));
            set(heditValErr, 'Enable', 'on');
            
            [all_subsets all_errors] = read_featsel_results('plnSelectionResults.txt', N);
            [all_subsets_v all_errors_v] = read_featsel_results('plnValidationResults.txt', N);

            axis([1 N 0 0.0001])
            plot([all_errors all_errors_v], '.-');
            u = axis();
            u(1) = 1;
%             u(2) = N;
            axis(u);
            xlabel('Subset size (N_1)')
            if(file_type == 1)
                ylabel('MSE');
            else
                ylabel('Accuracy');
            end
            legend('Training', 'Validation');

        catch err
            % Display any other errors as usual.            
            set(htextStatus, 'String', 'Error! See console.');
            set(heditTrgErr, 'String', 'failed');
            set(heditValErr, 'String', 'failed');
%             path(old_path);
            disp(err);
            disp(err.message);
            for i=1:length(err.stack)
                fprintf('In %s, function: %s, line %d\n', err.stack(i).file, err.stack(i).name, err.stack(i).line);
            end
            disp(err.identifier);
            if(strcmp(err.stack(1).name, 'read_approx_file') || strcmp(err.stack(1).name, 'read_class_file'))
                msgbox('There was a problem reading in the file. Check that you specified the correct number of inputs and outputs, selected the correct file type, and the file uses space delimiters only. See the console for details.');
            else
                msgbox('There was a problem. See the console for details.');
            end
        end
   end

   function test_Callback(source,eventdata)
       testing_gui();
   end

   function help_Callback(source,eventdata)
       if(exist(fullfile(pwd,'README.HTML'), 'file'))
           open('README.HTML');
       elseif(exist(fullfile(pwd,'README.MD'), 'file'))
           edit('README.MD');
       elseif(exist(fullfile(pwd,'README.TXT'), 'file'))
           edit('README.TXT');
       else
           msgbox('Readme not found.');
       end
   end

 
end
