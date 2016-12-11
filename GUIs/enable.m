function handles = enable(handles,enable)
%
%  Turn Property 'Enable' to 'on' or 'off' for all uicontrols in a figure.
%  'handles' contains all GUI handles
%  handles = enable(handles,1) --> enables all uicontrols
%  handles = enable(handles,0) --> disables all uicontrols
ch = struct2cell(handles);

for n = 1:numel(ch)
    try
        if enable
            set(ch{n},'Enable', 'on')
        else
            set(ch{n},'Enable', 'off')
        end
    catch
    end
end