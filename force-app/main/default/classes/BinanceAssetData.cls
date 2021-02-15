public with sharing class BinanceAssetData implements IAssetData {

    public class DataSourceRequestException extends Exception {}

    public Map<Long, AssetCandleObject> parseAssetData(HttpResponse response) {
        
        Map<Long, AssetCandleObject> binanceParsedData = new Map<Long, AssetCandleObject>();
        String body = response.getBody();
        List<Object> binancePayloadList =
            (List<Object>) System.JSON.deserializeUntyped(body);

        for(Object candle : binancePayloadList){

            String cleanString = (String.valueOf(candle)).remove('(');
            cleanString = cleanString.remove(')');
            List<String> theList  = cleanString.split(',');
            AssetCandleObject newCandle = new AssetCandleObject();

            newCandle.unix_time = Long.valueOf(theList[0]);
            newCandle.date_time = Datetime.newInstance( Long.valueOf(theList[0]) );
            newCandle.open = Double.valueOf(theList[1]);
            newCandle.high = Double.valueOf(theList[2]);
            newCandle.low = Double.valueOf(theList[3]);
            newCandle.close = Double.valueOf(theList[4]);

            binanceParsedData.put(
                Long.valueOf(theList[0]),
                newCandle
            );
        }
        return binanceParsedData;
    }

    public Long getStartTime(){

        List<AggregateResult> startTime = 
            [ SELECT MAX(unix_time__c) start FROM Binance_BTCUSDT__c ];
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
            '?symbol=' + pair +'&interval=' + timeInterval + 
            '&startTime=' + String.valueOf(this.getStartTime());

        for(String ep : availableClusters){
            request.setEndpoint(ep + endpointPath);
            try {
                response = http.send(request);
                if(response.getStatusCode() != 200){
                    failCount++;
                    system.debug(
                        'WARNING DATA_SOURCE_101: ' + ep + endpointPath + 
                        ' returned ' + response.getStatusCode()
                    );
                } 
            } catch (Exception e) {
                failCount++;
                errorList.add(e);
                system.debug(
                    'WARNING DATA_SOURCE_101: ' +
                    ep + ' call failed with message ' + e.getMessage()
                );
            }
        }
        if(failCount >= availableClusters.size()){
            system.debug('ERROR DATA_SOURCE_404: ' + String.valueof(errorList));
            throw new DataSourceRequestException(
                'ERROR DATA_SOURCE_404: All Binance available API clusters fail on data request!'
            );
        }else{
            return response;
        }
    }

    
}