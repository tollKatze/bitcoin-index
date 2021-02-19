@IsTest
public class BinanceAssetSyncSchedulableTest {
    
    public static String  CRON_EXP = '20 30 8 10 2 ?';

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

    @IsTest
    static void whenBinanceAssetIsScheduled_checkForCorrectCompletion(){
        
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

        BinanceAssetSyncSchedulable binanceDataSchedule = new BinanceAssetSyncSchedulable(); 

        Test.startTest();

        String jobId = System.schedule(
            'Get BTCUSDT Binance data ' + String.valueOf(Datetime.now()),
            CRON_EXP,
            binanceDataSchedule
        );

        List<Binance_BTCUSDT__c> candleData = [SELECT id FROM Binance_BTCUSDT__c];


        System.assertEquals(
            2,
            candleData.size(), 
            'Tasks exist before job has run'
        );

        Test.stopTest();
    }
}
