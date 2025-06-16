<img src="images/TU_logo_large.png" alt="TU logo" width="200" align="right"/>

# Staff Sickness Absence Rates
This repository holds the code for the analysis of NHS staff sickness absence rates.

## Repository Structure
The current structure of the repository is detailed below:

``` plaintext

├───.github/workflows
├───data
├───documentation
├───images
└───src
    ├───analysis
    ├───config
    ├───load
    ├───outputs
    └───requirements
    
```

### `.github/workflows`
Contains `deploy.yml` for deploying the outputs of the analysis as a static github page

### `data`
Contains raw downloads of NHS staff survey and sickness reasons data

### `documentation`
Contains a `.md` file with a description of the datasets used and links to their availability.

### `images`
Contains the TU logo for outputs

### `src`
Contains the codebase for the analysis and outputs:

* `analysis`: Contains scripts for undertaking the analysis and producing charts.
* `config`: Contains TU css files and palettes.
* `load`: Contains scripts for loading the data.
* `outputs`: Contains the `.qmd` file for rendering the outputs of the analysis.
* `requirements`: Contains the packages required to undertake the analysis.
  
## Contributors

This repository has been created and developed by:

-   [Andy Wilson](https://github.com/ASW-Analyst)