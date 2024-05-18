%Clear
clear
clc
close all


%%Number 2
%% Define G1, G2, G3, G4, H1, H2, and H3

G1_num = [0 0 1];
G1_den = [1 0 0];
G1 = tf(G1_num,G1_den)

G2_num = [0 0 1];
G2_den = [1 1];
G2 = tf(G2_num,G2_den)

G3_num = [0 1];
G3_den = [1 0];
G3 = tf(G3_num,G3_den)

G4_num = [1];
G4_den = [2 0];
G4 = tf(G4_num,G4_den)

H1_num = [0 1];
H1_den = [1 0];
H1 = tf(H1_num,H1_den)

H2_num = [0 1];
H2_den = [1 -1];
H2 = tf(H2_num,H2_den)

H3_num = [0 1];
H3_den = [1 -2];
H3 = tf(H3_num,H3_den)

%% Reduce Block Diagram @G2 and H2
%%since G2 and H2 is series, multiply
G2H2_num = conv(G2_num,H2_num)
G2H2_den = conv(G2_den,H2_den)
TF_G3H2 = tf(G2H2_num,G2H2_den)

%% Reduce Block Diagram @G2H2 and G3
%%since G2H2 and G3 are parallel
G3G2H2_num = conv(G2H2_den,G3_num)
G3G2H2_den_multi = conv(G2H2_den,G3_den)

G3G2H2_den_add = [0 0 0 1]
G3G2H2_den = G3G2H2_den_multi + G3G2H2_den_add 
TF_G2G3H2 = tf(G3G2H2_num,G3G2H2_den)

%% Reduce Block Diagram @G1 and G2
%%since G2 and H2 is series, multiply
G1G2_num = conv(G1_num,G2_num)
G1G2_den = conv(G1_den,G2_den)
TF_G1G2 = tf(G1G2_num,G1G2_den)

%% Reduce Block Diagram @G3G2H2 and G4H3

G2G3G4H2H3_num = conv(G3G2H2_num,H3_den)
G2G3G4H2H3_den = conv(G3G2H2_den,H3_den)

G2G3G4H2H3_multi = conv(G2G3G4H2H3_den,G4_den)
G2G3G4H2H3_den = G2G3G4H2H3_multi + [0 0 0 1 0 -1]
TF_G2G3G4H2H3 = tf(G2G3G4H2H3_num,G2G3G4H2H3_den)


%% Reduce Block Diagram @G2G3G4H2H3 and G1
G1G2G3G4H2H1_num = [1 -3 2]
G1G2G3G4H2H1_den = conv(G2G3G4H2H3_den,G1_den)
TF_G1G2G3G4H2H1 = tf(G1G2G3G4H2H1_num,G1G2G3G4H2H1_den)


%% Reduce Block Diagram @G1G2G3G4H2 and H1
G1G2G3G4H1H2H3_num = conv(H1_num,G1G2G3G4H2H1_num)
G1G2G3G4H1H2H3_multi = conv(G1G2G3G4H2H1_den,H1_den)
%%since
G1G2G3G4H1H2H3_den = G1G2G3G4H1H2H3_multi + [0 0 0 0 0 0 1 -3 2]
TF_reduced = tf(G1G2G3G4H1H2H3_num,G1G2G3G4H1H2H3_den)

%%STEP RESPONSE
step(TF_reduced,0:0.1:20)