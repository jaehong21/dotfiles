## Init

```bash
# check if $HOME is set
echo $HOME
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share

export GITHUB_USERNAME=jaehong21
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```

## Update `~/.config/chezmoi/chezmoi.toml`

```bash
# edit `.chezmoi.toml.tmpl` in this project then,
chezmoi init
```
