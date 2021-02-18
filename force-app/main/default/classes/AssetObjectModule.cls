public with sharing class AssetObjectModule extends di_Module{
    
    public override void configure() {
        bind('Binance_BTCUSDT__c').to(Binance_BTCUSDT__c.class);
        bind('Bitstamp_BTCUSD__c').to(Bitstamp_BTCUSD__c.class);
        bind('Gemini_BTCUSD__c').to(Gemini_BTCUSD__c.class);
        bind('Kraken_BTCUSD__c').to(Kraken_BTCUSD__c.class);
    }
}