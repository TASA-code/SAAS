function [vec_rotated] = update_vector(q, vector, quiver_vec, ratio, option)
    
    vec_rotated = quaternion_rotate(vector,q);

    quiver_vec.UData = vec_rotated(1)*ratio;
    quiver_vec.VData = vec_rotated(2)*ratio;
    quiver_vec.WData = vec_rotated(3)*ratio;

    if option == 'z'
        scatter3(vec_rotated(1), vec_rotated(2), vec_rotated(3),'LineWidth',2,...
                'MarkerEdgeColor','k','MarkerFaceColor','#808080',...
                'MarkerEdgeAlpha', 0.3, 'MarkerFaceAlpha', 0.3);
    end
end
