<details>
  <summary>Week 0 - VLSI SoC Design Flow and Tool Installation</summary>
<br>

  <details>
    <summary>Task 1: VLSI SoC Design Flow</summary>
 <br>
    
<p align="center">
  <img width="1906" height="1072" alt="image" src="https://github.com/user-attachments/assets/25776a4a-b95c-4fbe-a7a4-322a1f8b11bf" />
</p>



  </details>

<details>
  <summary>Task 2 - Tool Installation</summary>
  
# Week 0 – Tool Installation  

Setup guide for the **VSD RISC-V Tapeout Program**. Follow the steps below to prepare your environment.  



## Required Downloads  

-  Download and install **Oracle VirtualBox**:  
  > [VirtualBox Downloads](https://www.virtualbox.org/wiki/Downloads)  

-  Download **Ubuntu Desktop (20.04 or later, 64-bit)**:  
  > [Ubuntu Desktop Downloads](https://ubuntu.com/download/desktop)  


## Installation Walkthrough  

- Watch this step-by-step video for **VirtualBox + Ubuntu installation**:
  
 > [VirtualBox & Ubuntu Setup (YouTube)](https://www.youtube.com/watch?v=hYaCCpvjsEY)  

## System Requirements  

Ensure your host system meets these requirements:  

| Resource  | Minimum Requirement      |
|-----------|--------------------------|
|  RAM      | 6 GB                    |
|  Disk     | 50 GB free space        |
|  OS       | Ubuntu 20.04+ (64-bit)  |
|  CPU      | 4 vCPUs                 |


## Update Ubuntu  

Once Ubuntu is installed, update and clean the system by running:  

```bash
sudo apt update
sudo apt upgrade
sudo apt autoclean
sudo apt autoremove
sudo apt install adms autoconf libtool automake libxaw7-dev libreadline-dev flex bison libxpm-dev gperf gcc g++ make dkms gcc
```
### 1. Yosys

```bash
sudo apt−get install build−essential clang bison flex libreadline−dev gawk tc−dev libffi−dev git graphviz xdot pkg−config python3 libboost−system−dev 
libboost−python−dev libboost−filesystem−dev zlib1g−dev

git clone https://github.com/YosysHQ/yosys.git
cd yosys
make 
sudo make install
yosys
```
<img width="1853" height="394" alt="image" src="https://github.com/user-attachments/assets/8920718a-0944-4155-aa76-ae861786e03f" />

### 2. Icarus Verilog

```bash
git clone https://github.com/steveicarus/iverilog.git
cd iverilog
sh autoconf.sh
./configure
make
sudo make install
```
<img width="1863" height="350" alt="image" src="https://github.com/user-attachments/assets/ebf16fa1-990d-44fb-a39b-3b6bf5d406e8" />

### 3. Gtkwave
```bash
cd
sudo apt install gtkwave
gtkwave
```
<img width="1855" height="832" alt="image" src="https://github.com/user-attachments/assets/bbe6b7f1-08b6-4503-a086-dadc1bb5a421" />

### 4. Ngspice

Download the tarball from [SourceForge](https://sourceforge.net/projects/ngspice/files/) to your local directory.  
Then unpack it using:

```bash
tar -zxvf ngspice-44.tar.gz 
cd ngspice-44 
mkdir release 
cd release 
../configure --with-x --with-readline=yes --disable-debug 
 make 
 sudo make install
ngspice
```
<img width="1848" height="330" alt="image" src="https://github.com/user-attachments/assets/8ddd04f0-4955-45c4-a061-1a9ebcf343b4" />

### 5. Magic
```bash
sudo apt-get install m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev libncurses-dev
git clone https://github.com/RTimothyEdwards/magic
cd magic
./configure
make
sudo make install
magic
```
<img width="1854" height="827" alt="image" src="https://github.com/user-attachments/assets/8f5e8715-f095-4830-9a97-18ede3e6bfa9" />

### 6. OpenLane

##### Step 1 - Install Docker

```bash
# Remove legacy installations (optional)
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install dependencies
sudo apt-get update
sudo apt-get install \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

# Add Docker’s GPG key and repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
   https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Confirm installation
sudo docker run hello-world
```
<img width="1857" height="580" alt="image" src="https://github.com/user-attachments/assets/d9a551e7-b9be-4388-a839-48df393fa8a1" />

#### Step 2 - Make Docker Available Without Root

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo reboot # REBOOT!
```
#### Step 3 - Install OpenLane
##### Required Packages

Before installing OpenLane, make sure you have the following packages installed:

- Docker **19.03.12+**
- Git **2.35+**
- Python **3.6+**
- GNU Make

You can check if these dependencies are installed and their versions by running:

```bash
git --version
docker --version
python3 --version
python3 -m pip --version
make --version
python3 -m venv -h
```
<img width="1852" height="843" alt="image" src="https://github.com/user-attachments/assets/b55daf41-d4d4-4c44-9eff-0446ee286bf2" />

```bash
cd $HOME
git clone https://github.com/The-OpenROAD-Project/OpenLane
cd OpenLane
make
make test

# To enter the dockerized OpenLane environment
make mount
```
<img width="1857" height="287" alt="image" src="https://github.com/user-attachments/assets/fc7310f6-450d-47a1-a9ac-7cfdaa105967" />

## Reference
- https://github.com/YosysHQ/yosys.git
- https://github.com/steveicarus/iverilog.git
- https://sourceforge.net/projects/ngspice/files/
- https://github.com/RTimothyEdwards/magic
- https://github.com/The-OpenROAD-Project/OpenLane
  
</details>

</details>
