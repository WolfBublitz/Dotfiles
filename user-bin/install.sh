BIN_DIR=~/bin

if [[ ! -d $BIN_DIR ]]; then
    mkdir $BIN_DIR

    echo "export PATH=$BIN_DIR:$PATH" >> .bashrc
fi
