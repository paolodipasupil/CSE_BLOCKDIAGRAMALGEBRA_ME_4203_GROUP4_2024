%Clear
clear
clc
close all

%%Number 1
%% DEFINE G1, G2, G3, H1, H2 AND H3
G1_num = [0 0 1];
G1_den = [1 0 0];
G1 = tf(G1_num,G1_den)

G2_num = [0 0 1];
G2_den = [1 1];
G2 = tf(G2_num,G2_den)

G3_num = [0 1];
G3_den = [1 0];
G3 = tf(G3_num,G3_den)

H1_num = [0 1];
H1_den = [1 0];
H1 = tf(H1_num,H1_den)

H2_num = [0 1];
H2_den = [1 -1];
H2 = tf(H2_num,H2_den)

H3_num = [0 1];
H3_den = [1 -2];
H3 = tf(H3_num,H3_den)

%%Reduce Block Diagram for G2 and H2
GH2_den = conv(G2_den,H2_den);
GH2_num = conv(G2_num,H2_num);
GH2= tf(GH2_num, GH2_den)

T_F2num = conv(G2_num,GH2_den)
T_F2den_add = GH2_den + [0 0 1]
T_F2den = conv(T_F2den_add, G2_den)
TF2 = tf(T_F2num,T_F2den)

%%FOR 1/G2 branch
G2_branchrule_num = [1]
G2_num_along = [1]
TF_G2_branch = [G2_branchrule_num / G2] + G2_num_along
Recip_G2_num = TF_G2_branch

%%Reduce Block Diagram for G3 and H3
GH3_den = conv(G3_den,H3_den);
GH3_num = conv(G3_num,H3_num);

T_F3num = conv(G3_num,GH3_den)
T_F3den_add = GH3_den+ GH3_num;
T_F3den = conv(G3_den,T_F3den_add)
TF3 = tf(T_F3num,T_F3den)

%%Reduce Block Diagram for G3 and H3, 1/G2 branch
TF_G3H3recipG2_num = [1 0 -4 0]
TF_G3H3recipG2_den = T_F3den
TF_G3H3recipG2 = tf(TF_G3H3recipG2_num, TF_G3H3recipG2_den)

%%Reduce Block Diagram for G1 and G2H2
TF_G1G2H2_num = conv(G1_num, T_F2num)
TF_G1G2H2_den= conv(G1_den, T_F2den)
TF_G1G2H2= tf(TF_G1G2H2_num, TF_G1G2H2_den)

%%Reduce Block Diagram for H1 and G1G2H2
G1G2H2H1_den = conv(TF_G1G2H2_den, H1_den)
G1G2H2H1_num = conv(TF_G1G2H2_num, H1_num)
G1G2H2H1 = tf(G1G2H2H1_num,G1G2H2H1_den)

%%denominator
TF_G1G2H2H1_den_add = G1G2H2H1_den + TF_G1G2H2_num
TF_G1G2H2H1_den = conv(TF_G1G2H2H1_den_add,TF_G1G2H2_den)
TF_G1G2H2H1_num = conv(TF_G1G2H2_num,G1G2H2H1_den)
TF_G1G2H2H1= tf(TF_G1G2H2H1_num,TF_G1G2H2H1_den)

%%%%for TF_G1G2H2H1=tf(TF_G1G2H2H1_num,TF_G1G2H2H1_den)
%%% say A_num = TF_G1G2H2H1_num
%%% say A_den = TF_G1G2H2H1_den
A_num = [1 1 -1 -1 0 0 0 0 0]
A_den = [1 2 1 0 1 1 -1 -1 0 0 0 0]

%%%TF_G3H3recipG2 = tf(TF_G3H3recipG2_num, TF_G3H3recipG2_den)
%%% say B_num = TF_G3H3recipG2_num
%%% say B_den = TF_G3H3recipG2_den
B_num = [1 0 -4 0]
B_den = [1 -2 1 0]

%%since series, 
TF_reduced_num = conv(A_num,B_num)
TF_reduced_den = conv(A_den,B_den)
TF_reduced = tf(TF_reduced_num, TF_reduced_den)

%%STEP RESPONSE
step(TF_reduced,0:0.1:20)