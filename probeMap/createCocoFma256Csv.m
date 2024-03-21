allclear;

load coco_electrodespecs.mat

uniqueFma = unique(electrodespecs.arrayID);
offsetX   = 3200; %micrometer
offsetY   = 0; %micrometer
fmaCount  = (1:32)';
X     = [];   
Y     = [];   
Z     = [];   
FMA   = [];   
HSW   = [];
FMAID = [];

for fmaInd = 1:length(uniqueFma)
    q = find(strcmpi(electrodespecs.arrayID,uniqueFma{fmaInd}));

    tX     = round(electrodespecs.electrodePositionX(q)*1000 + offsetX);
    tY     = round(electrodespecs.electrodePositionY(q)*1000 + offsetY);
    tZ     = electrodespecs.electrodeLength(q)*1000;
    tFma   = electrodespecs.fmaElectrodeNumber(q);
    tHsw   = electrodespecs.hsampid(q);
    tFmaID = electrodespecs.arrayID(q);
    [~,sortInd] = sort(tFma);

    X     = [X; tX(sortInd)];
    Y     = [Y; tY(sortInd)];
    Z     = [Z; tZ(sortInd)];
    HSW   = [HSW; tHsw(sortInd)];
    FMA   = [FMA; fmaCount];
    FMAID = [FMAID; tFmaID(sortInd)];

    fmaCount = fmaCount + 32;
    offsetY  = offsetY + 3000;
end

%%%  CHECK THIS - there may be some confusion in fma v fmaID - thomas 18-05-2023
e       = table();
e.fmaID = FMAID;
e.fma   = FMA-1; % Python starts count from 0
e.hsw   = HSW-1;  % Python starts count from 0
e.x     = X;
e.y     = Y;
e.z     = Z;

writetable(e,'cocoFma256.csv')