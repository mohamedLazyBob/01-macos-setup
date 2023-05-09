# install homebrew, and add it to the path
# install git, wget, jq, coreutils, gofumpt (go fmt) using homebrew
# instal golang, and add it to the path
# install go packages
# install iterm2
# install oh-my-zsh
# install sublime text and merge(Graphical Git Client), vscode, vim
# add git config, ignore .DS_Store


# -------------- Get current logged in user --------------
# Get current logged in user
currentuser=`stat -f '%u %Su' /dev/console | awk '{ print $2 }'`
echo "\n\n-------------- Current logged in user is: $currentuser--------------"

# -------------- Install homebrew --------------
# if brew is not installed install it
echo "\n\n-------------- homebrew --------------\n\n"
brew --version >> /dev/null 2>&1
brew_error=$?
if [ $brew_error -ne 0 ]
then
  echo "-------------- Installing homebrew --------------\n\n"

  # install homebrew
  export HOMEBREW_NO_INSTALL_FROM_API=1
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/${currentuser}/.zprofile
else
  echo "-------------- homebrew is already installed --------------\n\n"
fi

# -------------- Install Golang and its tools --------------

# Check Golang version
sudo -iu ${currentuser} go version
golang_version_error=$?

echo "\n\n-------------- Golang version error: $golang_version_error --------------\n\n"
if [ $golang_version_error -ne 0 ]
then
  echo "-------------- Installing Golang --------------\n\n"
  # install go 
  brew install golang@1.20

  # Set GOROOT into path
  echo 'export GOROOT=/opt/homebrew/bin/go' >> /Users/${currentuser}/.zprofile

  echo "-------------- Installing Golang Packages --------------\n\n"
  go_pkgs=(
    github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest
    github.com/cweill/gotests/gotests@latest
    github.com/fatih/gomodifytags@latest
    github.com/josharian/impl@latest
    github.com/haya14busa/goplay/cmd/goplay@latest
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/go-delve/delve/cmd/dlv@master
    honnef.co/go/tools/cmd/staticcheck@latest
    golang.org/x/tools/gopls@latest
    mvdan.cc/gofumpt@latest
  )

  # Install required Go dependencies
  for go_pkg in "${go_pkgs[@]}"
  do
    sudo -iu ${currentuser} go install -v "$go_pkg"
  done
else
  echo "-------------- Golang is already installed --------------\n\n"
fi


# -------------- Install Git, wget, jq, coreutils, gofumpt (go fmt) using homebrew --------------
echo "\n\n-------------- Install Git, wget, jq, coreutils, gofumpt (go fmt) using homebrew --------------\n\n"
brew install git wget jq coreutils gofumpt


# -------------- Add git config --------------

# ignore .DS_Store
echo "\n\n-------------- Adding git config --------------\n\n"
touch /Users/$currentuser/.gitignore_global
git config --global core.excludesfile /Users/$currentuser/.gitignore_global
echo .DS_Store >> /Users/$currentuser/.gitignore_global


# -------------- install iterm2 --------------
echo "\n\n-------------- install iterm2 --------------\n\n"
# check if it's not isntalled before
brew list --cask iterm2 >> /dev/null 2>&1
iterm2_error=$?
if [ $iterm2_error -ne 0 ]
then
  brew install --cask iterm2
else
  echo "-------------- iterm2 is already installed --------------\n\n"
fi


# -------------- install oh-my-zsh --------------
echo "\n\n-------------- install oh-my-zsh --------------\n\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# -------------- install IDEs --------------

# install sublime text and merge(Graphical Git Client)
echo "\n\n-------------- install sublime text and merge(Graphical Git Client) --------------\n\n"
brew install --cask sublime-text
brew install --cask sublime-merge

# installl VSCode
echo "\n\n-------------- installl VSCode --------------\n\n"
brew install --cask visual-studio-code

# copy VSCode settings
echo "\n\n-------------- copy VSCode settings --------------\n\n"
touch /Users/$currentuser/Library/Application\ Support/Code/User/settings.json >> /dev/null 2>&1
cp ./.config/Code/User/settings.json /Users/$currentuser/Library/Application\ Support/Code/User/settings.json

# Install Visual Studio Extensions for Go
echo "\n\n-------------- Install Visual Studio Extensions for Go --------------\n\n"
code --install-extension golang.go

# install and setup vim
echo "\n\n-------------- install and setup vim --------------\n\n"
brew install vim
cp ./.vimrc /Users/$currentuser/.vimrc

# Get Vim-Go
echo "\n\n-------------- Get Vim-Go --------------\n\n"
git clone https://github.com/fatih/vim-go.git /home/$currentuser/.vim/pack/plugins/start/vim-go

# Install Vim-Go dependencies
# Launch Vim in Ex mode, execute the :GoInstallBinaries command to install Go binaries, and then quit the editor
echo "\n\n-------------- Install Vim-Go dependencies --------------\n\n"
printf ':GoInstallBinaries\n:q\n' | vim -e

echo "\n\n-------------- Done --------------\n\n"