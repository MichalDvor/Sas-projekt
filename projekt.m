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

signal_F_opraveny=signal_F;                                         % Vytvoreni opraveneho signalu
periodicke_ruseni=[507.982,517.985, 527.987, 537.99, 547.993, 557.995, 567.998, 578.001 ,588.003,43512,43522,43532,43542,43552,43562,43572,43582,43592];
% rušivé složky dle grafu, ještě 254.0009 dělá divný tón na pozadí, ale neni to periodické rušení bych řekl
periodicke_ruseni=round(periodicke_ruseni*N/frekvence_vzorkovani)+1; % úprava na pořadí v poli (+1 korekce)
signal_F_opraveny(periodicke_ruseni)=0;                          % Odstranění rušivých složek
signal_opraveny=ifft(signal_F_opraveny)*N;

                        % Signal opraveny v casove oblasti
signal_opraveny_n = signal_opraveny / max(max(signal_opraveny),abs(min(signal_opraveny))); % Normalizace

figure(1);                                                      % Plocha pro graf
subplot(2,1,1);                                                 % Rozdeleni na 2 radky, 1 sloupec
plot(t,signal_vzor_n, t, signal_opraveny_n);                    % Vykresleni vzoru a opraveneho signalu v casove 
title("Signal vzor normovany");
xlabel("t [s]");
ylabel("normovana amplituda");
legend("Vzor", "Opraveno");

%frekvence=1:length(signal_F);
osa_frekvence=frekvence_vzorkovani/N*(0:N-1);                   % osa pro amplitudové spektrum [Hz] (podle nápovědy matlabu)

subplot(2,1,2);                                                 % Amplitudové spektrum původního a opraveného signálu
loglog(osa_frekvence, abs(signal_F),osa_frekvence, abs(signal_F_opraveny));     % Graf obrazu frekvencni, ale obe logaritmicke
legend("Vzor", "Opraveno");


audiowrite("opraveno.wav",real(signal_opraveny),frekvence_vzorkovani); % Opraveny audio zaznam


%% 2
clc;
close all;

p=tf('p');                  % vytvori operatorovou promennou p
ws=588*2*pi;
wh=43512*2*pi;
wl=sqrt(ws*wh);
T=1/wl;
K=1/(10*ws);
F=K*p/(T*p+1)^2; 
figure(3)
bode(F);
grid on;


% 3
Ts=1/frekvence_vzorkovani;
z = tf('z',Ts);
a=exp(-Ts/T);
F_z=K*Ts/T^2*a*(z-1)/((z-a)^2);
F_z=minreal(F_z,1e-4);
F_z_c2d=c2d(F,Ts);

figure(4);
subplot(2,2,1);                             %Přechodová charakteristika F, F_z a F_z_c2d
step(F,F_z,F_z_c2d,"--");
legend ("Spojity","Analyticky","c2d");
title("Přechodová char.");
grid on;

subplot(2,2,3);                             %Impulsová charakteristika F, F_z a F_z_c2d
impulse(F,F_z,F_z_c2d,"--");
legend ("Spojity","Analyticky","c2d");
title("Impulsová char.");
grid on;

subplot(2,2,[2,4]);                             %Amplitudová a fázová charakteristika F, F_z a F_z_c2d
bode(F,F_z,F_z_c2d,"--");
legend ("Spojity","Analyticky","c2d");
title("Amplitudová a fázová char.");
grid on;

%4
signal_filtrovany=zeros(N,1);

signal_filtrovany(1)=0;                                 %První 2 prvky filtrovaného signálu
signal_filtrovany(2)=signal_vzor(1)*(-2*a+1+a-Ts/T*a);

for i=(3:N)
signal_filtrovany(i)=signal_vzor(i-1)*(K*Ts*a/(T^2)) + signal_vzor(i-2)*(K*Ts*a/(T^2)) + 2*a*signal_filtrovany(i-1) + a^2*signal_filtrovany(i-2);   
end

windowSize = 5; 
b = (1/windowSize)*ones(1,windowSize);
c = 1;
signal_filter=filter(signal_vzor,b,c);

figure(5);
subplot(2,1,1);                             
plot(t,signal_vzor_n);                      %Původní signál

subplot(2,1,2);                             %Filtrované signály
plot(t,signal_opraveny,t,signal_filter)
