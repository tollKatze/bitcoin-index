public with sharing class BitstampAssetData implements IAssetData {
    
    public HttpResponse getAssetData(String pair, String timeInterval) {
        return new HttpResponse();
    }

    public Map<String, AssetCandleObject> parseAssetData(HttpResponse response) {
        return new Map<String, AssetCandleObject>();
    }
}
