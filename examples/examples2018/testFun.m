function [dd, kk] = testFun( ab,b3 ,c )
%FUNTEST 此处显示有关此函数的摘要
%   此处显示详细说明
kk=f.run('examples2018/funtest.m',ab,b3,c);
ee=0;
for i=1:50
    if i>2
        break;
    end
    ee=ee+i;
end
dd=ee+kk;
return;
disp(['num2str: ',num2str(ee)]);
end