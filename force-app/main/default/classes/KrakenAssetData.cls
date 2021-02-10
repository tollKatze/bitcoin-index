public with sharing class KrakenAssetData implements IAssetData {
    
    public HttpResponse getAssetData(String pair) {
        return new HttpResponse();
    }

    public Map<String, AssetCandleObject> parseAssetData(HttpResponse response) {
        return new Map<String, AssetCandleObject>();
    }
}
