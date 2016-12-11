function make_outage_html

fid = fopen('outage_config.txt');
dr = fgetl(fid);
load([dr, '\Master.mat'])

time{1} = 'Week';
time{2} = 'Month';
time{3} = '3Month';
time{4} = 'Year';
time{5} = 'All';

subnets = fieldnames(M.Outage);
for t = 1:numel(time)
    TT = time{t};
    fid1 = fopen([dr,'\HTML\',TT,'.html'],'w+');
    fprintf(fid1,'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">\n')
    fprintf(fid1,'<html>\n')
    fprintf(fid1,'<head>\n')
    fprintf(fid1,'  <meta content="text/html; charset=ISO-8859-1"\n')
    fprintf(fid1,' http-equiv="content-type">\n')
    fprintf(fid1,['  <title>',TT,'</title>\n'])
    fprintf(fid1,'  <style>\n')
    fprintf(fid1,'    h1 {text-align: center; font-family: Agency FB;}\n')
    fprintf(fid1,'    h2 {text-align: center; font-family: Agency FB;}\n')
    fprintf(fid1,    'h3 {text-align: center; font-family: Agency FB;}\n')
    fprintf(fid1,'  </style>\n')
    fprintf(fid1,'</head>\n')
    fprintf(fid1,'<body style="width: 1200px;">\n')
    fprintf(fid1,'<div style="text-align: center;">\n')
    fprintf(fid1,'<h2><big>Alaska Volcano Observatory - Digital Station Outages</big></h2>\n')
    fprintf(fid1,'<hr style="width: 100%%; height: 2px;">\n')
    fprintf(fid1,'<h3>View:  [<a href="Week.html">Week</a>]\n')
    fprintf(fid1,'- [<a href="Month.html">Month</a>]\n')
    fprintf(fid1,'- [<a href="3Month.html">3Month</a>]\n')
    fprintf(fid1,'- [<a href="Year.html">Year</a>]\n')
    fprintf(fid1,'- [<a href="All.html">All</a>]\n')
    fprintf(fid1,'</h3>\n')
    fprintf(fid1,'<hr style="width: 100%%; height: 2px;">\n')
%   fprintf(fid1,'<img src="OutageColorBar.png"; height="600"; width="60"; style="position:fixed; margin-left:600px;">\n')
    fprintf(fid1,'</div>\n')
    fprintf(fid1,'<div style="text-align: center; font-family: Agency FB;">\n')
    for n = 1:numel(subnets)
        SU = subnets{n};
        fprintf(fid1,'<h2>%s</h2>\n',SU)
        fprintf(fid1,'  <img src="%s-%s.png"\n',SU,TT)
        fprintf(fid1,'   alt="%s %s-long Outage Plot"\n',SU,TT)
        fprintf(fid1,'   title="%s %s-long Outage Plot" align="middle"><br>\n',SU,TT)
        fprintf(fid1,'</h2>\n')
    end
    fprintf(fid1,'</div>\n </body>\n </html>\n')
    fclose(fid1)
end