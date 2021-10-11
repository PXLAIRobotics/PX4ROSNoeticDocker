# PX4ROSNoeticDocker


## Usage
### Build
./000_clone_px4_autopilot.bash
./001_build_container.bash

### Running
./002_start_container.bash

### Inside the container
Use tmux or the ./003_attach_bash_to_container.bash script.

#### Terminal 1
01_start_px4_gazebo_sim.bash

#### Terminal 2
02_connect_ros_via_mavlink.bash

#### Terminal 3
03_start_qgroundcontrol.bash

