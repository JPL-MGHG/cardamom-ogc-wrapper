cwlVersion: v1.2

$namespaces:
  s: https://schema.org/

$schemas:
  - http://schema.org/version/latest/schemaorg-current-https.rdf

s:softwareVersion: 1.0.0
s:version: 1.0.0
s:datePublished: 2026-01-29
s:author:
  - class: s:Person
    s:name: CARDAMOM Development Team

s:codeRepository: https://github.com/jpl-mghg/cardamom-ogc-wrapper
s:license: https://opensource.org/licenses/Apache-2.0

$graph:

  - class: Workflow
    id: cardamom-ogc-process
    label: CARDAMOM OGC Process
    doc: |
      OGC Application Package for CARDAMOM (Carbon Allocation and Redistribution
      for Dynamic Global Vegetation Models) model execution.

      This workflow processes a single input file through the CARDAMOM model,
      performing data assimilation and generating optimized parameters and
      model output in NetCDF format.

    inputs:
      input_file:
        type: File
        label: Input driver file
        doc: |
          Input file containing forcing data and model parameters for CARDAMOM.
          Typically in a format compatible with CARDAMOM (e.g., binary or NetCDF).

    outputs:
      output_data:
        type: Directory
        label: CARDAMOM output directory
        doc: |
          Directory containing:
          - output_param_file_*.cbr: Binary parameter file with optimized model parameters
          - output_file_*.nc: NetCDF format output file with model results
        outputSource: cardamom_step/output_directory

    steps:
      cardamom_step:
        run: "#main"
        in:
          input_file: input_file
        out:
          - output_directory

  - class: CommandLineTool
    id: main
    label: CARDAMOM Model Execution Tool
    doc: |
      CommandLineTool for executing the CARDAMOM model.
      Takes an input file and produces optimized parameters and model output.

    baseCommand: bash
    arguments:
      - "run_cardamom.sh"

    inputs:
      input_file:
        type: File
        label: Input file for CARDAMOM
        doc: Input file containing model parameters and forcing data
        inputBinding:
          prefix: "--input_file"

    outputs:
      output_directory:
        type: Directory
        label: CARDAMOM output directory
        doc: Directory containing all CARDAMOM outputs (parameter files and NetCDF results)
        outputBinding:
          glob: output

    requirements:
      - class: ShellCommandRequirement
      - class: DockerRequirement
        dockerPull: ghcr.io/jpl-mghg/cardamom-ogc-wrapper:latest
