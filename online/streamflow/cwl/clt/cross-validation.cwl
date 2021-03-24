#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["python", "/opt/claire-covid/nnframework/cross_validation.py"]
requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.metrics)
arguments:
  - position: 1
    prefix: --results_root
    valueFrom: $(runtime.outdir)  
  - position: 3
    prefix: --experiment_name
    valueFrom: '$(inputs.model_type)$(inputs.model_layers)_lr$(inputs.learning_rate)_step$(inputs.lr_step_size)_wd$(inputs.weight_decay)_epochs$(inputs.epochs)'
  - position: 4
    prefix: --dest_folder
    valueFrom: 'metrics_$(inputs.model_type)$(inputs.model_layers)_lr$(inputs.learning_rate)_step$(inputs.lr_step_size)_wd$(inputs.weight_decay)_epochs$(inputs.epochs)'
inputs:
  epochs:
    type: int
  k_folds:
    type: int
    inputBinding:
      position: 2
      prefix: --k_folds
  learning_rate:
    type: float
  lr_step_size:
    type: int
  metrics:
    type: Directory[]
  model_type:
    type: string
  model_layers:
    type: int
  weight_decay:
    type: float
outputs:
  results:
    type: Directory
    outputBinding:
      glob: 'metrics_$(inputs.model_type)$(inputs.model_layers)_lr$(inputs.learning_rate)_step$(inputs.lr_step_size)_wd$(inputs.weight_decay)_epochs$(inputs.epochs)'
