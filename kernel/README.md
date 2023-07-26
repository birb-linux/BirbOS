# Alternative kernel configs
This directory is meant to house some alternative kernel configurations to the default one. They may or may not be up-to-date and in no way are quaranteed to work with all devices. I also give zero security quarantees when it comes to hardening (like with the default kernel config).

## intel_nvidia_laptop
This kernel configuration was made for my gaming laptop with the following specs:
- Intel i5-9300H
- NVIDIA GeForce GTX 1650 Mobile
- SATA SSD (The default kernel config doesn't support this, because my desktop only has M.2 NVME SSDs)
- Hybrid graphics
- Integrated keyboard (needed extra HID and USB configuration)
