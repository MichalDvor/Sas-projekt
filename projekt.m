%1
clc 
clearvars
close all;

[signal_vzor, frekvence_vzorkovani] = audioread('270583.wav');   % Nacteni souboru

signal_vzor_n = signal_vzor / max(max(signal_vzor),abs(min(signal_vzor))); % Normalizace
Ts = 1/frekvence_vzorkovani;                                    % Perioda vzorkování
N = length(signal_vzor);                                        % Délka signálu (perioda)
t=(0:N-1)*Ts;                                                   % vektor času pro signal_vzor [s]


signal_F =fft(signal_vzor)/N;                                     % Fourierova transformace
figure(2);
stem(signal_F);

signal_F_opraveny=signal_F;                                     % Vytvoreni opraveneho signalu
periodicke_ruseni=[254.009,507.982,517.985, 527.987, 537.99, 547.993, 557.995, 567.998, 578.001 ,588.003,43512,43522,43532,43542,43552,43562,43572,43582,43592];% rušivé složky dle grafu
periodicke_ruseni=round(periodicke_ruseni*N/frekvence_vzorkovani)+1; % úprava na pořadí v poli (+1 korekce)
signal_F_opraveny(periodicke_ruseni)=0;                          % Odstranění rušivých složek

signal_opraveny=ifft(signal_F_opraveny)*N;                        % Signal opraveny v casove oblasti
signal_opraveny_n = signal_opraveny / max(max(signal_opraveny),abs(min(signal_opraveny))); % Normalizace

signal_F = fftshift(signal_F);
signal_F_opraveny=fftshift(signal_F_opraveny);
figure(1);                                                      % Plocha pro graf
subplot(2,1,1);                                                 % Rozdeleni na 2 radky, 1 sloupec
plot(t,signal_vzor_n, t, signal_opraveny_n);                    % Vykresleni vzoru a opraveneho signalu v casove 
title("Signal vzor normovany");
xlabel("t [s]");
ylabel("normovana amplituda");
legend("Vzor", "Opraveno");

%frekvence=1:length(signal_F);
osa_frekvence=frekvence_vzorkovani/N*(-N/2:N/2-1);                   % osa pro amplitudové spektrum [Hz] (podle nápovědy matlabu)

subplot(2,1,2);                                                 % Amplitudové spektrum původního a opraveného signálu
osa_frekvence_kladna=osa_frekvence(osa_frekvence>=0);
signal_vykresleni=abs(signal_F(N/2+1:end));
signal_vykresleni_opraveno=abs(signal_F_opraveny(N/2+1:end));
loglog(osa_frekvence_kladna, signal_vykresleni,osa_frekvence_kladna, signal_vykresleni_opraveno);     % Graf obrazu frekvencni, ale obe logaritmicke
legend("Vzor", "Opraveno");


audiowrite("opraveno.wav",real(signal_opraveny),frekvence_vzorkovani); % Opraveny audio zaznam

