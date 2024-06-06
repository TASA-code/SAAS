# Satellite Attitude Animation and Simulator
## (SAAS v.1)
Satellite Attitude Animation and Simulator (SAAS) is a tool that simulates satellite attitude describe by quaternions,
and has the capability of inputting on-orbit data to animate actual behaviour, 
while plotting groundtrack data.
---
## Modes
1. ATT_SIM: Provide simulation on user input quaternion and input environment
2. ATT_PROP: Based on INPUT_PROP.txt file for on-orbit satellite attitude simulation
---
## INPUT format
```
=[ Optimised transfer, unperturb ]=
TITLE INPUT_SIM.txt

MODE  simulation
MODEL 
        NAME    FS9
        CG     [2.7717896e+00  1.8211494e+01  8.9988957e+02]
        FILE   'model/fs9_SADA.stl'
END
ENV
        BETA_ANGLE 15
END
COMPONENT 
        STR1    [474.918, 479.593, 931.902]
                [473.641, 478.316, 934.298]
        STR2    [-486.347, 537.236, 332.014]
                [-443.741, 494.732, 411.878]
        USER    [-0.388, -0.198,-0.01]
                [0, 0, 0]
END
OPTION
        STR_VIEW   0
END
VALUE
        DESIGN         1
        FRAME         'ECI'
        QUAT_DESIGN   [0, -240, 50]
        QUAT_SINGLE   []
        QUAT_PROF     'QUAT_PROFILE.txt'
END
```

# Results
<p align="center">
  <img src="output/ATT_design.gif" width="350">
  <img src="output/ATT_sim.gif" width="350">
  <img src="output/ATT_trend.gif" width="350">
</p>


> [!IMPORTANT]  
> This is still an on-going work as more feature will be added into SAAS in future releases. 


