function c_vec = load_cursor(file)
if ~strcmp(file(end-3:end),'.bmp')
   file = [file, '.bmp'];
end
c_vec = imread(file);
if (size(c_vec,1) ~= 16) || (size(c_vec,2) ~= 16) % Is bitmap 16x16?
   error('Only 16 x 16 bitmaps allowed')
end
c_vec = double(c_vec);
for n = 1:numel(c_vec)
   if c_vec(n) == 0 % bmp black
      c_vec(n) = 1; % cursor black
   elseif c_vec(n) == 7 % bmp gray
      c_vec(n) = NaN; % cursor transparent
   elseif c_vec(n) == 15 % bmp white
      c_vec(n) = 2; % cursor white
   else
      error('Only black, white, and gray allowed in bitmap')
   end
end