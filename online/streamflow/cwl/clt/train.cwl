#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["python", "/opt/claire-covid/nnframework/main.py"]
arguments:
  - position: 9
    prefix: --name
    valueFrom: '$(inputs.model_type)$(inputs.model_layers)_lr$(inputs.learning_rate)_step$(inputs.lr_step_size)_wd$(inputs.weight_decay)_epochs$(inputs.epochs)'
  - position: 10
    prefix: --outdir
    valueFrom: 'training_$(inputs.model_type)$(inputs.model_layers)_lr$(inputs.learning_rate)_step$(inputs.lr_step_size)_wd$(inputs.weight_decay)_epochs$(inputs.epochs)'
inputs:
  dataset:
    type: Directory
    inputBinding:
      position: 1
      prefix: --dataset
  epochs:
    type: int
    inputBinding:
      position: 2
      prefix: --epochs
  k_fold_idx:
    type: int
    inputBinding:
      position: 3
      prefix: --k-fold-idx
  labels:
    type: File
    inputBinding:
      position: 4
      prefix: --labels
  learning_rate:
    type: float
    inputBinding:
      position: 5
      prefix: --learning-rate
  lr_step_size:
    type: int
    inputBinding:
      position: 6
      prefix: --lr-step-size
  model_type:
    type: string
    inputBinding:
      position: 7
      prefix: --model-type
  model_layers:
    type: int
    inputBinding:
      position: 8
      prefix: --model-layers
  weight_decay:
    type: float
    inputBinding:
      position: 11
      prefix: --weight-decay
  weights_dir:
    type: Directory
    inputBinding:
      position: 12
      prefix: --weights-path
outputs:
  results:
    type: Directory
    outputBinding:
      glob: "training_*/results/*"
