package org.lovebing.reactnative.protocol;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import org.lovebing.reactnative.domain.BaiDuMapInfo;

import java.util.ArrayList;
import java.util.List;

;

/**
 * Created by Administrator on 2017/7/4.
 */

//public String itemId;//钓点id
//public Double longitude;//钓点经度
//public Double latitude;//钓点纬度
//public String title;//钓点名称


public class BaiduMapProtocol {
    public List<BaiDuMapInfo> paserJson(String json) {

        List<BaiDuMapInfo> mapInfos = new ArrayList<BaiDuMapInfo>();
        //JSONObject jsonObject = JSONObject.parseObject(json);
        try{
            JSONArray  jsonArray = JSON.parseArray(json);
            for(int i=0;i<jsonArray.size();i++){
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                String itemId = jsonObject.getString("itemId");
                String type = jsonObject.getString("type");
                Double longitude = jsonObject.getDouble("longitude");
                Double latitude = jsonObject.getDouble("latitude");
                String title = jsonObject.getString("title");
                BaiDuMapInfo mapInfo = new BaiDuMapInfo(itemId,type,longitude,latitude,title);
                mapInfos.add(mapInfo);

            }
        }catch (Exception e){
            return  null;
        }

        return  mapInfos;

    }
}
