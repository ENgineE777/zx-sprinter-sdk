setx ZXSDK %~dp0

thirdparty\7zip\7zG.exe x "thirdparty\zxmak.zip" -o"zxmak" -y

echo select vdisk file="%~dp0zxmak\HDD\sp_disk1.vhd">zxmak\HDD\mount.txt
echo attach vdisk>>zxmak\HDD\mount.txt
echo select partition 1 >> zxmak\HDD\mount.txt
echo assign letter = Z: >> zxmak\HDD\mount.txt

echo select vdisk file="%~dp0zxmak\HDD\sp_disk1.vhd">zxmak\HDD\unmount.txt
echo detach vdisk>>zxmak\HDD\unmount.txt