# JCL Security Vulnerability Test Cases
## JCL Top 10 漏洞测试用例集 (类比 OWASP Top 10)

**用途**: 用于测试 SAST 扫描工具对 IBM z/OS JCL (Job Control Language) 的漏洞检测能力  
**来源**: 基于公开安全研究仓库的真实代码片段生成，包括 mainframed/Mainframed、
zedsec390/NJElib、hacksomeheavymetal/zOS、rapid7/metasploit-framework 等

---

## 漏洞列表总览

| 编号 | 文件名 | 漏洞类型 | 严重级别 | 对应 OWASP |
|------|--------|----------|----------|------------|
| V01 | JCL-V01-HARDCODED-CREDENTIALS.jcl | 硬编码凭据 | CRITICAL | A07:2021 |
| V02 | JCL-V02-RACF-DATABASE-EXPOSURE.jcl | RACF数据库未授权导出 | CRITICAL | A01:2021 |
| V03 | JCL-V03-APF-PRIVILEGE-ESCALATION.jcl | APF库提权 | CRITICAL | A04:2021 |
| V04 | JCL-V04-FTP-JES-INJECTION.jcl | FTP JES注入 | HIGH | A03:2021 |
| V05 | JCL-V05-INSECURE-DATASET-PERMISSIONS.jcl | 数据集权限过度开放 | HIGH | A01:2021 |
| V06 | JCL-V06-SURROGAT-USER-IMPERSONATION.jcl | SURROGAT用户冒用 | HIGH | A07:2021 |
| V07 | JCL-V07-INSECURE-PROTOCOL-USAGE.jcl | 明文协议使用 | HIGH | A02:2021 |
| V08 | JCL-V08-SENSITIVE-DATA-SYSOUT-EXPOSURE.jcl | 敏感数据SYSOUT泄漏 | MEDIUM-HIGH | A09:2021 |
| V09 | JCL-V09-NJE-CROSS-NODE-SUBMISSION.jcl | NJE跨节点未授权提交 | HIGH | A05:2021 |
| V10 | JCL-V10-SECURITY-CONTROL-BYPASS.jcl | JCL安全控制绕过 | MEDIUM-CRITICAL | A05:2021 |

---

## 各漏洞详细说明

### JCL-V01: 硬编码凭据 (Hardcoded Credentials)
**CRITICAL | 对应 OWASP A07:2021**

**测试场景**:
- V01-A: JOB 语句中 `PASSWORD=` 明文硬编码
- V01-B: `PARM=` 字段包含 DB2/应用凭据
- V01-C: FTP SYSIN 命令流含用户名+密码
- V01-D: TSO SYSTSIN 内联包含 LOGON 密码
- V01-E: ✅ 合规对照 (符号变量)

**SAST 应检测的关键字**: `PASSWORD=`, `PARM='user/pass'`, FTP INPUT DD 中明文凭据

**真实来源**: rapid7/metasploit-framework `ftp_jcl_creds` 模块中使用的认证模式

---

### JCL-V02: RACF 数据库未授权导出 (RACF Database Exposure)
**CRITICAL | 对应 OWASP A01:2021**

**测试场景**:
- V02-A: `PGM=IRRDBU00` 将 RACF DB 卸载到用户数据集 (**来自真实仓库 mainframed/Mainframed RACFUNLD 文件**)
- V02-B: IDCAMS REPRO 复制主 RACF 数据集
- V02-C: SYS1.UADS (用户属性数据集) 被复制
- V02-D: SYS1.PARMLIB 通过 IEBCOPY 被导出
- V02-E: ✅ 合规对照 (RACF 管理接口)

**SAST 应检测的关键字**: `PGM=IRRDBU00`, `DSN=SYS1.RACF*`, `DSN=SYS1.UADS`

**真实来源**: 完整的 RACFUNLD JCL 直接来自 `github.com/mainframed/Mainframed/blob/master/RACFUNLD`

---

### JCL-V03: APF 库提权 (APF Library Privilege Escalation)
**CRITICAL | 对应 OWASP A04:2021**

**测试场景**:
- V03-A: `PGM=ASMACLG` 汇编后将模块写入 APF 库 (`AC=1` 授权标志)
- V03-B: SETPROG APF,ADD 动态添加未授权库到 APF 列表
- V03-C: IEBCOPY 将用户库内容注入 SYS1.LPALIB
- V03-D: Linkage Editor 设置 `AC=1` 目标为 SYS1.LINKLIB
- V03-E: ✅ 合规对照 (不含 AC=1)

**SAST 应检测的关键字**: `AC=1` 在 LKED PARM 中, `DSN=SYS1.LPALIB`, `SETPROG APF,ADD`

**真实来源**: Metasploit `cmd/mainframe/apf_privesc_jcl` payload 逻辑 + mainframed767 RACF 提权博客

---

### JCL-V04: FTP JES 注入 (FTP JES Injection)
**HIGH | 对应 OWASP A03:2021**

