/*
 * Req_man.c
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

#include "Req_man.h"
#include "Req_man_private.h"

/* Named constants for Chart: '<Root>/Chart1' */
#define Req_man_IN_NO_ACTIVE_CHILD     ((uint8_T)0U)
#define Req_man_IN_Three               ((uint8_T)1U)
#define Req_man_IN_Two                 ((uint8_T)2U)
#define Req_man_IN_count               ((uint8_T)1U)
#define Req_man_IN_one                 ((uint8_T)3U)
#define Req_man_IN_st                  ((uint8_T)2U)

/* Block signals (default storage) */
B_Req_man_T Req_man_B;

/* Block states (default storage) */
DW_Req_man_T Req_man_DW;

/* Real-time model */
static RT_MODEL_Req_man_T Req_man_M_;
RT_MODEL_Req_man_T *const Req_man_M = &Req_man_M_;

/*
 * Output and update for function-call system:
 *    '<Root>/Simulink Function'
 *    '<Root>/Simulink Function1'
 *    '<Root>/Simulink Function2'
 */
void Req_man_SimulinkFunction(real_T *rty_Out1, P_SimulinkFunction_Req_man_T
  *localP)
{
  /* SignalConversion generated from: '<S2>/Out1' incorporates:
   *  Constant: '<S2>/Constant'
   */
  *rty_Out1 = localP->Constant_Value;
}

/* Model step function */
void Req_man_step(void)
{
  /* Chart: '<Root>/Chart1' */
  if (Req_man_DW.is_active_c1_Req_man == 0U) {
    Req_man_DW.is_active_c1_Req_man = 1U;
    Req_man_DW.is_st1 = Req_man_IN_one;

    /* Outputs for Function Call SubSystem: '<Root>/Simulink Function' */
    Req_man_SimulinkFunction(&Req_man_B.Merge, &Req_man_P.SimulinkFunction);
    Req_man_SimulinkFunction(&Req_man_B.Merge, &Req_man_P.SimulinkFunction);

    /* End of Outputs for SubSystem: '<Root>/Simulink Function' */
    Req_man_DW.is_st2 = Req_man_IN_st;
    Req_man_B.i = 0.0;
  } else {
    switch (Req_man_DW.is_st1) {
     case Req_man_IN_Three:
      if (Req_man_B.i >= 3.0) {
        Req_man_DW.is_st1 = Req_man_IN_one;

        /* Outputs for Function Call SubSystem: '<Root>/Simulink Function' */
        Req_man_SimulinkFunction(&Req_man_B.Merge, &Req_man_P.SimulinkFunction);
        Req_man_SimulinkFunction(&Req_man_B.Merge, &Req_man_P.SimulinkFunction);

        /* End of Outputs for SubSystem: '<Root>/Simulink Function' */
      }
      break;

     case Req_man_IN_Two:
      if (Req_man_B.i >= 3.0) {
        Req_man_DW.is_st1 = Req_man_IN_Three;

        /* Outputs for Function Call SubSystem: '<Root>/Simulink Function2' */
        Req_man_SimulinkFunction(&Req_man_B.Merge,
          &Req_man_P.SimulinkFunction2_f);
        Req_man_SimulinkFunction(&Req_man_B.Merge,
          &Req_man_P.SimulinkFunction2_f);

        /* End of Outputs for SubSystem: '<Root>/Simulink Function2' */
      }
      break;

     default:
      /* case IN_one: */
      if (Req_man_B.i >= 3.0) {
        Req_man_DW.is_st1 = Req_man_IN_Two;

        /* Outputs for Function Call SubSystem: '<Root>/Simulink Function1' */
        Req_man_SimulinkFunction(&Req_man_B.Merge,
          &Req_man_P.SimulinkFunction1_d);
        Req_man_SimulinkFunction(&Req_man_B.Merge,
          &Req_man_P.SimulinkFunction1_d);

        /* End of Outputs for SubSystem: '<Root>/Simulink Function1' */
      }
      break;
    }

    if (Req_man_DW.is_st2 == Req_man_IN_count) {
      if (Req_man_B.i >= 3.0) {
        Req_man_DW.is_st2 = Req_man_IN_count;
        Req_man_B.i = 1.0;
      } else {
        Req_man_B.i++;
      }
    } else {
      /* case IN_st: */
      Req_man_DW.is_st2 = Req_man_IN_count;
      Req_man_B.i = 1.0;
    }
  }

  /* End of Chart: '<Root>/Chart1' */

  /* Matfile logging */
  rt_UpdateTXYLogVars(Req_man_M->rtwLogInfo, (&Req_man_M->Timing.taskTime0));

  /* signal main to stop simulation */
  {                                    /* Sample time: [1.0s, 0.0s] */
    if ((rtmGetTFinal(Req_man_M)!=-1) &&
        !((rtmGetTFinal(Req_man_M)-Req_man_M->Timing.taskTime0) >
          Req_man_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(Req_man_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++Req_man_M->Timing.clockTick0)) {
    ++Req_man_M->Timing.clockTickH0;
  }

  Req_man_M->Timing.taskTime0 = Req_man_M->Timing.clockTick0 *
    Req_man_M->Timing.stepSize0 + Req_man_M->Timing.clockTickH0 *
    Req_man_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void Req_man_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)Req_man_M, 0,
                sizeof(RT_MODEL_Req_man_T));
  rtmSetTFinal(Req_man_M, 10.0);
  Req_man_M->Timing.stepSize0 = 1.0;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = NULL;
    Req_man_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(Req_man_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(Req_man_M->rtwLogInfo, (NULL));
    rtliSetLogT(Req_man_M->rtwLogInfo, "tout");
    rtliSetLogX(Req_man_M->rtwLogInfo, "");
    rtliSetLogXFinal(Req_man_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(Req_man_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(Req_man_M->rtwLogInfo, 4);
    rtliSetLogMaxRows(Req_man_M->rtwLogInfo, 0);
    rtliSetLogDecimation(Req_man_M->rtwLogInfo, 1);
    rtliSetLogY(Req_man_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(Req_man_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(Req_man_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &Req_man_B), 0,
                sizeof(B_Req_man_T));

  /* states (dwork) */
  (void) memset((void *)&Req_man_DW, 0,
                sizeof(DW_Req_man_T));

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(Req_man_M->rtwLogInfo, 0.0, rtmGetTFinal
    (Req_man_M), Req_man_M->Timing.stepSize0, (&rtmGetErrorStatus(Req_man_M)));

  /* SystemInitialize for Chart: '<Root>/Chart1' */
  Req_man_DW.is_st1 = Req_man_IN_NO_ACTIVE_CHILD;
  Req_man_DW.is_st2 = Req_man_IN_NO_ACTIVE_CHILD;
  Req_man_DW.is_active_c1_Req_man = 0U;

  /* SystemInitialize for Merge: '<Root>/Merge' */
  Req_man_B.Merge = Req_man_P.Merge_InitialOutput;
}

/* Model terminate function */
void Req_man_terminate(void)
{
  /* (no terminate code required) */
}
