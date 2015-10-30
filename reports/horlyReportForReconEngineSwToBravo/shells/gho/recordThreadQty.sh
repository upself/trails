#!/bin/bash

path=/opt/reports/recon-summary/files/threads-qty

./threadQty.sh reconEngineInventory>> $path/reconInventoryThreadQty.txt
./threadQty.sh reconEngineLicensing>> $path/reconLicensingThreadQty.txt
./threadQty.sh softwareToBravo>> $path/swToBravoThreadQty.txt