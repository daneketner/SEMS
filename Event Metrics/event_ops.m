function event_ops(e_wfa)

es = 0;
fi = 1;
rms = 1;
pf = 0;
op_n = es+fi+rms+pf;

figure
w = e_wfa(1);
title_str = ['[',get(w,'station'),' ',get(w,'channel'),' ',...
    get(w,'network'),'] Detected Events' ];
op_c = 1;           % current subplot
if es == 1
    subplot(op_n,1,op_c)
    event_space(e_wfa,'m','plot')
    op_c = op_c+1;
    title(title_str)
end
if fi == 1
    subplot(op_n,1,op_c)
    freq_index(e_wfa,[1,2],[10,20],'plot','fft');
    if op_c == 1
        title(title_str)
    end
    op_c = op_c+1;
end
if rms == 1
    subplot(op_n,1,op_c)
    event_rms(e_wfa,'plot')
    if op_c == 1
        title(title_str)
    end
    op_c = op_c+1;
end
if pf == 1
    subplot(op_n,1,op_c)
    peak_freq(e_wfa,'plot','fft');
    if op_c == 1
        title(title_str)
    end
end
