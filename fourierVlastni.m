function signalF = fourierVlastni(signal, time, period)
w0=2*pi/period;
M=size(time);
suma=zeros(size(time));
for k=1:size(time)
    suma(k)=sum(signal.*exp(-1j*w0*k*time(k)));
end
signalF=zeros(M);
for m = 1:M
 signalF(m)=1/period*suma(m);
end

end