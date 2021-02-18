public class AssetSync {


    public AssetSync(){}
    
    public Boolean commitAssetData(Map<Long, AssetCandleObject> candleData, String pair, String exchange) {
        
        String sObjectName = exchange + '_' + pair + '__c';
        Map<Long, SObject> newAssetData = new Map<Long, SObject>();

        for(Long candle : candleData.keySet()){
            
            Binance_BTCUSDT__c objectToCommit = new Binance_BTCUSDT__c();
            objectToCommit.clear();
            objectToCommit.put( 'unix_time__c', (Decimal) candleData.get(candle).unix_time );
            objectToCommit.put( 'date__c', candleData.get(candle).date_time );
            objectToCommit.put( 'open__c', candleData.get(candle).open );
            objectToCommit.put( 'high__c', candleData.get(candle).high );
            objectToCommit.put( 'low__c', candleData.get(candle).low );
            objectToCommit.put( 'close__c', candleData.get(candle).close );
            
            System.debug('object to commit: ' + objectToCommit);
            
            String stringUnixTime =  String.valueOf(candleData.get(candle).unix_time);

            newAssetData.put(
                Long.valueOf(stringUnixTime),
                objectToCommit
            );
        }
        
        System.debug('Map of objects to commit: ' + newAssetData);
        try {
            Database.SaveResult[] assetDataInsertionResult = Database.insert(newAssetData.values(), true);
            return true;
        } catch (Exception  e) {
            System.debug('e.getMessage(): ' + e.getMessage());
            System.debug('e.getStackTraceString(): ' + e.getStackTraceString());
            return false;
        }
    }
}   