# react-native-baidu-map [![npm version](https://img.shields.io/npm/v/react-native-baidu-map.svg?style=flat)](https://www.npmjs.com/package/react-native-baidu-map)

该项目基于 https://github.com/lovebing/react-native-baidu-map 库进行修改，在此特别感谢lovebing!

Baidu Map SDK modules and view for React Native(Android & IOS), support react native 0.30+

百度地图 React Native 模块，支持 react native 0.30+

添加加量多点聚合功能，marker添加itemId属性，点击聚合点cluster判断是否聚合点

地图升级到4.5版本

![Android](https://raw.githubusercontent.com/lovebing/react-native-baidu-map/master/images/android.jpg)
![IOS](https://raw.githubusercontent.com/lovebing/react-native-baidu-map/master/images/ios.jpg)

### Install 安装
    npm install git+https://github.com/mrlinjw/react-native-baidu-map.git --save
### Import 导入

#### Android Studio
- settings.gradle `
include ':react-native-baidu-map'
project(':react-native-baidu-map').projectDir = new File(settingsDir, '../node_modules/react-native-baidu-map/android')`

- build.gradle `compile project(':react-native-baidu-map')`

- MainApplication`new BaiduMapPackage(getApplicationContext())`
- AndroidMainifest.xml `<meta-data
            android:name="com.baidu.lbsapi.API_KEY" android:value="xx"/>`

#### Xcode
- Project navigator->Libraries->Add Files to 选择 react-native-baidu-map/ios/RCTBaiduMap.xcodeproj
- Project navigator->Build Phases->Link Binary With Libraries 加入 libRCTBaiduMap.a
- Project navigator->Build Settings->Search Paths， Framework search paths 添加 react-native-baidu-map/ios/lib，libray search paths 添加 $(SRCROOT)/../node_modules/react-native-baidu-map/ios/lib/thirdlibs, Header search paths 添加 react-native-baidu-map/ios/RCTBaiduMap
- 添加依赖, react-native-baidu-map/ios/lib 下的全部 framwordk， CoreLocation.framework和QuartzCore.framework、OpenGLES.framework、SystemConfiguration.framework、CoreGraphics.framework、Security.framework、libsqlite3.0.tbd（xcode7以前为 libsqlite3.0.dylib）、CoreTelephony.framework 、libstdc++.6.0.9.tbd（xcode7以前为libstdc++.6.0.9.dylib）
- 添加 BaiduMapAPI_Map.framework/Resources/mapapi.bundle

- 静态库中采用ObjectC++实现，因此需要您保证您工程中至少有一个.mm后缀的源文件(您可以将任意一个.m后缀的文件改名为.mm)，或者在工程属性中指定编译方式, 添加方式：即在Xcode的Project -> Edit Active Target -> Build Setting 中找到 Compile Sources As，并将其设置为"Objective-C++"

- 在"Info.plist中进行如下配置     
     `<key>LSApplicationQueriesSchemes</key>`
    ` <array>`
         `<string>baidumap</string>`
    `</array>`

- 其它一些注意事项可参考百度地图LBS文档

##### AppDelegate.m init 初始化
    #import "RCTBaiduMapViewManager.h"
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        ...
        [RCTBaiduMapViewManager initSDK:@"api key"];
        ...
    }

### Usage 使用方法

    import { MapView, MapTypes, MapModule, Geolocation } from 'react-native-baidu-map

#### MapView Props 属性
| Name                    | Type  | Default  | Extra
| ----------------------- |:-----:| :-------:| -------
| zoomControlsVisible     | bool  | true     | Android only
| trafficEnabled          | bool  | false    |
| baiduHeatMapEnabled     | bool  | false    |
| mapType                 | number| 1        |
| zoom                    | number| 10       |
| center                  | object| null     | {latitude: 0, longitude: 0}
| marker                  | object| null     | {latitude: 0, longitude: 0, title: '', itemId: ''}
| markers                 | array | []       | [marker, maker]
| onMapStatusChangeStart  | func  | undefined| Android only
| onMapStatusChange       | func  | undefined|
| onMapStatusChangeFinish | func  | undefined| Android only
| onMapLoaded             | func  | undefined|
| onMapClick              | func  | undefined|
| onMapDoubleClick        | func  | undefined|
| onMarkerClick           | func  | undefined|
| onMapPoiClick           | func  | undefined|

#### MapModule Methods (Deprecated)
    setMarker(double lat, double lng)
    setMapType(int mapType)
    moveToCenter(double lat, double lng, float zoom)
    Promise reverseGeoCode(double lat, double lng)
    Promise reverseGeoCodeGPS(double lat, double lng)
    Promise geocode(String city, String addr),
    Promise getCurrentPosition()

#### Geolocation Methods

| Method                    | Result
| ------------------------- | -------
| Promise reverseGeoCode(double lat, double lng) | `{"address": "", "province": "", "cityCode": "", "city": "", "district": "", "streetName": "", "streetNumber": ""}`
| Promise reverseGeoCodeGPS(double lat, double lng) |  `{"address": "", "province": "", "cityCode": "", "city": "", "district": "", "streetName": "", "streetNumber": ""}`
| Promise geocode(String city, String addr) | {"latitude": 0.0, "longitude": 0.0}
| Promise getCurrentPosition() | IOS: `{"latitude": 0.0, "longitude": 0.0, "address": "", "province": "", "cityCode": "", "city": "", "district": "", "streetName": "", "streetNumber": ""}` Android: `{"latitude": 0.0, "longitude": 0.0, "direction": -1, "altitude": 0.0, "radius": 0.0, "address": "", "countryCode": "", "country": "", "province": "", "cityCode": "", "city": "", "district": "", "street": "", "streetNumber": "", "buildingId": "", "buildingName": ""}`
