x = 1:Nx;
y = 1:Ny;
[X, Y] = meshgrid(x,y);
Z = 0;

x_o = 26
%original x_0 = 76
y_o = 100
for i = 1:amountSources
    m = (i-1)*2+1;
    Z_t = (t(30,i)-(sqrt(((X-double(coordinate_set(m)))*dx).^2+((Y-double(coordinate_set(m+1)))*dy).^2)/340)).^2;
    Z_t = Z_t;
    Z = Z+Z_t;
end

min = 1e03;
Mx = 0;
My = 0;
for i = 1:Ny
    for m = 1:Nx
        if(Z(i,m)<min)
           min = Z(i,m);
           Mx = m;
           My = i;
        end
    end
end

sourceMask = zeros(Nx, Ny);
for i=1:length(source_set)
    sourceMask = sourceMask + source_set(i).p_mask;
end

highestMask = ones(Ny,Nx)*5;
highestMask(My,Mx) = 10;

originalMask = zeros(Nx,Ny);
originalMask(y_o,x_o) = 10;
figure;
subplot(1,3,1)
imagesc(kgrid.y_vec * 1e3, kgrid.x_vec * 1e3, originalMask + highestMask, [0, 10]);
colormap(getColorMap);
ylabel('x-position [mm]');
xlabel('y-position [mm]');
title("Orgininal point and Guess location")
axis image

subplot(1,3,2)
imagesc(kgrid.y_vec * 1e3, kgrid.x_vec * 1e3, sensor.mask+ sourceMask, [-1, 1]);
colormap(getColorMap);
ylabel('x-position [mm]');
xlabel('y-position [mm]');
title("array with all simulated sources")
axis image

subplot(1,3,3)
imagesc(Z)
colormap(getColorMap);
colorbar
ylabel('x-position [mm]');
xlabel('y-position [mm]');
title("heatmap of guessed error")
axis image

%(x-double(coordinate_set(1))).^2 + y-double(coordinate_set(2))
%x = 26
%y = 100
dis = (sqrt((Mx-x_o)^2+(My-y_o)^2)*dx)*1000;
display(['found the following variables Mx=',num2str(Mx),' My=',num2str(My)])
display(['The actual coordinates are x_0=',num2str(x_o),' y_0=',num2str(y_o)])
display(['this means there is an error of ',num2str(dis),' mm'])