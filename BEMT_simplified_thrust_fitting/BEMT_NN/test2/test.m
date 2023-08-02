
rpm_normalize([1000;2000;3000;25000])

function xn = rpm_normalize(x)
    xmin = 1000;
    xmax = 25000;
    xavg = xmin/2 + xmax/2;
    xn = (x-xavg)/(xmax-xmin)*2;
end