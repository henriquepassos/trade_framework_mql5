//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\Trade.mqh>
#include <Indicators\Indicators.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM_STATE
  {
   STATE_NONE = 1,
   STATE_BUY = 2,
   STATE_SELL = 3
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUtilBuySell : public CObject
  {
protected:
   CSymbolInfo       *m_symbol;
   ENUM_TIMEFRAMES   m_period;
   ulong             m_magic;
   CPositionInfo     *m_position;
   CTrade            *m_trade;
public:
   void              CUtilBuySell(void);
   void             ~CUtilBuySell(void);

   bool              Init(CSymbolInfo *symbol, ENUM_TIMEFRAMES period, ulong magic, CPositionInfo *position, CTrade *trade);

   ENUM_STATE        Position(void);
   bool              Buy(double volume, double sl, double tp);
   bool              Sell(double volume, double sl, double tp);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilBuySell::CUtilBuySell(void) :
   m_symbol(NULL),
   m_period(PERIOD_CURRENT),
   m_magic(0),
   m_position(NULL),
   m_trade(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilBuySell::~CUtilBuySell(void)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilBuySell::Init(CSymbolInfo *symbol, ENUM_TIMEFRAMES period, ulong magic, CPositionInfo *position, CTrade *trade)
  {
   m_symbol = symbol;
   m_period = period;
   m_magic = magic;
   m_position = position;
   m_trade = trade;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_STATE CUtilBuySell::Position(void)
  {
   if(m_position.SelectByMagic(m_symbol.Name(), m_magic))
     {
      if(m_position.PositionType() == POSITION_TYPE_BUY)
        {
         return(STATE_BUY);
        }
      if(m_position.PositionType() == POSITION_TYPE_SELL)
        {
         return(STATE_SELL);
        }
     }
   return(STATE_NONE);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilBuySell::Buy(double volume, double sl, double tp)
  {
   bool res = m_trade.Buy(volume, m_symbol.Name(), m_symbol.Ask(), sl, tp);
   if(res)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": buy success. code=", m_trade.ResultRetcode(), ",description=", m_trade.ResultRetcodeDescription());
     }
   else
     {
      Print(__FILE__, " - ", __FUNCTION__, ": buy failure. code=", m_trade.ResultRetcode(), ",description=", m_trade.ResultRetcodeDescription());
     }
   return(res);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilBuySell::Sell(double volume, double sl, double tp)
  {
   bool res = m_trade.Sell(volume, m_symbol.Name(), m_symbol.Bid(), sl, tp);
   if(res)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": sell success. code=", m_trade.ResultRetcode(), ",description=", m_trade.ResultRetcodeDescription());
     }
   else
     {
      Print(__FILE__, " - ", __FUNCTION__, ": sell failure. code=", m_trade.ResultRetcode(), ",description=", m_trade.ResultRetcodeDescription());
     }
   return(res);
  }
//+------------------------------------------------------------------+
