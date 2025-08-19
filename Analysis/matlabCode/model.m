close all
clear all

fz = [500:100:1500];
nfz = length(fz);
n = 100;
vol0 = (fz/1000).^3;

rng(13)

expRatio = [1:0.05:2];
nexpRatio = length(expRatio);

gRate = nthroot(expRatio,3);

ngRate = length(gRate);
pd_DPI = []; % intial angle affects the disatance between cells from different days

statpd = []; % variable names: initial size (um); expansion rate; expansion angles: 1. center,2. edge,3. corner; mean displacement; std displacement
pd_cell = []; % intial angle does not affect the disatances among cells from different days

i = 1;j=1;k=1;
for i = 1:nfz % original size
    x = randsample(fz(i),n);
    y = randsample(fz(i),n);
    z = randsample(fz(i),n);
    center = [mean(x) mean(y) mean(z)];
    
    %from the center
    x1 = x-center(1);
    y1 = y-center(1);
    z1 = z-center(1);
    
    %from an edge
    x2 = x;
    y2 = y-center(1);
    z2 = z-center(1);
    
    %from a conner
    x3 = x;
    y3 = y;
    z3 = z;

    xyz1 = [x1 y1 z1];
    xyz2 = [x2 y2 z2];
    xyz3 = [x3 y3 z3];
    sxyz = size(xyz3);
    XYZ = zeros([sxyz 3]);
    XYZ(:,:,1) = [x1 y1 z1];
    XYZ(:,:,2) = [x2 y2 z2];
    XYZ(:,:,3) = [x3 y3 z3];
    XYZA = zeros([sxyz 3]);
    for j = 1:ngRate % expansion rate
        A =gRate(j);
        XYZA = XYZ*A;
        for k = 1:3 % different expansion angle
            xtk = XYZA(:,1,k);
            ytk = XYZA(:,2,k);
            ztk = XYZA(:,3,k);
            xt0k = XYZ(:,1,k);
            yt0k = XYZ(:,2,k);
            zt0k = XYZ(:,3,k);
            % vol0 = (max(xt0k) - min(xt0k)) * (max(yt0k) - min(yt0k)) * (max(zt0k) - min(zt0k)) ;
            vol1 = (max(xtk) - min(xtk)) * (max(ytk) - min(ytk)) * (max(ztk) - min(ztk)) ;
            rel_loc_k=sqrt((xtk-xt0k).^2 +(ytk-yt0k).^2 +(ztk-zt0k).^2);
            srel_loc_k = length(rel_loc_k);
            pdi = [repmat(fz(i),srel_loc_k,1) ...
                repmat(expRatio(j),srel_loc_k,1) ...
                repmat(k,srel_loc_k,1) ...
                rel_loc_k];
            pd_DPI=[pd_DPI;pdi];
            statpdi = [fz(i) expRatio(j) k mean(rel_loc_k) std(rel_loc_k)];
            statpd=[statpd;statpdi];

            rel_loc_i = [];
            for mm = 1:(n-1),
                for mmm = (mm+1):n,
                    X_img_i_j = xtk(mm);
                    Y_img_i_j = xtk(mm);
                    Z_img_i_j = xtk(mm);
                    X_img_i_k = xtk(mmm);
                    Y_img_i_k = xtk(mmm);
                    Z_img_i_k = xtk(mmm);
                    rel_loc_ijk = sqrt((X_img_i_k-X_img_i_j)^2 + ...
                        (Y_img_i_k-Y_img_i_j)^2 + ...
                        (Z_img_i_k-Z_img_i_j)^2);
                    rel_loc_i = [rel_loc_i;rel_loc_ijk];
                end
            end
            n_rel_loc = length(rel_loc_i);

            rel_loci = [repmat(fz(i),n_rel_loc,1) ...
                repmat(expRatio(j),n_rel_loc,1) ...
                repmat(k,n_rel_loc,1) ...
                rel_loc_i];
            pd_cell = [pd_cell;rel_loci];
        end
    end
end

clearvars -except pd_DPI pd_cell



