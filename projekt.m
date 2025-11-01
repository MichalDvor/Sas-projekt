%1
clc 
clearvars
close all;

[signal_vzor, frekvence_vzorkovani] = audioread('270583.wav');   % Nacteni souboru

signal_vzor_n = signal_vzor / max(max(signal_vzor),abs(min(signal_vzor))); % Normalizace
t=linspace(0,length(signal_vzor_n)/frekvence_vzorkovani,length(signal_vzor_n)); % Casova konstanta vytvoreni vektoru


signal_F =fft(signal_vzor);                                     % Fourierova transformace

signal_F_opraveny=signal_F;                                     % Vytvoreni opraveneho signalu
frekvence_ruseni_h=16108;
frekvence_ruseni_d=13900;
signal_F_opraveny(frekvence_ruseni_d:frekvence_ruseni_h)=0;
signal_F_opraveny(1170000:length(signal_F_opraveny))=0;         % Tohle odstrani to periodicke ruseni, nevim proc

signal_opraveny=ifft(signal_F_opraveny);                        % Signal opraveny v casove oblasti
signal_opraveny_n = signal_opraveny / max(max(signal_opraveny),abs(min(signal_opraveny))); % Normalizace

figure(1);                                                      % Plocha pro graf
subplot(2,1,1);                                                 % Rozdeleni na 2 radky, 1 sloupec
plot(t,signal_vzor_n, t, signal_opraveny_n);                       % Vykresleni vzoru a opraveneho signalu v casove 
title("Signal vzor normovany");
xlabel("t [s]");
ylabel("normovana amplituda");
legend("Vzor", "Opraveno");

frekvence=1:length(signal_F);

subplot(2,1,2);                                                         % Druhy graf
loglog(frekvence, abs(signal_F),frekvence, abs(signal_F_opraveny));     % Graf obrazu frekvencni, ale obe logaritmicke
legend("Vzor", "Opraveno");

%frekvence=0:length(signal_F);
%frekvence_ruseni_h=16108;
%frekvence_ruseni_d=13900;
%signal_F_opraveny=signal_F;                                  %abs(signal_F).*(okno((frekvence-frekvence_ruseni)*(1/sirka_pasma_ruseni)));
%signal_F_opraveny(frekvence_ruseni_d:frekvence_ruseni_h)=0;
%signal_F_opraveny(1170000:length(signal_F_opraveny))=0;      %tohle funguje

audiowrite("opraveno.wav",real(signal_opraveny),frekvence_vzorkovani); % Opraveny audio zaznam
