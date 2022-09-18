function generate_pdf_images(poses_data, labels_data, pdfImagesFolder, check_dir)

if check_dir && ~mkdir(".", pdfImagesFolder)
    error("Unable to create " + pdfImagesFolder);
end

fig = uifigure;
fig.WindowState = 'maximized';
g = geoglobe(fig);

airports = string(fieldnames(poses_data));

for i=1:numel(airports)
    airport = airports(i);
    cameraPoses = poses_data.(airport);
    images_names = labels_data.(airport){4};
    
    for j=1:numel(images_names)
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
            pause(10)
        elseif j==1
            pause(5)
        else
            pause(1.5)
        end
        
        image_name = pdfImagesFolder + "/" + images_names(j) + ".pdf";
        exportapp(fig, image_name);               
    end
end
close(fig)
end

