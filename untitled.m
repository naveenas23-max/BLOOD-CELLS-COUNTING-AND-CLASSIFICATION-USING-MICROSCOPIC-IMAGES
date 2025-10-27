clc; clear; close all;

% Step 1: Read the image
img = imread('ImDB1.jpg');
figure, imshow(img), title('Original Microscopic Image');

% Step 2: Convert to HSV color space
hsv_img = rgb2hsv(img);
H = hsv_img(:,:,1);
S = hsv_img(:,:,2);
V = hsv_img(:,:,3);

% Step 3: Preprocessing (filtering)
filtered = medfilt2(V, [3 3]);
figure, imshow(filtered), title('Filtered Image');

% Step 4: Segmentation using thresholding
bw = imbinarize(filtered, 'adaptive', 'ForegroundPolarity','dark','Sensitivity',0.45);
bw = imcomplement(bw);
bw = bwareaopen(bw, 50); % Remove small noise
figure, imshow(bw), title('Binary Segmented Image');

% Step 5: Label connected components
[L, num] = bwlabel(bw);
stats = regionprops(L, 'Area', 'Centroid', 'BoundingBox');

% Step 6: Classification based on area
RBC_count = 0;
WBC_count = 0;
Platelet_count = 0;

figure, imshow(img), title('Detected and Classified Cells');
hold on;
for k = 1:num
    area = stats(k).Area;
    centroid = stats(k).Centroid;
    bbox = stats(k).BoundingBox;
    
    % Thresholds (adjust based on image)
    if area > 1500 && area < 4000
        RBC_count = RBC_count + 1;
        rectangle('Position',bbox,'EdgeColor','r','LineWidth',1.5);
        text(centroid(1), centroid(2), 'RBC','Color','r','FontSize',10);
    elseif area >= 4000
        WBC_count = WBC_count + 1;
        rectangle('Position',bbox,'EdgeColor','b','LineWidth',1.5);
        text(centroid(1), centroid(2), 'WBC','Color','b','FontSize',10);
    elseif area < 1500
        Platelet_count = Platelet_count + 1;
        rectangle('Position',bbox,'EdgeColor','g','LineWidth',1.5);
        text(centroid(1), centroid(2), 'Platelet','Color','g','FontSize',10);
    end
end
hold off;

% Step 7: Display results
fprintf('\n===== BLOOD CELL COUNT RESULTS =====\n');
fprintf('Total RBCs: %d\n', RBC_count);
fprintf('Total WBCs: %d\n', WBC_count);
fprintf('Total Platelets: %d\n', Platelet_count);
