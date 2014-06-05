clear all

%% read tape
tape = endfi('..\ref\s-CH4.ENDFB-VII');

%% write tape
endfo(tape,'s-CH4')

%% Pull out a,b,Sab
a = tape{1,2}{1,2}{1,2}{1,30};
b = transpose(tape{1,2}{1,2}{1,2}{1,31});
Sab = tape{1,2}{1,2}{1,2}{1,32};

%% S(a,b) -> SS(a,b)
[ a,b,SSab ] = Sab2SSab( a,b,Sab );

%% Plot a few values of alpha in SS(alpha,-beta)
close all
ax(1) = axes;
semilogy(-b,SSab(9,:))
hold all
semilogy(-b,SSab(28,:))
hold all
semilogy(-b,SSab(44,:)) 
xlabel('\beta (dimensionless energy transfer)')
ylabel('{\fontname{Arial}\it{S}}(\alpha,-\beta)')
title('s-CH{_4} from ENDF/B-VII File 7')
legend('\alpha = 0.968','\alpha = 16.94','\alpha = 151.45')
set(ax(1) ...
  , 'Position', [0.06,0.11,0.42,0.81])
xlim([-25 450])
ylim([1e-10 1]);

%% Plot SS(a,b)
if true
% Create figure
% [ left bottom width height ]
position = [100 100 1100 500];
fig(1) = figure('Units', 'pixels', ...
    'Position', position);
% Axis limits
Xlims = [0 500];
Ylims = [-100 450];

% Subplots
ax(2) = axes;
i(2) = imagesc(a,-b,transpose(SSab));

% Set properties, define positions, colorbar is added to subplot?
set(ax(2) ...
  , 'Position', [0.58,0.11,0.33,0.81] ...
  , 'YDir', 'normal' ...
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

%% SS(a,b) -> S(Q,E)
[ Q,E,SQE ] = SSab2SQE( a,b,SSab );

%% Plot S(Q,E)
if true
% Create figure
% [ left bottom width height ]
position = [100 100 1100 500];
fig(2) = figure('Units', 'pixels', ...
    'Position', position);

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
set(fig(2), 'ColorMap', [0,0,0; jet(64);])
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
