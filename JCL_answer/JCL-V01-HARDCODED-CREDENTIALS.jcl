

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//PAYJOB01 JOB (ACCT001),'PAYROLL PROCESS',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             USER=PAYROLL,
//             PASSWORD=P4YR0LL99          
//STEP010  EXEC PGM=IEFBR14
//SYSPRINT DD SYSOUT=*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//DBCONN01 JOB (DB2001),'DB2 CONNECT JOB',CLASS=B,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IKJEFT01,
//             PARM='DB2ADMIN/S3cr3tDB2!'   
//SYSTSPRT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSIN  DD *
  DSN SYSTEM(DB2P)
  RUN PROGRAM(MYPGM) PLAN(MYPLAN)
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//FTPJOB01 JOB (FTP001),'FTP DATA TRANSFER',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=FTP,PARM='192.168.1.50'
//SYSPRINT DD SYSOUT=*
//INPUT    DD *
ftpuser                        
Passw0rd123                     
cd /data/payroll
get PAYROLL.MONTHLY.RPT
quit
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//TSOCHPW  JOB (TSO001),'CHANGE PASSWORD',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSIN  DD *
  LOGON IBMUSER PASSWORD(IBMDefau1t)  
  LU IBMUSER
  LOGOFF
/*

//*--------------------------------------------------------------------

