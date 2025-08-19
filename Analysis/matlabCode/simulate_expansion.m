close all
clear all

fz = 500; % initial size

vol0 = (fz/1000)^3;

XYLIM = [-400 400];
rng(13)
gtl = {'5%','20%','50%','90%'};
expRatio = [1.05 1.20 1.50 1.9];
gRate = nthroot(expRatio,3);

ngRate = length(gRate);
pd = [];
volexp = [];
for i = 1:ngRate
    subplot(2,2,i)
    x = rand(100,1) * fz;
    y = rand(100,1) * fz;
    z = rand(100,1) * fz;

    center = [mean(x) mean(y) mean(z)];    
    
    x0 = x-center(1);
    y0 = y-center(1);
    z0 = z-center(1);

    A =gRate(i);

    xt = A*x0;
    yt = A*y0;
    zt = A*z0;

    scatter(x0,y0,'filled')
    hold on
    scatter(xt,yt,'r')
    hold off
    ax = gca;
    ax.FontSize = 12;
    xlim(XYLIM)
    ylim(XYLIM)

    xlabel('X (\mum)','FontSize',12)
    ylabel('Y (\mum)','FontSize',12)
    title([gtl{i} ' volume expansion'])
    n = length(x);
    rel_loc_i=sqrt((xt-x0).^2 +(yt-y0).^2 +(zt-z0).^2);
    pd=[pd rel_loc_i];
end
rng('default')
