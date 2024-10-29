# resholve issue: aliases with env vars preceding their definitions aren't parsed correctly repro

running the repro with `nix run github:janw4ld/resholve-alias-env-vars-repro` fails with the error:

```plaintext
> [resholve context] /nix/store/h63slfwa931hcb66h8xgcpk9cp161h9g-resholve-0.10.5/bin/resholve --overwrite bin/ls-us-east-1
>   alias ls_use1='AWS_REGION=us-east-1 ls'
>         ^~~~~~~~
> /nix/store/y1yxn8fsgi577fzfr92xxvb6gy5pdhx5-ls-us-east-1-0.1.0/bin/ls-us-east-1:2: Couldn't resolve command 'AWS_REGION=us-east-1'
```

env vars that precede the alias aren't skipped during parsing so with `fix.aliases = true` the env var definition `AWS_REGION=us-east-1` is considered an unresolved command.
