/* -*- coding: utf-8 -*-
 *
 * This indicator is licensed under GNU GENERAL PUBLIC LICENSE Version 3.
 * See a LICENSE file for detail of the license.
 */

#property copyright "Copyright 2014, micclly."
#property link      "https://github.com/micclly"
#property version   "1.00"
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
