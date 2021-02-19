@isTest
public class AssetSyncTest {

    @isTest
    static void whenDataWasCorrectlyParsed_checkForCorrectInsertion(){
        String BINANCE = 'Binance';
        String BTCUSDT = 'BTCUSDT';
        Long baseTime = Long.valueof('1609462800000'); //Friday, January 1, 2021 1:00:00 AM
        Long latestTime = Long.valueof('1609462860000'); //One minute more
        Map<Long, AssetCandleObject> parsedData = new Map<Long, AssetCandleObject>();
        AssetCandleObject candleOne = new AssetCandleObject();
        AssetCandleObject candleTwo = new AssetCandleObject();
        
        candleOne.unix_time = baseTime;
        candleOne.date_time = Datetime.newInstance(baseTime);
        candleOne.open = 10000;
        candleOne.high = 12000;
        candleOne.low = 11000;
        candleOne.close = 11500;

        parsedData.put(
            candleOne.unix_time,
            candleOne
        );

        candleTwo.unix_time = latestTime;
        candleTwo.date_time = Datetime.newInstance(latestTime);
        candleTwo.open = 11000;
        candleTwo.high = 13000;
        candleTwo.low = 12000;
        candleTwo.close = 12500;

        parsedData.put(
            candleTwo.unix_time,
            candleTwo
        );
        
        System.debug(parsedData);

        AssetSync assetSync = new AssetSync();
        List<Database.SaveResult> result = assetSync.commitAssetData(
            parsedData,
            BTCUSDT,
            BINANCE
        );

        Test.startTest();

        System.assert(
            result[0].isSuccess(),
            'Asset data insertion failed'
        );

        System.assert(
            result[1].isSuccess(),
            'Asset data insertion failed'
        );

        System.assertEquals(
            2,
            result.size(),
            'A wrong ammount of rows was inserted expecting 1'
        );

        Test.stopTest();
      
    } 

    @isTest
    static void whenDataContainsDuplicates_checkForCorrectInsertion(){
        String BINANCE = 'Binance';
        String BTCUSDT = 'BTCUSDT';
        Long baseTime = Long.valueof('1609462800000'); //Friday, January 1, 2021 1:00:00 AM
        Long latestTime = Long.valueof('1609462860000'); //One minute more
        Map<Long, AssetCandleObject> parsedData = new Map<Long, AssetCandleObject>();
        AssetCandleObject candleOne = new AssetCandleObject();
        AssetCandleObject candleTwo = new AssetCandleObject();
        
        candleOne.unix_time = baseTime;
        candleOne.date_time = Datetime.newInstance(baseTime);
        candleOne.open = 10000;
        candleOne.high = 12000;
        candleOne.low = 11000;
        candleOne.close = 11500;

        parsedData.put(
            candleOne.unix_time,
            candleOne
        );

        candleTwo.unix_time = baseTime;
        candleTwo.date_time = Datetime.newInstance(baseTime);
        candleTwo.open = 10000;
        candleTwo.high = 12000;
        candleTwo.low = 11000;
        candleTwo.close = 11500;

        parsedData.put(
            candleTwo.unix_time,
            candleTwo
        );

        AssetSync assetSync = new AssetSync();
        List<Database.SaveResult> result = assetSync.commitAssetData(
                                                parsedData,
                                                BTCUSDT,
                                                BINANCE
                                           );

        Test.startTest();

        
        System.assert(
            result[0].isSuccess(),
            'Asset data insertion failed'
        );

        System.assertEquals(
            1,
            result.size(),
            'A wrong ammount of rows was inserted expecting 1'
        );
        
        
        Test.stopTest();
      
    } 

    @isTest
    static void whenNoDataPassed_checkForNoInsertion(){
        String BINANCE = 'Binance';
        String BTCUSDT = 'BTCUSDT';
        

        AssetSync assetSync = new AssetSync();
        List<Database.SaveResult> result = 
            assetSync.commitAssetData(
                new Map<Long, AssetCandleObject>(),
                BTCUSDT,
                BINANCE
            );

        Test.startTest();

        System.assertEquals(
            0,
            result.size(),
            'A wrong ammount of rows was inserted expecting 1'
        );
        
        Test.stopTest();
      
    }
}