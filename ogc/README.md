# CARDAMOM OGC Application Package

OGC-compliant CWL v1.2 application package for the CARDAMOM (Carbon Allocation and Redistribution for Dynamic Global Vegetation Models) framework.

## Files

- **cardamom-tool.cwl**: OGC-compliant CWL v1.2 workflow definition
- **job_order.yml**: Example job order file for running the workflow
- **README.md**: This file

## Usage

### Prerequisites

Install cwltool:
```bash
pip install cwltool
```

Build the Docker image:
```bash
cd ../docker
docker build -t cardamom-ogc:latest .
```

### Running the Workflow

**Basic execution:**
```bash
cwltool cardamom-tool.cwl job_order.yml
```

**With output directory specified:**
```bash
cwltool --outdir ./results cardamom-tool.cwl job_order.yml
```

**Verbose logging:**
```bash
cwltool --debug cardamom-tool.cwl job_order.yml
```

**Validation only (no execution):**
```bash
cwltool --validate cardamom-tool.cwl
```

## Inputs

- **input_file** (File, required): Input file containing forcing data and model parameters for CARDAMOM

## Outputs

- **output_data** (Directory): Contains all CARDAMOM outputs:
  - `output_param_file_*.cbr`: Binary parameter file with optimized model parameters
  - `output_file_*.nc`: NetCDF format output file with model results
  - Standard output/error logs

## Workflow Steps

1. **cardamom_step**: Executes CARDAMOM model
   - Runs `run_cardamom.sh`
   - Executes CARDAMOM_MDF for data assimilation
   - Executes CARDAMOM_RUN_MODEL to generate results

## Metadata

- **Version**: 1.0.0
- **CWL Version**: v1.2
- **License**: Apache License 2.0
- **Repository**: https://github.com/jpl-mghg/cardamom-ogc-wrapper
- **Author**: CARDAMOM Development Team

## References

- [CWL Specification](https://www.commonwl.org/)
- [CARDAMOM Framework](https://www.cardamom.info/)
- [OGC API - Processes](https://ogcapi.ogc.org/processes/)
- [cwltool Documentation](https://cwltool.readthedocs.io/)
