#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: ExpressionTool
requirements:
  InlineJavascriptRequirement: {}
inputs:
  dir:
    type: Directory
    loadListing: deep_listing
  regex: string
expression: |
  ${
    var re = new RegExp(inputs.regex);
    function filter(item, files) {
      if (re.test(item.basename)) {
        files.push(item);
      } else if (item.class == "Directory") {
        item.listing.forEach(function(item){
          filter(item, files);
        })
      }
    }
    var files = [];
    filter(inputs.dir, files);
    if (files.length === 0) {
      return null;
    } else if (files.length === 1) {
      return files[0];
    } else {
      return files;
    }
  }
outputs:
  files:
    type:
    - "null"
    - File
    - Directory
    - type: array
      items: [File, Directory]
