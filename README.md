mt4-unittest
===============

Description
-------------

This is a unit testing library for MetaTrader 4.

Requiremnts
-------------

MetaTrader 4, which supports MQL 5.

Installation
--------------

1. Copy [MQL4/Include/UnitTest.mqh](https://raw.github.com/micclly/mt4-unittest/master/MQL4/Include/UnitTest.mqh) to ``%APPDATA%/MetaQuotes/Terminal/<ID>/MQL4/Include``
1. See the following usage sample, or get it from [here](https://raw.github.com/micclly/mt4-unittest/master/MQL4/Samples/TestExpert.mq4).

Usage Sample
--------------

The code is same as [this](https://raw.github.com/micclly/mt4-unittest/master/MQL4/Samples/TestExpert.mq4). 

```cpp
#property strict

// This is must be false if release version
input bool paramUnitTesting = true;

input int paramMAPeriod = 13;

#include <UnitTest.mqh>

UnitTest* unittest;

int OnInit()
{
    if (paramUnitTesting) {
        unittest = new UnitTest();
    }

    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
    if (paramUnitTesting) {
        unittest.printSummary();
    }

    delete unittest;
}

void OnTick()
{
    if (paramUnitTesting) {
        runAllTests();
    }
}

double getMA(int shift)
{
    return (iMA(NULL, 0, paramMAPeriod, 0, MODE_SMA, PRICE_CLOSE, shift));
}

void getMAArray(const int& shifts[], double& mas[])
{
    for (int i = 0; i < ArraySize(shifts); i++) {
        mas[i] = getMA(shifts[i]);
    }
}

void runAllTests()
{
    testGetMA_shoudReturnSMA();
    testGetMAArray_shoudReturnCoupleOfSMA();
    testIsMAUp_shouldReturnTrue_MA0isLowerThanMA1();
}

void testGetMA_shoudReturnSMA()
{
    unittest.addTest(__FUNCTION__);

    const double actual = getMA(3);
    const double expected = iMA(NULL, 0, paramMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 3);

    unittest.assertEquals(__FUNCTION__, "MA must be SMA and 3 bars shifted", expected, actual);
}

void testGetMAArray_shoudReturnCoupleOfSMA()
{
    unittest.addTest(__FUNCTION__);

    const int shifts[] = {4, 5};
    double actual[2];
    getMAArray(shifts, actual);

    double expected[2];
    expected[0] = iMA(NULL, 0, paramMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 4);
    expected[1] = iMA(NULL, 0, paramMAPeriod, 0, MODE_SMA, PRICE_CLOSE, 5);

    unittest.assertEquals(__FUNCTION__, "MA array must contains a couple of SMA", expected, actual);
}
```
