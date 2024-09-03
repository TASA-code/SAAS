function [STR_TRACE, cone_handle] = STR_update(q_rotation, STR_VEC, STR_quiver, cone_handle)

    % Rotate STR vector
    rotated_STR = update_vector(q_rotation, STR_VEC, STR_quiver, 0.5, ' ');
    STR_TRACE = [rotated_STR(1), rotated_STR(2), rotated_STR(3)];
    % scatter3(rotated_STR(1), rotated_STR(2), rotated_STR(3),'LineWidth',1,'MarkerEdgeColor','k','MarkerFaceColor','#7E2F8E');

    % Create cone for STR FOV
    [x_cone, y_cone, z_cone, M] = plot_cone(rotated_STR(1), rotated_STR(2), rotated_STR(3));

    % Delete previous cone surface if it exists
    if ~isempty(cone_handle)
        delete(cone_handle);
    end

    % Plot cone
    cone_handle = surf(x_cone, y_cone, z_cone, 'Parent', hgtransform('Matrix', M), ...
        'LineStyle', 'none', 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.07);

end