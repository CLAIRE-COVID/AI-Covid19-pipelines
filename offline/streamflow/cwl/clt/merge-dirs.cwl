#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: [cp, -ar]
arguments:
  - position: 3
    valueFrom: $(runtime.outdir)
inputs:
  dirs:
    type:
      type: array
      items: Directory
      inputBinding:
        valueFrom: "$(self.path)/."
    inputBinding:
      position: 2
outputs:
  dir:
    type: Directory
    outputBinding:
      glob: $(runtime.outdir)
