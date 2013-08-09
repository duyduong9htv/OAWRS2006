function LUARSDatabaseConnector

config = LUARS_CONFIG;
DatabaseRootDir = fullfile(config.luarsRoot, 'Database');

javaaddpath(fullfile(DatabaseRootDir,'Java Code/luarsEntities/dist/luarsEntities.jar'));
addpath(genpath(fullfile(DatabaseRootDir, 'Matlab Code')));
