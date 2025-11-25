sudo apt update
sudo apt install libusb-1.0-0-dev git cmake build-essential
sudo apt install debhelper

git clone https://github.com/osmocom/rtl-sdr
cd rtl-sdr
sudo dpkg-buildpackage -b --no-sign
cd ..

sudo dpkg -i librtlsdr0_*
sudo dpkg -i librtlsdr-dev_*
sudo dpkg -i rtl-sdr_*
