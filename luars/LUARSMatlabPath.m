function LUARSMatlabPath

config = LUARS_CONFIG;
LUARSRootPath = config.luarsRoot;

matlabSubDir = 'Matlab Code';

addpath(genpath(fullfile(LUARSRootPath, 'Visualization', matlabSubDir)));
fprintf('Visualization Directory Added to Path.\n');
addpath(genpath(fullfile(LUARSRootPath, 'General', matlabSubDir)));
fprintf('General Directory Added to Path.\n');
addpath(genpath(fullfile(LUARSRootPath, 'ArrayProcessing', matlabSubDir)));
fprintf('Array Processing Directory Added to Path.\n');
addpath(genpath(fullfile(LUARSRootPath, 'Mapping', matlabSubDir)));
fprintf('Mapping Directory Added to Path.\n');
addpath(genpath(fullfile(LUARSRootPath, 'Database', matlabSubDir)));
fprintf('Database Directory Added to Path.\n');
addpath(genpath(fullfile(LUARSRootPath, 'Whales', matlabSubDir)));
fprintf('Whales Directory Added to Path.\n');