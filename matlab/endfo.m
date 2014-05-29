%% Write MatLab to ENDF tape
% Write cell array to ASCII tape

%% Write ENDF
% Write entire ENDF tape line-by-line from MatLab cell array

function [ ] = endfo( tape, filename )

% first line is label and may contain info (despite mf=mt=0)
% reset
n = 1; % write line number
k = 1; % read tape line number
c = 0; % write card line
s = 1; % write section line
f = 1; % write file line
m = 1; % write material line

% build string
file{1,n} = sprintf('%66s',tape{1,m}{1,f}{1,s}{1,k}{:});
file{2,n} = tape{2,m}; % mat
file{3,n} = tape{1,m}{2,f}; % mf
file{4,n} = tape{1,m}{2,f}; % mt
file{5,n} = 0; % card
c = c+1;

% TPID
k = 1; % read tape line number
% advance
m = m+1;
n = n+1;

for i=1:4
  temp1 = num2endf([tape{1,m}{1,f}{1,s}{1,k:k+5}],0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = tape{1,m}{1,f}{2,s}; % mt
  file{5,n} = c; % card
c = c+1;
n = n+1;
k = k+6;
end
clear temp*

for i=1:length(tape{1,m}{1,f}{1,s}{1,k})
  file{1,n} = tape{1,m}{1,f}{1,s}{1,k}{i};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = tape{1,m}{1,f}{2,s}; % mt
  file{5,n} = c; % card
c = c+1;
n = n+1;
end

% SEND
  temp1 = num2endf(zeros(6,1),0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = 0; % mt
  file{5,n} = 99999; % card
  c = 0;
  n = n+1;
  s = s+1;
  clear temp*
  
% FEND
  temp1 = num2endf(zeros(6,1),0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = 0; % mf
  file{4,n} = 0; % mt
  file{5,n} = 0; % card
  f = f+1;
  n = n+1;
  k = 1; % read tape line number
  c = c+1; % write card line
  s = 1; % write section line
  clear temp*

% File 7
% Section 2
% Head
  temp1 = num2endf([tape{1,m}{1,f}{1,s}{1,k:k+5}],0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = tape{1,m}{1,f}{2,s}; % mt
  file{5,n} = c; % card
  c = c+1;
  n = n+1;
  k = k+6;
clear temp*

% TAB1
temp1 = num2endf([tape{1,m}{1,f}{1,s}{1,k:k+7}],0);
for i=1:2
file{1,n} = temp1{i};
file{2,n} = tape{2,m}; % mat
file{3,n} = tape{1,m}{2,f}; % mf
file{4,n} = tape{1,m}{1,f}{2,s}; % mt
file{5,n} = c; % card
c = c+1;
n = n+1;
end
k = k+8;
clear temp*

for i=1:length(tape{1,m}{1,f}{1,s}{1,k})
  temp2(2*i-1) = tape{1,m}{1,f}{1,s}{1,k}{i};
  temp2(2*i) = tape{1,m}{1,f}{1,s}{1,k+1}{i};
end
temp1 = num2endf(temp2,1);
file{1,n} = temp1{1};
file{2,n} = tape{2,m}; % mat
file{3,n} = tape{1,m}{2,f}; % mf
file{4,n} = tape{1,m}{1,f}{2,s}; % mt
file{5,n} = c; % card
c = c+1;
n = n+1;
k=k+1;
clear temp*

% SEND
  temp1 = num2endf(zeros(6,1),0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = 0; % mt
  file{5,n} = 99999; % card
  c = 0;
  n = n+1;
  s = s+1;
  k = 1;
  clear temp*
  
% Section 4
% Head
  temp1 = num2endf([tape{1,m}{1,f}{1,s}{1,k:k+5}],0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = tape{1,m}{1,f}{2,s}; % mt
  file{5,n} = c; % card
  c = c+1;
  n = n+1;
  k = k+6;
clear temp*

  temp1 = num2endf([tape{1,m}{1,f}{1,s}{1,k:k+5}],0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = tape{1,m}{1,f}{2,s}; % mt
  file{5,n} = c; % card
  c = c+1;
  n = n+1;
  k = k+6;
clear temp*

% LIST
  temp1 = num2endf([tape{1,m}{1,f}{1,s}{1,k}{:}],1);
for i = 1:length(temp1)
  file{1,n} = temp1{i};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = tape{1,m}{1,f}{2,s}; % mt
  file{5,n} = c; % card
  c = c+1;
  n = n+1;
end
  k = k+1;
clear temp*

% TAB2
temp1 = num2endf([tape{1,m}{1,f}{1,s}{1,k:k+7}],0);
for i=1:2
file{1,n} = temp1{i};
file{2,n} = tape{2,m}; % mat
file{3,n} = tape{1,m}{2,f}; % mf
file{4,n} = tape{1,m}{1,f}{2,s}; % mt
file{5,n} = c; % card
c = c+1;
n = n+1;
end
k = k+8;
clear temp*

p = k;
k = k+8;
temp1 = tape{1,m}{1,f}{1,s}{1,k}; % alpha
temp2 = tape{1,m}{1,f}{1,s}{1,k+1}; % beta
temp3 = tape{1,m}{1,f}{1,s}{1,k+2}; % S

%repeat start
for j=1:length(temp2)

temp4 = num2endf( ...
    [tape{1,m}{1,f}{1,s}{1,p} ...
    temp2(j) ...
    tape{1,m}{1,f}{1,s}{1,p+2:p+7}] ...
    ,0);
for i=1:2
file{1,n} = temp4{i};
file{2,n} = tape{2,m}; % mat
file{3,n} = tape{1,m}{2,f}; % mf
file{4,n} = tape{1,m}{1,f}{2,s}; % mt
file{5,n} = c; % card
c = c+1;
n = n+1;
end

for i=1:length(temp1)
  temp5(2*i-1) = temp1(i);
  temp5(2*i) = temp3(i,j);
end

temp6 = num2endf(temp5,1);
for i=1:length(temp6)
file{1,n} = temp6{i};
file{2,n} = tape{2,m}; % mat
file{3,n} = tape{1,m}{2,f}; % mf
file{4,n} = tape{1,m}{1,f}{2,s}; % mt
file{5,n} = c; % card
c = c+1;
n = n+1;
end

end
k=k+3;
clear temp*

% TAB1
temp1 = num2endf([tape{1,m}{1,f}{1,s}{1,k:k+7}],0);
for i=1:2
file{1,n} = temp1{i};
file{2,n} = tape{2,m}; % mat
file{3,n} = tape{1,m}{2,f}; % mf
file{4,n} = tape{1,m}{1,f}{2,s}; % mt
file{5,n} = c; % card
c = c+1;
n = n+1;
end
k = k+8;
clear temp*

for i=1:length(tape{1,m}{1,f}{1,s}{1,k})
  temp2(2*i-1) = tape{1,m}{1,f}{1,s}{1,k}{i};
  temp2(2*i) = tape{1,m}{1,f}{1,s}{1,k+1}{i};
end
temp1 = num2endf(temp2,1);
file{1,n} = temp1{1};
file{2,n} = tape{2,m}; % mat
file{3,n} = tape{1,m}{2,f}; % mf
file{4,n} = tape{1,m}{1,f}{2,s}; % mt
file{5,n} = c; % card
c = c+1;
n = n+1;
k=k+1;
clear temp*

% SEND
  temp1 = num2endf(zeros(6,1),0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = tape{1,m}{2,f}; % mf
  file{4,n} = 0; % mt
  file{5,n} = 99999; % card
  c = 0;
  n = n+1;
  s = s+1;
  clear temp*
  
% FEND
  temp1 = num2endf(zeros(6,1),0);
  file{1,n} = temp1{1};
  file{2,n} = tape{2,m}; % mat
  file{3,n} = 0; % mf
  file{4,n} = 0; % mt
  file{5,n} = 0; % card
  f = f+1;
  n = n+1;
  k = 1; % read tape line number
  c = c+1; % write card line
  s = 1; % write section line
  clear temp*
  
% MEND
  temp1 = num2endf(zeros(6,1),0);
  file{1,n} = temp1{1};
  file{2,n} = 0; % mat
  file{3,n} = 0; % mf
  file{4,n} = 0; % mt
  file{5,n} = 0; % card
  f = f+1;
  n = n+1;
  k = 1; % read tape line number
  c = c+1; % write card line
  s = 1; % write section line
  clear temp*
  
% TEND
  file{1,n} = sprintf('%66s',[]);
  file{2,n} = -1; % mat
  file{3,n} = 0; % mf
  file{4,n} = 0; % mt
  file{5,n} = 0; % card
  f = f+1;
  n = n+1;
  k = 1; % read tape line number
  c = c+1; % write card line
  s = 1; % write section line
  clear temp*

% wrtie ASCII file
fid = fopen(filename,'w');

for i=1:length(file)
fprintf(fid,...
 [...
    file{1,i},...
    sprintf('%4s', num2str(file{2,i})),...
    sprintf('%2s', num2str(file{3,i})),...
    sprintf('%3s', num2str(file{4,i})),...
    sprintf('%5s', num2str(file{5,i})),...
    '\n'...
  ]...
);
end

%fprintf(fid,...

% append or truncate string with spaces to 66 char
%c = cellfun(@(x) sprintf('% 4s',x),c,'un',0);

% done
fclose(fid);

end

%% Control functions
% For controling reading tape
% if mt = 0 -> SEND
% if mf = 0 -> FEND
% if mat = 0 -> MEND
% if mat = -1 -> TEND

%% Main functions
% For writing various types of records

function [ out,file,n,k ] = conto( out,file,n,k,q,wrt )

end

function [ out,file,n,k ] = listo( out,file,n,k,wrt )

end

function [ out,file,n,k ] = tab1o( out,file,n,k,wrt )

end

function [ out,file,n,k ] = tab2o( out,file,n,k,wrt )

end

function [ out,file,n,k ] = texto( out,file,n,k,q,wrt )

end

%% Ancillary functions
% For doing chores

function [ endf ] = num2endf( num,q )
% Read numbers and return lines of 66 chars of 6 formatted numbers

m = ceil(length(num)/6);
endf={};

for i = 1:m*6
  if i>length(num)
    str{i} = '          ';
  elseif ~isnumeric(num(i)) || isempty(num(i))
    % not a number
    str{i} = sprintf('%10s',num(i));
  elseif rem(num(i),1) ~= 0 || i <=2 || q == 1
    % exponential
    if num(i) == 0
      num_exp = 0;
    else
      num_exp = floor(log10(num(i)));
    end
    if num_exp == 0
      str_coeff = sprintf('%1.10f',num(i));
    else
      str_coeff = sprintf('%1.10f',num(i)/(10^num_exp));
    end
    temp1 = num2str(num_exp);
    if num_exp >= 0
      temp1 = ['+' temp1];
    end
    str{i} = [str_coeff(1:10-length(temp1)) temp1];
  else
    % integer
    str{i} = sprintf('%10s',num2str(num(i)));
  end
end

for i = 1:m
  endf{i} = [' ' strjoin(str(1+(i-1)*6:i*6))];
end

end

function [ read ] = writenum( file,n,q )
% Read one line of up to 6 numbers

end

function [ read ] = writetext( file,n,q )
% Read one line of up to 6 numbers

end