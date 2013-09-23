function maint()
    % imagesEPSContrast();
    % imagesEPSNoise();
    imagesEPSBits();
end

% generates images in 12 and 16 bits
function imagesEPSBits()
    dicom = dicomread('col/1/rmlo.dcm');

    reducedImage = reduceWorkArea(dicom);
    fig = figure;
    imshow(reducedImage); colormap bone;
    print(fig, '-dpsc2', 'images/bits/12bits.eps');    

    convertedImage = f12to16bits(reducedImage);
    imshow(convertedImage); colormap bone;
    print(fig, '-dpsc2', 'images/bits/16bits.eps');    
end

% generates images showing the noise generation and the denoising 
function imagesEPSNoise()
    dicom = dicomread('col/1/rcc.dcm');
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
    dicom = dicomread('col/1/rmlo.dcm');
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
    bar(data); grid on;
    set(gca,'box', 'on', 'linewidth', 2.5);
    xlabel('Range of Intensity');
    ylabel('Frequency');
    print(fig, '-dpsc2', 'images/contrast/before-clahe-hist.eps');    

    imshow(imageAfterCLAHE); colormap bone;
    print(fig, '-dpsc2', 'images/contrast/after-clahe.eps');    

    [data, x] = imhist(imageAfterCLAHE); 
    bar(data); grid on; 
    set(gca,'box', 'on', 'linewidth', 2.5);
    xlabel('Range of Intensity');
    ylabel('Frequency');
    print(fig, '-dpsc2', 'images/contrast/after-clahe-hist.eps');    
end
