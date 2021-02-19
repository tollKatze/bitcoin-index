public class AssetSync {


    public AssetSync(){}
    
    public List<Database.SaveResult> commitAssetData(Map<Long, AssetCandleObject> candleData, String pair, String exchange) {
        if( candleData == null ||candleData.isEmpty() ) {
            return new List<Database.SaveResult>();
        }
        
        String sObjectName = exchange + '_' + pair + '__c';
        Map<Long, SObject> newAssetData = new Map<Long, SObject>();

        for(Long candle : candleData.keySet()){
            sObject objectToCommit = Schema.getGlobalDescribe().get(sObjectName).newSObject() ;
            objectToCommit.clear();
            objectToCommit.put( 'unix_time__c', (Decimal) candleData.get(candle).unix_time );
            objectToCommit.put( 'date__c', candleData.get(candle).date_time );
            objectToCommit.put( 'open__c', candleData.get(candle).open );
            objectToCommit.put( 'high__c', candleData.get(candle).high );
            objectToCommit.put( 'low__c', candleData.get(candle).low );
            objectToCommit.put( 'close__c', candleData.get(candle).close );
            
            String stringUnixTime =  String.valueOf(candleData.get(candle).unix_time);

            newAssetData.put(
                Long.valueOf(stringUnixTime),
                objectToCommit
            );
        }
        List<Database.SaveResult> assetDataInsertionResult = new List<Database.SaveResult>();

        try {
            assetDataInsertionResult = Database.insert(newAssetData.values(), true);
            return assetDataInsertionResult;
        } catch (Exception  e) {
            System.debug('Error message: ' + e.getMessage());
            System.debug('Error stack: ' + e.getStackTraceString());
            return assetDataInsertionResult;
        }
    }
}   