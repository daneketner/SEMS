clear all; 

fo1 = fopen('vel_10.dat', 'r'); 

data = fscanf(fo1, '%g %g',[2, inf]);


time = data(1, :);
vel = data(2, :); 
dt = time(2) - time(1); 


span = 25; 
window = ones(1, span); 
smoothed = convn(vel, window, 'same'); 
vel = smoothed; 

t_start = 8000;
t_stop = 12000; 

vel_test = vel(t_start:t_stop); 
t_test = time(t_start:t_stop);
%smo_test = smoothed(11000:12000); 

[maxpks, maxloc] = findpeaks(vel_test); 
[minpks, minloc] = findpeaks(-vel_test);

minpks = -minpks;  
svt = size(vel_test);

t = 1:svt(2); 

topenv = spline(maxloc, [0 maxpks 0], t);
botenv = spline(minloc, [0 minpks 0], t);
avgenv = (topenv+botenv)/2;
vel1 = vel_test - avgenv; 

figure(1)
plot(vel_test); 
hold on
plot(maxloc, maxpks, '+');
plot(minloc, minpks, '*'); 
plot(topenv, '--');
plot(botenv, '-.'); 
plot(avgenv); 
hold off

figure(2) 
plot(vel1);

vel1_complex = hilbert(vel1); 

figure(3)
plot3(t, real(vel1_complex), imag(vel1_complex)) 


omega = unwrap(angle(vel1_complex)); 
dwdt = diff(omega)/dt;
%dwdt2 = omega1+diff(abs(tot))/dt;

figure(4)
plot(t_test(1:(t_stop-t_start)), dwdt/2/pi);  
xlabel('time (s)')
ylabel('frequency (Hz)')
axis([time(t_start) time(t_stop) 0 6])
grid 





