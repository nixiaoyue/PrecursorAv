function y=blockaver(x,n)
%y=blockaver(x,n)
%input points are averaged over n points, no overlap

nblocks = floor(length(x) / n);
y = nanmean(reshape(x(1:n*nblocks), n, nblocks), 1);