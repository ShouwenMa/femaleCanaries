close all
clear all

load("pairwiseDistance_model_1PrecentStepRate.mat")

levIS = unique(pd_DPI(:,1)); % initial size (um)
nlevIS = length(levIS);
levER = unique(pd_DPI(:,2)); % expansion rate = 1 + p/100 (p: % expansion)
nlevER = length(levER);
levIL = unique(pd_DPI(:,3)); % initial locaition, 1.center, 2.edge. 3.corner
nlevIL = length(levIL);

statpd_DPI = []; % statitics
for i = 1:nlevIS
    for j = 1:nlevER
        for k = 1:nlevIL
            pd_DPI_ijk = pd_DPI(find(pd_DPI(:,1)==levIS(i) & ...
                pd_DPI(:,2)==levER(j) & ...
                pd_DPI(:,3)==levIL(k)),:);

            statpd_DPI_ijk = [levIS(i) levER(j) levIL(k) mean(pd_DPI_ijk(:,4)) std(pd_DPI_ijk(:,4))];
            statpd_DPI=[statpd_DPI;statpd_DPI_ijk];
        end
    end
end

clearvars i j k



%%%%%%%%% summary the cell displacements using different initial locations
figure 
statpd1 = statpd_DPI(find(statpd_DPI(:,3)==1),:);
scatter3(statpd1(:,1),(statpd1(:,2)-1)*100,statpd1(:,4))
hold on
statpd1 = statpd_DPI(find(statpd_DPI(:,3)==2),:);
scatter3(statpd1(:,1),(statpd1(:,2)-1)*100,statpd1(:,4))
statpd1 = statpd_DPI(find(statpd_DPI(:,3)==3),:);
scatter3(statpd1(:,1),(statpd1(:,2)-1)*100,statpd1(:,4))
hold off
xlabel('Initial size (\mum)','FontSize',12)
ylabel('% expansion','FontSize',12)
zlabel('Mean displacement (\mum)','FontSize',12)
legend({'Center','Edge','Corner'},'FontSize',12)
view([ 185.5   22])

clearvars i j
