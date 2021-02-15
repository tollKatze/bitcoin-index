public with sharing class GeminiAssetData implements IAssetData {

    public Long getStartTime(){
        return Long.valueof('123456789012');
    }
    
    public HttpResponse getAssetData(String pair, String timeInterval) {
        HttpResponse r = new HttpResponse();
        r.setStatusCode(200);
        return r;
    }

    public Map<Long, AssetCandleObject> parseAssetData(HttpResponse response) {
        return new Map<Long, AssetCandleObject>();
    }
}