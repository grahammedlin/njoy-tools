%% Organization of ENDF Tapes
% An ENDF _Tape_ is a single ASCII file, 
% each tape may have several _Materials_ (MAT), 
% i.e. MAT=125 is hydrogen, 
% each material has several _Files_ (MF) containing various types of data, 
% i.e. MF=3 are energy cross sections and MF=7 thermal scattering data,
% and each file is broken into _Sections_ (MT), usually by reaction type,
% i.e. in MF=3 section MT=1 is total cross section and MT=2 is elastic.
% Columns 67-80 contain 4 numbers describing each line, right aligned:
%
% MAT [70] MF [72] MT [75] card (line) of MT [80]
%
% MAT value of 0 indicates the end of a material, MT of 0 the end of a
% file, and MF of 0 then end of a section. A MAT value of -1 indicates the
% end of tape.
% Tapes should be 80 columns, although some end lines omit subsequent 
% numbers and aren't.
% records are of a few types, TPID, TEND, CONT, TAB1, etc. 

%% Organization of MatLab tape
% Load tapes into telescoping cell array corresponding 
% to ENDF mat, mt, mf, card
% row 1 is data, row to is identifier, and row 3 is description
% File, section data must be individually handled as each format varies.

function [ tape,file ] = endfi( filename )
%% Load ENDF
% Load entire ENDF tape line-by-line to MatLab cell array.
file = [];
out = [];

fid = fopen(filename,'r');
i = 1;
while true
  tline = fgetl(fid);
  if ischar(tline) 
    file{1,i} = tline;
  else
    break;
  end
  i = i+1;
end
fclose(fid);

% Pull out mat, mf, mt, and card numbers
file{5,length(file)} = [];
for i=1:length(file)
  mat = str2double(file{1,i}(67:70));
  file{2,i} = mat;
  if (length(file{1,i})>70) % file{2,i}>0)
    mf = str2double(file{1,i}(71:72));
    file{3,i} = mf;
    if (length(file{1,i})>72) % mf > 0)
      mt = str2double(file{1,i}(73:75));
      file{4,i} = mt;
      if (length(file{1,i})>75) % mt > 0)
        card = str2double(file{1,i}(76:80));
        file{5,i} = card;
      end
    end
  end
end

n = 1; % read line number
k = 1; % write line number
s = 1; % write section line
f = 1; % write file line
m = 1; % write material line
 
% first line is label and may contain info (despite mf=mt=0)
mat = file{2,n};
mf = file{3,n};
mt = file{4,n};
[matd,mfd,mtd] =  deal('Head');

[out,file,n,k] = texti(out,file,n,k,1,1);
  out{3,k-1} = 'Head';
  
% Virtual SEND
tape{1,m}{1,f}{1,s} = out;
out = {};
tape{1,m}{1,f}{2,s} = mt;
tape{1,m}{1,f}{3,s} = mtd;
%n = n+1;
k = 1;
s = s+1;

% Virtual FEND
tape{1,m}{2,f} = mf;
tape{1,m}{3,f} = mfd;
%n = n+1;
s = 1;
f = f+1;

% Virtual MEND
tape{2,m} = mat;
tape{3,m} = matd;
%n = n+1;
f = 1;
m = m+1;

% No TEND
mat = file{2,n};
mf = file{3,n};
mt = file{4,n};
matd = 'Material'; %add lookup?
[mfd,mtd] =  deal('TPID');

% TPID always comes next
% Start TPID block
[out,file,n,k] = conti(out,file,n,k,1:1:6,1);
  out{3,k-6} = 'ZA/MAT number';
  out{3,k-5} = 'AWR: ratio of target mass to neutron mass';
  out{3,k-4} = 'LRP: =-1, no File 2 given';
  out{3,k-3} = 'LFI: =0, this material does not fission';
  out{3,k-2} = 'NLIB: Library identifier, =0 for ENDF/B';
  out{3,k-1} = 'NMOD: Modification number, =0, evaluation converted from a previous version';

[out,file,n,k] = conti(out,file,n,k,1:1:6,1);
  out{3,k-6} = 'ELIS: Excitation energy of the target nucleus relative to 0.0 for the ground state';
  out{3,k-5} = 'STA: Target stability, =0, stable nucleus';
  out{3,k-4} = 'LIS: State number, =0 is ground state';
  out{3,k-3} = 'LISO" Isomeric state number. =0 is ground state';
  out{3,k-2} = '0';
  out{3,k-1} = 'NFOR Library format, i.e. version=6';

