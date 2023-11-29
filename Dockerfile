# To build this Dockerfile, run `docker build -t psaia - < Dockerfile`.

# Docker images are aimed for evaluating PSAIA.
# For production use, please compile PSAIA from source code and run in bare-metal for a better performace.

FROM ubuntu:latest
RUN apt update && apt install -y --no-install-recommends \
    g++ lib32z1 csh git ca-certificates sudo vim bc
RUN sudo echo "deb http://dk.archive.ubuntu.com/ubuntu/ bionic main universe" >> /etc/apt/sources.list
RUN apt install -y gnupg2
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
RUN apt update
RUN apt-get install -y --no-install-recommends g++-6
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 6
RUN apt-get install libgfortran3 

# All the necessary requirements for PSAIA have been installed beforehand.

RUN git clone https://github.com/Stephen523/MIALAB.git && \
    cd MIALAB/

RUN cd MIALAB/ && \ 
    chmod u+x main.sh
CMD cd MIALAB/ && ./main.sh
# To run ABACUS built by this image with all available threads, execute `docker run -v <host>:<wd> -w <wd/input> psaia`.
# Replace '<host>' with the path to pdb file's directory, '<wd>' with a path to working directory.
# e.g. after cloning the repo to `$HOME` and pulling image, execute docker run -v ~/PSAIA/data/pdb/:/MIALAB/data/pdb/ psaia
# Then,you can download the result directory or files to the place you specify.execute 'docker cp <container id>:<wd> <host>'
# e.g. docker cp a33200255e8b:/MIALAB/result/ ~/PSAIA/result/.

# To use this image as developing environment, execute `docker run -it --entrypoint /bin/bash psaia`.
# Please refer to https://docs.docker.com/engine/reference/commandline/run/ for more details.
