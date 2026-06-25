
//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//EXECBAT  JOB (BATCH01),'EXCESSIVE ACCESS',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=MYPGM,REGION=4096K
//STEPLIB  DD DISP=SHR,DSN=SYS1.LINKLIB    
//         DD DISP=SHR,DSN=SYS1.SVCLIB     
//PROCIN   DD DISP=SHR,DSN=SYS1.PROCLIB    
//PARMLIB  DD DISP=SHR,DSN=SYS1.PARMLIB    
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//UNPROTD  JOB (BATCH01),'UNPROTECTED OUTPUT',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=MYRPT,REGION=2048K
//SYSPRINT DD SYSOUT=*
//RPTOUT   DD DSN=PAYROLL.MONTHLY.REPORT,  
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(10,5)),
//            UNIT=SYSDA                    
//            DCB=(RECFM=FB,LRECL=133,BLKSIZE=13300)

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//RPTPRINT JOB (RPTS01),'PRINT PAYROLL',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=MYRPT,REGION=2048K
//SYSPRINT DD SYSOUT=*
//OUTPUT01 DD SYSOUT=(A,INTRDR)             
//PAYROLL  DD SYSOUT=A,                     
//            DEST=PRT001,                 
//            DCB=(RECFM=FBA,LRECL=133)
//* CONTAINS: SSN, SALARY, BANK ACCOUNT DATA

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//NOAUDIT  JOB (BATCH01),'SUPPRESS AUDIT',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=MYPGM
//SYSPRINT DD SYSOUT=*
//SMF      DD DUMMY                          
//RACFLOG  DD DUMMY                          
//SYSOUT   DD SYSOUT=*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//TMPDATA  JOB (BATCH01),'PII IN TEMP DS',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=EXTRACT
//SYSPRINT DD SYSOUT=*
//EXTRACT  DD DSN=&&CUSTDATA,              
//            DISP=(NEW,PASS),
//            SPACE=(CYL,(50,10)),
//            DCB=(RECFM=FB,LRECL=500)
//STEP020  EXEC PGM=REPORT,COND=(4,LT)
//INDATA   DD DSN=&&CUSTDATA,DISP=(OLD,DELETE)
//RPTOUT   DD DSN=TEMP.CUST.EXTRACT.RPT,   
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(20,5)),
//            DCB=(RECFM=FB,LRECL=133)


