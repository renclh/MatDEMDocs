%the file is used to analyse the data of MonteCarlo3
clear
MCdatas=[];
for dataI=1:100
    load(['data/step/BoxMonteCarlo0.2-0.2loopNum' num2str(dataI) '.mat']);%load the saved file
    d.setData();
    movedRates=zeros(d.SET.modelNum,1);
    for i=1:d.SET.modelNum
        sampleId=d.GROUP.(['sample' num2str(i)]);
        sDisplacement=d.data.Displacement(sampleId);
        sFilter=sDisplacement>B.ballR*2;
        movedRates(i)=sum(sFilter)/length(sFilter);
    end
    movedRateLimit=0.01;
    movedFilter=movedRates>movedRateLimit;
    
    MCdata=[aBFRates,d.SET.aMUpRate*ones(size(aBFRates)),movedFilter];
    MCdatas=[MCdatas;MCdata];
end
save('slope/MCdatas3.mat','MCdatas');