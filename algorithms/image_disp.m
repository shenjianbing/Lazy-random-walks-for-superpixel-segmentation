function [ output_args ] = image_disp( img,bmap,itr ,center_points,mark)
%IMAGE_DISP Summary of this function goes here

[X Y Z]=size(img);
idx = find(bmap>0);
bmapOnImg = img(:,:,1);
bmapOnImg(idx) = 1;
if Z==3
    temp=img(:,:,2);
    temp(idx)=0;
bmapOnImg(:,:,2) = temp;
    temp=img(:,:,3);
    temp(idx)=0;
bmapOnImg(:,:,3) = temp;
end
figure('name','bmap');imshow(bmapOnImg);
set(gca,'Units','normalized','Position',[0 0 1 1]);  %# Modify axes size
set(gcf,'Units','pixels','Position',[200 200 Y X]);  %# Modify figure size
hold on
x=center_points(:,1); y=center_points(:,2);
    plot(y ,x ,strcat(mark,'r'));
    fra = getframe(gcf);              %# Capture the current window
    set(figure(gcf),'visible','off');
imwrite(fra.cdata,strcat('results\',num2str(itr),'.',num2str(length(center_points)),'.bmp'));  %# Save the frame data

end
