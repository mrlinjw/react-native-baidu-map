package org.lovebing.reactnative.baidumap;

import android.content.Context;
import android.graphics.Point;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.baidu.mapapi.SDKInitializer;
import com.baidu.mapapi.clusterutil.clustering.Cluster;
import com.baidu.mapapi.clusterutil.clustering.ClusterItem;
import com.baidu.mapapi.clusterutil.clustering.ClusterManager;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.BitmapDescriptor;
import com.baidu.mapapi.map.BitmapDescriptorFactory;
import com.baidu.mapapi.map.MapPoi;
import com.baidu.mapapi.map.MapStatus;
import com.baidu.mapapi.map.MapStatusUpdate;
import com.baidu.mapapi.map.MapStatusUpdateFactory;
import com.baidu.mapapi.map.MapView;
import com.baidu.mapapi.map.MapViewLayoutParams;
import com.baidu.mapapi.map.Marker;
import com.baidu.mapapi.model.LatLng;
import com.baidu.mapapi.model.LatLngBounds;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import org.lovebing.reactnative.domain.BaiDuMapInfo;
import org.lovebing.reactnative.protocol.BaiduMapProtocol;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by lovebing on 12/20/2015.
 */
public class BaiduMapViewManager extends ViewGroupManager<MapView> {

    private static final String REACT_CLASS = "RCTBaiduMapView";

    private static ThemedReactContext mReactContext;

    private ReadableArray childrenPoints;
    private HashMap<String, Marker> mMarkerMap = new HashMap<>();
    private HashMap<String, List<Marker>> mMarkersMap = new HashMap<>();
    public static TextView mMarkerText;
    public  static MapView mapViewGloble;//全局mapview
    private ClusterManager<MyItem> mClusterManager;//多点聚合

    public String getName() {
        return REACT_CLASS;
    }

    public static int iconType =1;//图标类型

    public void initSDK(Context context) {
        SDKInitializer.initialize(context);
    }

    public MapView createViewInstance(ThemedReactContext context) {
        mReactContext = context;
        mapViewGloble =  new MapView(context);
        setListeners(mapViewGloble);
        Log.e("测试生命周期","入库");
        mClusterManager = new ClusterManager<MyItem>(mReactContext, mapViewGloble.getMap());
        return mapViewGloble;
    }

    @Override
    public void addView(MapView parent, View child, int index) {
        if(childrenPoints != null) {
            Point point = new Point();
            ReadableArray item = childrenPoints.getArray(index);
            if(item != null) {
                point.set(item.getInt(0), item.getInt(1));
                MapViewLayoutParams mapViewLayoutParams = new MapViewLayoutParams
                        .Builder()
                        .layoutMode(MapViewLayoutParams.ELayoutMode.absoluteMode)
                        .point(point)
                        .build();
                parent.addView(child, mapViewLayoutParams);
            }
        }

    }

    @ReactProp(name = "zoomControlsVisible")
    public void setZoomControlsVisible(MapView mapView, boolean zoomControlsVisible) {
        mapView.showZoomControls(zoomControlsVisible);
    }

    @ReactProp(name="trafficEnabled")
    public void setTrafficEnabled(MapView mapView, boolean trafficEnabled) {
        mapView.getMap().setTrafficEnabled(trafficEnabled);
    }

    @ReactProp(name="baiduHeatMapEnabled")
    public void setBaiduHeatMapEnabled(MapView mapView, boolean baiduHeatMapEnabled) {
        mapView.getMap().setBaiduHeatMapEnabled(baiduHeatMapEnabled);
    }

    @ReactProp(name = "iconType")
    public void setIconType(MapView mapView, int iconType) {
        Log.e("iconType图标类型",iconType+"" );
        this.iconType =iconType;
//        Log.e("我擦擦","ccccccccccccccccccccccccccccccccccccccccccccccccccccc");
//        //DefaultClusterRenderer.iv_unreadMsg.setImageResource();
//        changeResouce(iconType);


    }

    @ReactProp(name = "mapType")
    public void setMapType(MapView mapView, int mapType) {
        mapView.getMap().setMapType(mapType);
    }

