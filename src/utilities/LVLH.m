function [] = LVLH(option)
  % Initialize coordinate vectors
    x = [1; 0; 0];
    y = [0; 1; 0];
    z = [0; 0; 1];
    starts = zeros(3, 3);
    ends = [x y z];
    
    % Initialise vectors
    quiver3(starts(1, :), starts(2, :), starts(3, :), ends(1, :), ends(2, :), ends(3, :), 'k', 'LineWidth', 3,'Linestyle','-.');
    if option ==1
        text(1, 0, 0, '+V direction','HorizontalAlignment','right','FontWeight','bold');
    end
end