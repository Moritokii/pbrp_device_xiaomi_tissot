#!/bin/bash
repo init -u git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-9.0
repo sync --force-sync
git clone https://github.com/Takeshiro04/pbrp_device_xiaomi_tissot device/xiaomi/tissot/
rm -rf hardware/qcom/bootctrl
cd bootable/recovery
git reset --hard 951b5f7a669bc805fdd58b7ab2c919cec68714e6
cd ../..
. build/envsetup.sh
lunch omni_tissot-eng
mka recoveryimage
  ZIP=$(ls out/target/product/tissot/PBRP*.zip)
curl https://bashupload.com/$ZIP --data-binary @$ZIP
