@isTest
public class AssetCandleObjectTest {
    
    @isTest
    static void whenAssetCandleObjectInstanceIsCreated_verifyConstructor(){
        Long unixTime = Long.valueof('1609462800000');
        AssetCandleObject candle = 
            new AssetCandleObject(
                unixTime, //Friday, January 1, 2021 1:00:00 AM
                Datetime.newInstance(unixTime),
                10000,
                11000,
                9500,
                10500
            );
        
    }
}
