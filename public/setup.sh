# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages and casks with brew
brew update
brew upgrade

brew install --cask google-chrome visual-studio-code discord karabiner-elements shottr rectangle-pro 1password 1password-cli vlc hpedrorodrigues/tools/dockutil
brew install git fnm gh tmux pnpm

# Set up dock icons
echo "Setting up dock"
dockutil --remove all --no-restart
dockutil --add "/Applications/Google Chrome.app" --no-restart
dockutil --add "/Applications/Visual Studio Code.app" --no-restart
dockutil --add "/System/Applications/Utilities/Terminal.app" --no-restart
dockutil --add "/Applications/Discord.app" --no-restart
dockutil --add "/System/Applications/Messages.app" --no-restart
dockutil --add "/System/Applications/System Settings.app" --no-restart

#Folders to add to the dock
dockutil --add '/Applications' --view grid --display folder --no-restart
dockutil --add '~/Documents' --view grid --display folder --no-restart
dockutil --add '~/Downloads' --view grid --display folder

# if on a desktop, install caffeine
if [[ $(sysctl -n hw.model) = *MacStudio* ]]; then
  echo "Desktop detected, installing caffeine"
  brew install --cask caffeine
fi

# xcode command line tools
xcode-select --install

# oh-my-zsh
sh -c "$(curl -# -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh aliases
echo "alias c='open \$1 -a \"Visual Studio Code\"'" >>~/.zshrc

# oh-my-tmux
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

eval "$(op signin)"

# git config
echo "Setting up git"

git config --global user.name "Mark R. Florkowski"
git config --global user.email "mark.florkowski@gmail.com"
git config --global core.editor "code --wait"
git config --global push.default upstream

# commit signing with 1password
git config --global user.signingkey "$(op item get "Github SSH Key" --fields "Public Key" --account RXTVLR6HMRES3CGS7G3WHSUPOQ)"
git config --global gpg.format "ssh"
git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
git config --global commit.gpgsign true

# git aliases
git config --global alias.undo "reset --soft HEAD^"

# Set up dock hiding if on a laptop
if [[ $(sysctl -n hw.model) = *MacBook* ]]; then
  echo "Laptop detected, setting up dock hiding"
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0
  killall Dock
fi

# add karabiner mappings
echo "Getting karabiner configs"
mkdir -p ~/.config/karabiner/
curl -# https://gist.githubusercontent.com/markflorkowski/bc393361c0222f19ec3131b5686ed080/raw/62aec7067011cdf5e90cf54f252cbfb5a1e49de0/karabiner.json -o ~/.config/karabiner/karabiner.json

curl -# https://gist.githubusercontent.com/markflorkowski/3774bbbfeccd539c4343058e0740367c/raw/7c6e711a9516f83ff48c99e43eef9ca13fb05246/1643178345.json -o ~/.config/karabiner/assets/complex_modifications/1643178345.json

echo "Updating macOS settings"

# Disable annoying backswipe in Chrome
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

# Avoid the creation of .DS_Store files on network volumes or USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Finder tweaks
defaults write NSGlobalDomain AppleShowAllExtensions -bool true            # Show all filename extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # Disable warning when changing a file extension
defaults write com.apple.finder FXPreferredViewStyle Clmv                  # Use column view
defaults write com.apple.finder AppleShowAllFiles -bool true               # Show hidden files
defaults write com.apple.finder ShowPathbar -bool true                     # Show path bar
defaults write com.apple.finder ShowStatusBar -bool true                   # Show status bar
killall Finder

echo "Starting services"
open "/Applications/Rectangle Pro.app"
open "/Applications/Karabiner-Elements.app"