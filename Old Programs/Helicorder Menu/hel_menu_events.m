function hel_menu_events
%
%HEL_MENU_EVENTS:         
%
%INPUTS: none
%
%OUTPUTS: none

  figure('MenuBar','none','Name','Edit Events','NumberTitle','off','Position',[600,600,280,370]);
  
  scn_edit = uicontrol('Style','Edit','String','RDWB:BHZ:AV - no events','Position',[30,320,220,20],'CallBack', @Station_Edit_CallBack);
  load_rb = uicontrol('Style','RadioButton','String','Load Events From File','Position',[30,290,140,20],'CallBack', @FindEvents_RaBut_CallBack);
  manual_rb = uicontrol('Style','RadioButton','String','Select Event Start/Stop Times Manually','Position',[30,260,220,20],'CallBack', @FindEvents_RaBut_CallBack);
  sta_lta_rb = uicontrol('Style','RadioButton','String','Detect Events Using STA-LTA','Position',[30,230,180,20],'CallBack', @FindEvents_RaBut_CallBack);
  
  edp_txt = uicontrol('Style','Text','String','--- [EDP] Event Detection Parameters ---','Position',[50,200,200,20]);
  edp_sta_txt = uicontrol('Style','Text','String','STA (s)','Position',[50,175,50,20]);
  edp_sta_edit = uicontrol('Style','Edit','BackgroundColor','w','String','1','Enable','off','Position',[100,175,20,20],'CallBack', @EDP_STA_Edit_CallBack);
  edp_lta_txt = uicontrol('Style','Text','String','LTA (s)','Position',[130,175,50,20]);
  edp_lta_edit = uicontrol('Style','Edit','BackgroundColor','w','String','8','Enable','off','Position',[180,175,20,20],'CallBack', @EDP_LTA_Edit_CallBack);
  edp_skip_txt = uicontrol('Style','Text','String','Skip (s)','Position',[50,150,50,20]);
  edp_skip_edit = uicontrol('Style','Edit','BackgroundColor','w','String','6','Enable','off','Position',[100,150,20,20],'CallBack', @EDP_Skip_Edit_CallBack);
  edp_min_txt = uicontrol('Style','Text','String','Min Duration (s)','Position',[130,150,90,20]);
  edp_min_edit = uicontrol('Style','Edit','BackgroundColor','w','String','1.2','Enable','off','Position',[220,150,25,20],'CallBack', @EDP_Min_Dur_Edit_CallBack);
  edp_thresh_txt = uicontrol('Style','Text','String','Thresholds  [On]            [Off]','Position',[50,125,150,20]);
  edp_on_edit = uicontrol('Style','Edit','BackgroundColor','w','String','2.2','Enable','off','Position',[142,125,25,20],'CallBack', @EDP_Thresh_On_Edit_CallBack);
  edp_off_edit = uicontrol('Style','Edit','BackgroundColor','w','String','1.6','Enable','off','Position',[200,125,25,20],'CallBack', @EDP_Thresh_Off_Edit_CallBack);
  
  save_edp_pb = uicontrol('Style','PushButton','String','Save EPD','Position',[50,90,70,20],'CallBack', @Engage_PrBut_CallBack);
  load_edp_pb = uicontrol('Style','PushButton','String','Load EDP','Position',[130,90,80,20],'CallBack', @Engage_PrBut_CallBack);
  
  get_ev_pb = uicontrol('Style','PushButton','String','GET EVENTS','Position',[20,30,72,30],'CallBack', @Engage_PrBut_CallBack);
  clr_ev_pb = uicontrol('Style','PushButton','String','CLEAR EVENTS','Position',[102,30,87,30],'CallBack', @Engage_PrBut_CallBack);
  cancel_pb = uicontrol('Style','PushButton','String','CANCEL','Position',[200,30,55,30],'CallBack', @Engage_PrBut_CallBack);
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function StartTime_Edit_CallBack(varargin)
    start_string = get(StartTime_Edit,'String');
    if length(start_string)~=19
      errordlg('You must enter time if the form: YYYY MM DD HH MM SS','Bad Input','modal')
      return
    end
    start_YYYY = str2double(start_string(1:4));
    start_MO = str2double(start_string(6:7));
    start_DD = str2double(start_string(9:10));
    start_HH = str2double(start_string(12:13));
    start_MI = str2double(start_string(15:16));
    start_SS = str2double(start_string(18:19));
    if isnan(start_YYYY)||isnan(start_MO)||isnan(start_DD)||isnan(start_HH)||isnan(start_MI)||isnan(start_SS)
    errordlg('You must enter time if the form: YYYY MM DD HH MM SS','Bad Input','modal')
    end
  end
   
  function EndTime_Edit_CallBack(varargin)
    end_string = get(EndTime_Edit,'String');
    if length(end_string)~=19
      errordlg('You must enter time if the form: YYYY MM DD HH MM SS','Bad Input','modal')
      return
    end
    end_YYYY = str2double(end_string(1:4));
    end_MO = str2double(end_string(6:7));
    end_DD = str2double(end_string(9:10));
    end_HH = str2double(end_string(12:13));
    end_MI = str2double(end_string(15:16));
    end_SS = str2double(end_string(18:19));
    if isnan(end_YYYY)||isnan(end_MO)||isnan(end_DD)||isnan(end_HH)||isnan(end_MI)||isnan(end_SS)
      errordlg('You must enter time if the form: YYYY MM DD HH MM SS','Bad Input','modal')
    end
  end 

  function GenerateHel_RaBut_CallBack(h, eventdata)
    
    if (get(GenerateHel_RaBut, 'Value') == 1)
      set(HelMinutes_Edit,'Enable','on')
      set(VLP_RaBut,'Enable','on')
      set(VLP_High_Edit,'Enable','on')
      set(VLP_Low_Edit,'Enable','on')
      if (get(FindEvents_RaBut, 'Value') == 1)
        set(PlotEvents_RaBut,'Enable','on')
      end
    else
      set(PlotEvents_RaBut,'Value',0,'Enable','off')
      set(HelMinutes_Edit,'Enable','off')
      set(VLP_RaBut,'Value',0,'Enable','off')
      set(VLP_High_Edit,'Enable','off')
      set(VLP_Low_Edit,'Enable','off')
    end
  end  

  function HelMinutes_Edit_CallBack(varargin)
    if isempty(get(HelMinutes_Edit,'String'))==1
      errordlg('You must enter a number of minutes.','Bad Input','modal')
      set(HelMinutes_Edit, 'String', '30')
    elseif isnan(str2double(get(HelMinutes_Edit,'String')))==1
      errordlg('You must enter a number of minutes.','Bad Input','modal')
      set(HelMinutes_Edit, 'String', '30')
    end
  end 

  function FindEvents_RaBut_CallBack(h, eventdata)
    set(PlotEvents_RaBut,'Value',0,'Enable','off')
    if (get(FindEvents_RaBut, 'Value') == 1)
      set(EDP_STA_Edit,'Enable','on')
      set(EDP_LTA_Edit,'Enable','on')
      set(EDP_Thresh_On_Edit,'Enable','on')
      set(EDP_Thresh_Off_Edit,'Enable','on')
      set(EDP_Skip_Edit,'Enable','on')    
      set(EDP_Min_Dur_Edit,'Enable','on')
      set(PlotES_RaBut,'Enable','on')
      set(PlotFI_RaBut,'Enable','on')
      set(PlotRMS_RaBut,'Enable','on')
      set(PlotPF_RaBut,'Enable','on') 
      if (get(GenerateHel_RaBut, 'Value') == 1)
        set(PlotEvents_RaBut,'Enable','on')
      end
    else
      set(EDP_STA_Edit,'Enable','off')
      set(EDP_LTA_Edit,'Enable','off')
      set(EDP_Thresh_On_Edit,'Enable','off')
      set(EDP_Thresh_Off_Edit,'Enable','off')
      set(EDP_Skip_Edit,'Enable','off') 
      set(EDP_Min_Dur_Edit,'Enable','off')      
      set(PlotES_RaBut,'Value',0,'Enable','off')
      set(PlotFI_RaBut,'Value',0,'Enable','off')
      set(PlotRMS_RaBut,'Value',0,'Enable','off')
      set(PlotPF_RaBut,'Value',0,'Enable','off')      
    end 
  end  

  function PlotEvents_RaBut_CallBack(h, eventdata)
  end  

  function VLP_RaBut_CallBack(h, eventdata)
  end  

  function VLP_High_Edit_CallBack(varargin)
    if (isempty(get(VLP_High_Edit,'String'))==1)||...
       (isnan(str2double(get(VLP_High_Edit,'String')))==1)
      errordlg('You must enter an upper bound VLP period in seconds.','Bad Input','modal')
      set(VLP_High_Edit, 'String', '10')
    end
  end  

  function VLP_Low_Edit_CallBack(varargin)
    if (isempty(get(VLP_Low_Edit,'String'))==1)||...
       (isnan(str2double(get(VLP_Low_Edit,'String')))==1)
      errordlg('You must enter a lower bound VLP period in seconds.','Bad Input','modal')
      set(VLP_Low_Edit, 'String', '100')
    end
  end  

  function EDP_STA_Edit_CallBack(varargin)
    if (isempty(get(EDP_STA_Edit,'String'))==1)||...
       (isnan(str2double(get(EDP_STA_Edit,'String')))==1)
      errordlg('You must enter a numeric value for Short-Time Average in seconds.','Bad Input','modal')
      set(EDP_STA_Edit, 'String', '1')
    end
  end 

  function EDP_LTA_Edit_CallBack(varargin)
    if (isempty(get(EDP_LTA_Edit,'String'))==1)||...
       (isnan(str2double(get(EDP_LTA_Edit,'String')))==1)
      errordlg('You must enter a numeric value for Long-Time Average in seconds.','Bad Input','modal')
      set(EDP_LTA_Edit, 'String', '8')
    end
  end  

  function EDP_Thresh_On_Edit_CallBack(varargin)
    if (isempty(get(EDP_Thresh_On_Edit,'String'))==1)||...
       (isnan(str2double(get(EDP_Thresh_On_Edit,'String')))==1)
      errordlg('You must enter a numeric value for STA/LTA on threshold','Bad Input','modal')
      set(EDP_Thresh_On_Edit, 'String', '2.2')
    end
  end 

  function EDP_Thresh_Off_Edit_CallBack(varargin)
    if (isempty(get(EDP_Thresh_Off_Edit,'String'))==1)||...
       (isnan(str2double(get(EDP_Thresh_Off_Edit,'String')))==1)
      errordlg('You must enter a numeric value for STA/LTA off threshold','Bad Input','modal')
      set(EDP_Thresh_Off_Edit, 'String', '1.6')
    end
  end 

  function EDP_Skip_Edit_CallBack(varargin)
    if (isempty(get(EDP_Skip_Edit,'String'))==1)||...
       (isnan(str2double(get(EDP_Skip_Edit,'String')))==1)
      errordlg('You must enter a numeric value for Skip Interval.','Bad Input','modal')
      set(EDP_Skip_Edit, 'String', '6')
    end
  end

  function EDP_Min_Dur_Edit_CallBack(varargin)
    if (isempty(get(EDP_Min_Dur_Edit,'String'))==1)||...
       (isnan(str2double(get(EDP_Min_Dur_Edit,'String')))==1)
      errordlg('You must enter a numeric value for minimum event length in seconds.','Bad Input','modal')
      set(EDP_Min_Dur_Edit, 'String', '1.2')
    end
  end

  function PlotES_RaBut_CallBack(h, eventdata)
  end  

  function PlotFI_RaBut_CallBack(h, eventdata)
  end  

  function PlotRMS_RaBut_CallBack(h, eventdata)
  end  

  function PlotPF_RaBut_CallBack(h, eventdata)
  end  

  function [w events] = Engage_PrBut_CallBack(h, eventdata)
      
      host = Host_List{get(Host_PopupMenu, 'Value')};
      port = str2double(get(Port_Edit,'String'));
      ds = datasource('winston',host,port);
      
      station = get(Station_Edit,'String');
      channel = get(Channel_Edit,'String');
      network = get(Network_Edit,'String');
      scnl = scnlobject(station,channel,network);
      
      t1s = get(StartTime_Edit,'String');
      t2s = get(EndTime_Edit,'String');
      t_start = [str2double(t1s(1:4)),str2double(t1s(6:7)),...
                 str2double(t1s(9:10)),str2double(t1s(12:13)),...
                 str2double(t1s(15:16)),str2double(t1s(18:19))];
      t_end =   [str2double(t2s(1:4)),str2double(t2s(6:7)),...
                 str2double(t2s(9:10)),str2double(t2s(12:13)),...
                 str2double(t2s(15:16)),str2double(t2s(18:19))];
      
      gen_hel = get(GenerateHel_RaBut, 'Value');
      hel_min = str2double(get(HelMinutes_Edit, 'String'));
      get_events = get(FindEvents_RaBut, 'Value');
      plot_events = get(PlotEvents_RaBut, 'Value');
      plot_vlp = get(VLP_RaBut, 'Value');
      vlp_rng = [str2double(get(VLP_High_Edit, 'String')),... 
                 str2double(get(VLP_Low_Edit, 'String'))];
             
      edp_sta = str2double(get(EDP_STA_Edit, 'String'));
      edp_lta = str2double(get(EDP_LTA_Edit, 'String'));             
      edp_on  = str2double(get(EDP_Thresh_On_Edit, 'String'));    
      edp_off = str2double(get(EDP_Thresh_Off_Edit, 'String'));  
      edp_skp = str2double(get(EDP_Skip_Edit, 'String'));
      edp_mnd = str2double(get(EDP_Min_Dur_Edit, 'String'));
      edp = [edp_sta edp_lta edp_on edp_off edp_skp edp_mnd];
             
      es  = get(PlotES_RaBut, 'Value');
      fi = get(PlotFI_RaBut, 'Value'); 
      rms = get(PlotRMS_RaBut, 'Value'); 
      pf = get(PlotPF_RaBut, 'Value'); 
      event_ops = [es fi rms pf];
      
      sems_program(ds,scnl,t_start,t_end,gen_hel,hel_min,get_events,plot_events,plot_vlp,vlp_rng,edp,event_ops);

  end  

  return
end