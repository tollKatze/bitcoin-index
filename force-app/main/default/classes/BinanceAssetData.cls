public with sharing class BinanceAssetData implements IAssetData {

    public class DataSourceRequestException extends Exception {}

    public Map<String, AssetCandleObject> parseAssetData(HttpResponse response) {
        return new Map<String, AssetCandleObject>();
    }

    public Long getStartTime(){
        List<AggregateResult> startTime = [ SELECT MAX(unix_time__c) start FROM Binance_BTCUSDT__c ];
        String decimalString = String.valueOf(startTime[0].get('start'));
        return Long.valueOf(decimalString);
    }

    
    public HttpResponse getAssetData(String pair, String timeInterval) {

        AssetDataSources__mdt binanceSettings = 
            [
                SELECT Id, DeveloperName, Endpoint__c, Cluster1__c, Cluster2__c 
                FROM AssetDataSources__mdt
                WHERE DeveloperName = 'Binance'
            ];
        List<String> availableClusters = new List<String>();
        availableClusters.add(binanceSettings.Endpoint__c);
        if(binanceSettings.Cluster1__c != null) availableClusters.add(binanceSettings.Cluster1__c);
        if(binanceSettings.Cluster2__c != null) availableClusters.add(binanceSettings.Cluster2__c);

        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        Http http = new Http();
        List<Exception> errorList = new List<Exception>();
        request.setMethod('GET');
        Integer failCount = 0;
        String endpointPath = 
            '?symbol=' + pair +
            '&interval=1m';
            

        for(String ep : availableClusters){
            request.setEndpoint(ep);
            try {
                response = http.send(request);
            } catch (Exception e) {
                failCount++;
                errorList.add(e);
                system.debug(
                    'WARNING DATA_SOURCE_101: ' +
                    ep + ' call failed with message ' + e.getMessage()
                );
            }
        }
        if(failCount == availableClusters.size()){
            system.debug('ERROR DATA_SOURCE_404: ' + String.valueof(errorList));
            throw new DataSourceRequestException(
                'ERROR DATA_SOURCE_404: All Binance available API clusters fail on data request!'
            );
        }else{
            return response;
        }
    }

    
}
