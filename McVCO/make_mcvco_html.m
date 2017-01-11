function make_mcvco_html

fid = fopen('mcvco_config.txt');
dr = fgetl(fid);
load([dr, '\Master.mat'])

time{1} = 'Week';
time{2} = 'Month';
time{3} = '3Month';
time{4} = 'Year';
time{5} = 'All';

metric{1} = 'Voltages';
metric{2} = 'Waveforms';

subnets = fieldnames(M);
for t = 1:numel(time)
    for m = 1:numel(metric)
        TT = time{t};
        MM = metric{m};
        fid1 = fopen([dr,'\HTML\',MM,'-',TT,'.html'],'w+');
        
        fprintf(fid1,'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">\n')
        fprintf(fid1,'<html>\n')
        fprintf(fid1,'<head>\n')
        fprintf(fid1,'  <meta content="text/html; charset=ISO-8859-1"\n')
        fprintf(fid1,' http-equiv="content-type">\n')
        fprintf(fid1,['  <title>',MM,'-',TT,'</title>\n'])
        fprintf(fid1,'  <style>\n')
        fprintf(fid1,'    h1 {text-align: center; font-family: Agency FB;}\n')
        fprintf(fid1,'    h2 {text-align: center; font-family: Agency FB;}\n')
        fprintf(fid1,    'h3 {text-align: center; font-family: Agency FB;}\n')
        fprintf(fid1,'  </style>\n')
        fprintf(fid1,'</head>\n')
        fprintf(fid1,'<body style="width: 1200px;">\n')
        fprintf(fid1,'<div style="text-align: center;">\n')
        fprintf(fid1,'<h2><big>Alaska Volcano Observatory - McVCO Metrics</big></h2>\n')
        
        fprintf(fid1,'<hr style="width: 100%%; height: 2px;">\n')
        
        fprintf(fid1,'<h3>Plot:  [<a href="Voltages-%s.html">Voltages</a>]\n',TT)
        fprintf(fid1,'- [<a href="Waveforms-%s.html">Waveforms</a>]\n',TT)
        fprintf(fid1,'</h3>\n')
        
        fprintf(fid1,'<hr style="width: 100%%; height: 2px;">\n')
        
        fprintf(fid1,'<h3>View:  [<a href="%s-Week.html">Week</a>]\n',MM)
        fprintf(fid1,'- [<a href="%s-Month.html">Month</a>]\n',MM)
        fprintf(fid1,'- [<a href="%s-3Month.html">3Month</a>]\n',MM)
        fprintf(fid1,'- [<a href="%s-Year.html">Year</a>]\n',MM)
        fprintf(fid1,'- [<a href="%s-All.html">All</a>]\n',MM)
        fprintf(fid1,'</h3>\n')
        
        fprintf(fid1,'<hr style="width: 100%%; height: 2px;">\n')
        
        switch MM
            case 'Voltages'
        fprintf(fid1,'<img src="VoltageColorBar.png"; height="600"; width="60"; style="position:fixed; margin-left:600px;">\n')
            case 'Waveforms'
        end
        fprintf(fid1,'</div>\n')
        fprintf(fid1,'<div style="text-align: center; font-family: Agency FB;">\n')
        
        for n = 1:numel(subnets)
            SU = subnets{n};
            
            fprintf(fid1,'<h2>\n')
            fprintf(fid1,'  <a href="%s-%s-%s.html">%s</a>\n',SU,MM,TT,upper(SU))
            fprintf(fid1,'</h2>\n')
            
            fprintf(fid1,'<h2>\n')
            fprintf(fid1,'  <img src="Network_%s_Plots/%s-%s.png"\n',MM,SU,TT)
            fprintf(fid1,'   alt="%s %s-long %s Plot"\n',SU,TT,MM)
            fprintf(fid1,'   title="%s %s-long %s Plot" align="middle"><br>\n',SU,TT,MM)
            fprintf(fid1,'</h2>\n')
            
            fid2 = fopen([dr,'\HTML\',SU,'-',MM,'-',TT,'.html'],'w+');
            
            fprintf(fid2,'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">\n')
            fprintf(fid2,'<html>\n')
            fprintf(fid2,'<head>\n')
            fprintf(fid2,'  <meta content="text/html; charset=ISO-8859-1"\n')
            fprintf(fid2,'http-equiv="content-type">\n')
            fprintf(fid2,'  <title>%s-%s-%s</title>\n',SU,MM,TT)
            fprintf(fid2,'  <style>\n')
            fprintf(fid2,'    h1 {text-align: center; font-family: Agency FB;}\n')
            fprintf(fid2,'    h2 {text-align: center; font-family: Agency FB;}\n')
            fprintf(fid2,'    h3 {text-align: center; font-family: Agency FB;}\n')
            fprintf(fid2,'  </style>\n')
            fprintf(fid2,'</head>\n')
            fprintf(fid2,'<body style="width: 1200px;">\n')
            fprintf(fid2,'<h2><big>%s McVCO %s</big></h2>\n',SU,MM)
            
            fprintf(fid2,'<hr style="width: 100%%; height: 2px;">\n')
            fprintf(fid2,'<div style="text-align: center;">\n')
            fprintf(fid2,'<h3><a href="%s-%s.html">Return to All Networks</a></h3>\n',MM,TT)
            
            fprintf(fid2,'<h3>Plot:  [<a href="%s-Voltages-%s.html">Voltages</a>]\n',SU,TT)
            fprintf(fid2,'- [<a href="%s-Waveforms-%s.html">Waveforms</a>]\n',SU,TT)
            fprintf(fid2,'</h3>\n')
            
            fprintf(fid2,'<hr style="width: 100%%; height: 2px;">\n')
            
            fprintf(fid2,'<h3>View:  [<a href="%s-%s-Week.html">Week</a>]\n',SU,MM)
            fprintf(fid2,'- [<a href="%s-%s-Month.html">Month</a>]\n',SU,MM)
            fprintf(fid2,'- [<a href="%s-%s-3Month.html">3Month</a>]\n',SU,MM)
            fprintf(fid2,'- [<a href="%s-%s-Year.html">Year</a>]\n',SU,MM)
            fprintf(fid2,'- [<a href="%s-%s-All.html">All</a>]\n',SU,MM)
            fprintf(fid2,'</h3>\n')
            
            fprintf(fid2,'<hr style="width: 100%%; height: 2px;">\n')
            fprintf(fid2,'<div style="text-align: center; font-family: Agency FB;">\n')
            
            stations = fieldnames(M.(SU));
            for k = 1:numel(stations)
                ST = stations{k};
                channels = fieldnames(M.(SU).(ST));
                for kk = 1:numel(channels)
                    CH = channels{kk};
                    fprintf(fid2,'<h2>\n')
                    fprintf(fid2,'<img src="Channel_%s_Plots/%s-%s-%s.png"\n',MM,ST,CH,TT)
                    fprintf(fid2,'alt="%s:%s %s-Long %s Plot"\n',ST,CH,TT,MM)
                    fprintf(fid2,'title="%s:%s %s-Long %s Plot" align="middle">\n',ST,CH,TT,MM)
                    fprintf(fid2,'<br>\n')
                    fprintf(fid2,'</h2>\n')
                end
            end
            fprintf(fid2,'</div>\n </body>\n </html>\n')
            fclose(fid2)
        end
        fprintf(fid1,'</div>\n </body>\n </html>\n')
        fclose(fid1)
    end
end














