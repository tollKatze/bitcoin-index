@isTest
public class BtcPriceDataTest {

    @isTest
    private static void whenBinancePriceIsRequsted_checkData() {
        StaticResource BinancePayloadMock = 
            [
                SELECT Id, Body 
                FROM StaticResource 
                WHERE Name = 'binanceMockResponse' 
                LIMIT 1
            ];
        Blob bodyMock = BinancePayloadMock.Body;
        final String BTCUSDT = 'BTCUSDT';
        
        Map<String, String> mockHeaders  = new Map<String, String>();
        mockHeaders.put('Content-Type','application/json;charset=UTF-8');

        BinanceAssetMock mockBinance = new BinanceAssetMock(
                                                200,
                                                'OK',
                                                bodyMock,
                                                mockHeaders
                                            );
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockBinance);
        IAssetData binanceData = (IAssetData) di_Injector.Org.getInstance('Binance');
        HttpResponse result = binanceData.getAssetData(BTCUSDT);
        String body = result.getBody();
        system.debug(body);
        //Object[] response = (List<Object>) JSON.deserializeUntyped(body);
        
        
        System.assertNotEquals(
            null,
            result,
            'The binance callout result is empty!');
        System.assertEquals(
            200,
            result.getStatusCode(),
            'The status code is not correct. A 200 code expected!');
        
    }
}
