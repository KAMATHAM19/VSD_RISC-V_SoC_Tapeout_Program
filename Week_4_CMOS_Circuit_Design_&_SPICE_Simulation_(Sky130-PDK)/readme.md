# Week 4 – CMOS Circuit Design & SPICE Simulation (Sky130-PDK)





## Installation of NGSPICE


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


## Workshop Collaterals

```
git clone https://github.com/kunalg123/sky130CircuitDesignWorkshop.git
cd sky130CircuitDesignWorkshop
ls
```
<img width="920" height="427" alt="image" src="https://github.com/user-attachments/assets/27cc04de-0551-4a41-bd44-a1ec821c98bb" />


## Reference
- https://sourceforge.net/projects/ngspice/files/
- https://github.com/kunalg123/sky130CircuitDesignWorkshop.git
