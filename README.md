wpss
====

## Installation

#### Sabayon

```bash
# as root:
equo up
equo i -av python gcc git
pip install --disable-pip-version-check pip
pip install hererocks
# as user:
python -m hererocks -j2.1 -r^ ~/.lua_install
echo 'PATH=$PATH:~/.lua_install/bin' >> ~/.bashrc
source ~/.bashrc
luarocks install penlight
luarocks install cjson
luarocks install pegasus
luarocks install config
luarocks install luasocket
luarocks install i18n
git clone ssh://git@ssh20k.tetrarch.co:20000/skwerlman/wpsort-server.git
```

#### *buntu

```bash
sudo apt-get update
sudo apt-get install python git
sudo pip install --disable-pip-version-check pip
sudo pip install hererocks
python -m hererocks -j2.1 -r^ ~/.lua_install
echo 'PATH=$PATH:~/.lua_install/bin' >> ~/.bashrc
source ~/.bashrc
luarocks install penlight
luarocks install cjson
luarocks install pegasus
luarocks install config
luarocks install luasocket
luarocks install i18n
git clone ssh://git@ssh20k.tetrarch.co:20000/skwerlman/wpsort-server.git
```
