RI_ret_delay= [16.32631945	16.37543674	16.37543674	16.35498577	8.270210378];
Myopic_ret_delay = [18.03458724	16.16603279	16.29363286	16.3214252	13.05713574];

RI_stack_delay= [4.786825397	4.777777778	4.777777778	4.779047619	4.964761905];
Myopic_stack_delay = [12.66412698	12.41984127	12.14920635	12.39920635	10.02174603];

info  = [15 60 120 180 100];
plot (info, Myopic_ret_delay,'k.-','markerSize',20);
hold on
plot (info, RI_ret_delay,'k-*','markerSize',10);
hold on
plot (info, Myopic_stack_delay,'k-*','markerSize',10);
hold on
plot (info, RI_stack_delay,'k-*','markerSize',10);

retDelay = [Myopic_ret_delay' RI_ret_delay' ];
stackDelay = [Myopic_stack_delay' RI_stack_delay' ];

bar (retDelay)
bar (stackDelay)
xlabel('t*')
% ylabel('')
legend('myopic-MinMax: average customer wait time','myopic-RI: average customer wait time',...
    'myopic-MinMax: average stacking delay' , 'myopic-RI: average stacking delay' , 'Location','northeast')


r15 = [50 36 28 22 21];
r60 = [43 28 24 19 17];
r120 = [37 23 19 16 13.73];
r180 = [30 21 15 14 14];
rfull = [45 41 34 32 34]; 
x = [2000 2250 2500 2750 3000];
plot(x,r15,'k.-','markerSize',20); hold on
plot(x,r60,'k-*','markerSize',10); hold on
plot(x,r120,'k-d','markerSize',10); hold on
plot(x,r180,'k-s','markerSize',10); hold on