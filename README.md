# MacOS Configuration Automation

## MacOS Playbook

### Preparation

```
xcode-select --install

export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"

pip3 install ansible

ansible-galaxy install -r requirements.yml
```

### Run playbook

- Run full playbook

```
ansible-playbook main.yml -K
```

- Run specific tags

```
ansible-playbook main.yml -K --tags "defaults"
```

## Todo

- [ ] Set wallpaper

---

_inspired by [geerlingguy/mac-dev-playbook](https://github.com/geerlingguy/mac-dev-playbook/tree/master)_
