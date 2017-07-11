SELECT


tab1.区域 AS "地市",
tab1.DDATE AS "日期",
tab2.RRC连接建立成功率 AS "RRC建立成功率",
tab2.ERAB建立成功率 AS "ERAB建立成功率",
tab2.RRC建立拥塞率 AS "RRC拥塞率",
tab2.ERAB建立拥塞率 AS "ERAB拥塞率",
tab2.LTE业务掉线率 AS "掉话率",
tab4.异频切换成功率 AS "异频切换成功率",
tab4.同频切换成功率 AS "同频切换成功率",
tab3.平均每PRB干扰噪声功率 AS "PRB干扰噪声均值",
tab5.空口上行业务字节数MB AS "上行(MB)",
tab5.空口下行业务字节数MB AS "下行(MB)"

--tab2.无线接通率,
--tab2.RRC连接建立请求次数,
--tab2.RRC连接建立成功次数,
--tab2.RRC建立拥塞次数,
--tab2.ERAB建立请求个数,
--tab2.ERAB建立成功个数,
--tab2.ERAB建立拥塞次数,
--tab2.无线资源拥塞次数,
--tab4.同频切换请求次数,
--tab4.同频切换成功次数,
-- tab4.异频切换请求次数,
-- tab4.异频切换出成功次数
-- tab2.ERAB失败_传输层,
--tab2.ERAB建立失败_UE无响应,
-- tab2.ERAB建立失败_安全模式,
--tab2.E_RAB建立失败_核心网,
--tab2.E_RAB建立失败_无线层,

-- tab2.LTE业务掉线率,
-- tab2.LTE业务释放次数,
-- tab2.LTE业务掉线次数,
-- tab2.MME释放的ERAB数网络层,
-- tab2.eNB释放的ERAB数网络层,
-- tab2.eNB释放的ERAB数other,
-- tab2.eNB释放的ERAB数传输层,
-- tab2.E_RAB异常释放_网络拥塞


