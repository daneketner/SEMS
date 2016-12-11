function callback_scrolltext(source,event,hText)
  textString = get(hText,'UserData');
  nLines = numel(textString);
  lineIndex = nLines-round(get(source,'Value'));
  set(hText,'String',textString(lineIndex:nLines));
end