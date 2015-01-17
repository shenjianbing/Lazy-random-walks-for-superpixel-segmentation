function phi = img_smooth(img, time_step, num_iterations)
%IMG_SMOOTH Summary of this function goes here
%   Detailed explanation goes here
  phi = img;
for i=1:num_iterations

[phi] = evolve_height_function(phi,time_step);

end
end
%% function evolve_height_function
function [new_phi] = evolve_height_function(phi,time_step)
 
        band_ind = true(size(phi));
        delta_phi = height_function_change_rate(phi);
    ofs = 1;
    new_phi = phi;
    new_phi(band_ind) = phi(band_ind) - time_step * delta_phi(band_ind);
    new_phi = padarray(new_phi(1+ofs:end-ofs,1+ofs:end-ofs),[ofs,ofs],'replicate');
end 
%% Get the height derivative with respect to time assuming curvature motion
function delta_phi = height_function_change_rate(phi)

%     [dx,dy,dxx,dyy,dxy] = height_function_der(phi);
    [dx,dy,dxx,dyy,dxy] = weight_function(phi);
    
    delta_phi = -(dxx.*(dy.^2) - 2*dx.*dy.*dxy + dyy.*(dx.^2)) ./ ...
                (eps+(dx.^2 + dy.^2));
end