[out,file,n,k] = conti(out,file,n,k,1:1:6,1);
  out{3,k-6} = 'AWI: Mass of projectile in neutron mass units, i.e. =1';
  out{3,k-5} = 'EMAX: Upper limit of the energy range for evaluation';
  out{3,k-4} = 'LREL: Library release number, i.e. =2 for the ENDF/B-VI.2';
  out{3,k-3} = '0';
  out{3,k-2} = 'NSUB: Sub-library number';
  out{3,k-1} = 'NVER: Library version number, i.e. =7 for version ENDF/B-VII';

[out,file,n,k] = conti(out,file,n,k,1:1:6,1);
  out{3,k-6} = 'TEMP: Target temperature (K) for data generated by Doppler broadening. Use =0.0 primary evaluations';
  out{3,k-5} = '0.0';
  out{3,k-4} = 'LDRV: Special derived material flag, distinguishes between different evaluations with the same material keys';
  out{3,k-3} = '0';
  out{3,k-2} = 'NWD: Number of records with descriptive text';
  out{3,k-1} = 'NXC: Number of records in the directory for this material';

% Comment block
i=1;
while file{4,n+(i-1)} == 451
 i = i+1;
end
i = i-1;
[out,file,n,k] = texti(out,file,n,k,i,1);
  out{3,k-1} = 'Comments';

% what about index block?! Use NWD number

% SEND
tape{1,m}{1,f}{1,s} = out;
out = {};
tape{1,m}{1,f}{2,s} = mt;
tape{1,m}{1,f}{3,s} = mtd;
n = n+1;
k = 1;
s = s+1;

% FEND
tape{1,m}{2,f} = mf;
tape{1,m}{3,f} = mfd;
n = n+1;
s = 1;
f = f+1;

% No MEND
mat = file{2,n};
mf = file{3,n};
mt = file{4,n};
matd = 'Material'; %add lookup?

% Start reading files
% File 7
if mf == 7
  mfd = 'Thermal Data';

% Section 2, Elastic
% Head
if mt == 2
[out,file,n,k] = conti(out,file,n,k,1:1:6,1);
  out{3,k-6} = 'ZA/MAT number';
  out{3,k-5} = 'AWR: ratio of target mass to neutron mass';
  out{3,k-4} = 'LTHR: type of elastic thermal data, =2 for incoherent elastic, =1 for coherent';
  out{3,k-3} = '0';
  out{3,k-2} = '0';
  out{3,k-1} = '0';

% Coherent Elastic
if out{1,length(out)-3} == 1
  mtd = 'Coherent Elastic Data';
  
  % not yet
  return
end

% Incoherent Elastic
if out{1,length(out)-3} == 2
  mtd = 'Incoherent Elastic Data';
  [out,file,n,k] = tab1i(out,file,n,k,1);
  out{3,k-10} = 'SB: characteristic bound cross section (barns)';
  out{3,k-9} = '0.0';
  out{3,k-8} = '0';
  out{3,k-7} = '0';
  out{3,k-6} = 'NR';
  out{3,k-5} = 'NP: Number of temperatures';
  out{3,k-4} = 'interpolation stuff';
  out{3,k-3} = 'interpolation stuff';
  out{3,k-2} = 'T (k)';
  out{3,k-1} = 'W`(T) Debye-Waller integral divided by atomic mass (eV?1) as a function of temperature (K)';
end

% SEND
tape{1,m}{1,f}{1,s} = out;
out = {};
tape{1,m}{1,f}{2,s} = mt;
tape{1,m}{1,f}{3,s} = mtd;
n = n+1;
k = 1;
s = s+1;

mat = file{2,n};
mf = file{3,n};
mt = file{4,n};

end

% Section 4, Incoherent Inelastic
if mt == 4
  mtd = 'Incoherent Inelastic Data';
