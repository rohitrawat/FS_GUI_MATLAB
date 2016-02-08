temp_files = {'temp_trg.tra', 'temp_val.val', 'original_input_means_std.txt', 'plnResult.txt', 'plnSelectionResults.txt', 'plnValidationResults.txt', 'selectedFeatures.txt', 'stage1aPLN_weights.txt', 'stage1a_rejected_features.txt', 'stage1a_selected_features.txt', 'stage1a_SFS_training_probes.txt', 'stage1a_SFS_training.txt', 'stage1a_SFS_validation.txt', 'stage1bPLN_weights.txt', 'stage1b_rejected_features.txt', 'stage1b_selected_features.txt', 'stage1b_SFS_training_probes.txt', 'stage1b_SFS_training.txt', 'stage1b_SFS_validation.txt', 'stage1cPLN_weights.txt', 'stage1c_rejected_features.txt', 'stage1c_selected_features.txt', 'stage1c_SFS_training_probes.txt', 'stage1c_SFS_training.txt', 'stage1c_SFS_validation.txt', 'stage1_selected_features.txt', 'trg.txt', 'val.txt'};
result_files = {'final_feature_order.txt'};

for i=1:length(temp_files)
    if(exist(temp_files{i}, 'file'))
        delete(temp_files{i});
    end
end

delete(get(0,'CurrentFigure'));
