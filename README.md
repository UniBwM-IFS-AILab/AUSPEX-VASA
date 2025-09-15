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
This reads the OBC_TYPE environment variable and builds the Docker container accordingly.

## 2. Run container:
```
runvasa
```

## 3. Attach bash to running container:
```
vasabash
```

## (optional)
Adding user to docker group, to avoid using sudo for docker commands:
```
sudo usermod -aG docker $USER
```
