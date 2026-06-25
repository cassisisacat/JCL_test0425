

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//NOMSGLVL JOB (BATCH01),'SUPPRESS JES LOG',
//             CLASS=A,
//             MSGLEVEL=(0,0),            
//             MSGCLASS=X,
//             NOTIFY=&SYSUID
//STEP010  EXEC PGM=SENSITIV,REGION=4096K
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//PIIOUT   JOB (BATCH01),'PII SYSOUT',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=PAYRPT,REGION=4096K
//SYSPRINT DD SYSOUT=*
//PAYROLL  DD SYSOUT=A                     
//SSNDATA  DD SYSOUT=A                     
//CREDIT   DD SYSOUT=A                     
//ACCTNUM  DD SYSOUT=A                     
//* All of the above land in JES spool accessible to any SDSF user

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//DUMPJOB  JOB (BATCH01),'CORE DUMP',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=DBCONCT,REGION=4096K
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*                     
//SYSABEND DD SYSOUT=*                     
//* Dumps will contain DB2 passwords, RACF tokens, keying material
//* from program working storage

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//NOSMF    JOB (BATCH01),'DISABLE SMF',CLASS=A,NOTIFY=&SYSUID
//MODSMF   EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  /* Disable SMF recording for type 80 (RACF events) */
  EXEC 'SYS1.PARMLIB(SMFPRM00)'
  NOTYPE(80)                            
  NOTYPE(30)                              
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//ISPFHIST JOB (BATCH01),'READ ISPF HIST',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DISP=SHR,                   
//            DSN=IBMUSER.ISPF.ISPLOG
//SYSUT2   DD SYSOUT=*                    
//SYSIN    DD DUMMY
//* ISPF logs retain typed commands including: LOGON user/password,
//* TSO RACF commands, DB2 CONNECT user/password sequences


