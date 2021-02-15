@isTest
public class BtcPriceDataTest {

    @TestSetup
    static void makeData(){
        List<Binance_BTCUSDT__c> priceDataTest = new List<Binance_BTCUSDT__c>();

        Long baseTime = Long.valueof('1609462800000'); //Friday, January 1, 2021 1:00:00 AM
        Long latestTime = baseTime + 60000; //One minute more

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
    }

    @isTest
    private static void whenBinancePriceIsCorrectlyRequsted_checkData() {

        String BTCUSDT = 'BTCUSDT';
        String ONE_MINUTE = '1m';
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
        
        Map<Long, AssetCandleObject> assertionData = new Map<Long, AssetCandleObject>();                          
        
        AssetCandleObject candleOne =  new AssetCandleObject();
        candleOne.unix_time = Long.valueOf('1612897440000');
        candleOne.date_time = Datetime.newInstance(Long.valueOf('1612897440000'));
        candleOne.open = 47121.32;
        candleOne.high = 47175.65;
        candleOne.low = 47101.69;
        candleOne.close = 47125.27;
        
        assertionData.put(
            Long.valueOf('1612897440000'),
            candleOne
        );
        AssetCandleObject candleTwo = new AssetCandleObject();
        candleTwo.unix_time = Long.valueOf('1612897500000');
        candleTwo.date_time = Datetime.newInstance(Long.valueOf('1612897500000'));
        candleTwo.open = 47125.27;
        candleTwo.high = 47158.16;
        candleTwo.low = 47110.59;
        candleTwo.close = 47110.60;

        assertionData.put(
            Long.valueOf('1612897500000'),
            candleTwo
        );

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockBinance);

        IAssetData binanceData = (IAssetData) di_Injector.Org.getInstance('Binance');
        HttpResponse result =   binanceData.getAssetData( BTCUSDT, ONE_MINUTE );
        
        Map<Long, AssetCandleObject> parsedBinanceData =  binanceData.parseAssetData(result);
        
        AssetCandleObject assertionCandleOne = assertionData.get(
            Long.valueOf('1612897440000')
        );
        AssetCandleObject actualCandleOne = parsedBinanceData.get(
            Long.valueOf('1612897440000')
        );
        system.debug('Expected: ' + assertionCandleOne);
        System.debug('Actual : ' + actualCandleOne);
        System.assert(
            (
                (assertionCandleOne.unix_time == actualCandleOne.unix_time) &&
                (assertionCandleOne.date_time == actualCandleOne.date_time) &&
                (assertionCandleOne.open == actualCandleOne.open) &&
                (assertionCandleOne.high == actualCandleOne.high) &&
                (assertionCandleOne.low == actualCandleOne.low) &&
                (assertionCandleOne.close == actualCandleOne.close)
            ),
            'Assertion failed Payload transformation incorrect!'
        );

        System.assertNotEquals(
            null,
            result,
            'The binance callout result is empty!');
        System.assertEquals(
            200,
            result.getStatusCode(),
            'The status code is not correct. A 200 code expected!');
        
        Test.stopTest();
        
    }

    @isTest
    private static void whenBinancePriceIsNotCorrectlyRequsted_checkErrors() {
        String BTCUSDT = 'BTCUSDT';
        String ONE_MINUTE = '1m';
        Map<String, String> mockHeaders  = new Map<String, String>();
        mockHeaders.put('Content-Type','application/json;charset=UTF-8');

        AssetDataMock mockBinance = new AssetDataMock(
                                                400,
                                                'Bad request',
                                                '',
                                                mockHeaders
                                            );
        IAssetData binanceData = (IAssetData) di_Injector.Org.getInstance('Binance');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mockBinance);
        String errorMessage;
        HttpResponse result = new HttpResponse();
        try {
            result = binanceData.getAssetData( BTCUSDT, ONE_MINUTE );
        } catch (BinanceAssetData.DataSourceRequestException e) {
            errorMessage = e.getMessage();
        }
        system.assert(
            errorMessage.contains(
                'ERROR DATA_SOURCE_404: All Binance available API clusters fail on data request!'
            ),
            'Error is not the expected'
        );
        
        System.assertEquals(
            0,
            result.getStatusCode(),
            'The status code is not correct. A 400 code expected!');
        Test.stopTest();
        
    }

    @isTest
    private static void whenStartTimeIsretrieved_checkForCorrectResult(){
        Long latestTime = Long.valueof('1609462860000'); //Friday, January 1, 2021 1:10:00 AM
        IAssetData binanceData = (IAssetData) di_Injector.Org.getInstance('Binance');
        
        Test.startTest();
        Long startTime = binanceData.getStartTime();

        system.assertEquals(
            latestTime,
            startTime,
            'Retrived startTIme is not correct. Expecting ' + latestTime
        );
        Test.stopTest();
    }

    @isTest
    private static void whenCalloutIsSuccessful_verifyPayloadHandling(){
        

    }
        
    
}