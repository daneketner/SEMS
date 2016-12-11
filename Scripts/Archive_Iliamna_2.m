
%%
IVE_wfa_day = 'C:\Work\Iliamna\Single_Station_Detection_2\IVE\event_structure';
IVE_wfa_block = 'C:\Work\Iliamna\Single_Station_Detection_2\IVE\wfa_block';
IVE_corr_block = 'C:\Work\Iliamna\Single_Station_Detection_2\IVE\corr_block';

ILW_wfa_day = 'C:\Work\Iliamna\Single_Station_Detection_2\ILW\event_structure';
ILW_wfa_block = 'C:\Work\Iliamna\Single_Station_Detection_2\ILW\wfa_block';
ILW_corr_block = 'C:\Work\Iliamna\Single_Station_Detection_2\ILW\corr_block';

ILS_wfa_day = 'C:\Work\Iliamna\Single_Station_Detection_2\ILS\event_structure';
ILS_wfa_block = 'C:\Work\Iliamna\Single_Station_Detection_2\ILS\wfa_block';
ILS_corr_block = 'C:\Work\Iliamna\Single_Station_Detection_2\ILS\corr_block';

%%
d1 = [2012 1 1];
d2 = [2012 7 30];

wfa_day2block(d1,d2,IVE_wfa_day,IVE_wfa_block,500)
wfa_day2block(d1,d2,ILW_wfa_day,ILW_wfa_block,500)
wfa_day2block(d1,d2,ILS_wfa_day,ILS_wfa_block,500)

%%
wfablock2corrblock(IVE_wfa_block,IVE_corr_block,[72 73])
wfablock2corrblock(ILW_wfa_block,ILW_corr_block,[1 110])
wfablock2corrblock(ILS_wfa_block,ILS_corr_block,[1 36])