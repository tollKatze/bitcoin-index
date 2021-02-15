public with sharing class KrakenAssetData implements IAssetData {

    public Long getStartTime(){
        return Long.valueof('123456789012');
    }
    
    public HttpResponse getAssetData(String pair, String timeInterval) {
        return new HttpResponse();
    }

    public Map<Long, AssetCandleObject> parseAssetData(HttpResponse response) {
        return new Map<Long, AssetCandleObject>();
    }
}