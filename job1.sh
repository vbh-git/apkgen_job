cordova create $1 com.$2.app $2 &>/dev/null
export ANDROID_HOME=~/Android/Sdk
echo "Temporary App Generated"
cd $1 
cordova platform add android &>/dev/null
cordova plugin add cordova-plugin-dialogs &>/dev/null
cordova plugin add cordova-plugin-network-information &>/dev/null
cordova plugin add cordova-plugin-inappbrowser &>/dev/null
cordova plugin add cordova-plugin-exit &>/dev/null
echo "Dependencies added"
git clone https://github.com/vbh-git/apkgen_template1.git &>/dev/null
rm www/index.html www/js/index.js 
echo $2 >> appname
echo $3 >> appurl
head -c -1 -q apkgen_template1/indexhtml1 appname apkgen_template1/indexhtml2 > index.html
head -c -1 -q apkgen_template1/indexjs1 appurl apkgen_template1/indexjs2 > index.js
rm appname appurl
mv index.html www/
mv index.js www/js/
wget https://www.google.com/s2/favicons?domain=$3 -O icon.png &>/dev/null
cp icon.png www/img/icon.png
awk '/index.html/ { print; print "  <icon src=\"icon.png\" />"; next }1' config.xml >> config1
mv config1 config.xml
cat config.xml | awk '{ if(NR==2) {print $1, $2, $3, $4," xmlns:android=\"http://schemas.android.com/apk/res/android\""; $1=$2=$3=$4=""; print $0 } else  {print $0;}}' >> config1
mv config1 config.xml
awk '/name="android">/ { print; print "<edit-config file=\"app/src/main/AndroidManifest.xml\" mode=\"merge\" target=\"/manifest/application\">"; 
print "<application android:usesCleartextTraffic=\"true\" />";
print "</edit-config>";
next }1' config.xml >> config1
mv config1 config.xml
echo "Modified required files"
cordova build android &>/dev/null
mv ./platforms/android/app/build/outputs/apk/debug/app-debug.apk /root/generated_apps/$1$2.apk
cd ../
rm -rf $1
echo "App Generated"

