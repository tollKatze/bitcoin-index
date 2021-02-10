public with sharing class KrakenAssetData implements IAssetData {
    
    public String getAssetData() {
        return 'true';
    }

    public Map<String, AssetCandleObject> parseAssetData() {
        return new Map<String, AssetCandleObject>();
    }
}