**测试场景**:
- V04-A: `MSGLEVEL=(0,0)` 隐藏审计日志 + TSO 枚举命令 (**来自 zedsec390/NJElib tso.jcl**)
- V04-B: 通过 JES 提交的反向 Shell JCL (C编译+BPXBATCH执行)
- V04-C: 匿名 FTP 凭据
- V04-D: `/*XEQ` 跨节点执行
- V04-E: ✅ 合规对照 (TLS FTP + 符号变量)

**SAST 应检测的关键字**: `MSGLEVEL=(0,0)`, `PGM=BPXBATCH` with shell commands, `/*XEQ`

**真实来源**: zedsec390/NJElib tso.jcl 真实文件 + metasploit `exploit/mainframe/ftp/ftp_jcl_creds`

---

### JCL-V05: 数据集权限过度开放 (Insecure Dataset Permissions)
**HIGH | 对应 OWASP A01:2021**

**测试场景**:
- V05-A: 用户作业 `DISP=SHR` 访问 SYS1.LINKLIB/PROCLIB/PARMLIB
- V05-B: 新建敏感数据集缺少 `PROTECT=YES`
- V05-C: 薪资报表 SYSOUT 指向无控制打印机 `DEST=PRT001`
- V05-D: SMF/RACF 日志 DD 设为 DUMMY (审计抑制)
- V05-E: PII 数据留存于临时数据集未清理
- V05-F: ✅ 合规对照 (PROTECT=YES)

**SAST 应检测的关键字**: `DISP=SHR,DSN=SYS1.*`, 新建 DSN 无 `PROTECT`, `DEST=` 外部打印机

---

### JCL-V06: SURROGAT 用户冒用 (User Impersonation)
**HIGH | 对应 OWASP A07:2021**

**测试场景**:
- V06-A: JOB 卡 `USER=IBMUSER` 假冒高权限账户
- V06-B: `GROUP=SYS1` 提升到特权组
- V06-C: 启动任务 (STC) JCL 缺少 USER= (以默认账户运行)
- V06-D: BPXBATCH 执行 USS 枚举命令
- V06-E: 调用含 USER= 的内部 PROC
- V06-F: ✅ 合规对照 (无 USER=, 受限 CLASS)

**SAST 应检测的关键字**: `USER=IBMUSER`, `USER=SYS*`, `GROUP=SYS1`, BPXBATCH with `id;whoami`

**真实来源**: mainframed767 SURROGAT 博客文章中展示的攻击模式

---

### JCL-V07: 明文协议使用 (Insecure Protocol)
**HIGH | 对应 OWASP A02:2021**

**测试场景**:
- V07-A: FTP 明文端口 21
- V07-B: FTP 显式指定端口 21 + 凭据
- V07-C: BPXBATCH 调用 Telnet 端口 23
- V07-D: curl 使用 `http://` 含凭据
- V07-E: SMTP 无 STARTTLS 发送薪资报表
- V07-F: ✅ 合规对照 (FTPS 端口 990 + AUTH TLS)

**SAST 应检测的关键字**: `PGM=FTP` 无端口990, `telnet` port 23, `http://` in BPXBATCH

**真实来源**: NetSPI 主机渗透测试报告中的发现类型

---

### JCL-V08: SYSOUT 敏感数据泄漏 (Sensitive Data Exposure)
**MEDIUM-HIGH | 对应 OWASP A09:2021**

**测试场景**:
- V08-A: `MSGLEVEL=(0,0)` 完全抑制 JES 审计
- V08-B: PAYROLL/SSN/CREDIT DD 指向 `SYSOUT=A` (JES spool 可读)
- V08-C: `SYSUDUMP DD SYSOUT=*` (内存转储含密码)
- V08-D: TSO 命令禁用 SMF 80 (RACF 事件记录)
- V08-E: ISPF 命令历史数据集被读取 (含历史密码)
- V08-F: ✅ 合规对照 (受保护 MSGCLASS + PROTECT 的 DUMP)

**SAST 应检测的关键字**: `MSGLEVEL=(0,0)`, `SYSUDUMP DD SYSOUT=*`, `NOTYPE(80)` in SMFPRM

---

### JCL-V09: NJE 跨节点未授权提交 (NJE Cross-Node Submission)
**HIGH | 对应 OWASP A05:2021**

**测试场景**:
- V09-A: `/*XEQ REMNODE` 在远程节点执行 TSO 枚举
- V09-B: `/*ROUTE XEQ` 路由到目标节点
- V09-C: `/*XMIT NODENAME.USERID` 跨网络传输数据集
- V09-D: `JOBPARM SYSAFF=*` 通配符节点分配
- V09-E: `DEST=OFFSITE` SYSOUT 路由到外部节点
- V09-F: ✅ 合规对照 (SYSAFF=LOCALND 限定节点)

**SAST 应检测的关键字**: `/*XEQ`, `/*ROUTE XEQ`, `/*XMIT`, `SYSAFF=*`, `DEST=` 外部节点名

