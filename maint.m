function maint()
    imagesEPSContrast();
    % imagesEPSNoise();
end

% generates images showing the noise generation and the denoising 
function imagesEPSNoise(I)
    dicom = dicomread('0001/62199100.dcm');
    dicom = reduceWorkArea(dicom);
    dicom = f12to16bits(dicom);

    I = dicom(50:600, 900:1300);

    imageWithNoise = imnoise(I, 'salt & pepper', 0.1);
    imageWithoutNoise = adpmedian(imageWithNoise, 7);

    fig = figure;
    imshow(imageWithNoise);
    colormap bone;
    print(fig, '-dpsc2', 'images/noise/close-up-with-noise.eps');    

    imshow(imageWithoutNoise);
    colormap bone;
    print(fig, '-dpsc2', 'images/noise/close-up-denoised-image.eps');    
end

% generates images and histograms before and after the contrast enhancement
function imagesEPSContrast()
    dicom = dicomread('0001/62199132.dcm');
    dicom = reduceWorkArea(dicom);
    dicom = f12to16bits(dicom);
    I = dicom(1500:2300, 600:1300);
    I = adpmedian(I, 7);

    imageAfterCLAHE = adapthisteq(I, 'cliplimit', 0.0025, ...
                                 'numtiles', [10 10], 'nbins', 256, ...
                                 'distribution', 'exponential');
    
    fig = figure;
    imshow(I); colormap bone;
    print(fig, '-dpsc2', 'images/contrast/before-clahe.eps');    

    [data, x] = imhist(I); 
    bar(data); grid on; axis off; title('Histogram before CLAHE');
    print(fig, '-dpsc2', 'images/contrast/before-clahe-hist.eps');    

    imshow(imageAfterCLAHE); colormap bone;
    print(fig, '-dpsc2', 'images/contrast/after-clahe.eps');    

    [data, x] = imhist(imageAfterCLAHE); 
    bar(data); grid on; axis off; title('Histogram after CLAHE');
    print(fig, '-dpsc2', 'images/contrast/after-clahe-hist.eps');    
end
