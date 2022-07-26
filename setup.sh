#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  echo "Installing Oh-My-Zsh..."
  /bin/sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Linking Oh-My-Zsh dotfiles"
# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zprofile
rm -rf $HOME/.zshrc
ln -s $DOTFILES/zsh/.zprofile $HOME/.zprofile
ln -s $DOTFILES/zsh/.zshrc $HOME/.zshrc

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Installing Homebrew bundle..."
# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file $DOTFILES/brew/Brewfile

echo "Linking git dotfiles"
# Removes .gitconfig from $HOME (if it exists) and symlinks the .gitconfig file from the .dotfiles
rm -rf $HOME/.gitconfig
rm -rf $HOME/.gitignore_global
ln -s $DOTFILES/git/.gitconfig $HOME/.gitconfig
ln -s $DOTFILES/git/.gitignore_global $HOME/.gitignore_global

echo "Linking gh dotfiles"
rm -rf $HOME/.config/gh/config.yml
ln -s $DOTFILES/gh/config.yml $HOME/.config/gh/config.yml

echo "Linking AWS dotfiles"
rm -rf $HOME/aws/config
ln -s $DOTFILES/aws/config $HOME/aws/config

echo "Linking NuGet dotfiles"
rm -rf $HOME/nuget/NuGet/NuGet.Config
ln -s $DOTFILES/nuget/NuGet.Config $HOME/nuget/NuGet/NuGet.Config

# Check for VS Code and install if we don't have it
if test ! $(which code); then
  echo "Installing VS Code..."
  curl -o $HOME/Visual\ Studio\ Code.app https://code.visualstudio.com/sha/download?build=stable&os=darwin-arm64
  xattr -dr com.apple.quarantine $HOME/Visual\ Studio\ Code.app
  mkdir $HOME/code-portable-data
fi

echo "Linking VS Code dotfiles"
rm -rf $HOME/code-portable-data/user-data/User/settings.json
ln -s $DOTFILES/vscode/settings.json $HOME/code-portable-data/user-data/User/settings.json

echo "Linking VS Code extensions..."
vsixlist=(
ms-dotnettools.csharp
donjayamanne.githistory
codezombiech.gitignore
visualstudioexptteam.vscodeintellicode
ms-azuretools.vscode-docker
jmrog.vscode-nuget-package-manager
josefpihrt-vscode.roslynator
alefragnani.bookmarks
humao.rest-client
davidanson.vscode-markdownlint
zainchen.json
mongodb.mongodb-vscode
ckolkman.vscode-postgres
ms-vscode-remote.vscode-remote-extensionpack
)

for i in ${vsixlist[@]}; do
  code --install-extension $i
done
