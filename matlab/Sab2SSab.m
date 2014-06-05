%% S(a,b) -> SS(a,b)
% SSab denotes Script S(a,b), the traditional scattering function, and 
% S(a,b) denotes the symmetric fuction
% S(a,b) = e^(b/2)*SS(a,b)
% because for most materials (probably not hydrogen, deuterium)
% S(a,b) = S(a,-b)
% ENDF stores only the positive half

function [ a,b,SSab ] = Sab2SSab( a,b,Sab )

SSab = zeros(length(a),2*length(b)-1);
temp1 = horzcat(fliplr(Sab(:,2:end)), Sab);
b = horzcat(-fliplr(b(2:end)), b);
for i=1:length(b)
  SSab(:,i) = temp1(:,i) * exp(-b(i)/2) ;
end

end