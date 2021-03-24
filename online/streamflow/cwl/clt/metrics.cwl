#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["python", "/opt/claire-covid/nnframework/compute_metrics.py"]
requirements:
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.predictions_dir)
        writable: true
inputs:
  predictions_dir:
    type: Directory
    inputBinding:
      position: 3
      valueFrom: $(self.basename)
outputs:
  results:
    type: Directory
    outputBinding:
      glob: $(inputs.predictions_dir.basename)
