function sort_index = sort_fft_bins(fft_array,ind)

% Experiment did not work as hoped

n = 1;
N = size(fft_array,2);
power_array = zeros(N);
while n<N
   for k = n+1:N
      power_array(n,k) = sum(fft_array(:,n).*fft_array(:,k));
      power_array(k,n) = power_array(n,k);
      power_array(n,n) = NaN;
   end
   n=n+1;
end

sort_index = [];
while size(power_array,1) > 1
   sort_index = [sort_index ind];
   [A B] = max(power_array(ind,:));
   power_array(ind,:) = [];
   power_array(:,ind) = [];
   if B > ind
      ind = B-1;
   else
      ind = B;
   end
end



   
   
   
