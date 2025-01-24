# Trial and Error: A Trial History and Bayesian Approach

## Overview
Welcome to the "Trial and Error" repository! Our goal is to build data pipelines for analyzing trial history effects in psychophysical tasks using Bayesian approaches. This project is structured into three key analyses:

1. **Individual Session Analysis**: Analyze trial history data from single experimental sessions.
2. **Comparing Conditions Within Subjects**: Compare performance and decision-making patterns across experimental conditions for individual participants.
3. **Group-Level Analysis**: Aggregate and analyze data across multiple participants to identify consistent patterns and group-level trends.

## Table of Contents
- [Onboarding Documentation](#onboarding-documentation)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Data Access](#data-access)
- [Steps for Each Analysis](#steps-for-each-analysis)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

## Onboarding Documentation
### Get Started

1. **Join our Discord channel**: Stay updated and collaborate with the virtual members.
2. **Download MATLAB**: [MATLAB Download](https://www.mathworks.com/downloads/) (Free with VU email address).
3. **Access the onboarding Google Drive folder**: [Google Drive Folder](https://drive.google.com/drive/folders/19-npik6O2sBKtePoqAmUu3XODVIH9Io7) for background information and documents.

### Useful Resources
- [MATLAB Basics](https://www.mathworks.com/help/matlab/)
- [Trial History and Bayesian Modeling Background]([https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3005353/](https://drive.google.com/drive/folders/19-npik6O2sBKtePoqAmUu3XODVIH9Io7))
- [Awesome Visualization]([https://github.com/alpers/awesome-data-visualization](https://github.com/povilaskarvelis/DataViz))

## Prerequisites
Before installing and using the repository, ensure you have the following:

- MATLAB (latest version)
- Signal Processing Toolbox in MATLAB
- Access to the project’s data and resources (details below)

## Installation via VSCode
1. Clone the repository:
   ```bash
   git clone https://github.com/tiesmaaj/trial_and_error.git
   ```
2. Navigate to the project directory:
   ```bash
   cd trial-and-error
   ```
3. Open MATLAB and add the project directory to your path:
   ```matlab
   addpath(genpath('path_to_trial_and_error'))
   savepath
   ```

## Data Access
Data for the project can be accessed from the following sources:

### Public Datasets
- [Google Drive Folder](https://drive.google.com/drive/folders/19-npik6O2sBKtePoqAmUu3XODVIH9Io7): Download relevant experimental data.

- Example dataset:
  ```matlab
  data = load('example_data.mat');
  ```

### Example Datasets to Start
- Motion direction discrimination
- Simultaneity judgment
- Word categorization

## Steps for Each Analysis
### 1. Data Preparation
- Validate and preprocess input data.
- Test preprocessing scripts on example datasets to handle edge cases.

### 2. Visualization
- Create histograms, scatterplots, and advanced visualizations to illustrate trial history effects.
- Develop reusable visualization templates.

### 3. Documentation and Building
- Write clear instructions and explanations for users.
- Propose features to enhance the pipeline.

### 4. Testing and Debugging
- Test the pipeline on multiple datasets to ensure robustness.
- Resolve bugs and unexpected behaviors.

### 5. Bayesian Modeling
- Research and implement Bayesian modeling techniques.
- Define priors and likelihoods for specific tasks.
- Ensure results are interpretable and provide insights into decision-making patterns.

## Project Structure
```plaintext
trial-and-error/
├── src/               # Source code
├── data/              # Data files
├── scripts/           # Utility scripts
└── docs/              # Documentation
```

## Contributing
We welcome contributions to improve the project. To contribute:

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Submit a pull request.
5. Follow the team’s coding standards.

## License
This project is licensed under [license type]. All data used in this project adhere to the original data-sharing agreements of their respective sources.

---
Thank you for contributing to "Trial and Error"! Let’s build insightful pipelines together.

