function [score,coeff,cum_explained] = pca_scatterQC_2018(X,Y,QC,max,x,y,filename)

X0 = X(QC==0,:);
Y0 = Y(QC==0);
Xqc = X(QC==1,:);
Yqc = Y(QC==1);

grps = unique(Y0);

grey = [0.7,0.7,0.7];

sz = 10;
%colors = 'rgbcmykw';
colors = colormap(lines);
% red, blue, green, yellow, magenta
%colors = [255,0,0;0,0,200;0,200,0;255,255,0;255,150,255]./255;
% red, blue, blue, yellow, yellow
%colors = [255,0,0;0,100,255;0,100,255;255,255,100;255,255,100]./255;

[coeff,score0,latent,tsquared,explained] = pca(X0,'NumComponents',max);

score_qc = Xqc*coeff;
score = X*coeff;

%score = [score_qc;score0];
%Y = [Yqc;Y0];

%[coeff,score,explained] = ppca(X,max); 
%PPCA is Probabilistic Principal Component Analysis which amongst other 
%things can cope with missing values without prior imputation 
%- try it and see how it differs
fig = figure('InvertHardcopy','off','Color',[1 1 1]);
set(fig,'defaultLegendAutoUpdate','off')

hold on

data = [score0(:,x),score0(:,y)];

for i = 1:length(grps)
    temp = ismember(Y0,grps(i));
    if sum(temp) < 3, continue; end
    [xm,ym,x0,y0] = ci95_ellipse2018(data(temp,:),'mean');
    [xp,yp] = ci95_ellipse2018(data(temp,:),'pop');
    plot(xm,ym,'-','linewidth',1,'color',grey);
    plot(xp,yp,'--','linewidth',1,'color',grey);
    plot(x0,y0,'kx');
end


h = gscatter(score0(:,x),score0(:,y),Y0,'k','osvsv',sz);
for n = 1:length(h)
    set(h(n), 'MarkerFaceColor', colors(n+1,:),'LineWidth',1.5);
end
hz = gscatter(score_qc(:,x),score_qc(:,y),Yqc,'k','v',sz);
set(hz, 'MarkerFaceColor', colors(1,:),'LineWidth',1.5);
    
ylabel(['PC',int2str(y),' : ',num2str(explained(y),'%3.1f'),'% total variance'],'FontSize',14);
xlabel(['PC',int2str(x),' : ',num2str(explained(x),'%3.1f'),'% total variance'],'FontSize',14);
title(['PC ',int2str(x),' v PC',int2str(y)],'FontSize',14);
set(gca,'Box','on');

title('Principal Components Analysis');

cum_explained = cumsum(explained);
axis tight
legend1 = legend([h(:); hz]);
%legend1 = legend(gca,'show');
set(legend1,'FontSize',11,'FontName','Helvetica Neue','Location','best');
hold off
if nargin > 6
print('-dtiff','-r600',[filename,'.tiff'])
savefig([filename,'.fig'])
end

