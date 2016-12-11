function sems_gui
%
%SEMS_GUI: Graphical User Interface for 'sems_program'.         
%
%INPUTS: none
%
%OUTPUTS: none
  sems_path
  figure('MenuBar','none','Name','sems_GUI','NumberTitle','off','Position',[600,600,415,400]);

  Station_Text = uicontrol('Style','Text','String','Station','Position',[30,350,45,20]);
  Channel_Text = uicontrol('Style','Text','String','Channel','Position',[81,350,45,20]);
  Network_Text = uicontrol('Style','Text','String','Network','Position',[130,350,45,20]);
  Port_Text = uicontrol('Style','Text','String','Port','Position',[180,350,55,20]);
  
  Station_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','RDWB','Position',[30,330,45,20],'CallBack', @Station_Edit_CallBack);
  Channel_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','BHZ','Position',[81,330,45,20],'CallBack', @Channel_Edit_CallBack);
  Network_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','AV','Position',[130,330,45,20],'CallBack', @Network_Edit_CallBack);
  Port_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','16022','Position',[180,330,55,20],'CallBack', @Port_Edit_CallBack);
  
  Host_Text = uicontrol('Style','Text','String','Host','Position',[240,350,150,20]);
  Host_List = {'avovalve01.wr.usgs.gov','pubavo1.wr.usgs.gov','pubnmi1.wr.usgs.gov'};
  Host_PopupMenu = uicontrol('Style','PopupMenu','String',Host_List,'Position',[240,291,150,60],'CallBack', @Host_PopupMenu_CallBack,'BackgroundColor','w');

  StartTime_Text = uicontrol('Style','Text','String','Start Time','Position',[30,300,175,20]);
  EndTime_Text = uicontrol('Style','Text','String','End Time','Position',[215,300,175,20]);
  StartTime_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','2009 04 03 12 00 00','Position',[30,280,175,20],'CallBack', @StartTime_Edit_CallBack);
  EndTime_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','2009 04 03 16 00 00','Position',[215,280,175,20],'CallBack', @EndTime_Edit_CallBack);
  
  GenerateHel_RaBut = uicontrol('Style','RadioButton','String','Generate Helicorder with               minutes of data per line','Position',[30,250,300,20],'CallBack', @GenerateHel_RaBut_CallBack);
  HelMinutes_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','10','Enable','off','Position',[175,250,30,20],'CallBack',@HelMinutes_Edit_CallBack);
  FindEvents_RaBut= uicontrol('Style','RadioButton','String','Find events','Position',[30,220,80,20],'CallBack', @FindEvents_RaBut_CallBack);
  PlotEvents_RaBut= uicontrol('Style','RadioButton','String','Plot events on helicorder','Enable','off','Position',[120,220,140,20],'CallBack', @PlotEvents_RaBut_CallBack);
 
  EDP_Text = uicontrol('Style','Text','String','-------------------------- Event Detection Parameters --------------------------','Position',[30,190,360,20]);
  EDP_STA_Text = uicontrol('Style','Text','String','STA (s)','Position',[140,170,50,20]);
  EDP_STA_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','1','Enable','off','Position',[190,170,20,20],'CallBack', @EDP_STA_Edit_CallBack);
  EDP_LTA_Text = uicontrol('Style','Text','String','LTA (s)','Position',[220,170,50,20]);
  EDP_LTA_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','8','Enable','off','Position',[270,170,20,20],'CallBack', @EDP_LTA_Edit_CallBack);
  EDP_Skip_Text = uicontrol('Style','Text','String','Skip (s)','Position',[300,170,50,20]);
  EDP_Skip_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','6','Enable','off','Position',[350,170,20,20],'CallBack', @EDP_Skip_Edit_CallBack);
  
  EDP_Thresh_Text = uicontrol('Style','Text','String','Thresholds  [On]            [Off]','Position',[70,140,150,20]);
  EDP_Thresh_On_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','2.2','Enable','off','Position',[162,140,25,20],'CallBack', @EDP_Thresh_On_Edit_CallBack);
  EDP_Thresh_Off_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','1.6','Enable','off','Position',[220,140,25,20],'CallBack', @EDP_Thresh_Off_Edit_CallBack);
  EDP_Min_Dur_Text = uicontrol('Style','Text','String','Min Duration (s)','Position',[245,140,90,20]);
  EDP_Min_Dur_Edit = uicontrol('Style','Edit','BackgroundColor','w','String','1.2','Enable','off','Position',[335,140,25,20],'CallBack', @EDP_Min_Dur_Edit_CallBack);
 
  Engage_PrBut = uicontrol('Style','PushButton','String','Engage','BackgroundColor',[1 .6 .8],'Position',[320,20,50,40],'CallBack', @Engage_PrBut_CallBack);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  function Station_Edit_CallBack(varargin)
    if isempty(get(Station_Edit,'String'))==1
      errordlg('You must enter a station.','Bad Input','modal')
      set(Station_Edit, 'String', 'REF')
    end
  end

  function Channel_Edit_CallBack(varargin)
    if isempty(get(Channel_Edit,'String'))==1
      errordlg('You must enter a channel.','Bad Input','modal')
      set(Channel_Edit, 'String', 'EHZ')
    end
  end

  function Network_Edit_CallBack(varargin)
    if isempty(get(Network_Edit,'String'))==1
      errordlg('You must enter a network.','Bad Input','modal')
      set(Network_Edit, 'String', 'AV')
    end
  end

  function Port_Edit_CallBack(varargin)
    if isempty(get(Port_Edit,'String'))==1
      errordlg('You must enter a number for port.','Bad Input','modal')
      set(Port_Edit, 'String', '16022')
    elseif isnan(str2double(get(Port_Edit,'String')))==1
      errordlg('You must enter a number for port.','Bad Input','modal')
      set(Port_Edit, 'String', '16022')
    end
  end

  function Host_PopupMenu_CallBack(varargin)
  end

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
      if (get(FindEvents_RaBut, 'Value') == 1)
        set(PlotEvents_RaBut,'Enable','on')
      end
    else
      set(PlotEvents_RaBut,'Value',0,'Enable','off')
      set(HelMinutes_Edit,'Enable','off')
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
    end 
  end  

  function PlotEvents_RaBut_CallBack(h, eventdata)
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
             
      edp_sta = str2double(get(EDP_STA_Edit, 'String'));
      edp_lta = str2double(get(EDP_LTA_Edit, 'String'));             
      edp_on  = str2double(get(EDP_Thresh_On_Edit, 'String'));    
      edp_off = str2double(get(EDP_Thresh_Off_Edit, 'String'));  
      edp_skp = str2double(get(EDP_Skip_Edit, 'String'));
      edp_mnd = str2double(get(EDP_Min_Dur_Edit, 'String'));
      edp = [edp_sta edp_lta edp_on edp_off edp_skp edp_mnd];
             
      sems_program(ds,scnl,t_start,t_end,gen_hel,hel_min,get_events,plot_events,plot_vlp,vlp_rng,edp,event_ops);

  end  

  return
end