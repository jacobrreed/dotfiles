#!/bin/sh

system_type=$(uname -s)

if [ "$system_type" = "Darwin" ]; then
	# install homebrew if it's missing
	if ! command -v brew >/dev/null 2>&1; then
		echo "Installing homebrew"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi
	# Homebrew bundle using brewfile
	if [ -f "$HOME/.config/brew/Brewfile" ]; then
		echo "Homebrew bundling..."
		brew bundle --file "$HOME/.config/brew/Brewfile"
	fi
  # Install misc packages
  ## FNM
  curl -fsSL https://fnm.vercel.app/install | bash
elif [ "$system_type" = "Linux" ]; then
  # Install DPKG packages
  chmod u+x ~/.config/apt/restore.sh
  sudo ~/.config/apt/restore.sh
  # Install misc packages
  # FNM
  curl -fsSL https://fnm.vercel.app/install | bash
  # PyEnv
  curl https://pyenv.run | bash
elif [ "$system_type" = "FreeBSD" ]; then
	echo "FreeBSD - no bootstrapping found"
else
	echo "Other OS: $system_type"
fi

# Submodules
echo "Updating submodules..."
cd $HOME
yadm submodule update --recursive --init

# Bootstrap nvim with LazyVim
if command -v nvim >/dev/null 2>&1; then
	echo "Bootstrapping nvim..."
	nvim --headless '+Lazy! sync' +qa
fi
