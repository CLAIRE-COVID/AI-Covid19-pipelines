#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["python", "/opt/claire-covid/preprocessing_pipeline_ct_v2.py"]
inputs:
  subject:
    type: Directory
    inputBinding:
      position: 1
      prefix: --patient
outputs:
  preprocessed-datasets:
    type: Directory
    outputBinding:
      glob: "$(runtime.outdir)"