FROM
(SELECT
To_Date(To_Char(tab1.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS DDATE,
-- tab1.lncel_enb_id AS lncel_enb_id,
-- tab1.lncel_lcr_id AS lncel_lcr_id,
-- tab1.lnbts_name,
tab1.区域,
--  tab1.version,
sum(tab1.LTE小区可用率分子) AS LTE小区可用率分子,
sum(tab1.LTE小区可用率分母) AS LTE小区可用率分母,
round(decode(sum(tab1.LTE小区可用率分母),0,0,sum(tab1.LTE小区可用率分子)/sum(tab1.LTE小区可用率分母)*100),2) AS LTE小区可用率,
round(avg(tab1.LTE小区退服时长),2) AS LTE小区平均退服时长s,
round(sum(tab1.LTE小区退服时长),2) AS LTE小区总退服时长s

FROM
(SELECT
lcelav.lncel_id as lncel_id,
To_Date(To_Char(lcelav.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS pm_date,
Cast(To_Char(lcelav.PERIOD_START_TIME, 'hh24') As Number) As hour,
--c.lnbts_name AS lnbts_name,
--c.version,
(CASE
WHEN (c.city = 'Baoji' AND c.netmodel = 'FDD') THEN '宝鸡FDD'
WHEN (c.city = 'Baoji' AND c.netmodel = 'TDD') THEN '宝鸡TDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'FDD') THEN '西安FDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'TDD') THEN '西安TDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'FDD') THEN '咸阳FDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'TDD') THEN '咸阳TDD'
WHEN (c.city = 'Tongchuan' AND c.netmodel = 'TDD') THEN '铜川TDD'
WHEN (c.city = 'Hanzhong' AND c.netmodel = 'TDD') THEN '汉中TDD'
WHEN (c.city = 'Yulin' AND c.netmodel = 'TDD') THEN '榆林TDD'
WHEN (c.city = 'Yanan' AND c.netmodel = 'TDD') THEN '延安TDD'
WHEN (c.city = 'Shangluo' AND c.netmodel = 'TDD') THEN '商洛TDD'
ELSE NULL END) 区域,
ROUND(DECODE(SUM(DENOM_CELL_AVAIL),0,0,100 * SUM(SAMPLES_CELL_AVAIL) / SUM(DENOM_CELL_AVAIL)),2) AS LTE小区可用率,
SUM(SAMPLES_CELL_AVAIL) LTE小区可用率分子,
SUM(DENOM_CELL_AVAIL) LTE小区可用率分母,
SUM(DENOM_CELL_AVAIL - SAMPLES_CELL_AVAIL) * 10 AS LTE小区退服时长

FROM
NOKLTE_PS_LCELAV_LNCEL_HOUR lcelav
INNER JOIN C_LTE_CUSTOM c ON c.lncel_objid = lcelav.lncel_id and c.city is not null

WHERE
lcelav.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND lcelav.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
and (Cast(To_Char(lcelav.PERIOD_START_TIME, 'hh24') As Number) = 12 or
    Cast(To_Char(lcelav.PERIOD_START_TIME, 'hh24') As Number) = 13 or
    Cast(To_Char(lcelav.PERIOD_START_TIME, 'hh24') As Number) = 22 or
    Cast(To_Char(lcelav.PERIOD_START_TIME, 'hh24') As Number) = 23 )


GROUP BY
lcelav.lncel_id,
To_Date(To_Char(lcelav.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') ,
Cast(To_Char(lcelav.PERIOD_START_TIME, 'hh24') As Number),
c.city,
c.netmodel

) tab1
GROUP BY
To_Date(To_Char(tab1.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd'),
--  tab1.lncel_enb_id,
--  tab1.lncel_lcr_id,
-- tab1.lnbts_name,
-- tab1.version,
tab1.区域

) tab1,





(SELECT
To_Date(To_Char(tab2.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS DDATE,
--  tab2.lncel_enb_id AS lncel_enb_id,
--  tab2.lncel_lcr_id AS lncel_lcr_id,
tab2.区域,
round((decode(sum(tab2.RRC连接建立请求次数),0,0,sum(tab2.RRC连接建立成功次数)/sum(tab2.RRC连接建立请求次数)))*(decode(SUM(tab2.ERAB建立请求个数),0,0,sum(tab2.ERAB建立成功个数)/SUM(tab2.ERAB建立请求个数)))*100,2) AS 无线接通率,
round(decode(sum(tab2.RRC连接建立请求次数),0,0,sum(tab2.RRC连接建立成功次数)/sum(tab2.RRC连接建立请求次数))*100,2) AS RRC连接建立成功率,
round(decode(sum(tab2.RRC连接建立请求次数),0,0,sum(tab2.RRC建立拥塞次数)/sum(tab2.RRC连接建立请求次数))*100,2) AS RRC建立拥塞率,
sum(tab2.RRC连接建立请求次数) AS RRC连接建立请求次数,
sum(tab2.RRC连接建立成功次数) AS RRC连接建立成功次数,
sum(tab2.RRC建立拥塞次数) AS RRC建立拥塞次数,
sum(tab2.Setup_comp_miss无应答) AS Setup_comp_miss无应答,
sum(tab2.Setup_comp_error小区拒绝) AS Setup_comp_error小区拒绝,
sum(tab2.Reject_RRM_RAC资源分配失) AS Reject_RRM_RAC资源分配失,
sum(tab2.SIGN_CONN_ESTAB_FAIL_MAXRRC) as SIGN_CONN_ESTAB_FAIL_MAXRRC,
round(decode(SUM(tab2.ERAB建立请求个数),0,0,sum(tab2.ERAB建立成功个数)/SUM(tab2.ERAB建立请求个数))*100,2) AS ERAB建立成功率,
round(decode(sum(tab2.ERAB建立请求个数),0,0,sum(tab2.ERAB建立拥塞次数)/SUM(tab2.ERAB建立请求个数))*100,2) AS ERAB建立拥塞率,
sum(tab2.ERAB建立请求个数) AS ERAB建立请求个数,
sum(tab2.ERAB建立成功个数) AS ERAB建立成功个数,
sum(tab2.ERAB建立拥塞次数) AS ERAB建立拥塞次数,
sum(tab2.无线资源拥塞次数) AS 无线资源拥塞次数,
sum(tab2.传输资源拥塞次数) AS ERAB失败_传输层,
sum(tab2.ERAB建立失败_UE无响应) AS ERAB建立失败_UE无响应,
sum(tab2.ERAB建立失败_配置) AS ERAB建立失败_安全模式,
ROUND(avg(tab2.E_RAB建立失败_核心网),0) AS E_RAB建立失败_核心网,
ROUND(avg(tab2.E_RAB建立失败_无线层),0) AS E_RAB建立失败_无线层,
round(decode(sum(tab2.LTE业务释放次数),0,0,sum(tab2.LTE业务掉线次数)/sum(tab2.LTE业务释放次数))*100,2) AS LTE业务掉线率,
sum(tab2.LTE业务释放次数) AS LTE业务释放次数,
sum(tab2.LTE业务掉线次数) AS LTE业务掉线次数,
sum(tab2.EPC_EPS_BEARER_REL_REQ_RNL) AS MME释放的ERAB数网络层,
sum(tab2.ENB_EPS_BEARER_REL_REQ_RNL) AS eNB释放的ERAB数网络层,
sum(tab2.ENB_EPS_BEARER_REL_REQ_OTH) AS eNB释放的ERAB数other,
sum(tab2.ENB_EPS_BEARER_REL_REQ_TNL) AS eNB释放的ERAB数传输层,
sum(tab2.EPC_EPS_BEAR_REL_REQ_R_QCI1) AS  E_RAB异常释放_网络拥塞

FROM
(SELECT
luest.lncel_id,
To_Date(To_Char(luest.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS pm_date,
Cast(To_Char(luest.PERIOD_START_TIME, 'hh24') As Number) As hour,
(CASE
WHEN (c.city = 'Baoji' AND c.netmodel = 'FDD') THEN '宝鸡FDD'
WHEN (c.city = 'Baoji' AND c.netmodel = 'TDD') THEN '宝鸡TDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'FDD') THEN '西安FDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'TDD') THEN '西安TDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'FDD') THEN '咸阳FDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'TDD') THEN '咸阳TDD'
WHEN (c.city = 'Tongchuan' AND c.netmodel = 'TDD') THEN '铜川TDD'
WHEN (c.city = 'Hanzhong' AND c.netmodel = 'TDD') THEN '汉中TDD'
WHEN (c.city = 'Yulin' AND c.netmodel = 'TDD') THEN '榆林TDD'
WHEN (c.city = 'Yanan' AND c.netmodel = 'TDD') THEN '延安TDD'
WHEN (c.city = 'Shangluo' AND c.netmodel = 'TDD') THEN '商洛TDD'
ELSE NULL END) 区域,
round(DECODE(decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))), 0, 0, sum(luest.SIGN_CONN_ESTAB_COMP) / decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))))
* DECODE(sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS),0,0,sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS)/sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS))*100,2) 无线接通率,
round(DECODE(decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))), 0, 0, sum(luest.SIGN_CONN_ESTAB_COMP) / decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))))*100,2) AS RRC连接建立成功率,

round(decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_FAIL_PUCCH),sum(luest.SIGN_CONN_ESTAB_FAIL_RRMRAC)/decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))))*100,2) AS RRC建立拥塞率，

decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0,luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode( luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO)),sum(luest.SIGN_CONN_ESTAB_ATT_MO_S + luest.SIGN_CONN_ESTAB_ATT_MT + luest.SIGN_CONN_ESTAB_ATT_MO_D + luest.SIGN_CONN_ESTAB_ATT_OTHERS + luest.SIGN_CONN_ESTAB_ATT_EMG + decode(luest.SIGN_CONN_ESTAB_ATT_DEL_TOL,'',0, luest.SIGN_CONN_ESTAB_ATT_DEL_TOL)+ decode(luest.SIGN_CONN_ESTAB_ATT_HIPRIO,'',0,luest.SIGN_CONN_ESTAB_ATT_HIPRIO))) AS RRC连接建立请求次数,
sum(luest.SIGN_CONN_ESTAB_COMP) AS RRC连接建立成功次数,

decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_FAIL_PUCCH),sum(luest.SIGN_CONN_ESTAB_FAIL_RRMRAC)) AS RRC建立拥塞次数,

decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum( lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA),sum(lepsb.EPS_BEARER_SETUP_FAIL_RESOUR)) AS 无线资源拥塞次数,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS - lepsb.EPS_BEARER_SETUP_COMPLETIONS - lepsb.ERAB_INI_SETUP_FAIL_RNL_UEL - lepsb.ERAB_ADD_SETUP_FAIL_RNL_UEL - lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU - lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU - lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA - lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA - lepsb.ERAB_INI_SETUP_FAIL_RNL_RIP - lepsb.ERAB_ADD_SETUP_FAIL_RNL_RIP - lepsb.ERAB_ADD_SETUP_FAIL_UP - lepsb.ERAB_ADD_SETUP_FAIL_RNL_MOB),sum(lepsb.EPS_BEARER_SETUP_FAIL_TRPORT)) AS 传输资源拥塞次数,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_INI_SETUP_FAIL_RNL_UEL + lepsb.ERAB_ADD_SETUP_FAIL_RNL_UEL ),Sum(lepsb.EPS_BEARER_SETUP_FAIL_RNL)) ERAB建立失败_UE无响应,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_ADD_SETUP_FAIL_UP),Sum(lepsb.EPS_BEARER_SETUP_FAIL_OTH)) AS ERAB建立失败_配置,
sum(luest.SIGN_EST_F_RRCCOMPL_MISSING) AS Setup_comp_miss无应答,
sum(luest.SIGN_EST_F_RRCCOMPL_ERROR) AS Setup_comp_error小区拒绝,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_FAIL_PUCCH),sum(luest.SIGN_CONN_ESTAB_FAIL_RRMRAC)) AS Reject_RRM_RAC资源分配失,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(luest.SIGN_CONN_ESTAB_FAIL_MAXRRC),'') AS SIGN_CONN_ESTAB_FAIL_MAXRRC, --LN7.0无此指标
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(lepsb.ERAB_ADD_SETUP_FAIL_UP),'') AS E_RAB建立失败_核心网, --LN7.0无此指标
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(lepsb.ERAB_INI_SETUP_FAIL_RNL_RIP + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RIP),'') AS E_RAB建立失败_无线层, --LN7.0无此指标
round(decode(sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS),0,0, sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS) / sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS))*100,2) AS ERAB建立成功率,

round(decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU),SUM( lepsb.EPS_BEARER_SETUP_FAIL_TRPORT + lepsb.EPS_BEARER_SETUP_FAIL_RESOUR )/sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS))*100,2) AS ERAB建立拥塞率，

sum(lepsb.EPS_BEARER_SETUP_COMPLETIONS) AS ERAB建立成功个数,
sum(lepsb.EPS_BEARER_SETUP_ATTEMPTS) AS ERAB建立请求个数,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum(lepsb.ERAB_INI_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_INI_SETUP_FAIL_TNL_TRU + lepsb.ERAB_ADD_SETUP_FAIL_RNL_RRNA + lepsb.ERAB_ADD_SETUP_FAIL_TNL_TRU),SUM( lepsb.EPS_BEARER_SETUP_FAIL_TRPORT + lepsb.EPS_BEARER_SETUP_FAIL_RESOUR )) AS ERAB建立拥塞次数，
round(DECODE(decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum( lepsb.EPC_EPS_BEARER_REL_REQ_RNL  + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH + lepsb.ERAB_REL_ENB_RNL_INA + lepsb.ERAB_REL_ENB_RNL_RED + lepsb.ERAB_REL_ENB_RNL_RRNA + lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH ) ,sum( lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH + lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_ACT_NON_GBR + lepsb.ENB_EPSBEAR_REL_REQ_RNL_REDIR + lepsb.ENB_EPS_BEARER_REL_REQ_NORM + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER )), 0, 0, decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',SUM( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH ) ,SUM( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH ))/ decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH + lepsb.ERAB_REL_ENB_RNL_INA + lepsb.ERAB_REL_ENB_RNL_RED + lepsb.ERAB_REL_ENB_RNL_RRNA + lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH ) ,sum( lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH + lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_ACT_NON_GBR + lepsb.ENB_EPSBEAR_REL_REQ_RNL_REDIR + lepsb.ENB_EPS_BEARER_REL_REQ_NORM + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER )) )*100,2) AS LTE业务掉话率,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',SUM( lepsb.EPC_EPS_BEARER_REL_REQ_RNL  + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH ) ,SUM( lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH))  AS LTE业务掉线次数,
sum(lepsb.EPC_EPS_BEARER_REL_REQ_RNL) EPC_EPS_BEARER_REL_REQ_RNL,
sum(lepsb.EPC_EPS_BEARER_REL_REQ_OTH) EPC_EPS_BEARER_REL_REQ_OTH,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH),Sum(lepsb.ENB_EPS_BEARER_REL_REQ_OTH)) ENB_EPS_BEARER_REL_REQ_OTH,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_REL_ENB_RNL_UEL),Sum(lepsb.ENB_EPS_BEARER_REL_REQ_RNL)) ENB_EPS_BEARER_REL_REQ_RNL,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_REL_ENB_TNL_TRU),Sum(lepsb.ENB_EPS_BEARER_REL_REQ_TNL)) ENB_EPS_BEARER_REL_REQ_TNL,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',SUM(lepsb.ERAB_REL_ENB_RNL_EUGR),Sum(lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1)) EPC_EPS_BEAR_REL_REQ_R_QCI1,
AVG(lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1) avgEPC_EPS_BEAR_REL_REQ_R_QCI1,
sum(lepsb.PRE_EMPT_GBR_BEARER) PRE_EMPT_GBR_BEARER,
sum(lepsb.PRE_EMPT_NON_GBR_BEARER) PRE_EMPT_NON_GBR_BEARER,
decode((CASE WHEN c.version='FL16' THEN 'FL16'WHEN c.version='FLF16' THEN 'FL16'WHEN c.version='FL16A' THEN 'FL16' WHEN c.version='TL16' THEN 'FL16' ELSE c.version END),'FL16',sum( lepsb.EPC_EPS_BEARER_REL_REQ_RNL  + lepsb.ERAB_REL_ENB_RNL_UEL + lepsb.ERAB_REL_ENB_RNL_EUGR + lepsb.ERAB_REL_ENB_TNL_TRU + lepsb.ERAB_REL_HO_PART + lepsb.ERAB_REL_EPC_PATH_SWITCH + lepsb.ERAB_REL_ENB_RNL_INA + lepsb.ERAB_REL_ENB_RNL_RED + lepsb.ERAB_REL_ENB_RNL_RRNA + lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH ) ,sum( lepsb.EPC_EPS_BEARER_REL_REQ_NORM + lepsb.EPC_EPS_BEARER_REL_REQ_DETACH + lepsb.EPC_EPS_BEARER_REL_REQ_RNL + lepsb.ERAB_REL_ENB_ACT_NON_GBR + lepsb.ENB_EPSBEAR_REL_REQ_RNL_REDIR + lepsb.ENB_EPS_BEARER_REL_REQ_NORM + lepsb.ENB_EPS_BEARER_REL_REQ_RNL + lepsb.ENB_EPS_BEARER_REL_REQ_TNL + lepsb.ENB_EPS_BEARER_REL_REQ_OTH + lepsb.EPC_EPS_BEAR_REL_REQ_R_QCI1 + lepsb.PRE_EMPT_GBR_BEARER + lepsb.PRE_EMPT_NON_GBR_BEARER)) AS LTE业务释放次数

