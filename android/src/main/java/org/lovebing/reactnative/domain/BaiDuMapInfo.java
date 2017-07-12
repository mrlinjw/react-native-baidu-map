package org.lovebing.reactnative.domain;

/**
 * Created by Administrator on 2017/7/4.
 */

/**
 * 钓点信息
 */
public class BaiDuMapInfo {

    public String itemId;//钓点id
    public String type;//类型
    public Double longitude;//钓点经度
    public Double latitude;//钓点纬度
    public String title;//钓点名称

    public BaiDuMapInfo() {
    }

    public BaiDuMapInfo(String itemId, String type, Double longitude, Double latitude, String title) {
        this.itemId = itemId;
        this.type = type;
        this.longitude = longitude;
        this.latitude = latitude;
        this.title = title;
    }

    @Override
    public String toString() {
        return "BaiDuMapInfo{" +
                "itemId='" + itemId + '\'' +
                ", type='" + type + '\'' +
                ", longitude=" + longitude +
                ", latitude=" + latitude +
                ", title='" + title + '\'' +
                '}';
    }
}
