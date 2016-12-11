%%
deep_spurr = [5, 23, 31, 34, 35, 37, 39, 42, 43, 65, 68, 70, 82, 85,...
              103, 104, 106, 119, 120, 122, 155, 156, 158, 159, 160,...
              164, 167, 169];
[lat, lon] = llboxkm(61.25, -152.18, 30);
multi_fam_summary_plot(EM, FM, deep_spurr, lat, lon, cmap, difmap)

%%         
shallow_spurr = [11, 14, 15, 20, 22, 26, 32, 36, 40, 44, 51, 64, 66, 67,...
                 69, 71, 83, 84, 102, 105, 118, 121, 153, 154, 157, 161,...
                 162, 163, 165, 166, 168];
[lat, lon] = llboxkm(61.25, -152.18, 30);
multi_fam_summary_plot(EM, FM, shallow_spurr, lat, lon, cmap, difmap)

%%         
aniakchak = [4, 8, 28, 45, 46, 47, 48, 72, 73, 74, 75, 76, 108, 109,...
             110, 170, 172, 173, 174, 175, 176, 177];
[lat, lon] = llboxkm(volc_loc.lat(3), volc_loc.lon(3), 15);
multi_fam_summary_plot(EM, FM, aniakchak, lat, lon, cmap, difmap)

%%
akutan = [17, 33, 77, 96];
[lat, lon] = llboxkm(54.05, -166.1, 15);
multi_fam_summary_plot(EM, FM, akutan, lat, lon, cmap, difmap)
             
%%
redoubt = [123, 126, 127, 128, 129, 130];
[lat, lon] = llboxkm(volc_loc.lat(25), volc_loc.lon(25), 20);
multi_fam_summary_plot(EM, FM, redoubt, lat, lon, cmap, difmap)

%%
okmok = [6,7 10, 12, 29, 38, 89, 90, 91, 92, 93, 94, 132, 133, 134, 135,...
         136, 137, 138, 139, 140];
[lat, lon] = llboxkm(53.4, -167.9, 35);
multi_fam_summary_plot(EM, FM, okmok, lat, lon, cmap, difmap)     

%%
tanaga = [21, 50, 80, 81];
[lat, lon] = llboxkm(volc_loc.lat(31), volc_loc.lon(31), 5);
multi_fam_summary_plot(EM, FM, tanaga, lat, lon, cmap, difmap)  

%%
gareloi = [62, 101, 115, 149, 150, 151];
[lat, lon] = llboxkm(51.75, -178.9, 25);
multi_fam_summary_plot(EM, FM, gareloi, lat, lon, cmap, difmap) 

%%
adagadak = [19, 24, 25, 60, 61, 63, 99, 100, 152];
[lat, lon] = llboxkm(52, -176.5, 15);
multi_fam_summary_plot(EM, FM, adagadak, lat, lon, cmap, difmap) 