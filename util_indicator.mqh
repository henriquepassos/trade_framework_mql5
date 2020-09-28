//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\SymbolInfo.mqh>
#include <Indicators\Indicators.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUtilIndicator : public CObject
  {
protected:
   CSymbolInfo       *m_symbol;
   ENUM_TIMEFRAMES   m_period;

   CIndicators       m_indicators;

   CiADX             *m_adx;
   CiATR             *m_atr;
   CiBands           *m_bands;
   CiMA              *m_ma1;
   CiMA              *m_ma2;
   CiMACD            *m_macd;
   CiRSI             *m_rsi;
   CiSAR             *m_sar;
   CiStdDev          *m_std;
   CiStochastic      *m_stoch;
public:
   void              CUtilIndicator(void);
   void             ~CUtilIndicator(void);

   bool              Init(CSymbolInfo *symbol, ENUM_TIMEFRAMES period);

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
   double            StdDev_Main(int ind);
   double            Stoch_Main(int ind);
   double            Stoch_Signal(int ind);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilIndicator::CUtilIndicator(void) :
   m_symbol(NULL),
   m_period(PERIOD_CURRENT),
   m_adx(NULL),
   m_atr(NULL),
   m_bands(NULL),
   m_ma1(NULL),
   m_ma2(NULL),
   m_macd(NULL),
   m_rsi(NULL),
   m_sar(NULL),
   m_stoch(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilIndicator::~CUtilIndicator(void)
  {
   if(CheckPointer(m_adx) == POINTER_DYNAMIC)
      delete m_adx;
   if(CheckPointer(m_atr) == POINTER_DYNAMIC)
      delete m_atr;
   if(CheckPointer(m_bands) == POINTER_DYNAMIC)
      delete m_bands;
   if(CheckPointer(m_ma1) == POINTER_DYNAMIC)
      delete m_ma1;
   if(CheckPointer(m_ma2) == POINTER_DYNAMIC)
      delete m_ma2;
   if(CheckPointer(m_macd) == POINTER_DYNAMIC)
      delete m_macd;
   if(CheckPointer(m_rsi) == POINTER_DYNAMIC)
      delete m_rsi;
   if(CheckPointer(m_sar) == POINTER_DYNAMIC)
      delete m_sar;
   if(CheckPointer(m_std) == POINTER_DYNAMIC)
      delete m_std;
   if(CheckPointer(m_stoch) == POINTER_DYNAMIC)
      delete m_stoch;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::Init(CSymbolInfo *symbol, ENUM_TIMEFRAMES period)
  {
   m_symbol = symbol;
   m_period = period;
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::Refresh(void)
  {
   m_indicators.Refresh();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitADX(int ma_period)
  {
   if((m_adx = new CiADX) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_adx))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_adx.Create(m_symbol.Name(), m_period, ma_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitATR(int ma_period)
  {
   if((m_atr = new CiATR) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_atr))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_atr.Create(m_symbol.Name(), m_period, ma_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitBands(int ma_period, int ma_shift, double deviation, int applied)
  {
   if((m_bands = new CiBands) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_bands))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_bands.Create(m_symbol.Name(), m_period, ma_period, ma_shift, deviation, applied))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitMA1(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied)
  {
   if((m_ma1 = new CiMA) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_ma1))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_ma1.Create(m_symbol.Name(), m_period, ma_period, ma_shift, ma_method, applied))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitMA2(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied)
  {
   if((m_ma2 = new CiMA) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_ma2))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_ma2.Create(m_symbol.Name(), m_period, ma_period, ma_shift, ma_method, applied))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitMACD(int fast_ema_period, int slow_ema_period, int signal_period, int applied)
  {
   if((m_macd = new CiMACD) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_macd))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_macd.Create(m_symbol.Name(), m_period, fast_ema_period, slow_ema_period, signal_period, applied))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitRSI(int ma_period, int applied)
  {
   if((m_rsi = new CiRSI) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_rsi))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_rsi.Create(m_symbol.Name(), m_period, ma_period, applied))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitSAR(double step, double maximum)
  {
   if((m_sar = new CiSAR) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_sar))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_sar.Create(m_symbol.Name(), m_period, step, maximum))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitStdDev(int ma_period, int ma_shift, ENUM_MA_METHOD ma_method, int applied)
  {
   if((m_std = new CiStdDev) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_std))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_std.Create(m_symbol.Name(), m_period, ma_period, ma_shift, ma_method, applied))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilIndicator::InitStoch(int Kperiod, int Dperiod, int slowing, ENUM_MA_METHOD ma_method, ENUM_STO_PRICE price_field)
  {
   if((m_stoch = new CiStochastic) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_stoch))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_stoch.Create(m_symbol.Name(), m_period, Kperiod, Dperiod, slowing, ma_method, price_field))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::ADX_Main(int ind)
  {
   return(m_adx.Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::ADX_Plus(int ind)
  {
   return(m_adx.Plus(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::ADX_Minus(int ind)
  {
   return(m_adx.Minus(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::ATR_Main(int ind)
  {
   return(m_atr.Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::Bands_Base(int ind)
  {
   return(m_bands.Base(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::Bands_Upper(int ind)
  {
   return(m_bands.Upper(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::Bands_Lower(int ind)
  {
   return(m_bands.Lower(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::MA1_Main(int ind)
  {
   return(m_ma1.Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::MA2_Main(int ind)
  {
   return(m_ma2.Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::MACD_Main(int ind)
  {
   return(m_macd.Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::MACD_Signal(int ind)
  {
   return(m_macd.Signal(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::RSI_Main(int ind)
  {
   return(m_rsi.Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::SAR_Main(int ind)
  {
   return(m_sar.Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::StdDev_Main(int ind)
  {
   return(m_std.Main(ind));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::Stoch_Main(int ind)
  {
   return(m_stoch.Main(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilIndicator::Stoch_Signal(int ind)
  {
   return(m_stoch.Signal(ind));
  }
//+------------------------------------------------------------------+
