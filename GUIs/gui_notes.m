% Things I leaned from GUI examples

% set(S.fh,'WindowButtonMotionFcn',{@fh_wbm_cb,S})
%   This is active as long as cursor is within figure (S.fh)

% get(0,'PointerLocation')
%   Pixels from bottom left of main screen

% set([S.pb1,S.bp2,S.bp3],'call',{pb_cb});
%   One callback for multiple objects

% set(S.ed,'keypressfcn',{@ed_kpfcn,S})
% function ed_kpfcn(varargin)
% [K,S] = varargin{[2,3]}
% Kmod = K.modifier;
% Kkey = K.key;
%   Get Pressed key ('a','s','k') and modifierd ('shift','control')

% seltype = get(S.fh,'selectiontype');
%   'normal' -- left click, 'alt' -- right click

% S.a = findobj('children',S.b); 
%   Find object of which S.b is a child
% S.b = findobj('parent',S.a); 
%   Find object(s) of which S.a is a parent

% strmatch(str2find,str_array) 
%   returns row number
