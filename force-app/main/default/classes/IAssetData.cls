public interface IAssetData {

    HttpResponse getAssetData(String pair, String timeInterval);
    Map<String, AssetCandleObject> parseAssetData(HttpResponse dataResponse);

}