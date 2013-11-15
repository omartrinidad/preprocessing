function maint()
    imagesEPSContrast();
    % imagesEPSNoise();
    % imagesEPSBits();
end

% generates images in 12 and 16 bits
function imagesEPSBits()
    dicom = dicomread('col/17/lmlo.dcm'); %in article: 1,rmlo

    reducedImage = reduceWorkArea(dicom);
    fig = figure;
    imshow(reducedImage); colormap bone;
    print(fig, '-djpeg', 'images/bits/12bits.jpg');    

    convertedImage = f12to16bits(reducedImage);
    imshow(convertedImage); colormap bone;
    print(fig, '-djpeg', 'images/bits/16bits.jpg');    
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
    print(fig, '-djpeg', 'images/noise/close-up-with-noise.jpg');    

    imshow(imageWithoutNoise);
    colormap bone;
    print(fig, '-djpeg', 'images/noise/close-up-denoised-image.jpg');    
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
    print(fig, '-djpeg', 'images/contrast/before-clahe.jpg');    

    [data, x] = imhist(I); 
    bar(data); grid on;
    set(gca,'box', 'on', 'linewidth', 2.5, 'fontsize', 16);
    xlabel('Range of Intensity', 'fontsize', 23);
    ylabel('Frequency', 'fontsize', 23);
    print(fig, '-djpeg', 'images/contrast/before-clahe-hist.jpg');    

    imshow(imageAfterCLAHE); colormap bone;
    print(fig, '-djpeg', 'images/contrast/after-clahe.jpg');    

    [data, x] = imhist(imageAfterCLAHE); 
    bar(data); grid on; 
    set(gca,'box', 'on', 'linewidth', 2.5, 'fontsize', 16);
    xlabel('Range of Intensity', 'fontsize', 23);
    ylabel('Frequency', 'fontsize', 23);
    print(fig, '-djpeg', 'images/contrast/after-clahe-hist.jpg');    
end
