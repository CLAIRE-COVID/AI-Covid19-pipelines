#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
$namespaces:
  sf: "https://streamflow.org/cwl#"
requirements:
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
inputs:
  dataset: Directory
  epochs: int
  k_folds: int
  labels: File
  learning_rate: float[]
  lr_step_size: int[]
  model_type: string
  model_layers: int[]
  weight_decay: float[]
  weights_dir: Directory
outputs:
  results:
    type: Directory[]
    outputSource: grid-search/results
steps:
  get-array:
    run: clt/get-array.cwl
    in:
      size: k_folds
    out: [array]
  grid-search:
    run:
      class: Workflow
      requirements:
        ScatterFeatureRequirement: {}
        StepInputExpressionRequirement: {}
        SubworkflowFeatureRequirement: {}
      inputs:
        dataset: Directory
        epochs: int
        k_folds: int
        k_fold_idx: int[]
        labels: File
        learning_rate: float
        lr_step_size: int
        model_type: string
        model_layers: int
        weight_decay: float
        weights_dir: Directory
      outputs:
        results:
          type: Directory
          outputSource: fold-metrics/results
      steps:
        train-fold:
          run:
            class: Workflow
            inputs:
              dataset: Directory
              epochs: int
              k_fold_idx: int
              labels: File
              learning_rate: float
              lr_step_size: int
              model_type: string
              model_layers: int
              weight_decay: float
              weights_dir: Directory
            outputs:
              results:
                type: Directory
                outputSource: metrics/results
            steps:
              train:
                run: clt/train.cwl
                in:
                  dataset: dataset
                  epochs: epochs
                  k_fold_idx: k_fold_idx
                  labels: labels
                  learning_rate: learning_rate
                  lr_step_size: lr_step_size
                  model_type: model_type
                  model_layers: model_layers
                  weight_decay: weight_decay
                  weights_dir: weights_dir
                out: [results]
              metrics:
                run: clt/metrics.cwl
                in:
                  predictions_dir: train/results
                out: [results]
          in:
            dataset: dataset
            epochs: epochs
            k_fold_idx: k_fold_idx
            labels: labels
            learning_rate: learning_rate
            lr_step_size: lr_step_size
            model_type: model_type
            model_layers: model_layers
            weight_decay: weight_decay
            weights_dir: weights_dir
          out: [results]
          scatter: k_fold_idx
        fold-metrics:
          run: clt/cross-validation.cwl
          in:
            epochs: epochs
            k_folds: k_folds
            learning_rate: learning_rate
            lr_step_size: lr_step_size
            metrics: train-fold/results
            model_type: model_type
            model_layers: model_layers
            weight_decay: weight_decay
          out: [results]
    in:
      dataset: dataset
      epochs: epochs
      k_folds: k_folds
      k_fold_idx: get-array/array
      labels: labels
      learning_rate: learning_rate
      lr_step_size: lr_step_size
      model_type: model_type
      model_layers: model_layers
      weight_decay: weight_decay
      weights_dir: weights_dir
    out: [results]
    scatter: [learning_rate, lr_step_size, model_layers, weight_decay]
    scatterMethod: flat_crossproduct
