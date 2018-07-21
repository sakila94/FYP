% ------------------------------------------------------------ %
% @author - Harindu Ashan
% @institute - University of Moratuwa
%
% @info - 
% @ref - 
% ------------------------------------------------------------ %

folderPath = pwd;
addpath(fullfile(folderPath, 'func_stip'));
addpath(fullfile(folderPath, 'func_stip/diff_masks'));
addpath(fullfile(folderPath, 'func_stip/basic_funcs'));
addpath(fullfile(folderPath, 'func_stip/harris_funcs'));

% The relevant path must be given which contains the dataset
% in the folder "Videos". 
folderPath = sprintf('%s/Videos', folderPath);
fileList = dir(folderPath);
videoNames = {fileList.name};

tempList = [];

for index = 1 : length(videoNames) - 2
	% ----------------------------------------- %
	% Testing the output
	fprintf('Video Number: %d out of %d\nVideo Name: %s\n',...
		index, length(videoNames) - 2, fileList(index + 2).name) 

	vidNameAndFormat = fileList(index + 2).name;

	tempList = [tempList string(split(fileList(index + 2).name, '.'))];
	% ----------------------------------------- %

	% ----------------------------------------- %
	% Extract the STIP points
	[stipArray] = stipFeatExtract(folderPath, tempList(1, index), tempList(2, index));
	% ----------------------------------------- %

	% ----------------------------------------- %
	% Create text file having video name and then
	% save the stip points in the file and move
	% it to the final Output folder.
	tempFile = sprintf('%s.txt', tempList(1, index));

	% Copying the stips in the text file
    fileID = fopen(tempFile, 'wt');
    for ii = 1 : size(stipArray, 1)
        fprintf(fileID, '%g\t', stipArray(ii, :));
        fprintf(fileID, '\n');
    end
    fclose(fileID);
    clear stipArray;
	% ----------------------------------------- %

	% ----------------------------------------- %
	% Move file into the Output folder
	movefile(tempFile, 'Output');
	clear tempFile;
	% ----------------------------------------- %
	fprintf('Done!\n\n')

end

fprintf('Complete!!!\n')