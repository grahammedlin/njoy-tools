% clear tape ans
% tape = endfi('..\ref\s-CH4.ENDFB-VII');
% endfo(tape,'s-CH4')

a = tape{1,2}{1,2}{1,2}{1,30};
b = transpose(tape{1,2}{1,2}{1,2}{1,31});
Sab = tape{1,2}{1,2}{1,2}{1,32};

%% S(a,b) -> SS(a,b)
% ENDF stores only the positive half, mirror before transforming
SSab = zeros(length(a),2*length(b)-1);
temp1 = horzcat(fliplr(Sab(:,2:end)), Sab);
bs = horzcat(-fliplr(b(2:end)), b);
for i=1:length(bs)
  SSab(:,i) = temp1(:,i) * exp(-bs(i)/2) ;
end

%% Constants
% Temperature in (K)
T = 22; 
% Boltzman constant in (eV/K)
kb = 8.6173324e-5;
% reduced Planck's constant in (eV*s)
hbar = 6.58211928e-16;
% neutron mass in (MeV/c^2) -> (eV/(m/s)^2)
m = 9.39565378e8/2.99792458e8^2;
%% SS(a,b) -> S(Q,E)
Q = sqrt(a*2*m*kb*T)/hbar;
E = kb*T*bs;
SQE = SSab/(kb*T);

%% Plots
close all

% Create figure
% [ left bottom width height ]
position = [100 100 1100 500];
fig(1) = figure('Units', 'pixels', ...
    'Position', position);

% Plot a few values of alpha in SS(alpha,-beta)
ax(1) = axes;
semilogy(-bs,SSab(9,:))
hold all
semilogy(-bs,SSab(28,:))
hold all
semilogy(-bs,SSab(44,:)) 
xlabel('\beta (dimensionless energy transfer)')
ylabel('{\fontname{Arial}\it{S}}(\alpha,\beta)')
title('s-CH{_4} from ENDF/B-VII File 7')
legend('\alpha = 0.968','\alpha = 16.94','\alpha = 151.45')
set(ax(1) ...
  , 'Position', [0.06,0.11,0.42,0.81])
xlim([-25 450])
ylim([1e-10 1]);


%% heat maps
if true
% Axis limits
Xlims = [0 500];
Ylims = [-100 450];

% Subplots
ax(2) = axes;
i(2) = imagesc(a,-bs,transpose(SSab));

% Set properties, define positions, colorbar is added to subplot?
set(ax(2) ...
  , 'Position', [0.58,0.11,0.33,0.81] ...
  , 'YDir', 'normal' ...
  , 'XScale', 'Log' ...
  , 'XLim', Xlims ...
  , 'YLim', Ylims ...
);
set(ax(2) ...
  , 'XLim', Xlims ...
);
set(get(ax(2),'XLabel'),'String',...
    '\alpha (dimensionless momentum transfer)')
set(get(ax(2),'YLabel'),'String',...
    '\beta (dimensionless energy transfer)')
set(get(ax(2),'Title'),'String',...
    's-CH{_4} from ENDF/B-VII File 7')

% Define a colormap, add colorbar key
set(fig(1), 'ColorMap', [0,0,0; jet(64);])
c = colorbar;
set(c ...
  , 'Position', [0.92,0.11,0.02,0.81] ...
);
set(get(c,'YLabel'),'String',...
    'Scattering function {\fontname{Arial}\it{S}}(\alpha,\beta)')

% Set all axis color limits the same
% allax = findobj(gcf,'Type','axes');
% set(ax,'CLim', [min(SSanb_endf(:)) max(SSanb_endf(:))])
% end
end


if false
% Axis limits
Xlims = [0 21];
Ylims = [-.25 .8];

% Subplots
ax(2) = axes;
i(2) = imagesc(Q/1e10,-E,transpose(SQE));

% Set properties, define positions, colorbar is added to subplot?
set(ax(2) ...
  , 'Position', [0.58,0.11,0.33,0.81] ...
  , 'YDir', 'normal' ...
  , 'XLim', Xlims ...
  , 'YLim', Ylims ...
);
set(get(ax(2),'XLabel'),'String',...
    'Momentum transfer, Q (1/A^{-1})')
set(get(ax(2),'YLabel'),'String',...
    'Energy transfer, E (eV)')
set(get(ax(2),'Title'),'String',...
    's-CH{_4} from ENDF File 7')

% Define a colormap, add colorbar key
set(fig(1), 'ColorMap', [0,0,0; jet(64);])
c = colorbar;
set(c ...
  , 'Position', [0.92,0.11,0.02,0.81] ...
);
set(get(c,'YLabel'),'String',...
    'Scattering function {\fontname{Arial}\it{S}}(Q,E)')

% Set all axis color limits the same
% allax = findobj(gcf,'Type','axes');
% set(ax,'CLim', [min(SSanb_endf(:)) max(SSanb_endf(:))])
% end
end
%