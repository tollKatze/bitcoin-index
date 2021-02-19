@isTest
public class AssetDataMockRandomClusterFailureTest {
    
    @isTest
    static void whenAssetDataMockRandomClusterFailureInstaceIscreated_verifyContructor(){
        String stringBody = '{a : "a"}';
        Blob blobBody = Blob.valueOf('');

        AssetDataMockRandomClusterFailure  mockOne = 
            new AssetDataMockRandomClusterFailure(
                200,
                'Ok',
                stringBody,
                new Map<String, String>()
            );

        AssetDataMockRandomClusterFailure  mockTwo = 
            new AssetDataMockRandomClusterFailure(
                200,
                'Ok',
                blobBody,
                new Map<String, String>()
            );

        Test.startTest();
        
        HTTPResponse respOne = mockOne.respond(new HTTPRequest());
        HTTPResponse respTwo = mockTwo.respond(new HTTPRequest());

        System.assertEquals(
            respOne.getBody(),
            stringBody,
            'Wrong body format'
        );

        System.assertEquals(
            respTwo.getBody(),
            '',
            'Wrong body format'
        );

        Test.stopTest();
    }
}
