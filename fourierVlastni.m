function signalF = fourierVlastni(signal, time, period)
w0=2*pi/period;
[a,velikost]=size(time);
suma=zeros(size(time));
for k=1:velikost
    suma(k)=sum(signal.*exp(-1j*w0*k*time(k)));
end
sigF=zeros(M);
for m = 1:velikost
 sigF(m)=1/period*suma(m);
end
signalF=sigF;
end
