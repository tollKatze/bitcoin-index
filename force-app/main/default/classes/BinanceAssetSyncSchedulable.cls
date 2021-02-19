global class BinanceAssetSyncSchedulable implements Schedulable {
   
   global void execute(SchedulableContext sc) {
      String BTCUSDT = 'BTCUSDT';
      String BINANCE = 'Binance';
      AssetSync binanceSync = new AssetSync();

      IAssetData binanceAssetData = (IAssetData) di_Injector.Org.getInstance('Binance');
      HttpResponse binanceDataResponse = binanceAssetData.getAssetData(BTCUSDT, '1m');
      Map<Long, AssetCandleObject> binanceParsedData = 
         binanceAssetData.parseAssetData(binanceDataResponse);
      
      List<Database.SaveResult> assetSyncResult = 
         binanceSync.commitAssetData(
            binanceParsedData,
            BTCUSDT,
            BINANCE
         );
   }
}