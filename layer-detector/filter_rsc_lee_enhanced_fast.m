%% This is Radar enhanced Lee filter:
%% https://catalyst.earth/catalyst-system-files/help/concepts/orthoengine_c/Chapter_825.html
%% Date: 02212024
%% Remote Sensing Center
%% Author: Mishal Thapa
function sfiltered=filter_rsc_lee_enhanced_fast(imgdata, nhood, Nlooks)
var_img=var(imgdata(:));     %variance of the whole image data
% nhood=[3,3];
% Estimate the local mean of imgdata.
localMean = filter2(ones(nhood), imgdata) / prod(nhood);
% Estimate of the local variance of imgdata.
% localVar = filter2(ones(nhood), imgdata.^2) / prod(nhood) - localMean.^2;
localVar = filter2(ones(nhood), (imgdata-localMean).^2) / prod(nhood);

Damp=1;   %default can use 1.
Ci=sqrt(localVar)./localMean;   %local_sigma/local_mean
Cu=sqrt(1/Nlooks);
Cmax=sqrt(1+2/Nlooks);
W=exp(-Damp*(Ci-Cu)./(Cmax-Ci));
%% find the locations:
sfiltered=zeros(size(imgdata));
locs1 =find(Ci<=Cu);
locs2=find((Cu<Ci) & (Ci<Cmax));
locs3=find(Ci>=Cmax);
sfiltered(locs1)=localMean(locs1);
sfiltered(locs2)=localMean(locs2).*W(locs2)+ imgdata(locs2).*(1-W(locs2));
sfiltered(locs3)=imgdata(locs3);
end