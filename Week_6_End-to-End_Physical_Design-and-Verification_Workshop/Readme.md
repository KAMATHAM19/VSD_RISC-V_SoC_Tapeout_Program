
<details>
  <summary>Installation of OpenLane and Magic</summary>
  
# Installation of OpenLane and Magic

### Step 1 - Install Docker
```
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
- verify installation

```
sudo docker run hello-world
```

<img width="1862" height="502" alt="image" src="https://github.com/user-attachments/assets/a56a83b5-3ec7-41bd-b969-9bb2b22e3d39" />

### Step 2 - Make Docker Available Without Root

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
sudo reboot # REBOOT!
```
## Step 3 - Install OpenLane
#### Required Packages

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
```
<img width="1863" height="162" alt="image" src="https://github.com/user-attachments/assets/3485c277-09b6-405e-a7a5-6df50591b07b" />

```
make
make test
```
<img width="1862" height="998" alt="image" src="https://github.com/user-attachments/assets/00cda496-5fba-477a-b1f2-f3c2f5a43b29" />


# To enter the Dockerized OpenLane environment
```
make mount
```
<img width="1860" height="121" alt="image" src="https://github.com/user-attachments/assets/cb519d7e-db3b-4d6b-8b6a-ede9979a77cc" />


###  Magic
```bash
sudo apt-get install m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev libncurses-dev
git clone https://github.com/RTimothyEdwards/magic
cd magic
```
<img width="1863" height="162" alt="image" src="https://github.com/user-attachments/assets/7ccaa89c-caf7-4128-88d7-adb5971bf49a" />

```
./configure
make
sudo make install
```
<img width="1860" height="997" alt="image" src="https://github.com/user-attachments/assets/0198dcef-4edf-4569-905b-8974bbb1c8cb" />

```
magic
```
<img width="1854" height="827" alt="image" src="https://github.com/user-attachments/assets/8f5e8715-f095-4830-9a97-18ede3e6bfa9" />

### Building PDKs from Source

To build and install the **OpenPDKs (Process Design Kits)** for the **SkyWater SKY130 process node**, follow the steps below:

```
git clone https://github.com/RTimothyEdwards/open_pdks.git
cd open_pdks
```
<img width="1860" height="236" alt="image" src="https://github.com/user-attachments/assets/d335b412-0427-472e-a4ba-e19f7b5bbb31" />

```
./configure --enable-sky130-pdk
make
sudo make install
```

  
</details>

Sky130 Day 1 - Inception of open-source EDA, OpenLANE and Sky130 PDK

Sky130 Day 2 - Good floorplan vs bad floorplan and introduction to library cells

Sky130 Day 3 - Design library cell using Magic Layout and ngspice characterization

Sky130 Day 4 - Pre-layout timing analysis and importance of good clock tree

Sky130 Day 5 - Final steps for RTL2GDS using tritonRoute and openSTA
