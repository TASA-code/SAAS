function [quat, vec] = LVLH()
  % Initialize coordinate vectors
    % x = [1; 0; 0];
    % y = [0; 1; 0];
    % z = [0; 0; 1];
    % starts = zeros(3, 3);
    % ends = [x y z];
    
  quat = eye(3,3);
  % Initialise vectors
  % quiver3(starts(1, :), starts(2, :), starts(3, :), ends(1, :), ends(2, :), ends(3, :), 'k', 'LineWidth', 3,'Linestyle','-.');
  vec(1) = quiver3(0,0,0, 1, 0, 0, 'color', "k", 'LineWidth', 3,'Linestyle','-.');
  vec(2) = quiver3(0,0,0, 0, 1, 0, 'color', "k", 'LineWidth', 3,'Linestyle','-.');
  vec(3) = quiver3(0,0,0, 0, 0, 1, 'color', "k", 'LineWidth', 3,'Linestyle','-.');

  text(vec(1).UData, vec(1).VData, vec(1).WData, '+V dir','HorizontalAlignment','right','FontWeight','bold');

end