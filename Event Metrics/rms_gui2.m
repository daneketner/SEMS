function rms_gui2(rms_array,rms_r_sst)
% R - rms_gui structure
% Setting individual color takes 20 times longer!

R.rms = rms_array;
zz = zeros(size(R.rms,1),1);
oo = ones(size(R.rms,1),1);
R.cdata = [zz,zz,oo]; % [red, green, blue] - default (all blue)
if ~isempty(rms_r_sst)
   R.r_sst = rms_r_sst;
   for n = 1:numel(R.r_sst)
      if ~isempty(R.r_sst{n})
         w = get_red_w('ref:ehz',R.rms(n,1),R.rms(n,1)+1/24,1);
         w = remove_sst(R.r_sst{n},w,NaN);
         w = zero2nan(w,10);
         R.rms(n,2) = rms(w);
         R.cdata(n,:) = [1,0,0];
      end  
   end
else
   R.r_sst = cell(size(R.rms,1),1);
end
R.size = 10; % Size of scatter plot marker
R.median = median(R.rms(:,2));
R.fh = figure; 
R.ax = axes;
R.scat = scatter(R.rms(:,1),R.rms(:,2),R.size);
set(R.scat,'CData',R.cdata)
set(R.scat,'UserData',R.r_sst)
dynamicDateTicks
set(R.scat,'HitTest','on','ButtonDownFcn',{@scatClick,R})

function scatClick(varargin)
R = varargin{3};
rms_time = get(R.scat,'xdata');
rms_dat = get(R.scat,'ydata');
rms_cdata = get(R.scat,'CData');
rms_r_sst = get(R.scat,'UserData');
mouse = get(R.ax(1),'currentpoint');
[val, pnt] =min(sqrt((rms_time-mouse(1,1)).^2 + (rms_dat-mouse(1,2)).^2));
clk_t = rms_time(pnt);
clk_r = rms_r_sst{pnt};
w = get_red_w('ref:ehz',clk_t,clk_t+1/24,1);
if ~isempty(clk_r)
   clk_r = event_editor(w,'sst',clk_r);
else
   clk_r = event_editor(w);
end
clk_r = clk_r{:};
w = remove_sst(clk_r,w,NaN);
w = zero2nan(w,10);
rms_dat(pnt) = rms(w);
rms_cdata(pnt,:) = [1 0 0];
rms_r_sst{pnt} = clk_r;
set(R.scat,'ydata',rms_dat,'Cdata',rms_cdata,'UserData',rms_r_sst)
end

end