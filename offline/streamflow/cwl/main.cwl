#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: Workflow
requirements:
  SubworkflowFeatureRequirement: {}
inputs:
  dataset: Directory
outputs:
  subjects:
    type: Directory[]
    outputSource: get-subjects/preprocessed-datasets
  labels:
    type: File
    outputSource: get-labels/labels
steps:
  get-labels:
    run:
      class: Workflow
      requirements:
        StepInputExpressionRequirement: {}
      inputs:
        dataset: Directory
      outputs:
        labels:
          type: File
          outputSource: extract/content
      steps:
        filter:
          run: clt/filter.cwl
          in:
            dir: dataset
            regex:
              valueFrom: ^.*_head_.*\.tgz$
          out: [files]
        extract:
          run: clt/extract.cwl
          in:
            tarfile: filter/files
            out_glob:
              valueFrom: derivatives/labels/labels_covid19_posi.tsv
          out: [content]
    in:
      dataset: dataset
    out: [labels]
  get-subjects:
    run:
      class: Workflow
      requirements:
        ScatterFeatureRequirement: {}
        SubworkflowFeatureRequirement: {}
      inputs:
        dataset: Directory
      outputs:
        preprocessed-datasets:
          type: Directory[]
          outputSource: get-datasets/files
      steps:
        filter:
          run: clt/filter.cwl
          in:
            dir: dataset
            regex:
              valueFrom: ^.*_subjects_.*\.tgz$
          out: [files]
        scatter-archives:
          run:
            class: Workflow
            requirements:
              ScatterFeatureRequirement: {}
              StepInputExpressionRequirement: {}
              SubworkflowFeatureRequirement: {}
            inputs:
              tarfile: File
            outputs:
              preprocessed-datasets:
                type: Directory
                outputSource: merge-dirs/dir
            steps:
              extract:
                run: clt/extract.cwl
                in:
                  tarfile: tarfile
                  out_glob:
                    valueFrom: sub-*
                out: [content]
              scatter-subjects:
                run:
                  class: Workflow
                  requirements:
                    ScatterFeatureRequirement: {}
                    StepInputExpressionRequirement: {}
                    SubworkflowFeatureRequirement: {}
                  inputs:
                    subject: Directory
                  outputs:
                    preprocessed-datasets:
                      type: Directory
                      outputSource: preprocess/preprocessed-datasets
                  steps:
                    preprocess:
                      run: clt/preprocess.cwl
                      in:
                        subject: subject
                      out: [preprocessed-datasets]
                in:
                  subject: extract/content
                out: [preprocessed-datasets]
                scatter: subject
              merge-dirs:
                run: clt/merge-dirs.cwl
                in:
                  dirs: scatter-subjects/preprocessed-datasets
                out: [dir]
          in:
            tarfile: filter/files
          out: [preprocessed-datasets]
          scatter: tarfile
        merge-dirs:
          run: clt/merge-dirs.cwl
          in:
            dirs: scatter-archives/preprocessed-datasets
          out: [dir]
        get-datasets:
          run: clt/filter.cwl
          in:
            dir: merge-dirs/dir
            regex:
              valueFrom: ^final3.*$
          out: [files]

    in:
      dataset: dataset
    out: [preprocessed-datasets]
