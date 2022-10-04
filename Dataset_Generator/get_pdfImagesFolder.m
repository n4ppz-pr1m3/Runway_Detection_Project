
% function pdfImagesFolder = get_pdfImagesFolder(preDatasetFolder)

% Returns the path to the pdf images folder of a pre-dataset.

% Input :
% preDatasetFolder (string) : pre-dataset folder path

% Output :
% pdfImagesFolder (string) : pdf images folder path

function pdfImagesFolder = get_pdfImagesFolder(preDatasetFolder)
pdfImagesFolder = fullfile(preDatasetFolder, "PDF_Images");
end