**真实来源**: zedsec390/NJElib 库的 JCL 示例 + NJElib README 中的 NJE 利用模式

---

### JCL-V10: JCL 安全控制绕过 (Security Control Bypass)
**MEDIUM-CRITICAL | 对应 OWASP A05:2021**

**测试场景**:
- V10-A: STEPLIB 用户库在系统库**之前** (Trojan Horse 模块注入)
- V10-B: `REGION=0M` 无限内存分配 (DoS)
- V10-C: `COND=EVEN` 安全验证步骤失败后继续执行敏感步骤
- V10-D: IDCAMS DELETE 删除生产数据集
- V10-E: IEBUPDTE 修改 SYS1.PARMLIB(SMFPRMxx)
- V10-F: `ADDRSPC=REAL` 实存储访问
- V10-G: `TYPRUN=COPY` 绕过正常执行流
- V10-H: ✅ 合规对照 (系统库在前 + 有限 REGION + 正确 COND)

**SAST 应检测的关键字**: 用户 DSN 在 STEPLIB 第一位, `REGION=0M`, `COND=EVEN`, `ADDRSPC=REAL`

---

## SAST 检测规则总结

以下是建议 SAST 工具实现的 JCL 规则集:

```
RULE-001: HARDCODED_PASSWORD      - PASSWORD= with non-symbolic literal
RULE-002: HARDCODED_PARM_CRED     - PARM= containing user/password patterns
RULE-003: FTP_PLAIN_CREDENTIALS   - FTP INPUT DD with literal credentials
RULE-004: RACF_DB_ACCESS          - PGM=IRRDBU00 or DSN=SYS1.RACF*
RULE-005: APF_WRITE               - LKED/COPY targeting SYS1.LPA/LINKLIB + AC=1
RULE-006: SETPROG_APF_ADD         - SETPROG APF,ADD in SYSTSIN
RULE-007: FTP_NO_TLS              - PGM=FTP without port 990 or AUTH TLS
RULE-008: TELNET_USAGE            - telnet command in BPXBATCH STDPARM
RULE-009: MSGLEVEL_SUPPRESSED     - MSGLEVEL=(0,0) in JOB statement
RULE-010: SYSOUT_SENSITIVE_DD     - DD names containing PAYROLL/SSN/CREDIT -> SYSOUT=*
RULE-011: SYSUDUMP_PUBLIC         - SYSUDUMP or SYSABEND DD SYSOUT=*
RULE-012: NJE_CROSS_NODE          - /*XEQ, /*ROUTE XEQ, SYSAFF=*
RULE-013: NJE_XMIT                - /*XMIT or TRANSMIT to external node
RULE-014: USER_IMPERSONATION      - USER=IBMUSER or USER=SYS* in JOB card
RULE-015: SURROGAT_GROUP          - GROUP=SYS1 or known privileged groups
RULE-016: SYSTEM_DS_WRITE         - DISP=OLD or write to SYS1.PARMLIB
RULE-017: STEPLIB_USER_FIRST      - User-controlled DSN first in STEPLIB
RULE-018: UNLIMITED_REGION        - REGION=0M
RULE-019: COND_EVEN_BYPASS        - COND=EVEN on sensitive steps
RULE-020: IDCAMS_DELETE_PROD      - IDCAMS DELETE on production DSN patterns
RULE-021: UNPROTECTED_DATASET     - New DSN allocation without PROTECT=YES
RULE-022: ANONYMOUS_FTP           - anonymous or anonymous@ in FTP INPUT DD
RULE-023: HTTP_NO_TLS             - http:// in BPXBATCH STDPARM
RULE-024: SMF_DISABLE             - NOTYPE(80) or NOTYPE(30) in SYSTSIN
RULE-025: BPXBATCH_SHELL_ENUM     - id;whoami;cat /etc/passwd in STDPARM
```

---

## 参考仓库

| 仓库 | URL | 贡献内容 |
|------|-----|----------|
| mainframed/Mainframed | github.com/mainframed/Mainframed | RACFUNLD JCL (V02-A 真实代码) |
| zedsec390/NJElib | github.com/zedsec390/NJElib | tso.jcl (V04-A/V09 真实代码) |
| rapid7/metasploit-framework | github.com/rapid7/metasploit-framework | APF privesc JCL payload 模式 |
| hacksomeheavymetal/zOS | github.com/hacksomeheavymetal/zOS | 综合漏洞清单和 SAST 建议 |
| samanL33T/Awesome-Mainframe-Hacking | github.com/samanL33T/Awesome-Mainframe-Hacking | 漏洞分类参考 |
| ricardojba/Even-More-Awesome-Mainframe-Hacking | github.com/ricardojba/Even-More-Awesome-Mainframe-Hacking | NJE 利用技术 |
| NetSPI 大型机渗透测试 | netspi.com/blog | 真实漏洞案例 |
| DoD z/OS STIGs | stigviewer.com | 合规标准参考 |
