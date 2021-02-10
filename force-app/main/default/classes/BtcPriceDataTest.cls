@isTest
public class BtcPriceDataTest {

    @isTest
    private static void whenBinancePriceIsRequsted_checkData() {
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('binanceMockResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'text/plain;charset=UTF-8');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse result;// = BinanceBitcoinData.makeGetCallout();
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
