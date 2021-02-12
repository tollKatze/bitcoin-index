public with sharing class AssetDataModule extends di_Module{
    

    public override void configure() {
        bind('Binance').to(BinanceAssetData.class);
        bind('Bitstamp').to(BitstampAssetData.class);
        bind('Gemini').to(GeminiAssetData.class);
        bind('Kraken').to(KrakenAssetData.class);
    }
}