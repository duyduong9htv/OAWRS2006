function PrepFiguresForPPT(fh,fontSize)
%
% The purpose of this function is to change the visual appearance of a
% Matlab figure to make it suitable for PowerPoint
%
% The input variables are:
%
%   axesHandle = vector of axis handles
%
%   Created By: David Reed
%

% th = findall(fh,'Type','text');
% set(th,'FontWeight','Bold','FontSize', fontSize)

ch = allchild(fh);

for ii = 1:length(ch)
    
    if strcmp((get(ch(ii),'Type')),'axes')
        set(ch(ii), 'FontSize', fontSize, 'FontWeight', 'Bold');
        
        hx = get(ch(ii),'xlabel');
        hy = get(ch(ii),'ylabel');
        ht = get(ch(ii),'Title');
        
        if ~isempty(hx)
            set(hx, 'FontWeight', 'Bold', 'FontSize', fontSize);
        end
        if ~isempty(hy)
            set(hy, 'FontWeight', 'Bold', 'FontSize', fontSize);
        end
        if ~isempty(ht)
            set(ht, 'FontWeight', 'Bold', 'FontSize', fontSize);
        end
    end
end