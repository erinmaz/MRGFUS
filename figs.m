%LESION VOLUME FIGURE, 051518
%copied from google sheet MRGFUS/Lesion Volume - Working
%https://docs.google.com/spreadsheets/d/1hkB76ZZJLdYTov6ueGIEtb-8jEMdD2Ieg6oPrHuvnoA/edit?usp=sharing
data1=[1	230
1	141
1	416
1	180
1	442
1	182
1	202
1	396];
data2=[2	47
2	20
2	94
2	13
2	31
2	7
2	1
2	63];

colours = {'k','k','k','k','k','k','k','k'};
markers = {'+','o','*','.','<','>','square','x'};
figure
hold
for i=1:length(data1)
scatter(data1(i,1),data1(i,2),100,colours{i},markers{i});
scatter(data2(i,1),data2(i,2),100,colours{i},markers{i});
end
set(gca,'fontsize', 18);

axis([0 3 0 500]);
xticks([1 2]);
xticklabels({'Day 1','Day 90'});
xlabel('Time since treatment');
ylabel('T1w lesion volume (mm^3)');