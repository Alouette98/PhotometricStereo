
% Computer Vision Homework 2
% Date: 2018-10-25
% Author: DengChenguang

% --- Read image ---

folder_name = './';
file_type = '*.pgm';

files = dir([folder_name file_type]);
image_number = 63;
data = cell(image_number,2);
for i = 1:image_number
    img = imread([folder_name files(i).name]);
    data{i,1}= img;
    data{i,2}=files(i).name;
end

% data: a struct with the size of 1*number of images.
% have 2 properties: graph -- image, 192*168 pixel
%                          -- info, name of image.


% --- Get light source information ---
for i = 1:image_number
    k = 1;                        % light parameter
    name = data{i,2};
    angle1 = str2num(name(13:16))/180*pi;
    angle2 = str2num(name(18:20))/180*pi;
    
    x = -k * sin(angle2); 
    y = -k * sin(angle1) * cos(angle2);
    z = k * cos(angle2) * cos(angle1);
    
    light(i,1)=x;
    light(i,2)=y;
    light(i,3)=z;
end

% -- Caculation of g(x,y) --
VnT = zeros(i,1);
In = zeros(i,1);

for x = 1:192
    for y = 1:168
        for i = 1:image_number
             pixel_info = data{i,1}(x,y);
             In(i,1) = pixel_info;
             VnT(i,1) = light(i,1);
             VnT(i,2) = light(i,2);
             VnT(i,3) = light(i,3);
             % fprintf("%d\n",pixel_info);
             slt = VnT\In;
             g{x,y}=slt;
             n{x,y}=slt / norm(slt);
        end
    end
end

for i = 1:192
    for j = 1:168
        Nx(i,j) = n{i,j}(1);
        Ny(i,j) = n{i,j}(2);
        Nz(i,j) = n{i,j}(3);
    end
end

        

% -- Caculate f(x,y) --

C = 0; % constant
for x = 1:192
    for y = 1:168
        value = 0;
        for s = 1:x
            fx = n{s,1}(1) / n{s,1}(3);
            value = value + fx;
        end
        for t = 1:y
            fy = n{x,t}(2) / n{x,t}(3);
            value = value + fy;
        end
        value = value + C;
        f(x,y) = value;
    end
end


% -- show image--

subplot(1,3,1);
imagesc(Nx);
xlabel('X axis');

subplot(1,3,2);
imagesc(Ny);
xlabel('Y axis');

subplot(1,3,3);
imagesc(Nz);
xlabel('Z axis');

figure;
xaxis = 1:1:192;
yaxis = 1:1:168;
[X, Y] = meshgrid(xaxis,yaxis);
Z=f';
surf(X,Y,Z);
