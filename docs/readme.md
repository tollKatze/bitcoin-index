
                         __    ___  __   __                    __   ___         __   __   __   __  
                        |__) |  |  /  ` /  \ | |\ |    | |\ | |  \ |__  \_/    |  \ /  \ /  ` /__` 
                        |__) |  |  \__, \__/ | | \|    | | \| |__/ |___ / \    |__/ \__/ \__, .__/ 
                                                                                                

# ERROR CODES

Please refer to Binance API docs for detailed 400 erors

|ERROR              |SEVERITY       |DESCRIPTION                                    |
|-------------------|---------------|-----------------------------------------------|
|DATA_SOURCE_101    |Warining       |API cluster callout failed with exception      |
|DATA_SOURCE_102    |Warining       |API cluster callout response other than 200    |       
|DATA_SOURCE_404    |Critical       |All available clusters failed.                 |
|DATA_INSERTION_404 |Critical       |



# TEST DATA

Binance payload ['binanceMockResponse.json'](force-app/main/default/staticresources/binanceMockResponse.json)


# TEST CASES
## BinanceAssetData.cls

**whenBinancePriceIsCorrectlyRequsted_checkData** When the asset price is correctly requested and 200 received  payload is parsed and verified

**whenBinancePriceIsNotCorrectlyRequsted_checkErrors** When price request is not correctly send verify error codes.

**whenStartTimeIsretrieved_checkForCorrectResult** When last time commited to database is requested check last time is returned.


## BtcPriceDataRandomClusterFailureTest.cls

**whenBinancePriceIsCorrectlyRequstedAndRandomClusterFails_checkData** When asset price is correctly requested verufy that single cluster failure is correctly handled.

*Important* This test implememnts a random expression to simulate failure in one or more of the cluster calls. Probablity of 3 cluster failure is 0.01 being the less probable of all outcomes but it may occur.

        if( failRandomNumber < 0.45 || failRandomNumber > 0.55 ) {
            resp.setStatusCode(200);
        } else {
            resp.setStatusCode(400);
        }