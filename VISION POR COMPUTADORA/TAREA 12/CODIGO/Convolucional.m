%% Mostrar una muestra de imagenes %%
rutae = "WormData.csv";
labelsTable = readtable(rutae);
% Filtrar las imágenes 'alive'
aliveFiles = labelsTable(strcmp(labelsTable.Status, 'alive'), :);
% Filtrar las imágenes 'dead'
deadFiles = labelsTable(strcmp(labelsTable.Status, 'dead'), :);

%% Seleccionar las primeras 2 de cada tipo %%
base = "WormImages\";
subplot(2,2,1)
imagesc(imread(strcat(base,aliveFiles.File{1})))
title("Ejemplo vivos 1")
subplot(2,2,2)
imagesc(imread(strcat(base,aliveFiles.File{2})))
title("Ejemplo vivos 2")
subplot(2,2,3)
imagesc(imread(strcat(base,deadFiles.File{1})))
title("Ejemplo muertos 1")
subplot(2,2,4)
imagesc(imread(strcat(base,deadFiles.File{2})))
title("Ejemplo muertos 2")
colormap("gray")


%% Cargar las imagenes %%
ruta = "WormImages\wormA01.tif"
img = imread(ruta);
%imshow(img)
imagesc(img)
colormap("gray")

%% Tamaño de la imagen %%
size(img)


%% Etiquetas %%
rutae = "WormData.csv";
labelsTable = readtable(rutae);
labelsTable;

%% Cargar todas las imagenes %%
imageFolder = "WormImages";
% Crear un arreglo de imagenDatastore
imds = imageDatastore(fullfile(imageFolder), ...
    'IncludeSubfolders', false, ...
    'FileExtensions', '.tif', ...
    'LabelSource', 'none');


%% Agregar las etiquetas al datastore
imds.Labels = categorical(labelsTable.Status);


%% Dividir los datos %%
rng(64)
[imdsTrain, imdsValidation] = splitEachLabel(imds, 0.8, 'randomized');
% Revisar que sale de aqui
imdsTrain
% Re definir el tamaño de las imagenes
imageSize = [100 100 1]; % Usa 3 en lugar de 1 si es RGB
augmentedTrain = augmentedImageDatastore(imageSize, imdsTrain);
augmentedVal = augmentedImageDatastore(imageSize, imdsValidation);
layers = [
    imageInputLayer(imageSize)
    convolution2dLayer(3, 8, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    convolution2dLayer(3, 16, 'Padding', 'same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2, 'Stride', 2)
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer
];
% Entrenar a la red %%
options = trainingOptions('adam', ...
    'MaxEpochs', 20, ...
    'ValidationData', augmentedVal, ...
    'ValidationFrequency', 5, ...
    'Verbose', true, ...
    'Plots', 'training-progress');
net = trainNetwork(augmentedTrain, layers, options);


%% Evaluar red %%
predictedLabels = classify(net, augmentedVal);
valLabels = imdsValidation.Labels;
accuracy = sum(predictedLabels == valLabels)/numel(valLabels);
fprintf('Precisión en validación: %.2f%%\n', accuracy * 100);

%% Hacer la matriz de confusión %%

confusionchart(imdsValidation.Labels,predictedLabels)

%% Evaluar red por fuera %%
A = classify(net, augmentedVal)

%%
augmentedVal.NumObservations


%% Leer la primera imagen del conjunto de validación
img = readimage(imdsValidation, 19);
% Mostrar la imagen
imagesc(img);
colormap("gray")
title('Imagen de validación');
% Redimensionar (si es necesario)
imageSize = [100 100 1];  % Cambia a [100 100 3] si es RGB
imgResized = imresize(img, imageSize(1:2));
imagesc(imgResized);
colormap("gray")
% Clasificar la imagen con la red entrenada %%
predictedLabel = classify(net, imgResized);
% Mostrar predicción
disp(['La red predice: ' char(predictedLabel)]);

