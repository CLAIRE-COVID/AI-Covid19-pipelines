#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: ExpressionTool
requirements:
  InlineJavascriptRequirement: {}
inputs:
  size: int
expression: |
  ${
    return Array.from(Array(inputs.size).keys())
  }
outputs:
  array:
    type: int[]
