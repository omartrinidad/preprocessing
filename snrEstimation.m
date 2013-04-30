% signal noise to ratio estimation

function snr = snrEstimation(signalnoise, signal) 
    noise = signalnoise - signal;
    figure, imshow(noise);
    signalmean = mean(signal(:));
    stdnoise = std2(noise(:));
    snr = signalmean/stdnoise;
