function [ pca_coeff, gmm, all_train_files, all_train_labels, all_test_files, all_test_labels ] = pretrain(params)
%PRETRAIN  Subsample STIP features, calculate PCA coefficients and train GMM model
%   Inputs:
%       params - structure of parameters
%       t_type - 'train' or 'test'
%
%   Outputs:
%       pca_coeff - PCA coefficients for each STIP feature
%       gmm - GMM params for each STIP feature

% To construct Fisher vector, fist to estimate the parameters of GMM.
% To estimate GMM params, subsampling vectors from STIP descriptors.

gmm_params.cluster_count=params.K;
gmm_params.maxcomps=gmm_params.cluster_count/4;
gmm_params.GMM_init= 'kmeans';
gmm_params.pnorm = single(2);    % L2 normalization, 0 to disable
gmm_params.subbin_norm_type = 'l2';
gmm_params.norm_type = 'l2';
gmm_params.post_norm_type = 'none';
gmm_params.pool_type = 'sum';
gmm_params.quad_divs = 2;
gmm_params.horiz_divs = 3;
gmm_params.kermap = 'hellinger';

stip_feat_num=length(params.feat_list);
pca_coeff=cell(stip_feat_num,1); % PCA coeficients
gmm=cell(stip_feat_num,1);   % GMM parameters

feat_sample_train=params.train_sample_data;
feat_sample_test=params.test_sample_data;

fprintf('Subsampling STIP features ...\n');
if ~exist(feat_sample_train,'file')
    [feats_train, all_train_files, all_train_labels]=subsample(params,'train');
    save(feat_sample_train, 'feats_train','all_train_labels','all_train_files','-v7.3');
else
    load(feat_sample_train);
end

if ~exist(feat_sample_test,'file')
    [feats_test, all_test_files, all_test_labels]=subsample(params,'test');
    save(feat_sample_test, 'feats_test','all_test_labels','all_test_files','-v7.3');
else
    load(feat_sample_test);
end

for i=1:stip_feat_num
	feat=feats_train{i}; % use both train and test data to gen codebook
	
	% L1 normalization & Square root
	feat=sqrt(feat/norm(feat,1));
	
	% Do PCA on train/test data to half-size original descriptors
	fprintf('Doing PCA ...\n');
	pca_coeff{i} = pca(feat');
% 	pca_coeff{i} = pca_coeff{i}(:, 1:floor(size(feat,1)/2))';
	% dimensionality reduction
	feat = pca_coeff{i} * feat;

	fprintf('Training Guassian Mixture Model ...\n');
	%[gmm{i}.means, gmm{i}.covar, gmm{i}.prior] = vl_gmm(feat, params.K, 'MaxNumIterations', 300);
	gmm{i}=gmm_gen_codebook(feat,gmm_params);
end

end

