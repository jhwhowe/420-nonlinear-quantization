function autoArrangeFigures(NH, NW, monitor) 
% autoArrangeFigures(NH, NW, monitor) 
% 
% INPUT : 
% NH : number of grid of height direction 
% NW : number of grid of width direction 
% monitor : monitor number (1 or 2) (optional, default 1) 
% OUTPUT : 
% 
% How to use. 
% Call this function once after all figures are opened. 
% 
% get every figures that are opened now and arrange them. 
% if you want arrange automatically, just type 'autoArrangeFigures(0,0)'
% but maximum number of figures for automatic mode is 20. 
% 
% if you want specify size of grid, give non-zero numbers for parameters. 
% but if your grid size is smaller than actually opened, 
% this function will switch to automatic mode and if more 
% figures are opend than maximum number, then it gives error. 
% Example) 
% 10 figures are opend, and you want to arrange them by 2 x 5. 
% Then you can type 'autoArrangeFigures(2,5)' 
% 
% leejaejun, Koreatech, Korea Republic,2014.10.19 
% jaejun0201@koreatech.ac.kr

% source: http://www.mathworks.com/matlabcentral/fileexchange/48480-autoarrangefigures-nh--nw-

if nargin<3 
    monitor = 1; 
end

if monitor > 2
    error('Not support more than 2 monitors')
    return
end
N_FIG = NH * NW; 
if N_FIG == 0 
    autoArrange = 1; 
else 
    autoArrange = 0; 
end

figHandle = flipud(findobj('Type','figure'));
figHandle = sort(figHandle);
n_fig = size(figHandle,1);
if n_fig <= 0 
    error('figures are not found'); 
    return 
end



screen_sz = get(0,'MonitorPositions');
figure_area = screen_sz(monitor,:); % [x y w h]

scn_h = figure_area(4); 
scn_w = figure_area(3);

if autoArrange==0 
    if n_fig > N_FIG 
        autoArrange = 1; 
        warning('too many figures than you told. change to autoArrange'); 
    else 
        nh = NH; 
        nw = NW; 
    end 
end

if autoArrange == 1 
    if n_fig > 20 
        error('too many figures(maximum = 20)') 
    return 
    end 

    grid = [2 2 2 2 2 3 3 3 3 3 3 4 4 4 4 4 4 4 4 4; 
    3 3 3 3 3 3 3 3 4 4 4 5 5 5 5 5 5 5 5 6]'; 

    if scn_w > scn_h 
        nh = grid(n_fig,1); 
        nw = grid(n_fig,2); 
    else 
        nh = grid(n_fig,2); 
        nw = grid(n_fig,1); 
    end 
end

% fig_h = (scn_h-50)/nh;  task bar on the bottom in windows. 

if ispc() == 1  % windows
    fig_h = (scn_h-50)/nh;
else            % Others (Only checked with Ubuntu 12.04)
    fig_h = (scn_h-25)/nh; 
    scn_h = scn_h - 25;
end

fig_w = scn_w/nw;

top_corner_x = figure_area(1);

fig_cnt = 1; 
for i=1:1:nh 
    for k=1:1:nw 
        if fig_cnt>n_fig 
            return 
        end 
        fig_pos = [top_corner_x+fig_w*(k-1) scn_h-fig_h*i fig_w fig_h]; 
        set(figHandle(fig_cnt),'OuterPosition',fig_pos); 
        fig_cnt = fig_cnt + 1; 
    end 
    
end

end