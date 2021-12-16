clc
clear all
close all
classes = {'Unknown', 'Compacts', 'Sedans', 'SUVs', 'Coupes', ...
    'Muscle', 'SportsClassics', 'Sports', 'Super', 'Motorcycles', ...
    'OffRoad', 'Industrial', 'Utility', 'Vans', 'Cycles', ...
    'Boats', 'Helicopters', 'Planes', 'Service', 'Emergency', ...
    'Military', 'Commercial', 'Trains'};
labels=[0	1	1	1	1	1	1	1	1	2	2	2	2	2	2	0	0	0	0	0	0	0	0];

%%
files = dir('Train_data_bbox/*/*_image.jpg');
for idx = 1:numel(files)
snapshot = [files(idx).folder, '/', files(idx).name];
disp(snapshot)
img = imread(snapshot);



proj = read_bin(strrep(snapshot, '_image.jpg', '_proj.bin'));
proj = reshape(proj, [4, 3])';

try
    bbox = read_bin(strrep(snapshot, '_image.jpg', '_bbox.bin'));
catch
    disp('[*] no bbox found.')
    bbox = single([]);
end
bbox = reshape(bbox, 11, [])';



%figure(1)
%clf()
%imshow(img)
%axis on
%hold on


%set(gcf, 'position', [100, 100, 800, 400])



    R = rot(bbox(1, 1:3));
    t = reshape(bbox(1, 4:6), [3, 1]);

    sz = bbox(1, 7:9);
     [vert_3D, edges] = get_bbox(-sz / 2, sz / 2);
    vert_3D = R * vert_3D + t;

    vert_2D = proj * [vert_3D; ones(1, size(vert_3D, 2))];
    vert_2D = vert_2D ./ vert_2D(3, :);
xmin=min(vert_2D(1,:)); xmax=max(vert_2D(1,:));
ymin=min(vert_2D(2,:)); ymax=max(vert_2D(2,:));

 
    
%plot([xmin xmin xmax xmax xmin],[ymin ymax ymax ymin ymin],'-r');

        
       

    t = double(t);  % only needed for `text()`
    c = classes{int64(bbox(1, 10)) + 1};
    ignore_in_eval = logical(bbox(1, 11));
    %if ignore_in_eval
      %  text(t(1), t(2), t(3), c, 'color', 'r')
   % else
      %  text(t(1), t(2), t(3), c)
    %end
%     xmin=1100; xmax=1914; ymin=300; ymax=1052;
fID=strrep(snapshot, '_image.jpg', '_bbox2D.bin');
fileID=fopen(fID,'w');
fwrite(fileID,[xmin ymin,xmax,ymax,labels(bbox(10))],'single');
fclose(fileID);

end
%%
function [v, e] = get_bbox(p1, p2)
v = [p1(1), p1(1), p1(1), p1(1), p2(1), p2(1), p2(1), p2(1)
    p1(2), p1(2), p2(2), p2(2), p1(2), p1(2), p2(2), p2(2)
    p1(3), p2(3), p1(3), p2(3), p1(3), p2(3), p1(3), p2(3)];
e = [3, 4, 1, 1, 4, 4, 1, 2, 3, 4, 5, 5, 8, 8
    8, 7, 2, 3, 2, 3, 5, 6, 7, 8, 6, 7, 6, 7];
end

%%
function R = rot(n)
theta = norm(n, 2);
if theta
    n = n / theta;
    K = [0, -n(3), n(2); n(3), 0, -n(1); -n(2), n(1), 0];
    R = eye(3) + sin(theta) * K + (1 - cos(theta)) * K^2;
else
    R = eye(3);
end
end

%%
function data = read_bin(file_name)
id = fopen(file_name, 'r');
data = fread(id, inf, 'single');
fclose(id);
end
