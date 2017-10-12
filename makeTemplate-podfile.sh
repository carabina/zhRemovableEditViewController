#!/bin/sh
#
# 初始化Podfile文件
#
#
function echoSkyBlue(){ # 天蓝色
  echo "\033[36m$1 \033[0m"
}

if test -f ./Podfile
then
  echoSkyBlue "=================== 文件存在，已退出 ===================="
  exit 1
fi

echoSkyBlue "=================== podfile ===================="
echoSkyBlue "请输入将要依赖的pod库，如 pod 'ThemeManager', '~> 0.1.1' "
printf "\033[36m> \033[0m"
read var_pod

target_name=$(echo $(basename ./*.xcodeproj) | awk -F. '{print $1}')

echo "# 公有库 source 
source 'https://github.com/CocoaPods/Specs.git'
\nplatform :ios, '7.0'
use_frameworks!

target '$target_name' do
    
  $var_pod
    
end" > Podfile

if test -n "$var_pod"
then
  pod install
fi

