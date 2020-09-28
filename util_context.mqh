//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\AccountInfo.mqh>
#include <Trade\DealInfo.mqh>
#include <Trade\HistoryOrderInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\Trade.mqh>
#include <Indicators\Indicators.mqh>

#include "util_bar.mqh"
#include "util_buysell.mqh"
#include "util_indicator.mqh"
#include "util_price.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUtilContext : public CObject
  {
protected:
   ENUM_TIMEFRAMES   m_period;
   ulong             m_magic;
   ulong             m_deviation;
   double            m_adjusted_point;

   CAccountInfo      *m_account;
   CDealInfo         *m_deal;
   COrderInfo        *m_order;
   CPositionInfo     *m_position;
   CSymbolInfo       *m_symbol;
   CTrade            *m_trade;

   CUtilBar          m_bar;
   CUtilBuySell      m_buysell;
   CUtilIndicator    m_indicator;
   CUtilPrice        m_price;
public:
   void              CUtilContext(void);
   void             ~CUtilContext(void);

   bool              Init(string symbol, ENUM_TIMEFRAMES period, ulong magic);

   bool              Refresh(void);

   bool              InitADX(int ma_period);
   bool              InitATR(int ma_period);
   bool              InitBands(int ma_period, int ma_shift, double deviation, int applied);
   bool              InitMA1(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied);
   bool              InitMA2(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied);
   bool              InitMACD(int fast_ema_period, int slow_ema_period, int signal_period, int applied);
   bool              InitRSI(int ma_period, int applied);
   bool              InitSAR(double step, double maximum);
   bool              InitStdDev(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied);
   bool              InitStoch(int Kperiod, int Dperiod, int slowing, ENUM_MA_METHOD ma_method, ENUM_STO_PRICE price_field);

   ENUM_STATE        Position(void);
   bool              Buy(double volume, double sl, double tp);
   bool              Sell(double volume, double sl, double tp);

   bool              IsNewBar(void);

   double            Ask(void);
   double            Bid(void);

   double            Open(int ind);
   double            High(int ind);
   double            Low(int ind);
   double            Close(int ind);
   int               Spread(int ind);
   datetime          Time(int ind);
   long              TickVolume(int ind);
   long              RealVolume(int ind);

   double            AvgOpen(int ind);
   double            AvgHigh(int ind);
   double            AvgLow(int ind);
   double            AvgClose(int ind);
   long              AvgTickVolume(int ind);
   long              AvgRealVolume(int ind);

   double            ADX_Main(int ind);
   double            ADX_Plus(int ind);
   double            ADX_Minus(int ind);
   double            ATR_Main(int ind);
   double            Bands_Base(int ind);
   double            Bands_Upper(int ind);
   double            Bands_Lower(int ind);
   double            MA1_Main(int ind);
   double            MA2_Main(int ind);
   double            MACD_Main(int ind);
   double            MACD_Signal(int ind);
   double            RSI_Main(int ind);
   double            SAR_Main(int ind);
   double            Stoch_Main(int ind);
   double            Stoch_Signal(int ind);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilContext::CUtilContext(void) :
   m_period(PERIOD_CURRENT),
   m_magic(0),
   m_deviation(0),
   m_adjusted_point(0),
   m_account(NULL),
   m_deal(NULL),
   m_order(NULL),
   m_position(NULL),
   m_symbol(NULL),
   m_trade(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilContext::~CUtilContext(void)
  {
   if(m_account != NULL)
     {
      delete m_account;
      m_account = NULL;
     }
   if(m_deal != NULL)
     {
      delete m_deal;
      m_deal = NULL;
     }
   if(m_order != NULL)
     {
      delete m_order;
      m_order = NULL;
     }
   if(m_position != NULL)
     {
      delete m_position;
      m_position = NULL;
     }
   if(m_symbol != NULL)
     {
      delete m_symbol;
      m_symbol = NULL;
     }
   if(m_trade != NULL)
     {
      delete m_trade;
      m_trade = NULL;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::Init(string symbol, ENUM_TIMEFRAMES period, ulong magic)
  {
//---
   if(symbol != ::Symbol() || period != ::Period())
     {
      Print(__FILE__, " - ", __FUNCTION__, ": wrong symbol or timeframe");
      return(false);
     }
   if((m_symbol = new CSymbolInfo) == NULL)
     {
      return(false);
     }
   if(!m_symbol.Name(symbol))
     {
      return(false);
     }
//---
   m_period = period;
   m_magic = magic;
   int digits_adjust = (m_symbol.Digits() == 3 || m_symbol.Digits() == 5) ? 10 : 1;
   m_adjusted_point = m_symbol.Point() * digits_adjust;
   m_deviation = (ulong)(3 * m_adjusted_point / m_symbol.Point());
//---
   if((m_trade = new CTrade) == NULL)
     {
      return(false);
     }
   m_trade.SetExpertMagicNumber(magic);
   m_trade.SetMarginMode();
   m_trade.SetDeviationInPoints(m_deviation);
//---
   if((m_account = new CAccountInfo) == NULL)
     {
      return(false);
     }
   if((m_deal = new CDealInfo) == NULL)
     {
      return(false);
     }
   if((m_order = new COrderInfo) == NULL)
     {
      return(false);
     }
   if((m_position = new CPositionInfo) == NULL)
     {
      return(false);
     }
//---
   if(!(m_account.TradeAllowed() && m_account.TradeExpert() && m_symbol.IsSynchronized() && Bars(m_symbol.Name(), m_period) >= 20))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": unable to trade");
      return(false);
     }
//---
   if(!m_bar.Init(m_symbol, m_period))
     {
      return(false);
     }
   if(!m_buysell.Init(m_symbol, m_period, m_magic, m_position, m_trade))
     {
      return(false);
     }
   if(!m_indicator.Init(m_symbol, m_period))
     {
      return(false);
     }
   if(!m_price.Init(m_symbol, m_period))
     {
      return(false);
     }
//---
   if(!Refresh())
     {
      Print(__FILE__, " - ", __FUNCTION__, ": unable to refresh rates");
      return(false);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::Refresh(void)
  {
   if(!(m_symbol.RefreshRates() && m_symbol.Ask() != 0 && m_symbol.Bid() != 0))
     {
      return(false);
     }
   if(!m_indicator.Refresh())
     {
      return(false);
     }
   if(!m_price.Refresh())
     {
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitADX(int ma_period)
  {
   return(m_indicator.InitADX(ma_period));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitATR(int ma_period)
  {
   return(m_indicator.InitATR(ma_period));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitBands(int ma_period, int ma_shift, double deviation, int applied)
  {
   return(m_indicator.InitBands(ma_period, ma_shift, deviation, applied));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitMA1(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied)
  {
   return(m_indicator.InitMA1(ma_period, ma_shift, ma_method, applied));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitMA2(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied)
  {
   return(m_indicator.InitMA2(ma_period, ma_shift, ma_method, applied));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitMACD(int fast_ema_period, int slow_ema_period, int signal_period, int applied)
  {
   return(m_indicator.InitMACD(fast_ema_period, slow_ema_period, signal_period, applied));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitRSI(int ma_period, int applied)
  {
   return(m_indicator.InitRSI(ma_period, applied));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitSAR(double step, double maximum)
  {
   return(m_indicator.InitSAR(step, maximum));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitStdDev(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied)
  {
   return(m_indicator.InitStdDev(ma_period, ma_shift, ma_method, applied));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::InitStoch(int Kperiod, int Dperiod, int slowing, ENUM_MA_METHOD ma_method, ENUM_STO_PRICE price_field)
  {
   return(m_indicator.InitStoch(Kperiod, Dperiod, slowing, ma_method, price_field));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_STATE CUtilContext::Position(void)
  {
   return(m_buysell.Position());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::Buy(double volume, double sl, double tp)
  {
   return(m_buysell.Buy(volume, sl, tp));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::Sell(double volume, double sl, double tp)
  {
   return(m_buysell.Sell(volume, sl, tp));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilContext::IsNewBar(void)
  {
   return(m_bar.IsNewBar());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Ask(void)
  {
   return(m_symbol.Ask());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Bid(void)
  {
   return(m_symbol.Bid());
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Open(int ind)
  {
   return(m_price.Open(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::High(int ind)
  {
   return(m_price.High(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Low(int ind)
  {
   return(m_price.Low(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Close(int ind)
  {
   return(m_price.Close(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CUtilContext::Spread(int ind)
  {
   return(m_price.Spread(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime CUtilContext::Time(int ind)
  {
   return(m_price.Time(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CUtilContext::TickVolume(int ind)
  {
   return(m_price.TickVolume(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CUtilContext::RealVolume(int ind)
  {
   return(m_price.RealVolume(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::AvgOpen(int ind)
  {
   return(m_price.AvgOpen(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::AvgHigh(int ind)
  {
   return(m_price.AvgHigh(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::AvgLow(int ind)
  {
   return(m_price.AvgLow(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::AvgClose(int ind)
  {
   return(m_price.AvgClose(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CUtilContext::AvgTickVolume(int ind)
  {
   return(m_price.AvgTickVolume(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CUtilContext::AvgRealVolume(int ind)
  {
   return(m_price.AvgRealVolume(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::ADX_Main(int ind)
  {
   return(m_indicator.ADX_Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::ADX_Plus(int ind)
  {
   return(m_indicator.ADX_Plus(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::ADX_Minus(int ind)
  {
   return(m_indicator.ADX_Minus(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::ATR_Main(int ind)
  {
   return(m_indicator.ATR_Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Bands_Base(int ind)
  {
   return(m_indicator.Bands_Base(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Bands_Upper(int ind)
  {
   return(m_indicator.Bands_Upper(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Bands_Lower(int ind)
  {
   return(m_indicator.Bands_Lower(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::MA1_Main(int ind)
  {
   return(m_indicator.MA1_Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::MA2_Main(int ind)
  {
   return(m_indicator.MA2_Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::MACD_Main(int ind)
  {
   return(m_indicator.MACD_Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::MACD_Signal(int ind)
  {
   return(m_indicator.MACD_Signal(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::RSI_Main(int ind)
  {
   return(m_indicator.RSI_Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::SAR_Main(int ind)
  {
   return(m_indicator.SAR_Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Stoch_Main(int ind)
  {
   return(m_indicator.Stoch_Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilContext::Stoch_Signal(int ind)
  {
   return(m_indicator.Stoch_Signal(ind));
  }
//+------------------------------------------------------------------+
