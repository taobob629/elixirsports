

# 指定pubspec.yaml文件的路径
PUBSPEC_FILE="pubspec.yaml"

# 使用grep查找version行，然后使用awk提取版本号
VERSION=$(grep "^version:" $PUBSPEC_FILE | awk -F': ' '{print $2}')

# 打印版本号
echo "Version: $VERSION"

fvm flutter build appbundle

# 定义原始文件名和新文件名
OLD_FILE="build/app/outputs/bundle/release/app-release.aab"
NEW_FILE="build/app/outputs/bundle/release/正式版-$VERSION.aab"

# 使用mv命令重命名文件
if [ -f "$OLD_FILE" ]; then
    mv "$OLD_FILE" "$NEW_FILE"
    echo "文件已成功重命名为 $NEW_FILE"
else
    echo "文件 $OLD_FILE 不存在"
fi


# flutter build apk -t lib/main_dev.dart

# # 定义原始文件名和新文件名
# OLD_FILE="build/app/outputs/flutter-apk/app-release.apk"
# NEW_FILE="build/app/outputs/flutter-apk/测试版.apk"

# # 使用mv命令重命名文件
# if [ -f "$OLD_FILE" ]; then
#     mv "$OLD_FILE" "$NEW_FILE"
#     echo "文件已成功重命名为 $NEW_FILE"
# else
#     echo "文件 $OLD_FILE 不存在"
# fi
# win
# explorer 'build\app\outputs\flutter-apk\'

# mac
open 'build/app/outputs/flutter-apk'