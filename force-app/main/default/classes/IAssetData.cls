public interface IAssetData {

    HttpResponse getAssetData(String pair);
    Map<String, AssetCandleObject> parseAssetData(HttpResponse dataResponse);

}