    @ReactProp(name="zoom")
    public void setZoom(MapView mapView, float zoom) {
        MapStatus mapStatus = new MapStatus.Builder().zoom(zoom).build();
        MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mapStatus);
        mapView.getMap().setMapStatus(mapStatusUpdate);
    }
    @ReactProp(name="center")
    public void setCenter(MapView mapView, ReadableMap position) {
        if(position != null) {
            double latitude = position.getDouble("latitude");
            double longitude = position.getDouble("longitude");
            LatLng point = new LatLng(latitude, longitude);
            MapStatus mapStatus = new MapStatus.Builder()
                    .target(point)
                    .build();
            MapStatusUpdate mapStatusUpdate = MapStatusUpdateFactory.newMapStatus(mapStatus);
            mapView.getMap().setMapStatus(mapStatusUpdate);
        }
    }

    @ReactProp(name="marker")
    public void setMarker(MapView mapView, ReadableMap option) {
        if(option != null) {
            String key = "marker_" + mapView.getId();
            Marker marker = mMarkerMap.get(key);
            if(marker != null) {
                MarkerUtil.updateMaker(marker, option);
            }
            else {
                marker = MarkerUtil.addMarker(mapView, option);
                mMarkerMap.put(key, marker);
            }
        }
    }

    List<BaiDuMapInfo> mapInfos = new ArrayList<BaiDuMapInfo>();
   public static List<MyItem> itemstest =  new ArrayList<MyItem>();
    @ReactProp(name="markers")
    public void setMarkers(final MapView mapView, ReadableArray options) {
        //modify


        Log.e("iconType图标。。。",iconType+"");
        Log.e("测试生命周期","聚合");
        mClusterManager.clearItems();//清除所有的items
        mClusterManager.getMarkerCollection().clear();
        mClusterManager.getClusterMarkerCollection().clear();
        Log.e("options", options + "");
       // Toast.makeText(mReactContext,"caca",Toast.LENGTH_LONG).show();
        BaiduMapProtocol protocol = new BaiduMapProtocol();
        mapInfos = protocol.paserJson(options + "");
        Log.e("mapInfos", mapInfos + "");
        //Log.e("latitude", mapInfos.get(0).latitude + "");
        List<MyItem> items =  new ArrayList<MyItem>();
        // 定义点聚合管理类ClusterManager

      //  mClusterManager = new ClusterManager<MyItem>(mReactContext, mapViewGloble.getMap());
//

        for (BaiDuMapInfo info : mapInfos) {
            LatLng llA = new LatLng(info.latitude, info.longitude);
            items.add(new MyItem(llA,info.title,info.itemId,info.type));

        }
        Log.e("items", "item大小"+items.size() + "");
        itemstest = items;
        mClusterManager.addItems(items);
        mClusterManager.cluster();
        // 设置地图监听，当地图状态发生改变时，进行点聚合运算
        mapViewGloble.getMap().setOnMapStatusChangeListener(mClusterManager);
        // 设置maker点击时的响应
        mapViewGloble.getMap().setOnMarkerClickListener(mClusterManager);

        mClusterManager.setOnClusterClickListener(new ClusterManager.OnClusterClickListener<MyItem>() {
            @Override
            public boolean onClusterClick(Cluster<MyItem> cluster) {
                //Toast.makeText(mReactContext, cluster.getSize()+"", Toast.LENGTH_SHORT).show();

                //if(childClusterVisible){
                    List<MyItem> items = (List<MyItem>) cluster.getItems();
                    LatLngBounds.Builder builder2 = new LatLngBounds.Builder();

                WritableMap writableMap = Arguments.createMap();

                WritableArray backItems = Arguments.createArray();
                if(items.size()>0){
                //总部
                writableMap.putDouble("latitude", items.get(0).getPosition().latitude);
                writableMap.putDouble("longitude", items.get(0).getPosition().longitude);
                writableMap.putBoolean("cluster", true);
                writableMap.putString("itemId", items.get(0).getItemId());
                    writableMap.putString("type", items.get(0).getZIndex());
                writableMap.putString("title", items.size()+"个聚合点");
                for(int j=0;j<items.size();j++){
                    WritableMap writableMap_1 = Arguments.createMap();
                    writableMap_1.putDouble("latitude", items.get(j).getPosition().latitude);
                    writableMap_1.putDouble("longitude", items.get(j).getPosition().longitude);
                    writableMap_1.putString("itemId", items.get(j).getItemId());
                    writableMap_1.putString("title", items.get(j).getTitile());
                    writableMap_1.putString("type", items.get(j).getZIndex());
                    backItems.pushMap(writableMap_1);
                }
                    writableMap.putArray("items",backItems);
                    sendEvent(mapViewGloble, "onMarkerClick", writableMap);
                }
                return false;
            }
        });

        mClusterManager.setOnClusterItemClickListener(new ClusterManager.OnClusterItemClickListener<MyItem>() {
            @Override
            public boolean onClusterItemClick(MyItem item) {
                String showText = item.getTitile();

               // Toast.makeText(mReactContext, showText, Toast.LENGTH_SHORT).show();

                WritableMap writableMap = Arguments.createMap();
                WritableMap writableMap_1 = Arguments.createMap();

                WritableArray items = Arguments.createArray();
                //总部
               writableMap.putDouble("latitude",item.getPosition().latitude);
                writableMap.putDouble("longitude", item.getPosition().longitude);
                writableMap.putBoolean("cluster", false);
                writableMap.putString("itemId", item.getItemId());
                writableMap.putString("title", item.getTitile());
                writableMap.putString("type", item.getZIndex());

                writableMap_1.putDouble("latitude", item.getPosition().latitude);
                writableMap_1.putDouble("longitude", item.getPosition().longitude);
                writableMap_1.putString("itemId", item.getItemId());
                writableMap_1.putString("title", item.getTitile());
                writableMap_1.putString("type", item.getZIndex());
                items.pushMap(writableMap_1);
                writableMap.putArray("items",items);
                sendEvent(mapViewGloble, "onMarkerClick", writableMap);
                return false;
            }
        });
        mClusterManager.setHandler(handler, MAP_STATUS_CHANGE); //设置handler

    }


    @ReactProp(name = "childrenPoints")
    public void setChildrenPoints(MapView mapView, ReadableArray childrenPoints) {
        this.childrenPoints = childrenPoints;
    }


    /**
     * add by du 2017-10-16 16:31
     * @param mapStatus
     * @return
     */
    public static WritableMap getEventParams(MapStatus mapStatus) {
        WritableMap writableMap = Arguments.createMap();
        WritableMap target = Arguments.createMap();
        target.putDouble("latitude", mapStatus.target.latitude);
        target.putDouble("longitude", mapStatus.target.longitude);
        writableMap.putMap("target", target);
        writableMap.putDouble("zoom", mapStatus.zoom);
        writableMap.putDouble("overlook", mapStatus.overlook);
        return writableMap;
    }
    /**
     *
     * @param mapView
     */
    private void setListeners(final MapView mapView) {
        BaiduMap map = mapView.getMap();

        if(mMarkerText == null) {
            mMarkerText = new TextView(mapView.getContext());
            mMarkerText.setBackgroundResource(R.drawable.popup);
            mMarkerText.setPadding(32, 32, 32, 32);
        }



        map.setOnMapStatusChangeListener(new BaiduMap.OnMapStatusChangeListener() {

            private WritableMap getEventParams(MapStatus mapStatus) {
                WritableMap writableMap = Arguments.createMap();
                WritableMap target = Arguments.createMap();
                target.putDouble("latitude", mapStatus.target.latitude);
                target.putDouble("longitude", mapStatus.target.longitude);
                writableMap.putMap("target", target);
                writableMap.putDouble("zoom", mapStatus.zoom);
                writableMap.putDouble("overlook", mapStatus.overlook);
                return writableMap;
            }

            @Override
            public void onMapStatusChangeStart(MapStatus mapStatus) {

                sendEvent(mapView, "onMapStatusChangeStart", getEventParams(mapStatus));
                Log.i("BaiduMap","onMapStatusChangeStart");

            }

            @Override
            public void onMapStatusChange(MapStatus mapStatus) {
                Log.i("BaiduMap","onMapStatusChange");
                sendEvent(mapView, "onMapStatusChange", getEventParams(mapStatus));
            }

            @Override
            public void onMapStatusChangeFinish(MapStatus mapStatus) {
                if(mMarkerText.getVisibility() != View.GONE) {
                    mMarkerText.setVisibility(View.GONE);
                }
                sendEvent(mapView, "onMapStatusChangeFinish", getEventParams(mapStatus));
                Log.i("BaiduMap","onMapStatusChangeFinish");
            }
        });

        map.setOnMapLoadedCallback(new BaiduMap.OnMapLoadedCallback() {
            @Override
            public void onMapLoaded() {
                sendEvent(mapView, "onMapLoaded", null);
            }
        });

        map.setOnMapClickListener(new BaiduMap.OnMapClickListener() {
            @Override
            public void onMapClick(LatLng latLng) {
                mapView.getMap().hideInfoWindow();
                WritableMap writableMap = Arguments.createMap();
                writableMap.putDouble("latitude", latLng.latitude);
                writableMap.putDouble("longitude", latLng.longitude);
                sendEvent(mapView, "onMapClick", writableMap);
            }

            @Override
            public boolean onMapPoiClick(MapPoi mapPoi) {
                WritableMap writableMap = Arguments.createMap();
                writableMap.putString("name", mapPoi.getName());
                writableMap.putString("uid", mapPoi.getUid());
                writableMap.putDouble("latitude", mapPoi.getPosition().latitude);
                writableMap.putDouble("longitude", mapPoi.getPosition().longitude);
                sendEvent(mapView, "onMapPoiClick", writableMap);
                return true;
            }
        });
        map.setOnMapDoubleClickListener(new BaiduMap.OnMapDoubleClickListener() {
            @Override
            public void onMapDoubleClick(LatLng latLng) {
                WritableMap writableMap = Arguments.createMap();
                writableMap.putDouble("latitude", latLng.latitude);
                writableMap.putDouble("longitude", latLng.longitude);
                sendEvent(mapView, "onMapDoubleClick", writableMap);
            }
        });

        /*
        map.setOnMarkerClickListener(new BaiduMap.OnMarkerClickListener() {
            @Override
            public boolean onMarkerClick(Marker marker) {
                if(marker.getTitle().length() > 0) {
                    mMarkerText.setText(marker.getTitle());
                    InfoWindow infoWindow = new InfoWindow(mMarkerText, marker.getPosition(), -80);
                    mMarkerText.setVisibility(View.GONE);
                    mapView.getMap().showInfoWindow(infoWindow);
                }
                else {
                    mapView.getMap().hideInfoWindow();
                }
//                WritableMap writableMap = Arguments.createMap();
//                WritableMap position = Arguments.createMap();
//
//                position.putDouble("latitude", marker.getPosition().latitude);
//                position.putDouble("longitude", marker.getPosition().longitude);
//                position.putInt("itemId", marker.getPeriod());
//                writableMap.putMap("position", position);
//                writableMap.putString("title", marker.getTitle());

                WritableMap writableMap = Arguments.createMap();
                WritableMap writableMap_1 = Arguments.createMap();
                WritableMap writableMap_2 = Arguments.createMap();
                WritableArray items = Arguments.createArray();
                writableMap.putDouble("latitude", 111.000);
                writableMap.putDouble("longitude", 111.111);
                writableMap.putString("cluster", "true");
                writableMap.putString("itemId", "1");
                writableMap.putString("title", "2个聚合点");
//                for(int i=0;i<2;i++){
//
//                }
                writableMap_1.putDouble("latitude", 222.000);
                writableMap_1.putDouble("longitude", 222.111);
                writableMap_1.putString("itemId", "16");
                writableMap_1.putString("title", "傻逼一");

                writableMap_2.putDouble("latitude", 333.000);
                writableMap_2.putDouble("longitude", 333.111);
                writableMap_2.putString("itemId", "15");
                writableMap_2.putString("title", "傻逼二");

                items.pushMap(writableMap_1);
                items.pushMap(writableMap_2);
                writableMap.putArray("items",items);
                sendEvent(mapView, "onMarkerClick", writableMap);
                return true;
            }
        });*/

    }

    /**
     *
     * @param eventName
     * @param params
     */
    public static void sendEvent(MapView mapView, String eventName, @Nullable WritableMap params) {
        WritableMap event = Arguments.createMap();
        event.putMap("params", params);
        event.putString("type", eventName);
        mReactContext
                .getJSModule(RCTEventEmitter.class)
                .receiveEvent(mapView.getId(),
                        "topChange",
                        event);
    }



    //----------------------------------------------------------分割线------------------------------------------//
    //-----------------------------------------------------------聚合功能----------------------------------------//


