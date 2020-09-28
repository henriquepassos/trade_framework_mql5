//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\SymbolInfo.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUtilBar
  {
protected:
   CSymbolInfo       *m_symbol;
   ENUM_TIMEFRAMES   m_period;

   datetime          m_datetime;
public:
                     CUtilBar(void);
                    ~CUtilBar(void);

   bool              Init(CSymbolInfo *symbol, ENUM_TIMEFRAMES period);

   bool              IsNewBar(void);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilBar::CUtilBar(void) :
   m_symbol(NULL),
   m_period(PERIOD_CURRENT),
   m_datetime(0)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilBar::~CUtilBar(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilBar::Init(CSymbolInfo *symbol, ENUM_TIMEFRAMES period)
  {
   m_symbol = symbol;
   m_period = period;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilBar::IsNewBar(void)
  {
   datetime lastBar = datetime(SeriesInfoInteger(m_symbol.Name(), m_period, SERIES_LASTBAR_DATE));
   if(m_datetime != lastBar && lastBar)
     {
      m_datetime = lastBar;
      return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+
