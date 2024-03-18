function [] = eclipse(i,ecl_data)

    scatter(i,ecl_data,'.','k');
    box on;
    grid on;
    pbaspect([0.7 4 1])
    ylim([-0.5 1.5]);
    xlim([i-10, i+10])
    title('Eclipse','FontSize',12,'Interpreter','latex')

end