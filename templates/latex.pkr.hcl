packer {
  required_plugins {
    tart = {
      version = ">= 1.1.0"
      source  = "github.com/cirruslabs/tart"
    }
  }
}

variable "macos_version" {
  type =  string
}

variable "xcode_version" {
  type =  string
}

source "tart-cli" "tart" {
  vm_base_name = "ghcr.io/onevcat/${var.macos_version}-xcode:${var.xcode_version}"
  vm_name      = "${var.macos_version}-xcode-${var.xcode_version}-latex:latest"
  cpu_count    = 4
  memory_gb    = 8
  disk_size_gb = 80
  ssh_password = "admin"
  ssh_timeout  = "120s"
  ssh_username = "admin"
}

build {
  sources = ["source.tart-cli.tart"]
  
  # Install LaTex
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install --cask basictex",
      "eval \"$(/usr/libexec/path_helper)\"",
      "sudo tlmgr update --self",
      "sudo tlmgr install footmisc nowidow relsize datetime fmtcount leading pagecolor changepage enumitem tocloft mdframed needspace nopageno ctex environ trimspaces zhnumber titlesec adjustbox collectbox newunicodechar catchfile hardwrap zref"
    ]
  }

  # Install Pandoc
  provisioner "shell" {
    inline = [
      "curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh",
      "echo 'source ~/.ghcup/env' >> ~/.zprofile",
      "source ~/.zprofile",
      "cabal install pandoc",
      "cabal install --lib pandoc",
      "cabal install --lib pandoc-types",
      "cabal install pandoc-cli",
      "pandoc --version"
    ]
  }

  # Install misc & font
  provisioner "shell" {
    inline = [
      "source ~/.zprofile",
      "brew install ImageMagick sourcekitten epubcheck cmark",
      "sudo mkdir /usr/local/include/",
      "sudo ln -s /opt/homebrew/include/cmark.h /usr/local/include/",
      "wget https://github.com/onevcat/objc-image-packer/releases/download/0.0.2/fonts.zip",
      "unzip fonts.zip",
      "cp ./fonts/* /Library/Fonts/",
      "rm -rf ./fonts",
      "rm fonts.zip",
      "pip3 install git+https://github.com/objcio/pygments.git",
      "echo 'export PATH=~/Library/Python/3.9/bin/:$PATH' >> ~/.zprofile",
      "source ~/.zprofile",
      "which pygmentize",
    ]
  }
}