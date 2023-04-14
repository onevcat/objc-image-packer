# Image Packer for ObjCCN books

Install [Packer](https://www.packer.io) to get started.

Ref: [tart templates](https://github.com/cirruslabs/macos-image-templates)

### Init

```bash
packer init config.pkr.hcl
```

### Build Xcode image

```bash
packer build -var-file="variables.pkrvars.hcl" templates/xcode.pkr.hcl
```

### Build LaTex image

```bash
packer build -var-file="variables.pkrvars.hcl" templates/latex.pkr.hcl
```

### Push an image

```bash
# Set user name and personal access token in .env
export $(cat .env | xargs) && tart push ventura-xcode-14.3-latex:latest ghcr.io/onevcat/ventura-xcode-14.3-latex:latest
```

### Clone and Use VM

```bash
tart clone ghcr.io/onevcat/ventura-xcode-14.3-latex:latest my_vm
tart run --dir=src:~/Documents/somefolder my_vm

# Headless mode
# tart run --no-graphics --dir=src:~/Documents/somefolder my_vm

# Connect with SSH
ssh admin@$(tart ip my_vm)
```