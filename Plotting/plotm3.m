
function plotm3(w)

X = get(fix_data_length(w-min(w))./max(w),'data');
Y = zeros(numel(X),length(X{1}));
for n=1:numel(X)
   Y(n,:)=X{n};
end
M=max(max(Y));
warning off
Y = 10*log10(abs(Y)/M);
warning on
inf = -20;
figure
imagesc(1:size(Y,2),1:size(Y,1),Y,[inf,0]);