FROM
NOKLTE_PS_LUEST_LNCEL_HOUR luest
INNER JOIN NOKLTE_PS_LEPSB_LNCEL_HOUR lepsb ON lepsb.lncel_id = luest.lncel_id
AND lepsb.period_start_time = luest.period_start_time
AND lepsb.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND lepsb.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
and (Cast(To_Char(lepsb.PERIOD_START_TIME, 'hh24') As Number) = 12 or
    Cast(To_Char(lepsb.PERIOD_START_TIME, 'hh24') As Number) = 13 or
    Cast(To_Char(lepsb.PERIOD_START_TIME, 'hh24') As Number) = 22 or
    Cast(To_Char(lepsb.PERIOD_START_TIME, 'hh24') As Number) = 23 )

RIGHT JOIN C_LTE_CUSTOM c ON c.lncel_objid = luest.lncel_id and c.city is not null

WHERE
luest.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND luest.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
and (Cast(To_Char(luest.PERIOD_START_TIME, 'hh24') As Number) = 12 or
    Cast(To_Char(luest.PERIOD_START_TIME, 'hh24') As Number) = 13 or
    Cast(To_Char(luest.PERIOD_START_TIME, 'hh24') As Number) = 22 or
    Cast(To_Char(luest.PERIOD_START_TIME, 'hh24') As Number) = 23 )

