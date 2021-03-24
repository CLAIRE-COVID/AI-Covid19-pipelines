#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: [tar, -xzf]
inputs:
  tarfile:
    type: File
    inputBinding:
      position: 1
  out_glob:
    type: string
outputs:
  content:
    type:
    - "null"
    - File
    - Directory
    - type: array
      items: [File, Directory]
    outputBinding:
      glob: $(inputs.out_glob)
