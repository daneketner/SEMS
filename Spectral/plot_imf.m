function plot_imf(wave,imf)
%
%PLOT_IMFS: Plot Intrinsic Mode Functions
%
%PLANS FOR IMPROVEMENT: Mode input selecting different ways to display the
%IMFs (2 rows, 1 row, etc.)
%
%INPUTS: wave - waveform object    
%        imf - intrinsic mode functions
%        (i.e. [0 .5])   
%
%OUTPUTS: generates a figure, no output arguments

%%%%% Plot Individual IMFs %%%%%

v = get(wave,'data');
Fs = get(wave, 'freq');
station=get(wave,'station');          % Station
channel=get(wave,'channel');          % Channel
network=get(wave,'network');          % Network 
dt = 1/Fs;
L = length(v);
max_v = max(abs(v));
t = (1:L)*dt;
imf_n = length(imf(1,:));
imf_n_str = num2str(imf_n);
figure('Name','IMF set','NumberTitle','off');
title(['[',station,' ',channel,' ',network,'] ',...
       datestr(get(wave,'start'),'dd-mmm-yyyy')])
for n = 1:imf_n
    subplot(imf_n,1,n)
    plot(t,imf(:,n))
    xlim([min(t) max(t)])
end

% %%%%%%%%%%%% Seismic Signal with IMF Subset Overlay %%%%%%%%%%%%
% 
% figure('Name','IMF overlay','NumberTitle','off',...
%        'Position',[200,200,500,500]);
% h = axes('Position',[0,0,1,1]);
% 
% IMF_Start_Edit = uicontrol('Style','Edit','BackgroundColor','w',...
%                            'String','1','Position',[150,100,45,20],...
%                            'CallBack', @IMF_Start_Edit_CallBack);
% IMF_End_Edit =   uicontrol('Style','Edit','BackgroundColor','w',...
%                            'String',imf_n_str,'Position',[200,100,45,20],...
%                            'CallBack', @IMF_End_Edit_CallBack);
% Engage_PrBut =   uicontrol('Style','PushButton','String','Engage',...
%                            'Position',[150,55,145,40],...
%                            'CallBack', @Engage_PrBut_CallBack);
%                       
% h_1 = axes('Position',[.1,.3,.8,.6]);
% plot(t,v,'Color','k')   % Plot trace black
% xlim([t(1) t(L)])
% ylim([-max_v max_v])
% h_2 = [];
% h_title = [];
% 
% function IMF_Start_Edit_CallBack(varargin)
% end
% 
% function IMF_End_Edit_CallBack(varargin)
% end
% 
% function Engage_PrBut_CallBack(h, eventdata)
% 
% IMF_Start = str2double(get(IMF_Start_Edit,'String'));
% IMF_End = str2double(get(IMF_End_Edit,'String'));    
%     
% if (isa(IMF_Start, 'numeric')~=1)||(isa(IMF_End, 'numeric')~=1)
%    errordlg('You must enter integer values.','Bad Input','modal')
%    return
% end    
% 
% if (IMF_Start<1)||(IMF_End>imf_n)
%    oob = ['IMF set must be between 1 and ',imf_n_str,'.']; 
%    errordlg(oob,'Out of bounds','modal') 
%    IMF_Start = 1;
%    set(IMF_Start_Edit,'String','1')
%    IMF_End = imf_n;
%    set(IMF_End_Edit,'String',imf_n_str)
% end   
% 
% if IMF_Start>IMF_End
%    errordlg('Start index exceeds end index.','Swapping Inputs...','modal') 
%    temp = IMF_Start;
%    IMF_Start = IMF_End;
%    IMF_End = temp;
%    set(IMF_Start_Edit,'String','num2str(IMF_Start)')
%    set(IMF_End_Edit,'String','num2str(IMF_End)')
% end   
% 
% sub = zeros(L,1);
% for n = IMF_Start:IMF_End
%     sub = sub + imf(:,n);
% end
% 
% if ishandle(h_2)==1
%     cla(h_2)
% end
% h_2 = axes('Position',[.1,.3,.8,.6]);
% plot(t,sub,'Color','r')   % Plot IMF subset in red
% xlim([t(1) t(L)])
% ylim([-max_v max_v])
% set(h_2,'Visible','off')
% 
% if ishandle(h_title)==1
%     cla(h_title)
% end
% h_title = axes('Position',[0,.9,1,.1]); 
% title_text =...
% text(.5,.5,['[',station,' ',channel,' ',network,' ',...
% datestr(get(wave,'start'),'dd-mmm-yyyy'),']'],...
% 'FontSize',18,'VerticalAlignment','middle','HorizontalAlignment','center'); 
% set(h_title,'Visible','off')
% 
% end % function Engage_PrBut_CallBack
% end % function plot_imf