GROUP BY
To_Date(To_Char(luest.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd'),
Cast(To_Char(luest.PERIOD_START_TIME, 'hh24') As Number),
luest.lncel_id,
c.city,
c.netmodel,
c.version

) tab2

GROUP BY
To_Date(To_Char(tab2.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd'),
--  tab2.lncel_enb_id,
--  tab2.lncel_lcr_id,
tab2.区域
) tab2,




(SELECT
To_Date(To_Char(tab3.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS DDATE,
--tab3.lncel_enb_id AS lncel_enb_id,
--tab3.lncel_lcr_id AS lncel_lcr_id,
--tab3.lnbts_name,
tab3.区域,
--tab3.version,
round(avg(tab3.RSSI_PUCCH_MIN),2) AS RSSI_PUCCH_MIN,
round(avg(tab3.RSSI_PUCCH_MAX),2) AS RSSI_PUCCH_MAX,
round(avg(tab3.RSSI_PUCCH_AVG),2) AS RSSI_PUCCH_AVG,
round(AVG(tab3.CELL_PUCCH_MEAN),2) AS CELL_PUCCH_MEAN,
round(avg(tab3.RSSI_PUSCH_MIN),2) AS RSSI_PUSCH_MIN,
round(avg(tab3.RSSI_PUSCH_MAX),2) AS RSSI_PUSCH_MAX,
round(avg(tab3.RSSI_PUSCH_AVG),2) AS RSSI_PUSCH_AVG,
round(AVG(tab3.CELL_PUSCH_MEAN),2) AS CELL_PUSCH_MEAN,
round(avg(tab3.平均每PRB干扰噪声功率),2) AS 平均每PRB干扰噪声功率
FROM
(SELECT
lpqul.lncel_id,
To_Date(To_Char(lpqul.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS pm_date,
Cast(To_Char(lpqul.PERIOD_START_TIME, 'hh24') As Number) As hour,
--c.lnbts_name AS lnbts_name,
--c.version,
(CASE
WHEN (c.city = 'Baoji' AND c.netmodel = 'FDD') THEN '宝鸡FDD'
WHEN (c.city = 'Baoji' AND c.netmodel = 'TDD') THEN '宝鸡TDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'FDD') THEN '西安FDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'TDD') THEN '西安TDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'FDD') THEN '咸阳FDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'TDD') THEN '咸阳TDD'
WHEN (c.city = 'Tongchuan' AND c.netmodel = 'TDD') THEN '铜川TDD'
WHEN (c.city = 'Hanzhong' AND c.netmodel = 'TDD') THEN '汉中TDD'
WHEN (c.city = 'Yulin' AND c.netmodel = 'TDD') THEN '榆林TDD'
WHEN (c.city = 'Yanan' AND c.netmodel = 'TDD') THEN '延安TDD'
WHEN (c.city = 'Shangluo' AND c.netmodel = 'TDD') THEN '商洛TDD'
ELSE NULL END) 区域,
avg(lpqul.RSSI_PUCCH_MIN) AS RSSI_PUCCH_MIN,
avg(lpqul.RSSI_PUCCH_MAX) AS RSSI_PUCCH_MAX,
avg(lpqul.RSSI_PUCCH_AVG) AS RSSI_PUCCH_AVG,
AVG(lpqul.RSSI_CELL_PUCCH_MEAN) AS CELL_PUCCH_MEAN,
avg(lpqul.RSSI_PUSCH_MIN) AS RSSI_PUSCH_MIN,
avg(lpqul.RSSI_PUSCH_MAX) AS RSSI_PUSCH_MAX,
avg(lpqul.RSSI_PUSCH_AVG) AS RSSI_PUSCH_AVG,
AVG(lpqul.RSSI_CELL_PUSCH_MEAN) AS CELL_PUSCH_MEAN,
decode(sum((lpqul.RSSI_PUSCH_LEVEL_01)+(lpqul.RSSI_PUSCH_LEVEL_02)+
(lpqul.RSSI_PUSCH_LEVEL_03)+(lpqul.RSSI_PUSCH_LEVEL_04)+(lpqul.RSSI_PUSCH_LEVEL_05)+
(lpqul.RSSI_PUSCH_LEVEL_06)+(lpqul.RSSI_PUSCH_LEVEL_07)+(lpqul.RSSI_PUSCH_LEVEL_08)+
(lpqul.RSSI_PUSCH_LEVEL_09)+(lpqul.RSSI_PUSCH_LEVEL_10)+(lpqul.RSSI_PUSCH_LEVEL_11)+
(lpqul.RSSI_PUSCH_LEVEL_12)+(lpqul.RSSI_PUSCH_LEVEL_13)+(lpqul.RSSI_PUSCH_LEVEL_14)+
(lpqul.RSSI_PUSCH_LEVEL_15)+(lpqul.RSSI_PUSCH_LEVEL_16)+(lpqul.RSSI_PUSCH_LEVEL_17)+
(lpqul.RSSI_PUSCH_LEVEL_18)+(lpqul.RSSI_PUSCH_LEVEL_19)+(lpqul.RSSI_PUSCH_LEVEL_20)+
(lpqul.RSSI_PUSCH_LEVEL_21)+(lpqul.RSSI_PUSCH_LEVEL_22)),0,-120,round(sum(-120*
(lpqul.RSSI_PUSCH_LEVEL_01)-119*(lpqul.RSSI_PUSCH_LEVEL_02)-117*(lpqul.RSSI_PUSCH_LEVEL_03)-
115*(lpqul.RSSI_PUSCH_LEVEL_04)-113*(lpqul.RSSI_PUSCH_LEVEL_05)-111*(lpqul.RSSI_PUSCH_LEVEL_06)-
109*(lpqul.RSSI_PUSCH_LEVEL_07)-107*(lpqul.RSSI_PUSCH_LEVEL_08)-105*(lpqul.RSSI_PUSCH_LEVEL_09)-
103*(lpqul.RSSI_PUSCH_LEVEL_10)-101*(lpqul.RSSI_PUSCH_LEVEL_11)-99*(lpqul.RSSI_PUSCH_LEVEL_12)-
97*(lpqul.RSSI_PUSCH_LEVEL_13)-95*(lpqul.RSSI_PUSCH_LEVEL_14)-93*(lpqul.RSSI_PUSCH_LEVEL_15)-
91*(lpqul.RSSI_PUSCH_LEVEL_16)-89*(lpqul.RSSI_PUSCH_LEVEL_17)-87*(lpqul.RSSI_PUSCH_LEVEL_18)-
85*(lpqul.RSSI_PUSCH_LEVEL_19)-83*(lpqul.RSSI_PUSCH_LEVEL_20)-81*(lpqul.RSSI_PUSCH_LEVEL_21)-
80*(lpqul.RSSI_PUSCH_LEVEL_22))/sum((lpqul.RSSI_PUSCH_LEVEL_01)+(lpqul.RSSI_PUSCH_LEVEL_02)+
(lpqul.RSSI_PUSCH_LEVEL_03)+(lpqul.RSSI_PUSCH_LEVEL_04)+(lpqul.RSSI_PUSCH_LEVEL_05)+
(lpqul.RSSI_PUSCH_LEVEL_06)+(lpqul.RSSI_PUSCH_LEVEL_07)+(lpqul.RSSI_PUSCH_LEVEL_08)+
(lpqul.RSSI_PUSCH_LEVEL_09)+(lpqul.RSSI_PUSCH_LEVEL_10)+(lpqul.RSSI_PUSCH_LEVEL_11)+
(lpqul.RSSI_PUSCH_LEVEL_12)+(lpqul.RSSI_PUSCH_LEVEL_13)+(lpqul.RSSI_PUSCH_LEVEL_14)+
(lpqul.RSSI_PUSCH_LEVEL_15)+(lpqul.RSSI_PUSCH_LEVEL_16)+(lpqul.RSSI_PUSCH_LEVEL_17)+
(lpqul.RSSI_PUSCH_LEVEL_18)+(lpqul.RSSI_PUSCH_LEVEL_19)+(lpqul.RSSI_PUSCH_LEVEL_20)+
(lpqul.RSSI_PUSCH_LEVEL_21)+(lpqul.RSSI_PUSCH_LEVEL_22)),2)) -

decode(sum((lpqul.SINR_PUSCH_LEVEL_1)+(lpqul.SINR_PUSCH_LEVEL_2)+(lpqul.SINR_PUSCH_LEVEL_3)+
(lpqul.SINR_PUSCH_LEVEL_4)+(lpqul.SINR_PUSCH_LEVEL_5)+(lpqul.SINR_PUSCH_LEVEL_6)+(lpqul.SINR_PUSCH_LEVEL_7)
+(lpqul.SINR_PUSCH_LEVEL_8)+(lpqul.SINR_PUSCH_LEVEL_9)+(lpqul.SINR_PUSCH_LEVEL_10)+
(lpqul.SINR_PUSCH_LEVEL_11)+(lpqul.SINR_PUSCH_LEVEL_12)+(lpqul.SINR_PUSCH_LEVEL_13)+
(lpqul.SINR_PUSCH_LEVEL_14)+(lpqul.SINR_PUSCH_LEVEL_15)+(lpqul.SINR_PUSCH_LEVEL_16)+
(lpqul.SINR_PUSCH_LEVEL_17)+(lpqul.SINR_PUSCH_LEVEL_18)+(lpqul.SINR_PUSCH_LEVEL_19)+
(lpqul.SINR_PUSCH_LEVEL_20)+(lpqul.SINR_PUSCH_LEVEL_21)+(lpqul.SINR_PUSCH_LEVEL_22)),0,0,
round(sum(-10*(lpqul.SINR_PUSCH_LEVEL_1)-9*(lpqul.SINR_PUSCH_LEVEL_2)-7*(lpqul.SINR_PUSCH_LEVEL_3)-
5*(lpqul.SINR_PUSCH_LEVEL_4)-3*(lpqul.SINR_PUSCH_LEVEL_5)-1*(lpqul.SINR_PUSCH_LEVEL_6)
+1*(lpqul.SINR_PUSCH_LEVEL_7)+3*(lpqul.SINR_PUSCH_LEVEL_8)+5*(lpqul.SINR_PUSCH_LEVEL_9)+
7*(lpqul.SINR_PUSCH_LEVEL_10)+9*(lpqul.SINR_PUSCH_LEVEL_11)+11*(lpqul.SINR_PUSCH_LEVEL_12)+
13*(lpqul.SINR_PUSCH_LEVEL_13)+15*(lpqul.SINR_PUSCH_LEVEL_14)+17*(lpqul.SINR_PUSCH_LEVEL_15)+
19*(lpqul.SINR_PUSCH_LEVEL_16)+21*(lpqul.SINR_PUSCH_LEVEL_17)+23*(lpqul.SINR_PUSCH_LEVEL_18)+
25*(lpqul.SINR_PUSCH_LEVEL_19)+27*(lpqul.SINR_PUSCH_LEVEL_20)+29*(lpqul.SINR_PUSCH_LEVEL_21)+
30*(lpqul.SINR_PUSCH_LEVEL_22))/sum((lpqul.SINR_PUSCH_LEVEL_1)+(lpqul.SINR_PUSCH_LEVEL_2)+(lpqul.SINR_PUSCH_LEVEL_3)+
(lpqul.SINR_PUSCH_LEVEL_4)+(lpqul.SINR_PUSCH_LEVEL_5)+(lpqul.SINR_PUSCH_LEVEL_6)+(lpqul.SINR_PUSCH_LEVEL_7)
+(lpqul.SINR_PUSCH_LEVEL_8)+(lpqul.SINR_PUSCH_LEVEL_9)+(lpqul.SINR_PUSCH_LEVEL_10)+
(lpqul.SINR_PUSCH_LEVEL_11)+(lpqul.SINR_PUSCH_LEVEL_12)+(lpqul.SINR_PUSCH_LEVEL_13)+
(lpqul.SINR_PUSCH_LEVEL_14)+(lpqul.SINR_PUSCH_LEVEL_15)+(lpqul.SINR_PUSCH_LEVEL_16)+
(lpqul.SINR_PUSCH_LEVEL_17)+(lpqul.SINR_PUSCH_LEVEL_18)+(lpqul.SINR_PUSCH_LEVEL_19)+
(lpqul.SINR_PUSCH_LEVEL_20)+(lpqul.SINR_PUSCH_LEVEL_21)+(lpqul.SINR_PUSCH_LEVEL_22)),2))  AS 平均每PRB干扰噪声功率

FROM
NOKLTE_PS_LPQUL_LNCEL_hour lpqul
INNER JOIN C_LTE_CUSTOM c ON c.lncel_objid = lpqul.lncel_id and c.city is not null

WHERE
lpqul.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND lpqul.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
and (Cast(To_Char(lpqul.PERIOD_START_TIME, 'hh24') As Number) = 12 or
    Cast(To_Char(lpqul.PERIOD_START_TIME, 'hh24') As Number) = 13 or
    Cast(To_Char(lpqul.PERIOD_START_TIME, 'hh24') As Number) = 22 or
    Cast(To_Char(lpqul.PERIOD_START_TIME, 'hh24') As Number) = 23 )

GROUP BY
To_Date(To_Char(lpqul.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd'),
Cast(To_Char(lpqul.PERIOD_START_TIME, 'hh24') As Number),
lpqul.lncel_id,
c.version,
c.city,
c.netmodel

) tab3

GROUP BY
To_Date(To_Char(tab3.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd'),
--  tab3.lncel_enb_id,
--  tab3.lncel_lcr_id,
--  tab3.lnbts_name,
--  tab3.version,
tab3.区域

) tab3,


(SELECT
To_Date(To_Char(tab4.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS DDATE,
-- tab4.lncel_enb_id AS lncel_enb_id,
--  tab4.lncel_lcr_id AS lncel_lcr_id,
-- tab4.lnbts_name,
tab4.区域,
-- tab4.version,
round(decode(sum(tab4.同频切换请求次数),0,0,sum(tab4.同频切换成功次数)/sum(tab4.同频切换请求次数))*100,2) AS 同频切换成功率,
sum(tab4.同频切换请求次数) AS 同频切换请求次数,
sum(tab4.同频切换成功次数) AS 同频切换成功次数,
round(decode(sum(tab4.异频切换请求次数),0,0,sum(tab4.异频切换出成功次数)/sum(tab4.异频切换请求次数))*100,2) AS 异频切换成功率,
sum(tab4.异频切换请求次数) AS 异频切换请求次数,
sum(tab4.异频切换出成功次数) AS 异频切换出成功次数

FROM
(SELECT
lianbho.lncel_id,
To_Date(To_Char(lianbho.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd')  AS pm_date,
Cast(To_Char(lianbho.PERIOD_START_TIME, 'hh24') As Number) As hour,
--c.lnbts_name AS lnbts_name,
--c.version,
(CASE
WHEN (c.city = 'Baoji' AND c.netmodel = 'FDD') THEN '宝鸡FDD'
WHEN (c.city = 'Baoji' AND c.netmodel = 'TDD') THEN '宝鸡TDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'FDD') THEN '西安FDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'TDD') THEN '西安TDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'FDD') THEN '咸阳FDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'TDD') THEN '咸阳TDD'
WHEN (c.city = 'Tongchuan' AND c.netmodel = 'TDD') THEN '铜川TDD'
WHEN (c.city = 'Hanzhong' AND c.netmodel = 'TDD') THEN '汉中TDD'
WHEN (c.city = 'Yulin' AND c.netmodel = 'TDD') THEN '榆林TDD'
WHEN (c.city = 'Yanan' AND c.netmodel = 'TDD') THEN '延安TDD'
WHEN (c.city = 'Shangluo' AND c.netmodel = 'TDD') THEN '商洛TDD'
ELSE NULL END) 区域,
round(DECODE(SUM(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT),0,0，SUM(lianbho.SUCC_INTRA_ENB_HO+lienbho.SUCC_INTER_ENB_HO+LIENBHO.INTER_ENB_S1_HO_SUCC-LHO.HO_INTFREQ_SUCC)/SUM(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT))*100,2) AS 同频切换成功率，
SUM(lianbho.ATT_INTRA_ENB_HO+lienbho.ATT_INTER_ENB_HO+lienbho.INTER_ENB_S1_HO_ATT-lho.HO_INTFREQ_ATT) AS 同频切换请求次数,
SUM(lianbho.SUCC_INTRA_ENB_HO+lienbho.SUCC_INTER_ENB_HO+LIENBHO.INTER_ENB_S1_HO_SUCC-LHO.HO_INTFREQ_SUCC) AS 同频切换成功次数,
round(decode(SUM(lho.HO_INTFREQ_ATT),0,0,SUM(lho.HO_INTFREQ_SUCC)/SUM(lho.HO_INTFREQ_SUCC))*100,2) AS 异频切换成功率，
SUM(lho.HO_INTFREQ_ATT) AS 异频切换请求次数,
SUM(lho.HO_INTFREQ_SUCC) AS 异频切换出成功次数

FROM

NOKLTE_PS_LIENBHO_LNCEL_HOUR lienbho
INNER JOIN NOKLTE_PS_LIANBHO_LNCEL_HOUR lianbho ON lienbho.lncel_id = lianbho.lncel_id
AND lienbho.period_start_time = lianbho.period_start_time
AND lianbho.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND lianbho.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
and (Cast(To_Char(lianbho.PERIOD_START_TIME, 'hh24') As Number) = 12 or
    Cast(To_Char(lianbho.PERIOD_START_TIME, 'hh24') As Number) = 13 or
    Cast(To_Char(lianbho.PERIOD_START_TIME, 'hh24') As Number) = 22 or
    Cast(To_Char(lianbho.PERIOD_START_TIME, 'hh24') As Number) = 23 )


INNER JOIN NOKLTE_PS_LHO_LNCEL_HOUR lho ON lienbho.lncel_id = lho.lncel_id
AND lienbho.period_start_time = lho.period_start_time
AND lho.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND lho.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
and (Cast(To_Char(lho.PERIOD_START_TIME, 'hh24') As Number) = 12 or
    Cast(To_Char(lho.PERIOD_START_TIME, 'hh24') As Number) = 13 or
    Cast(To_Char(lho.PERIOD_START_TIME, 'hh24') As Number) = 22 or
    Cast(To_Char(lho.PERIOD_START_TIME, 'hh24') As Number) = 23 )
    
INNER JOIN C_LTE_CUSTOM c ON c.lncel_objid = lienbho.lncel_id and c.city is not null


WHERE
lienbho.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND lienbho.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
and (Cast(To_Char(lienbho.PERIOD_START_TIME, 'hh24') As Number) = 12 or
    Cast(To_Char(lienbho.PERIOD_START_TIME, 'hh24') As Number) = 13 or
    Cast(To_Char(lienbho.PERIOD_START_TIME, 'hh24') As Number) = 22 or
    Cast(To_Char(lienbho.PERIOD_START_TIME, 'hh24') As Number) = 23 )

GROUP BY
lianbho.lncel_id,
To_Date(To_Char(lianbho.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') ,
Cast(To_Char(lianbho.PERIOD_START_TIME, 'hh24') As Number),
c.city,
c.netmodel

) tab4
GROUP BY
To_Date(To_Char(tab4.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd'),
-- tab4.lncel_enb_id,
--  tab4.lncel_lcr_id,
-- tab4.lnbts_name,
-- tab4.version,
tab4.区域

) tab4，




(SELECT
To_Date(To_Char(tab5.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS DDATE,
--   tab5.lncel_enb_id AS lncel_enb_id,
--   tab5.lncel_lcr_id AS lncel_lcr_id,
tab5.区域,
round(sum(tab5.空口上行业务字节数MB)/1024,2) AS 空口上行业务字节数MB,---MByte 单位
--round(decode(sum(tab4.ACTIVE_TTI_UL),0,0,(sum(tab4.空口上行业务字节数MB)*1000*8)/sum(tab4.ACTIVE_TTI_UL)/1024),2) AS 空口上行业务平均速率,---Mbps单位
round(sum(tab5.空口下行业务字节数MB)/1024,2) AS 空口下行业务字节数MB ---MByte 单位
--round(decode(sum(tab4.ACTIVE_TTI_DL),0,0,(sum(tab4.空口下行业务字节数MB)*1000*8)/sum(tab4.ACTIVE_TTI_DL)/1024),2) AS 空口下行业务平均速率---Mbps单位

FROM
(SELECT
lcellt.lncel_id,
To_Date(To_Char(lcellt.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS pm_date,
Cast(To_Char(lcellt.PERIOD_START_TIME, 'hh24') As Number) As hour,
(CASE
WHEN (c.city = 'Baoji' AND c.netmodel = 'FDD') THEN '宝鸡FDD'
WHEN (c.city = 'Baoji' AND c.netmodel = 'TDD') THEN '宝鸡TDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'FDD') THEN '西安FDD'
WHEN (c.city = 'Xian' AND c.netmodel = 'TDD') THEN '西安TDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'FDD') THEN '咸阳FDD'
WHEN (c.city = 'Xianyang' AND c.netmodel = 'TDD') THEN '咸阳TDD'
WHEN (c.city = 'Tongchuan' AND c.netmodel = 'TDD') THEN '铜川TDD'
WHEN (c.city = 'Hanzhong' AND c.netmodel = 'TDD') THEN '汉中TDD'
WHEN (c.city = 'Yulin' AND c.netmodel = 'TDD') THEN '榆林TDD'
WHEN (c.city = 'Yanan' AND c.netmodel = 'TDD') THEN '延安TDD'
WHEN (c.city = 'Shangluo' AND c.netmodel = 'TDD') THEN '商洛TDD'
ELSE NULL END) 区域,
--decode(sum(lcellt.ACTIVE_TTI_UL),0,0,sum(lcellt.PDCP_SDU_VOL_UL) * 8 * 1000 /sum(lcellt.ACTIVE_TTI_UL*1024)) AS 空口上行业务平均速率,
SUM(PDCP_SDU_VOL_UL) / 1024 AS 空口上行业务字节数MB,
--sum(lcellt.ACTIVE_TTI_UL)  AS ACTIVE_TTI_UL,
--decode(sum(lcellt.ACTIVE_TTI_DL), 0, 0,sum(lcellt.PDCP_SDU_VOL_DL) * 8 * 1000 /sum(lcellt.ACTIVE_TTI_DL*1024)) AS 空口下行业务平均速率,
SUM(PDCP_SDU_VOL_DL) / 1024 AS 空口下行业务字节数MB
--sum(lcellt.ACTIVE_TTI_DL) AS ACTIVE_TTI_DL

FROM
NOKLTE_PS_LCELLT_LNCEL_HOUR lcellt
INNER JOIN C_LTE_CUSTOM c ON c.lncel_objid = lcellt.lncel_id and c.city is not null

WHERE
lcellt.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND lcellt.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
and (Cast(To_Char(lcellt.PERIOD_START_TIME, 'hh24') As Number) = 12 or
    Cast(To_Char(lcellt.PERIOD_START_TIME, 'hh24') As Number) = 13 or
    Cast(To_Char(lcellt.PERIOD_START_TIME, 'hh24') As Number) = 22 or
    Cast(To_Char(lcellt.PERIOD_START_TIME, 'hh24') As Number) = 23 )

GROUP BY
To_Date(To_Char(lcellt.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd'),
Cast(To_Char(lcellt.PERIOD_START_TIME, 'hh24') As Number),
lcellt.lncel_id,
c.city,
c.netmodel

) tab5

GROUP BY
-- tab5.pm_date,
To_Date(To_Char(tab5.pm_date, 'yyyy-mm-dd'), 'yyyy-mm-dd'),
--  tab5.lncel_enb_id,
--  tab5.lncel_lcr_id,
tab5.区域

) tab5


WHERE
tab1.DDATE = tab2.DDATE AND tab1.区域 = tab2.区域
AND tab1.DDATE = tab3.DDATE AND tab1.区域 = tab3.区域
AND tab1.DDATE = tab4.DDATE AND tab1.区域 = tab4.区域
AND tab1.DDATE = tab5.DDATE AND tab1.区域 = tab5.区域
--  AND tab1.DDATE = tab6.DDATE AND tab1.lncel_enb_id = tab6.lncel_enb_id AND tab1.lncel_lcr_id = tab6.lncel_lcr_id
--  AND tab1.DDATE = tab7.DDATE AND tab1.lncel_enb_id = tab7.lncel_enb_id AND tab1.lncel_lcr_id = tab7.lncel_lcr_id
--  AND tab1.DDATE = tab8.DDATE AND tab1.lncel_enb_id = tab8.lncel_enb_id AND tab1.lncel_lcr_id = tab8.lncel_lcr_id
--  AND tab1.DDATE = tab9.DDATE AND tab1.lncel_enb_id = tab9.lncel_enb_id AND tab1.lncel_lcr_id = tab9.lncel_lcr_id
--  AND tab1.DDATE = tab10.DDATE AND tab1.lncel_enb_id = tab10.lncel_enb_id AND tab1.lncel_lcr_id = tab10.lncel_lcr_id
-- AND tab1.DDATE = tab11.DDATE AND tab1.lncel_enb_id = tab11.lncel_enb_id AND tab1.lncel_lcr_id = tab11.lncel_lcr_id
--AND tab1.区域 IS NOT NULL
order by
tab1.区域
