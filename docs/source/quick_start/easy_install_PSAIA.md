# Easy Installation

This guide helps you install PSAIA with basic features.  We recommend building PSAIA with [Docker](#container-deployment) to avoid dependency issues. We recommend compiling PSAIA(and possibly its requirements) from the source code using the latest compiler for the best performace. You can also deploy PSAIA **without building** by [Docker](#container-deployment) . Please note that PSAIA only supports Linux; for Windows users, please consider using [WSL](https://learn.microsoft.com/en-us/windows/wsl/) or docker.

## Prerequisites

This program needs Naccess, you can download it if from http://www.bioinf.manchester.ac.uk/naccess/ and then put the directory named naccess2.1.1 in Program/.

## Install requirements

Some of these packages can be installed with popular package management system, such as `apt` and `yum`:

```bash
sudo apt update && sudo apt install -y libopenblas-openmp-dev liblapack-dev libscalapack-mpi-dev libelpa-dev libfftw3-dev libcereal-dev libxc-dev g++ make cmake bc git lib32z1
```

Please refer to our [guide]([Stephen523/MIALAB: A repository for MIALAB (github.com)](https://github.com/Stephen523/MIALAB)) on installing requirements.


## Get PSAIA source code

Of course a copy of PSAIA source code is required, which can be obtained via one of the following choices:

- Clone the whole repo with git: `git clone https://github.com/Stephen523/MIALAB.git
- Clone the minimum required part of repo: `git clone https://github.com/Stephen523/MIALAB.git --depth=1`
- Get the source code of a stable version from [here](https://github.com/Stephen523/MIALAB)

### Update to latest release

Please check the [release page](https://github.com/deepmodeling/abacus-develop/releases) for the release note of a new version.

It is OK to download the new source code from beginning following the previous step.

To update your cloned git repo in-place:

```bash
git remote -v
# Check if the output contains the line below
# origin https://github.com/deepmodeling/abacus-develop.git (fetch)
# The remote name is marked as "upstream" if you clone the repo from your own fork.

# Replace "origin" with "upstream" or the remote name corresponding to deepmodeling/abacus-develop if necessary
git fetch origin
git checkout v3.2.0 # Replace the tag with the latest version
git describe --tags # Verify if the tag has been successfully checked out
```

Then proceed to the [Build and Install](#build-and-install) part. If you encountered errors, try remove the `build` directory first and reconfigure.

To use the codes under active development:

```bash
git checkout develop
git pull
```

## Run

> Put pdb files of proteins in the folder named /data/pdb/.
>
> Then run the following order to run:
>
> ```
> bash main.sh
> ```
>
> The result of each chain starts with "chain x",which shows the residue patchs that is most likely to be a protein binding sites in this chain. The patch number can be modified in work/sort_patch.sh.
>
> Then, you will get the results in the folder: /result/
>

## Container Deployment

> Please note that containers target at developing and testing, but not massively parallel computing for production. Docker has a bad support to MPI, which may cause performance degradation.

We've built a ready-for-use version of ABACUS with docker [here](https://github.com/deepmodeling/abacus-develop/pkgs/container/abacus). For a quick start: pull the image, prepare the data, run container. Instructions on using the image can be accessed in [Dockerfile](../../Dockerfile). A mirror is available by `docker pull registry.dp.tech/deepmodeling/abacus`.

We also offer a pre-built docker image containing all the requirements for development. Please refer to our [Package Page](https://github.com/orgs/deepmodeling/packages?repo_name=abacus-develop).

The project is ready for VS Code development container. Please refer to [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers#_quick-start-try-a-development-container). Choose `Open a Remote Window -> Clone a Repository in Container Volume` in VS Code command palette, and put the [git address](https://github.com/deepmodeling/abacus-develop.git) of `ABACUS` when prompted.

For online development environment, we support [GitHub Codespaces](https://github.com/codespaces): [Create a new Codespace](https://github.com/codespaces/new?machine=basicLinux32gb&repo=334825694&ref=develop&devcontainer_path=.devcontainer%2Fdevcontainer.json&location=SouthEastAsia)

We also support [Gitpod](https://www.gitpod.io/): [Open in Gitpod](https://gitpod.io/#https://github.com/deepmodeling/abacus-develop)