//    public void setChildClusterVisible(MapView mapView, boolean childClusterVisible) {
//        showChildCluster(childClusterVisible);
////        if(childClusterVisible){
////            Toast.makeText(mReactContext,"添加属性",Toast.LENGTH_SHORT).show();
////            showChildCluster(childClusterVisible);
////        }else{
////            Toast.makeText(mReactContext,"不添加属性",Toast.LENGTH_SHORT).show();
////        }
//
//    }

    MapView mMapView;
    BaiduMap mBaiduMap;
    MapStatus ms;


    private final  int MAP_STATUS_CHANGE = 100;
    private Handler handler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what) {
                case MAP_STATUS_CHANGE:
                    MapStatus mapStatus = (MapStatus) msg.obj;
                    if(mapStatus!=null){
                        Log.i("MarkerClusterDemo", "mapStatus="+mapStatus.toString());
                        // to do :  判断地图状态，进行相应处理
                    }
                    break;
                default:
                    break;
            }
        }
    };


    /**
     * 向地图添加Marker点
     */
    public void addMarkers() {
        // 添加Marker点
        LatLng llA = new LatLng(35.963175, 120.400244);
        LatLng llB = new LatLng(35.952821, 120.399199);
        LatLng llC = new LatLng(35.939723, 120.425541);
        LatLng llD = new LatLng(35.906965, 120.401394);
        LatLng llE = new LatLng(35.956965, 120.331394);
        LatLng llF = new LatLng(35.886965, 120.441394);
        LatLng llG = new LatLng(35.996965, 120.411394);

//        Bundle bundleA = new Bundle();
//        bundleA.putString("index","001");
//        Bundle bundleB = new Bundle();
//        bundleB.putString("index","002");
//        Bundle bundleC = new Bundle();
//        bundleC.putString("index","003");
        List<MyItem> items = new ArrayList<MyItem>();
//        items.add(new MyItem(llA, bundleA));
//        items.add(new MyItem(llB, bundleB));
//        items.add(new MyItem(llC, bundleC));
//        items.add(new MyItem(llD));
//        items.add(new MyItem(llE));
//        items.add(new MyItem(llF));
//        items.add(new MyItem(llG));

        mClusterManager.addItems(items);

    }

    /**
     * 每个Marker点，包含Marker点坐标以及图标
     */
    public class MyItem implements ClusterItem {
        private final LatLng mPosition;
        private  String mTitle;
        private  String mItemId;
        private  String mType;
        private Bundle mBundle;

        public MyItem(LatLng latLng,String title,String itemId,String type) {
            mPosition = latLng;
            mTitle=title;
            mItemId=itemId;
            mType = type;
            mBundle = null;
        }
        public MyItem(LatLng latLng, Bundle bundle) {
            mPosition = latLng;
          //  mBundle = bundle;
        }
        @Override
        public LatLng getPosition() {
            return mPosition;
        }

        @Override
        public String getTitile() {
            return mTitle;
        }

        @Override
        public String getItemId() {
            return mItemId;
        }

        @Override
        public String getZIndex() {
            return mType;
        }

        @Override
        public BitmapDescriptor getBitmapDescriptor() {
            //int iconId = R.drawable.icon_gcoding;
            //modify by du 2017-10-11 15:09
            int iconId = R.drawable.icon_gcoding;
            switch (iconType){
                case 1:
                    iconId = R.drawable.icon_diaodian;//钓点
                    break;
                case 2:
                    iconId = R.drawable.icon_qita;
                    break;
                case 3:
                    iconId = R.drawable.icon_luying;//露营
                    break;
                case 4:
                    iconId = R.drawable.icon_jingdian;//景点
                    break;
                case 5:
                    iconId = R.drawable.icon_qita;
                    break;
                case 6:
                    iconId = R.drawable.icon_qita;
                    break;
                case 7:
                    iconId = R.drawable.icon_qita;
                    break;
                case 8:
                    iconId = R.drawable.icon_chuangjia;//船家
                    break;
                case 9:
                    iconId = R.drawable.icon_qita;
                    break;
                case 10:
                    iconId = R.drawable.icon_qita;
                    break;
                case 11:
                    iconId = R.drawable.icon_qita;
                    break;
                case 12:
                    iconId = R.drawable.icon_qita;
                    break;
                case 13:
                    iconId = R.drawable.icon_yujudian;//渔具店
                    break;
                case 14:
                    iconId = R.drawable.icon_qita;
                    break;
                case 15:
                    iconId = R.drawable.icon_qita;
                    break;
                case 16:
                    iconId = R.drawable.icon_qita;
                    break;
                case 17:
                    iconId = R.drawable.icon_qita;
                    break;
                case 18:
                    iconId = R.drawable.icon_qianshui;//潜水
                    break;
                default:
                    iconId = R.drawable.icon_qita;
                    break;


            }
//            if(mBundle!=null){
//                if("001".contentEquals(mBundle.getString("index"))) {
//                    iconId = R.drawable.icon_marka;
//                } else if("002".contentEquals(mBundle.getString("index"))) {
//                    iconId = R.drawable.icon_markb;
//                }
//            }

            return BitmapDescriptorFactory
                    .fromResource(iconId);//R.drawable.icon_gcoding);
        }

        public Bundle getBundle(){
            return mBundle;
        }

    }
}
