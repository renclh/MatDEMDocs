
d.setData();
f.run('fun/mixGroupId.m',d);%mix the groupId
d.showFilter('SlideZ',0.05,0.75);
d.showFilter('SlideY',0.05,0.85);
d.showFilter('SlideX',0.05,0.85);
figure;
d.show('StressZZ');
figure;
d.show('groupId');