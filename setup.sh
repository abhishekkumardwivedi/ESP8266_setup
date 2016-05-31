#Build essential tools
sudo apt-get install autoconf libtool libtool-bin bison build-essential gawk git gperf flex texinfo libtool libncurses5-dev libc6-dev-amd64 python-serial libexpat-dev python-setuptools

export ESPRESSIF_HOME=/opt/Espressif
sudo mkdir -p $ESPRESSIF_HOME
sudo chown `whoami`:root $ESPRESSIF_HOME
cd $ESPRESSIF_HOME
export ESP_SDK_HOME=$ESPRESSIF_HOME/esp-rtos-sdk
git clone https://github.com/espressif/esp_iot_rtos_sdk.git $ESP_SDK_HOME
cd $ESP_SDK_HOME
git reset --hard 169a436ce10155015d056eab80345447bfdfade5
wget -O lib/libhal.a https://github.com/esp8266/esp8266-wiki/raw/master/libs/libhal.a
cd $ESP_SDK_HOME/include/lwip/arch
sed -i "s/#include \"c_types.h\"/\/\/#include \"c_types.h\"/" cc.h

cd $ESPRESSIF_HOME
wget -O esp_iot_sdk_v0.9.3_14_11_21.zip https://github.com/esp8266/esp8266-wiki/raw/master/sdk/esp_iot_sdk_v0.9.3_14_11_21.zip
wget -O esp_iot_sdk_v0.9.3_14_11_21_patch1.zip https://github.com/esp8266/esp8266-wiki/raw/master/sdk/esp_iot_sdk_v0.9.3_14_11_21_patch1.zip
unzip esp_iot_sdk_v0.9.3_14_11_21.zip
unzip esp_iot_sdk_v0.9.3_14_11_21_patch1.zip
mv esp_iot_sdk_v0.9.3 ESP8266_SDK
mv License ESP8266_SDK/




# Xtensa crosstool
cd $ESPRESSIF_HOME
git clone -b lx106 git://github.com/jcmvbkbc/crosstool-NG.git
cd crosstool-NG
./bootstrap && ./configure --prefix=`pwd` && make && sudo make install
./ct-ng xtensa-lx106-elf
./ct-ng build
export PATH=$PATH:$ESPRESSIF_HOME/crosstool-NG/builds/xtensa-lx106-elf/bin

# Some of header files are missing in SDK, lets add
cd /opt/Espressif/ESP8266_SDK
wget -O lib/libc.a https://github.com/esp8266/esp8266-wiki/raw/master/libs/libc.a
wget -O lib/libhal.a https://github.com/esp8266/esp8266-wiki/raw/master/libs/libhal.a
wget -O include.tgz https://github.com/esp8266/esp8266-wiki/raw/master/include.tgz
tar -xvzf include.tgz
rm include.tgz

#ESP tools
cd $ESPRESSIF_HOME
git clone https://github.com/RostakaGmfun/esptool.git
cd esptool
sudo python setup.py install

rm -rf build
mkdir -p build
cd build
# cmake -DCMAKE_INSTALL_PREFIX=<YOUR_DESTINATION_PATH> -DKAA_PLATFORM=esp8266 -DCMAKE_TOOLCHAIN_FILE=../toolchains/esp8266.cmake ..
# make install

#ESP image tool
cd /opt/Espressif
wget -O esptool_0.0.2-1_i386.deb https://github.com/esp8266/esp8266-wiki/raw/master/deb/esptool_0.0.2-1_i386.deb
sudo dpkg -i esptool_0.0.2-1_i386.deb

#ESP upload tool
cd /opt/Espressif
git clone https://github.com/themadinventor/esptool esptool-py
sudo ln -s $PWD/esptool-py/esptool.py crosstool-NG/builds/xtensa-lx106-elf/bin/
