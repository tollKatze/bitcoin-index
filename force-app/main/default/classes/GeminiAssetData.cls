public with sharing class GeminiAssetData implements IAssetData {
    
    public HttpResponse getAssetData(String pair) {
        HttpResponse r = new HttpResponse();
        r.setStatusCode(200);
        return r;
    }

    public Map<String, AssetCandleObject> parseAssetData(HttpResponse response) {
        return new Map<String, AssetCandleObject>();
    }
}
