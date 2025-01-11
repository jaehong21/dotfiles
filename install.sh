sudo xcodebuild -license accept

echo "Install Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

helm plugin install https://github.com/databus23/helm-diff

echo "Install kitty..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
echo "include $HOME/.config/nvim/kitty.conf" > $HOME/.config/kitty/kitty.conf
