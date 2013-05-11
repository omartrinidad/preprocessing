dicom = dicomread('files_no_used/case2/im52');
dicom = f12to16bitsm(dicom);
dicom = reduceWorkArea(dicom);
dicom = adapthisteq(dicom);

[newData dicomReduced] = shrinkHistogram(dicom, 16);

%fig = figure;
%subplot(2, 2, 1);
%imshow(dicom);
%caption = sprintf('16 bits mammogram');
%title(caption, 'FontSize', 14, 'Color', 'b');
%
%subplot(2, 2, 2);
%imshow(dicomReduced);
%caption = sprintf('Image shrinked');
%title(caption, 'FontSize', 14, 'Color', 'b');
%
%subplot(2, 2, 3);
%imhist(dicom);
%caption = sprintf('16 bits mammogram histogram');
%title(caption, 'FontSize', 14, 'Color', 'b');
%
%subplot(2, 2, 4);
%imhist(dicomReduced);
%caption = sprintf('Image shrinked histogram');
%title(caption, 'FontSize', 14, 'Color', 'b');
