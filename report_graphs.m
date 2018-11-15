%% Make some graphs for the report

year = [2010:2017]';
total_G = [347607;332539;328291;324623;300822;295991;292943;287796];
total_W = [7969.56854;12917.7686;17157.21054;23958.09534;26762.2652;34661.68849;32748.00254;43983.96287];

for i = 2:length(year)

growth_G(i-1) = 100*(total_G(i) - total_G(i-1)) / total_G(i-1);
growth_W(i-1) = 100*(total_W(i) - total_W(i-1)) / total_W(i-1);
growth_year(i-1) = (year(i) + year(i-1))/2;

end

figure()
area_plot = cat(2,total_W, total_G) / 1000;
h = area(cat(2,year,year) , area_plot, 'FaceColor', 'flat');
title('UK Electrical Energy Generation 2010-2017', 'interpreter', 'latex')
ylabel('Energy Generated in TWh', 'interpreter', 'latex')
xlabel('Year', 'interpreter', 'latex')
h(1).FaceColor = [0 0.25 0.25];
h(2).FaceColor = [0 0.5 0.5];
text(2016,20, 'Wind', 'color', [1 1 1], 'Fontsize', 14)%, 'FontWeight', 'bold')
text(2013,200, 'Total', 'color', [1 1 1], 'Fontsize', 14)%, 'FontWeight', 'bold')
print -depsc C:\Users\xav_m\OneDrive\Documents\XAVI\University\Final_Year\HELICOPTERS\Coursework\Windturbine_Optimisation\Report\Figures\ukGen

mean_G = mean(growth_G);
mean_W = mean(growth_W);
mean_G = mean_G * ones(1,length(growth_G));
mean_W = mean_W * ones(1,length(growth_G));
figure()
plot(growth_year, growth_G, '-b','LineWidth', 1.5)
hold on
plot(growth_year, mean_G, '--b','LineWidth', 1.5)
hold on
plot(growth_year,growth_W, '-', 'color', [0 0.5 0.5],'LineWidth', 1.5)
hold on
plot(growth_year, mean_W, '--', 'color', [0 0.5 0.5],'LineWidth', 1.5)
hold on
plot([2010.5 2016.5], [0 0], '-k', 'LineWidth', 0.5, 'HandleVisibility', 'off')
xlim([2010.5 2016.5]);
grid on
title('UK Wind Turbine Electricity Generation Growth 2010-2017', 'interpreter', 'latex')
ylabel('Annual Growth (\%)', 'interpreter', 'latex')
xlabel('Year', 'interpreter', 'latex')
legend({'Total Power', 'Total Power Average ', 'Wind Power', 'Wind Power Average'}, 'interpreter', 'latex')
print -depsc C:\Users\xav_m\OneDrive\Documents\XAVI\University\Final_Year\HELICOPTERS\Coursework\Windturbine_Optimisation\Report\Figures\WindGrowth