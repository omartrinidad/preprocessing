function maint()
    dicom = dicomread('0001/62199100.dcm');
    changed = reduceWorkArea(dicom);
    changed = f12to16bits(changed);

    I = changed(50:600, 900:1300);

    imagesEPSNoise(I);
end

% generates images showing the noise generation and the denoising 
function imagesEPSNoise(I)
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

% generates images before and after the contrast enhancement
