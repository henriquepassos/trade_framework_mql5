//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2020, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#include "strat_123.mqh"

input group "Trade setup"
sinput ulong MagicNumber = 897123409127834;        // Expert magic number
sinput ulong DeviationInPoints = 10;               // Deviation in points
input double TradeVolume = 5.0;                    // Volume

CStrat123 m_ct;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!m_ct.Init(_Symbol, _Period, MagicNumber, TradeVolume))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": unable to init context");
      return(INIT_FAILED);
     }

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   m_ct.Exec();
  }
//+------------------------------------------------------------------+