% Head
[out,file,n,k] = conti(out,file,n,k,1:1:6,1);
  out{3,k-6} = 'ZA/MAT number';
  out{3,k-5} = 'AWR: ratio of target mass to neutron mass';
  out{3,k-4} = '0';
  out{3,k-3} = 'LAT: which temperature used to compute a and b, =0 the actual temperature, =1, divided by constant T0 = 0.0253 eV';
  out{3,k-2} = 'LASYM: whether an asymmetric S(a, b), =0, S is symmetric, =1, S is asymmetric';
  out{3,k-1} = '0';

% Parameter List
[out,file,n,k] = listi(out,file,n,k,1);
  out{3,k-7} = '0.0';
  out{3,k-6} = '0.0';
  out{3,k-5} = 'LLN: form of S(s, b), =0, S directly, =1, ln(S)';
  out{3,k-4} = '0';
  out{3,k-3} = 'NI: Total number of items in the B(N) list. NI=6(NS+1)';
  out{3,k-2} = 'NS: Number of non-principal scattering atom types. Usually (NS+1) types of atoms in the molecule';
  out{3,k-1} = 'B(N): List of constants';

% S(a,b)
% only 1 temperature!
[out,file,n,k] = tab2i(out,file,n,k,1);
  out{3,k-11} = 'T0';
  out{3,k-3} = 'a';
  out{3,k-2} = 'b';
  out{3,k-1} = 'S(a,b)';

% Effective temperatures
[out,file,n,k] = tab1i(out,file,n,k,1);
  out{3,k-10} = '0.0';
  out{3,k-9} = '0.0';
  out{3,k-8} = '0';
  out{3,k-7} = '0';
  out{3,k-6} = 'NR';
  out{3,k-5} = 'NT: Number of temperatures, LT+1';
  out{3,k-4} = 'interpolation stuff';
  out{3,k-3} = 'interpolation stuff';
  out{3,k-2} = 'T (K)';
  out{3,k-1} = 'Teff0 (K): effective temperatures for the short collision-time approximation for the principal atom';

% SEND
tape{1,m}{1,f}{1,s} = out;
out = {};
tape{1,m}{1,f}{2,s} = mt;
tape{1,m}{1,f}{3,s} = mtd;
n = n+1;
k = 1;
s = s+1;
  
end

% FEND
tape{1,m}{2,f} = mf;
tape{1,m}{3,f} = mfd;
n = n+1;
s = 1;
f = f+1;

end

% MEND

tape{2,m} = mat;
tape{3,m} = matd;

% TEND

% Notes:
% ~feof(fid) is a test for end of file

end

%% Control functions
% For controling reading tape
% if mt = 0 -> SEND
% if mf = 0 -> FEND
% if mat = 0 -> MEND
% if mat = -1 -> TEND

% not yet

%% File functions
% For reading various types of files

% not yet

%% Section functions
% For reading various types of sections

% not yet

%% Record functions
% For reading various types of records
% out, file, n, k have the same definitions 
% q: number of something to read, different per function
% wrt: append out, if used alone, or return just the data, if used within 
%   another function

function [ out,file,n,k ] = conti( out,file,n,k,q,wrt )
% Parallels contio from njoy endf.f90
% Read control record
% [MAT,MF,MT/C1,C2,L1,L2,N1,N2]CONT
% A special case is the HEAD record which starts a section
% C1 and C2 fields always contain ZA and AWR, respectively
% q: list of entries to read

read = readnum( file,n,q);
n = n+1;

if wrt
  out(1,k:k+length(q)-1) = read(1:length(q));
  k = k+length(q);
else
  out = read;
end

end  

function [ out,file,n,k ] = listi( out,file,n,k,wrt )
% Parallels listio from njoy endf.f90
% Read list record
% [MAT,MF,MT/ C1, C2, L1, L2, NPL, N2/ Bn] LIST
% List of NPL numbers Bn

[temp1,file,n,k] = conti(out,file,n,k,1:1:6,0);
npl = temp1{1,length(temp1)-1};
m = ceil(npl/6);
for i = 1:m
  temp2(1+(i-1)*6:i*6) = readnum( file,n,1:1:6);
  n = n+1;
end

if wrt
  out(1,k:k+5) = temp1;  
  k = k+6;
  out{1,k} = temp2;
  k = k+1;
else
  out = {};
  out(1,1:6) = temp1;  
  out(1,7) = temp2; 
end

end

