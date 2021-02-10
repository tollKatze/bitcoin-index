@isTest
public class BtcPriceDataTest {

    @isTest
    private static void whenBinancePriceIsRequsted_checkData() {
        final String BTCUSDT = 'BTCUSDT';
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('binanceMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/plain;charset=UTF-8');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        IAssetData binanceData = (IAssetData) di_Injector.Org.getInstance('Binance');

        HttpResponse result = binanceData.getAssetData(BTCUSDT);
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
