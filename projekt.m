
%1
clc 
clearvars
close all;

[signal_vzor, frekvence_vzorkovani] = audioread('270583.wav');   % Nacteni souboru

signal_vzor_n = signal_vzor / max(max(signal_vzor),abs(min(signal_vzor))); % Normalizace
t=linspace(0,length(signal_vzor_n)/frekvence_vzorkovani,length(signal_vzor_n)); % Casova konstanta vytvoreni vektoru


signal_F =fft(signal_vzor);

figure(1);                                                      % Plocha pro graf
subplot(2,1,1);                                                 % Rozdeleni na 2 radky, 1 sloupec
plot(t,signal_vzor_n);                                          % Vykresleni vzoru signalu 
title("Signal vzor normovany");
xlabel("t [s]");
ylabel("normovana amplituda");


subplot(2,1,2);                                                 % Druhy graf
loglog(abs(signal_F));                                          % Graf obrazu ve fourierovi, ale obe logaritmicke

frekvence=0:length(signal_F);
frekvence_ruseni_h=16108;
frekvence_ruseni_d=13900;
signal_F_opraveny=signal_F;                                  %abs(signal_F).*(okno((frekvence-frekvence_ruseni)*(1/sirka_pasma_ruseni)));
signal_F_opraveny(frekvence_ruseni_d:frekvence_ruseni_h)=0;
signal_F_opraveny(1170000:length(signal_F_opraveny))=0;      %tohle funguje


signal_opraveny=ifft(signal_F_opraveny);
t=linspace(0,length(signal_opraveny)/frekvence_vzorkovani,length(signal_opraveny)); % Casova konstanta vytvoreni vektoru

figure(2);                                                      % Plocha pro graf
subplot(2,1,1);                                                 % Rozdeleni na 2 radky, 1 sloupec
plot(t,signal_opraveny);                                          % Vykresleni vzoru signalu 
title("Signal opraven");
xlabel("t [s]");
ylabel("normovana amplituda");


subplot(2,1,2);                                                 % Druhy graf
loglog(abs(signal_F_opraveny)); 


audiowrite("opraveno.wav",real(signal_opraveny),frekvence_vzorkovani);