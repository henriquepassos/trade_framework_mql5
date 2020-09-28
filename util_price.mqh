//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Trade\SymbolInfo.mqh>
#include <Indicators\Indicators.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CUtilPrice : public CObject
  {
protected:
   CSymbolInfo       *m_symbol;
   ENUM_TIMEFRAMES   m_period;

   CIndicators       m_indicators;

   CiOpen            *m_open;
   CiHigh            *m_high;
   CiLow             *m_low;
   CiClose           *m_close;
   CiSpread          *m_spread;
   CiTime            *m_time;
   CiTickVolume      *m_tick_volume;
   CiRealVolume      *m_real_volume;
public:
   void              CUtilPrice(void);
   void             ~CUtilPrice(void);

   bool              Init(CSymbolInfo *symbol, ENUM_TIMEFRAMES period);

   bool              Refresh(void);

   bool              InitOpen(void);
   bool              InitHigh(void);
   bool              InitLow(void);
   bool              InitClose(void);
   bool              InitSpread(void);
   bool              InitTime(void);
   bool              InitTickVolume(void);
   bool              InitRealVolume(void);

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
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilPrice::CUtilPrice(void) :
   m_symbol(NULL),
   m_period(PERIOD_CURRENT),
   m_open(NULL),
   m_high(NULL),
   m_low(NULL),
   m_close(NULL),
   m_spread(NULL),
   m_time(NULL),
   m_tick_volume(NULL),
   m_real_volume(NULL)
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CUtilPrice::~CUtilPrice(void)
  {
   if(CheckPointer(m_open) == POINTER_DYNAMIC)
      delete m_open;
   if(CheckPointer(m_high) == POINTER_DYNAMIC)
      delete m_high;
   if(CheckPointer(m_low) == POINTER_DYNAMIC)
      delete m_low;
   if(CheckPointer(m_close) == POINTER_DYNAMIC)
      delete m_close;
   if(CheckPointer(m_spread) == POINTER_DYNAMIC)
      delete m_spread;
   if(CheckPointer(m_time) == POINTER_DYNAMIC)
      delete m_time;
   if(CheckPointer(m_tick_volume) == POINTER_DYNAMIC)
      delete m_tick_volume;
   if(CheckPointer(m_real_volume) == POINTER_DYNAMIC)
      delete m_real_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::Init(CSymbolInfo *symbol, ENUM_TIMEFRAMES period)
  {
   m_symbol = symbol;
   m_period = period;
   if(!InitOpen() || !InitHigh() || !InitLow() || !InitClose())
     {
      return(false);
     }
   if(!InitSpread() || !InitTime() || !InitTickVolume() || !InitRealVolume())
     {
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::Refresh(void)
  {
   m_indicators.Refresh();
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::InitOpen(void)
  {
   if((m_open = new CiOpen) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_open))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_open.Create(m_symbol.Name(), m_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::InitHigh(void)
  {
   if((m_high = new CiHigh) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_high))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_high.Create(m_symbol.Name(), m_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::InitLow(void)
  {
   if((m_low = new CiLow) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_low))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_low.Create(m_symbol.Name(), m_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::InitClose(void)
  {
   if((m_close = new CiClose) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_close))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_close.Create(m_symbol.Name(), m_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::InitSpread(void)
  {
   if((m_spread = new CiSpread) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_spread))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_spread.Create(m_symbol.Name(), m_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::InitTime(void)
  {
   if((m_time = new CiTime) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_time))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_time.Create(m_symbol.Name(), m_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::InitTickVolume(void)
  {
   if((m_tick_volume = new CiTickVolume) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_tick_volume))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_tick_volume.Create(m_symbol.Name(), m_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CUtilPrice::InitRealVolume(void)
  {
   if((m_real_volume = new CiRealVolume) == NULL)
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error creating object");
      return(false);
     }
   if(!m_indicators.Add(m_real_volume))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error adding object");
      return(false);
     }
   if(!m_real_volume.Create(m_symbol.Name(), m_period))
     {
      Print(__FILE__, " - ", __FUNCTION__, ": error initializing object");
      return(false);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilPrice::Open(int ind)
  {
   return(m_open.GetData(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilPrice::High(int ind)
  {
   return(m_high.GetData(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilPrice::Low(int ind)
  {
   return(m_low.GetData(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilPrice::Close(int ind)
  {
   return(m_close.GetData(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CUtilPrice::Spread(int ind)
  {
   return(m_spread.GetData(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime CUtilPrice::Time(int ind)
  {
   return(m_time.GetData(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CUtilPrice::TickVolume(int ind)
  {
   return(m_tick_volume.GetData(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CUtilPrice::RealVolume(int ind)
  {
   return(m_real_volume.GetData(ind));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilPrice::AvgOpen(int ind)
  {
   double avg = 0.0;
   for(int i = 1; i < ind + 1; i++)
     {
      avg += Open(i);
     }
   avg /= ind;
   return avg;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilPrice::AvgHigh(int ind)
  {
   double avg = 0.0;
   for(int i = 1; i < ind + 1; i++)
     {
      avg += High(i);
     }
   avg /= ind;
   return avg;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilPrice::AvgLow(int ind)
  {
   double avg = 0.0;
   for(int i = 1; i < ind + 1; i++)
     {
      avg += Low(i);
     }
   avg /= ind;
   return avg;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CUtilPrice::AvgClose(int ind)
  {
   double avg = 0.0;
   for(int i = 1; i < ind + 1; i++)
     {
      avg += Close(i);
     }
   avg /= ind;
   return avg;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CUtilPrice::AvgTickVolume(int ind)
  {
   long avg = 0;
   for(int i = 1; i < ind + 1; i++)
     {
      avg += TickVolume(i);
     }
   avg /= ind;
   return avg;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
long CUtilPrice::AvgRealVolume(int ind)
  {
   long avg = 0;
   for(int i = 1; i < ind + 1; i++)
     {
      avg += RealVolume(i);
     }
   avg /= ind;
   return avg;
  }
//+------------------------------------------------------------------+
