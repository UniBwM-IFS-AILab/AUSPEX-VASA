# AUSPEX-VASA
Docker container for AUSPEX.

For detailed instructions see the main repository [AUSPEX](https://github.com/UniBwM-IFS-AILab/AUSPEX).
To cite **AUSPEX-VASA**, please use the following reference:
```
@article{Doeschl-et-al:2025:AUSPEX,
  author = {Bj{\"o}rn D{\"o}schl and Kai Sommer and Jane Jean Kiam},
  title = {{AUSPEX: An Integrated Open-Source Decision-Making Framework for UAVs in Rescue Missions}},
  publisher = {TechRxiv.org},
  year = {2025},
  month = {March},
  doi = {10.36227/techrxiv.174123265.55724570/v1},
  url = {https://www.techrxiv.org/doi/full/10.36227/techrxiv.174123265.55724570/v1}
}
```
## 1. Build container:
```
buildvasa
```

## 2. Run container:
For ground station / simulation:
```
run_terra_vasa
```
For drones there are different containers depending on the hardware:
* Raspberry Pi:
```
run_avis_pi_vasa
```
* Nvidia Jetson Xavier:
```
run_avis_jetson_vasa
```

## 3. Open second bash on running container:
```
vasabash
```

## (optional)
Adding user to docker group, to avoid using sudo for docker commands:
```
sudo usermod -aG docker $USER
```
