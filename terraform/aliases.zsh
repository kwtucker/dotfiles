#!/usr/bin/env zsh

alias tf='terraform'
alias tfi='terraform init'
alias tfv='terraform validate -json | jq ".diagnostics|=sort_by(.range.filename)" | jq "{
  valid: .valid,
  error_count: .error_count,
  warning_count: .warning_count,
  diagnostics: [.diagnostics[] |  {
      severity: .severity, 
      summary: .summary,
      detail: .detail,
      filename: .range.filename,
      start_line: .range.start.line
    }
  ]
}"'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'
alias tfs='terraform state'
alias tfr='terraform refresh'
