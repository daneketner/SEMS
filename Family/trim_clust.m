function F = trim_clust(F,varargin)

%CORRBLOCK2CLUST: Trim Clusters By Size Range or Time Range
%
%USAGE: F = corrblock2clust(F,varargin)
%
%INPUTS: log
%        
%OUTPUTS: log

%% USER-DEFINED PROPERTIES
if (nargin > 1)
   v = varargin;
   nv = nargin-1;
   if ~rem(nv,2) == 0
      error(['trim_clust: Arguments after wave must appear in ',...
         'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'start'
            m = 1;
            while m <= numel(F.T)
               trim = find(F.T{m} < val);
               F.T{m}(trim) = [];
               F.I{m}(trim) = [];
               if numel(F.T{m}) == 0
                  F.T(m) = [];
                  F.I(m) = [];
                  F.numel(m) = [];
                  F.start(m) = [];
                  F.end(m) = [];
               else
                  m = m+1;
               end
            end
         case 'end'
            m = 1;
            while m <= numel(F.T)
               trim = find(F.T{m} > val);
               F.T{m}(trim) = [];
               F.I{m}(trim) = [];
               if numel(F.T{m}) == 0
                  F.T(m) = [];
                  F.I(m) = [];
                  F.numel(m) = [];
                  F.start(m) = [];
                  F.end(m) = [];
               else
                  m = m+1;
               end
            end
         case 'size'
            if numel(val)==1
               val(2) = Inf;
            elseif numel(val)==2
               if val(1)>val(2)
                  val(1) = temp;
                  val(1) = val(2);
                  val(2) = temp;
               end
            else
               error('trim_clust: property ''size'' is the wrong dimension')
            end
            for m = 1:numel(F.T)
               trim = find(F.numel < val(1) | F.numel > val(2));
               F.T(trim) = [];
               F.I(trim) = [];
               F.numel(trim) = [];
               F.start(trim) = [];
               F.end(trim) = [];
            end
         otherwise
            error('trim_clust: Property name not recognized')
      end
   end
end