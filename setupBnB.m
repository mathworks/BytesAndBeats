function setupBnB
tic
disp('Installing Bytes and Beats toolbox.');
rootDir = fileparts(mfilename('fullpath'));

toolboxFile = fullfile(rootDir, 'Bytes and Beats.mltbx');
toolboxes = matlab.addons.toolbox.installedToolboxes;
if(~isempty(toolboxes) && any(strcmp({toolboxes.Name}, "Bytes and Beats")))

    answer = questdlg('A toolbox named Bytes and Beats is already installed. Would you like to uninstall and reinstall?', ...
        'Reinstall Toolbox', ...
        'Yes', 'No', 'No');
    switch answer
        case 'Yes'
            disp('Installing toolbox. This may take several minutes.');
            toolboxName = toolboxes((strcmp({toolboxes.Name}, "Bytes and Beats")));
            matlab.addons.toolbox.uninstallToolbox(toolboxName);
            matlab.addons.toolbox.installToolbox(toolboxFile);
            disp('Bytes and Beats toolbox installed.');
    end
else
    disp('Installing toolbox. This may take several minutes.');
    matlab.addons.toolbox.installToolbox(toolboxFile);
    disp('BytesAndBeats toolbox installed');
end

disp('Downloading audio files from online repository. This may take several minutes.');

mkdir('zip_files'); % This will store the initially downloaded large zip file
mkdir('audio_files'); % This will be the final destination for all unzipped content

% Music Clips are provided by The Philharmonia Orchestra. The license information can be found at https://philharmonia.co.uk/resources/sound-samples/
unzip("https://philharmonia-assets.s3-eu-west-1.amazonaws.com/uploads/2020/02/12112005/all-samples.zip", "zip_files");
initialUnzipDir = fullfile(pwd, 'zip_files', 'all-samples');
disp('Download and unzip completed.');

zipPattern = fullfile(initialUnzipDir, '*.zip');
zipFiles = dir(zipPattern);

disp(['Processing ', num2str(length(zipFiles)), ' nested zip files...']);

% Process each nested zip file
for k = 1:length(zipFiles)
    disp(['Unzipping file ', num2str(k), ' of ', num2str(length(zipFiles)), ': ', zipFiles(k).name]);

    [~, zipName, ~] = fileparts(zipFiles(k).name);

    % Handle special case renaming
    if strcmp(zipName, 'cor anglais')
        zipName = 'english horn';
    end

    unzipTargetDir = fullfile(pwd, 'audio_files', zipName);

    if ~exist(unzipTargetDir, 'dir')
        mkdir(unzipTargetDir);
    end

    zipFilePath = fullfile(initialUnzipDir, zipFiles(k).name);
    unzip(zipFilePath, unzipTargetDir); % Using MATLAB's unzip

    delete(zipFilePath);
end

rmdir('zip_files', 's');
disp('Audio files installed.');

cd(rootDir)

disp('Course setup complete');
toc
end

% © COPYRIGHT 2024 by The MathWorks®, Inc.