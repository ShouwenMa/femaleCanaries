close all
clear all

load("pairwiseDistance_model_5PrecentStepRate.mat")

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







%%% calculate the difference between pairwise distances

levRLS = unique(pd_cell(:,1)); % size
levRLR = unique(pd_cell(:,2)); % growth rate
levRLA = unique(pd_cell(:,3)); % angle
nlevRLS = length(levRLS);
nlevRLR = length(levRLR);
nlevRLA = length(levRLA);

levIS = unique(pd_DPI(:,1)); % initial size (um)
nlevIS = length(levIS);
levER = unique(pd_DPI(:,2)); % expansion rate = 1 + p/100 (p: % expansion)
nlevER = length(levER);
levIL = unique(pd_DPI(:,3)); % initial locaition, 1.center, 2.edge. 3.corner
nlevIL = length(levIL);

i = 1;ii=10;iii=2;

statRLoc = [];
for i = 1:nlevIS
    pd_cell_i = pd_cell(find(pd_cell(:,1)==levIS(i)),:);
    levERi = unique(pd_cell_i(:,2)); % growth rate
    nlevERi = length(levERi);
    levILi = unique(pd_cell_i(:,3)); % angle
    nlevILi = length(levILi);
    pd_cell_i_0 = pd_cell_i(find(pd_cell_i(:,2)==levERi(1)),:); % growth rate = 1
    for ii = 2:nlevERi
        for iii = 1:nlevILi
            pd_cell_ii_iii = pd_cell_i(find(pd_cell_i(:,2)==levERi(ii) & ...
                pd_cell_i(:,3)==levILi(iii)),:);
            pd_cell_ii_iii_0 = pd_cell_i_0(find(pd_cell_i_0(:,3)==levILi(iii)),:);
            diff_ii_iii = pd_cell_ii_iii(:,4)-pd_cell_ii_iii_0(:,4);

            statRLociii = [levIS(i) levERi(ii) levILi(iii) mean(diff_ii_iii) std(diff_ii_iii)];
            statRLoc=[statRLoc;statRLociii];

        end
    end
end

%%%%%%%%% Identical cell displacements despite using different initial locations
figure 
statRLoc1 = statRLoc(find(statRLoc(:,3)==1),:);
scatter3(statRLoc1(:,1),(statRLoc1(:,2)-1)*100,statRLoc1(:,4),10)
hold on
statRLoc1 = statRLoc(find(statRLoc(:,3)==2),:);
scatter3(statRLoc(:,1),(statRLoc(:,2)-1)*100,statRLoc(:,4),20)
statRLoc1 = statRLoc(find(statRLoc(:,3)==3),:);
scatter3(statRLoc1(:,1),(statRLoc1(:,2)-1)*100,statRLoc1(:,4),30)
hold off
xlabel('Initial size (\mum)','FontSize',12)
ylabel('% expansion','FontSize',12)
zlabel('Mean displacement (\mum)','FontSize',12)
legend({'Center','Edge','Corner'},'FontSize',12)
set(gca,'TickDir','out','Box','off')
set(gca,'TickLength',[0.02, 0.01])
% view(90,0)
view([ 185.5   22])
