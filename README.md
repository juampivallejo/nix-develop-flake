# nix-develop-flake

Nix flake for development environments

Use this flake in conjunction with `direnv` to create and activate development environments
with different dependencies.

## Usage

```
nix develop github:juampivallejo/nix-develop-flake#python313 --no-write-lock-file
nix develop .
```

## Usage with `direnv`

1. Make sure `nix-direnv` is installed

Use the `.envrc` file to specify the shell to activate, for example:

```
use flake path:.#python310
```

or

```
use flake "github:juampivallejo/nix-develop-flake#python313" --no-write-lock-file
```

2. Enable `direnv` on every desired folder using `direnv allow`
