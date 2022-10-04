
% function generate_pdf_images(poses_data, render_times, pdfImagesFolder, pad_value, check_dir)

% Generates pdf images from poses data.

% render_times := [initial_delay, new_airport_delay, base_delay] controls
% the rendering process :
% - initial_delay : time before rendering the first image
% - new_airport_delay : time before rendering the first image of an airport
% - base_delay : time between two consecutives images renders

% The images names are their indices padded with pad_value 0.

% Input :
% poses_data (poses data struct) : camera poses used to produce the images
% render_times (3 1-d double array) : render times
% pdfImagesFolder (string) : path to the destination pdf images folder
% pad_value (integer) : padding value for files indexing
% check_dir (boolean) : specifies if a folder needs to be created

function generate_pdf_images(poses_data, render_times, pdfImagesFolder, pad_value, check_dir)

if check_dir && ~mkdir(".", pdfImagesFolder)
    error("Unable to create " + pdfImagesFolder);
end

fig = uifigure;
fig.WindowState = 'maximized';
g = geoglobe(fig);

initial_wait_time = render_times(1);
new_location_wait_time = render_times(2);
base_wait_time = render_times(3);

airports = string(fieldnames(poses_data));

for i=1:numel(airports)
    airport = airports(i);
    offset = poses_data.(airport).offset;
    cameraPoses = poses_data.(airport).poses;
    nPoses = size(cameraPoses, 1);

    for j=1:nPoses
        cameraPose = cameraPoses(j, :);
        lat = cameraPose(1);
        lon = cameraPose(2);
        ht = cameraPose(3);
        heading = cameraPose(4);
        pitch = cameraPose(5);
        roll = cameraPose(6);
        campos(g, lat, lon, ht);
        camheading(g, heading);
        campitch(g, pitch);
        camroll(g, roll);
        drawnow
        if i==1 && j==1
            pause(initial_wait_time)
        elseif j==1
            pause(new_location_wait_time)
        else
            pause(base_wait_time)
        end
        
        pdf_image_name = strcat(format_indexed_name('', offset+j, pad_value), '.pdf');
        image_path = fullfile(pdfImagesFolder, pdf_image_name);
        exportapp(fig, image_path);               
    end
end
close(fig)
end

