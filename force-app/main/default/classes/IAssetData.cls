public interface IAssetData {
    Long getStartTime();
    HttpResponse getAssetData(String pair, String timeInterval);
    Map<Long, AssetCandleObject> parseAssetData(HttpResponse dataResponse);

}