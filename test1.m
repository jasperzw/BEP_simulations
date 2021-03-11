sourceMask = zeros(Nx, Ny);
for i=1:length(source_set)
    sourceMask = sourceMask + source_set(i).p_mask
end

imagesc(sourceMask)