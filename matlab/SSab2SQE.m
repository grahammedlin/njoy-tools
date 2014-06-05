%% SS(a,b) -> S(Q,E)

function [ Q,E,SQE ] = SSab2SQE( a,b,SSab )

constants;

Q = sqrt(a*2*m*kb*T)/hbar;
E = kb*T*b;
SQE = SSab/(kb*T);

end

