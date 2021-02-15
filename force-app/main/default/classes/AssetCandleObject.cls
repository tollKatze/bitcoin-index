public with sharing class AssetCandleObject {
    
    public Long unix_time;
    public Datetime date_time;
    public Double open;
    public Double high;
    public Double low;
    public Double close;
    
    public AssetCandleObject(){}
    public AssetCandleObject (
        Long ut,
        Datetime dt,
        Double Op,
        Double Hi,
        Double Lo,
        Double Cl
    ) {
        unix_time = ut;
        date_time = dt;
        open = Op;
        high = Hi;
        low =  Lo;
        close = Cl;
    }
}