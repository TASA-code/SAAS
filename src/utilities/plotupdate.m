function [] = plotupdate(VEC, update_value, ratio)

VEC.UData = update_value(1)*ratio;
VEC.VData = update_value(2)*ratio;
VEC.WData = update_value(3)*ratio;


end
