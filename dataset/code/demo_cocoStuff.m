% demo_cocoStuff()
%
% Shows the basic usage of the COCO-Stuff dataset.
% Loads an image, the ground-truth annotations and captions.
% Matlab's Vision Toolbox is required to display the captions.
%
% Copyright by Holger Caesar, 2016

% Get images
imageListPath = fullfile(cocoStuff_root(), 'imageLists', 'all.txt');
imageList = textread(imageListPath, '%s'); %#ok<DTXTRD>

% Load an image
imageName = imageList{1};
imagePath = fullfile(cocoStuff_root(), 'images', [imageName, '.jpg']);
image = imread(imagePath);

% Load annotations
labelPath = fullfile(cocoStuff_root(), 'annotations', [imageName, '.mat']);
labelStruct = load(labelPath);
labelMap = labelStruct.S;
labelNames = labelStruct.names;
captions = labelStruct.captions;
regionMapStuff = labelStruct.regionMapStuff;
regionLabelsStuff = labelStruct.regionLabelsStuff;

% Replace stuff labels with class 'unlabeled'
labelMapThings = labelMap;
thingCount = 80;
labelMapThings(labelMapThings > 1+thingCount) = 1;

% Get stuff labels from superpixel labels
labelMapStuff = regionLabelsStuff(regionMapStuff);

% Convert label maps to images
cmap = cmapThingsStuff();
labelMapThingsIm = ind2rgb(labelMapThings, cmap);
labelMapStuffIm = ind2rgb(labelMapStuff, cmap);
labelMapIm = ind2rgb(labelMap, cmap);

% Insert label names into label map image
labelMapThingsIm = imageInsertBlobLabels(labelMapThingsIm, labelMapThings, labelNames);
labelMapStuffIm = imageInsertBlobLabels(labelMapStuffIm, labelMapStuff, labelNames);
labelMapIm = imageInsertBlobLabels(labelMapIm, labelMap, labelNames);

% Open figure
h1 = figure(1);
clf;
h1.Name = 'COCO-Stuff example annotations';

% Show image
subplot(2, 2, 1);
imshow(image);
title('Image');

% Show thing labels
subplot(2, 2, 2);
imshow(labelMapThingsIm);
title('Thing labels');

% Show stuff labels
subplot(2, 2, 3);
imshow(labelMapStuffIm);
title('Stuff labels');

% Show stuff and thing labels
subplot(2, 2, 4);
imshow(labelMapIm);
title('Thing+stuff labels');

% Show captions in another figure
h2 = figure(2);
clf;
h2.Name = 'Image captions';
axis off;
h2.Units = 'pixels';
h2.Position(3) = 800;
h2.Position(4) = 200;
captionsStr = strjoin(captions, '\n');
text(0.5, 0.6, captionsStr, 'HorizontalAlignment', 'center', 'FontSize', 15);