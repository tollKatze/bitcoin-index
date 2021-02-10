public interface IAssetData {

    String getAssetData();
    Map<String, AssetCandleObject> parseAssetData();

}