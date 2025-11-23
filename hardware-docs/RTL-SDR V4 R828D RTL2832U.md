# RTL-SDR V4 --- R828D + RTL2832U

A concise technical overview of the RTL-SDR Blog V4 USB SDR receiver,
based on the **R828D** tuner and the **RTL2832U** demodulator.

## 1. Overview

The RTL-SDR V4 is an improved version of the popular low-cost SDR USB
dongle. It features a **1 PPM TCXO**, redesigned input filtering, SMA
antenna connector, optional **Bias-T**, and an aluminum enclosure that
acts as a heat sink.\
This device is **receive-only**.

## 2. Key Features

-   **Tuner:** R828D\
-   **Demodulator:** RTL2832U (USB 2.0)\
-   **Frequency Range:** \~500 kHz--1.766 GHz (continuous)\
-   **TCXO:** 1 PPM\
-   **Instantaneous Bandwidth:** Up to \~3.2 MHz (typical stable \~2.4
    MHz)\
-   **Antenna Connector:** SMA (female)\
-   **Bias-T:** Software-controlled (for powering LNAs/active antennas)\
-   **Housing:** Aluminum case for shielding and cooling

## 3. Specifications

  Parameter             Value
  --------------------- -------------------------------------
  Main Chip             RTL2832U
  Tuner                 R828D
  Frequency Range       \~500 kHz -- 1.766 GHz
  Bandwidth             Up to \~3.2 MHz
  Frequency Stability   1 PPM TCXO
  Antenna Connector     SMA (female)
  Bias-T                Yes, software-switchable
  USB Interface         USB 2.0
  Max Input Signal      \~+10 dBm (avoid strong RF sources)

## 4. Compatible Software

**Windows:** SDR#, HDSDR, SDR Console\
**Linux:** GQRX, CubicSDR, rtl_fm, rtl_tcp, dump1090, SoapySDR\
**macOS:** GQRX, CubicSDR\
**Android:** SDR Touch (requires USB OTG)

## 5. Common Use Cases

-   Wideband spectrum monitoring (VHF/UHF)\
-   FM/AM/NFM/WFM reception\
-   ADS-B aircraft tracking (1090 MHz)\
-   AIS (162 MHz)\
-   NOAA APT weather satellite reception\
-   Decoding digital modes (DMR, P25, POCSAG, RTTY, PSK, etc.)\
-   General DSP experimentation and learning

## 6. Practical Tips

-   **Use a proper antenna** tuned for your target band; stock antennas
    are limited.\
-   If using **Bias-T**, ensure that your LNA or antenna can accept the
    voltage/current.\
-   Avoid exposure to **very strong transmitters** to prevent damage.\
-   Allow the device to warm up for optimal **TCXO stability**.

## 7. Limitations

-   Receive-only --- **cannot transmit**.\
-   Lower dynamic range compared to higher-end SDRs (Airspy, SDRplay).\
-   Front-end can be overloaded by strong nearby transmitters without
    filtering.

## 8. Useful Command-Line Examples (Linux)

``` bash
# Install rtl-sdr tools
sudo apt update
sudo apt install rtl-sdr

# Simple FM broadcast reception to WAV file
rtl_fm -f 99.3M -M fm -s 200k -r 48k | sox -t raw -r 48k -e signed -b 16 -c 1 -V1 - output.wav

# ADS-B reception
dump1090 --gain auto --interactive
```

## 9. Additional Resources

-   RTL-SDR Blog official documentation\
-   Driver packages (librtlsdr)\
-   Open-source decoding tools (dump1090, rtl_433, etc.)

Drivers instalation help:
https://www.rtl-sdr.com/V4/
