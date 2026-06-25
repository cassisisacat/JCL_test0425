

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//FTPCLR01 JOB (NET001),'CLEARTEXT FTP',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=FTP,                          
//             PARM='MAINFRAME.PARTNER.COM'       
//SYSPRINT DD SYSOUT=*
//INPUT    DD *
ftpusr01                                  
FtpPassw0rd                               
lcd 'PROD.EXPORT.DATA'
put MONTHLY.EXTRACT /incoming/extract
quit
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//FTPCLR02 JOB (NET001),'FTP PORT 21',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=FTP,
//             PARM='10.20.30.40 21'               
//SYSPRINT DD SYSOUT=*
//INPUT    DD *
FTPADMIN
ADMIN123
binary
get /data/salary_extract.dat 'HLQ.SALARY.EXTRACT'
quit
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//TELNTSN  JOB (NET001),'TELNET SESSION',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=BPXBATCH,REGION=4096K
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//STDPARM  DD *
SH telnet legacy.host.com 23             
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//HTTPGET  JOB (NET001),'HTTP NO TLS',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=BPXBATCH,REGION=4096K
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//STDPARM  DD *
SH curl -u admin:password123 \
        http://api.internal.com/v1/sensitive \  <== SAST: http:// + CRED
        -o /tmp/output.json
/*

//*--------------------------------------------------------------------

//*--------------------------------------------------------------------
//SMTPMAIL JOB (NET001),'SMTP CLEARTEXT',CLASS=A,NOTIFY=&SYSUID
//STEP010  EXEC PGM=CSSMTP                        
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
HELO mailhost.company.com
MAIL FROM: batch@company.com
RCPT TO: manager@company.com
DATA
Subject: Monthly Payroll Report
Attachment: PAYROLL.MONTHLY.DATA              
.
QUIT
/*

