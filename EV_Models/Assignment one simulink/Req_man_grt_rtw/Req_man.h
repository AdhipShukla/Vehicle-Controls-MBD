/*
 * Req_man.h
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "Req_man".
 *
 * Model version              : 1.1
 * Simulink Coder version : 9.4 (R2020b) 29-Jul-2020
 * C source code generated on : Wed Oct 13 13:23:44 2021
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_Req_man_h_
#define RTW_HEADER_Req_man_h_
#include <float.h>
#include <string.h>
#include <stddef.h>
#ifndef Req_man_COMMON_INCLUDES_
#define Req_man_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "rt_logging.h"
#endif                                 /* Req_man_COMMON_INCLUDES_ */

#include "Req_man_types.h"

/* Shared type includes */
#include "multiword_types.h"
#include "rt_nonfinite.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
#define rtmGetFinalTime(rtm)           ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWLogInfo
#define rtmGetRTWLogInfo(rtm)          ((rtm)->rtwLogInfo)
#endif

#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
#define rtmGetStopRequested(rtm)       ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
#define rtmSetStopRequested(rtm, val)  ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
#define rtmGetStopRequestedPtr(rtm)    (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
#define rtmGetT(rtm)                   ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
#define rtmGetTFinal(rtm)              ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetTPtr
#define rtmGetTPtr(rtm)                (&(rtm)->Timing.taskTime0)
#endif

/* Block signals (default storage) */
typedef struct {
  real_T Merge;                        /* '<Root>/Merge' */
  real_T i;                            /* '<Root>/Chart1' */
} B_Req_man_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  uint8_T is_active_c1_Req_man;        /* '<Root>/Chart1' */
  uint8_T is_st1;                      /* '<Root>/Chart1' */
  uint8_T is_st2;                      /* '<Root>/Chart1' */
} DW_Req_man_T;

/* Parameters for system: '<Root>/Simulink Function' */
struct P_SimulinkFunction_Req_man_T_ {
  real_T Constant_Value;               /* Expression: 1
                                        * Referenced by: '<S2>/Constant'
                                        */
};

/* Parameters (default storage) */
struct P_Req_man_T_ {
  real_T Merge_InitialOutput;         /* Computed Parameter: Merge_InitialOutput
                                       * Referenced by: '<Root>/Merge'
                                       */
  P_SimulinkFunction_Req_man_T SimulinkFunction2_f;/* '<Root>/Simulink Function2' */
  P_SimulinkFunction_Req_man_T SimulinkFunction1_d;/* '<Root>/Simulink Function1' */
  P_SimulinkFunction_Req_man_T SimulinkFunction;/* '<Root>/Simulink Function' */
};

/* Real-time Model Data Structure */
struct tag_RTM_Req_man_T {
  const char_T *errorStatus;
  RTWLogInfo *rtwLogInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block parameters (default storage) */
extern P_Req_man_T Req_man_P;

/* Block signals (default storage) */
extern B_Req_man_T Req_man_B;

/* Block states (default storage) */
extern DW_Req_man_T Req_man_DW;

/* Model entry point functions */
extern void Req_man_initialize(void);
extern void Req_man_step(void);
extern void Req_man_terminate(void);

/* Real-time Model object */
extern RT_MODEL_Req_man_T *const Req_man_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'Req_man'
 * '<S1>'   : 'Req_man/Chart1'
 * '<S2>'   : 'Req_man/Simulink Function'
 * '<S3>'   : 'Req_man/Simulink Function1'
 * '<S4>'   : 'Req_man/Simulink Function2'
 */
#endif                                 /* RTW_HEADER_Req_man_h_ */
