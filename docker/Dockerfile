# Use miniforge as the base image for a lightweight conda environment
FROM condaforge/miniforge3:latest

# Set working directory
WORKDIR /workspace

# Update package manager and install git in a single layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create conda environment with required packages and clean up in one layer
# This reduces image size by removing unnecessary files
RUN conda install -c conda-forge -n base \
    python=3.10 \
    gcc \
    netcdf4 \
    hdf5 && \
    conda clean -afy

# Optional: Activate the environment in shell interactions
SHELL ["conda", "run", "-n", "base", "/bin/bash", "-c"]

# Clone the CARDAMOM repository
RUN git clone --depth 1 https://github.com/CARDAMOM-framework/CARDAMOM.git && \
    cd CARDAMOM && \
    ./BASH/CARDAMOM_COMPILE.sh

# Copy the wrapper script
COPY run_cardamom.sh /workspace/run_cardamom.sh
RUN chmod +x /workspace/run_cardamom.sh

CMD ["/bin/bash"]
