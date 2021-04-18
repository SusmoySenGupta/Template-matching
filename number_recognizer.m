clc;
close all;

%Reading images
database = imread('F:\Projects\matlab\Template-matching\images\database.jpg');
feature  = imread('F:\Projects\matlab\Template-matching\images\9.jpg');

%Converting to gray image
database_gray = rgb2gray(database);
feature_gray  = rgb2gray(feature);


%Converting to intensity image
database_thresh = graythresh(database_gray);
feature_thresh  = graythresh(feature_gray);


%Converting to binary image
database_binary = im2bw(database_gray, database_thresh);
feature_binary  = im2bw(feature_gray, feature_thresh);


%Getting height & width
[database_height, database_width] = size(database_binary);
[feature_height, feature_width] = size(feature_binary);
fprintf('Height and Width of database: %d, %d\n', database_height, database_width);
fprintf('Height and Width of feature: %d, %d\n', feature_height, feature_width);


% Getting the mean value for the feaure
feature_sum = 0;
for i = 1:feature_height
    for j = 1: feature_width
        feature_sum =  feature_sum + feature_binary(i,j);
    end
end
feature_mean = feature_sum / (feature_height * feature_width);
fprintf('Feature sum and mean: %d, %.2f\n', feature_sum, feature_mean);


% Setting up a matrix with the initial value of 0
ncc_value = zeros(1, 10); 

pixel = 1;
for check = 1:10
    % Getting the mean value for each number in the database image
    database_sum = 0;
    for row = 1:database_height
        for column = pixel:pixel + 29
            database_sum = database_sum + database_binary(row, column);
        end
    end
    % Getting the mean value for the each number
    database_mean = database_sum/(database_height * database_width);
    fprintf('For number %d, sum and mean: %d, %.2f\n', check - 1, database_sum, database_mean);
    
    %Applying the formula
    candidate = 0;
    template  = 0;
    numerator = 0;
    denominator_database = 0;
    denominator_candidate = 0;
    for row = 1:database_height
        feature_column = 1;
        for column = pixel:pixel + 29
            candidate = feature_binary(row, feature_column) - feature_mean;
            template  = database_binary(row, column) - database_mean;
            numerator = numerator + ( candidate * template );
            denominator_candidate = denominator_candidate + (candidate * candidate);
            denominator_database = denominator_database + (template * template);
            feature_column = feature_column + 1;
        end
    end
    ncc_value(check) = numerator / sqrt(denominator_candidate * denominator_database);

    pixel = pixel + 30;
end

% Getting the maximum value and it's index
[max_value, index] = max(ncc_value);
fprintf('Max ncc value: %.2f', max_value);

% Plotting
fprintf('\n Matched With %d\n', index-1);
subplot(3,1,1);
imshow( database_binary );
title('Database Image');
subplot(3,1,2);
imshow( feature_binary );
title('Target Image');
subplot(3,1,3);
imshow( database_binary );
title('Best match is shown by red rectangle box');
rectangle('Position',[(index-1)* feature_width 0.5 feature_width feature_height], 'Edgecolor','r');

