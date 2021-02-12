@isTest
public class BtcPriceDataTest {

    static final String BTCUSDT = 'BTCUSDT';
    static final String oneMinute = '1m';

    @isTest
    private static void whenBinancePriceIsCorrectlyRequsted_checkData() {
        StaticResource BinancePayloadMock = 
            [
                SELECT Id, Body 
                FROM StaticResource 
                WHERE Name = 'binanceMockResponse' 
                LIMIT 1
            ];
        Blob bodyMock = BinancePayloadMock.Body;
        Map<String, String> mockHeaders  = new Map<String, String>();
        mockHeaders.put('Content-Type','application/json;charset=UTF-8');

        AssetDataMock mockBinance = new AssetDataMock(
                                                200,
                                                'OK',
                                                bodyMock,
                                                mockHeaders
                                            );
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockBinance);

        IAssetData binanceData = (IAssetData) di_Injector.Org.getInstance('Binance');
        HttpResponse result =   binanceData.getAssetData(
                                    BtcPriceDataTest.BTCUSDT, 
                                    BtcPriceDataTest.oneMinute
                                );
        String body = result.getBody();
        
        System.assertNotEquals(
            null,
            result,
            'The binance callout result is empty!');
        System.assertEquals(
            200,
            result.getStatusCode(),
            'The status code is not correct. A 200 code expected!');
        Test.testStop();
        
    }

    @isTest
    private static void whenBinancePriceIsNotCorrectlyRequsted_checkErrors() {
        
        Map<String, String> mockHeaders  = new Map<String, String>();
        mockHeaders.put('Content-Type','application/json;charset=UTF-8');

        AssetDataMock mockBinance = new AssetDataMock(
                                                400,
                                                'Bad request',
                                                '',
                                                mockHeaders
                                            );
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockBinance);
        
        IAssetData binanceData = (IAssetData) di_Injector.Org.getInstance('Binance');
        HttpResponse result = binanceData.getAssetData(
                                BtcPriceDataTest.BTCUSDT,
                                BtcPriceDataTest.oneMinute
                            );
        
        System.assertNotEquals(
            null,
            result,
            'The binance callout result is empty!');
        System.assertEquals(
            400,
            result.getStatusCode(),
            'The status code is not correct. A 400 code expected!');
        
    }

    @isTest
    private static void whenStartTimeIsretrieved_checkForCorrectParameter(){

        List<Binance_BTCUSDT__c> priceDataTest = new List<Binance_BTCUSDT__c>();

        Long baseTime = Long.valueof('1609462860'); //Friday, January 1, 2021 1:00:00 AM
        Long latestTime = baseTime + 60; //

        priceDataTest.add(
            new Binance_BTCUSDT__c(
                unix_time__c = baseTime,
                date__c = Datetime.newInstance(baseTime),
                open__c = 10000,
                high__c = 12000,
                low__c = 11000,
                close__c = 11500
            )
        );

        priceDataTest.add(
            new Binance_BTCUSDT__c(
                unix_time__c = latestTime,
                date__c = Datetime.newInstance(baseTime),
                open__c = 11000,
                high__c = 13000,
                low__c = 12000,
                close__c = 12500
            )
        );
        
        insert priceDataTest;

        Test.startTest();

        BinanceAssetData binanceData = new BinanceAssetData();
        Long startTime = binanceData.getStartTime();

        system.assertEquals(
            latestTime,
            startTime,
            'Retrived startTIme is not correct. Expecting ' + baseTime
        );

        Test.stopTest();

    }
        
    
}