function [ out,file,n,k ] = tab1i( out,file,n,k,wrt )
% Parallels tab1io from njoy endf.f90
% Read one dimensional table record
% [MAT,MF,MT/ C1, C2, L1, L2, NR, NP/xint/y(x)] TAB1
% 

[temp1,file,n,k] = conti(out,file,n,k,1:1:6,0);
nr = temp1{1,length(temp1)-1};
np = temp1{1,length(temp1)};
[temp2,file,n] = conti(out,file,n,k+1,1:1:2,0);
xint = temp2{1,length(temp2)-1};
y = temp2{1,length(temp2)};
m = ceil(np/3);
for i=1:m
  if i == m
    j = rem(np,3);
    temp3(1+(i-1)*6:(i-1)*6+2*j) = readnum( file,n,1:1:2*j);
  else
    temp3(1+(i-1)*6:i*6) = readnum( file,n,1:1:6);
  end
  n = n+1;
end

if wrt
  out(1,k:k+5) = temp1;
  k = k+6;
  out(1,k:k+1) = temp2;
  k = k+2;
  out{1,k} = temp3(1:2:length(temp3));
  k = k+1;
  out{1,k} = temp3(2:2:length(temp3));
  k = k+1;
else
  out = {};
  out(1,1:6) = temp1;
  out(1,7:8) = temp2;
  out{1,9} = temp3(1:2:length(temp3));
  out{1,10} = temp3(2:2:length(temp3));
end

end

function [ out,file,n,k ] = tab2i( out,file,n,k,wrt )
% Parallels tab2io from njoy endf.f90
% Read two dimensional table record
% [MAT,MF,MT/ C1, C2, L1, L2, NR, NZ/ Zint] TAB2
% 

[temp1,file,n,k] = conti(out,file,n,k,1:1:6,0);
nrz = temp1{1,length(temp1)-1};
nz = temp1{1,length(temp1)};
[temp2,file,n,k] = conti(out,file,n,k,1:1:2,0);
zint = temp2{1,length(temp2)-1};
zint = temp2{1,length(temp2)};

for i=1:nz    
  % TAB1 over T0
   [temp3,~,n,k] = tab1i(out,file,n,k,0);
   temp6 = temp3(1,1:6);
   temp7 = temp3(1,7:8);
   temp4(i,:) = temp3{1,2}; % b
   temp5(i,:) = temp3{1,10};   % S
end
% n = n + ???

if wrt
  out(1,k:k+5) = temp1;
  k = k+6;
  out(1,k:k+1) = temp2;
  k = k+2;
  out(1,k:k+5) = temp6;
  k = k+6;
  out(1,k:k+1) = temp7;
  k = k+2;
  %out{1,k} = temp3{1,1}; % T
  %k = k+1;
  out{1,k} = cell2mat(temp3{1,length(temp3)-1}); % a
  k = k+1;
  out{1,k} = temp4; % b
  k = k+1;
  out{1,k} = transpose(cell2mat(temp5)); % S
  k = k+1;
else
  % nothing uses this as a subfunction
  return
end

end

function [ out,file,n,k ] = texti( out,file,n,k,q,wrt )
% Parallels tpidio from njoy endf.f90
% Read text record
% [MAT, MF, MT/ HL] TEXT
% HL = 66 characters of text
% A special case is TPID, the first entry in a tape
% q: lines to read

for i=1:q
  temp1{i} = file{1,n}(1:66); 
  n = n+1;
end

if wrt
  out{1,k} = temp1;
else
  out = temp1;
end
k = k+1;

end

%% Ancillary functions
% For doing chores

function [ read ] = readnum( file,n,q )
% Read one line of up to 6 numbers

read{1,length(q)} = [];
i = 1;
for m=q
  temp1 = file{1,n}((11*m-10):(11*m));
  % Matlab doesn't recoginze NNN+N as exponential
  temp2 = union(strfind(temp1,'+'),strfind(temp1,'-'));
  % if null or negative number
  if isempty(temp2) || isstrprop(temp1(temp2-1), 'wspace')
     temp6 = str2double(temp1);
  % else exponential
  else 
     temp4 = str2double(temp1(1:temp2-1));
     temp5 = str2double(temp1(temp2:11));
     temp6 = temp4 * 10^ temp5;
   end  
   read{1,i} = temp6;
   i = i+1;
end

end