SELECT

(CASE
WHEN c.city = 'Baoji' THEN '宝鸡'
WHEN c.city = 'Xianyang' THEN '咸阳'
WHEN c.city = 'Tongchuan' THEN '铜川'
WHEN c.city = 'Hanzhong' THEN '汉中'
WHEN c.city = 'Yulin' THEN '榆林'
WHEN c.city = 'Yanan' THEN '延安'
WHEN c.city = 'Shangluo' THEN '商洛'
WHEN c.city = 'Other' THEN '其他'
ELSE NULL END) as "地市",
 
--cellres.WCEL_ID,
cellres.PERIOD_START_TIME AS "日期",
--cellres.hour as hour,

/* servlev.RRC建立成功率 AS "RRC连接建立成功率(%)", */
round(decode(sum(servlev.RRC建立成功率_Y),0,null,
    sum(servlev.RRC建立成功率_X)/sum(servlev.RRC建立成功率_Y))*100,2) AS "RRC连接建立成功率(%)",


/* servlev.语音rab建立成功率 AS "电路域RAB建立成功率(%)", */
round(decode(sum(servlev.语音rab建立成功率_Y),0,null,
    sum(servlev.语音rab建立成功率_X)/sum(servlev.语音rab建立成功率_Y))*100,2) AS "电路域RAB建立成功率(%)",

/* servlev.分组rab建立成功率 AS "分组域RAB建立成功率(%)", */
round(decode(sum(servlev.分组rab建立成功率_Y),0,null,
    sum(servlev.分组rab建立成功率_X)/sum(servlev.分组rab建立成功率_Y))*100,2) AS "分组域RAB建立成功率(%)",

/* servlev.语音业务掉话率 AS "电路域业务掉话率(%)", */
round(decode(sum(servlev.语音业务掉话率_Y),0,null,
    sum(servlev.语音业务掉话率_X)/sum(servlev.语音业务掉话率_Y))*100,2) AS "电路域业务掉话率(%)",

/* servlev.分组业务掉线率 AS "分组域业务掉话率(%)", */
round(decode(sum(servlev.分组业务掉线率_Y),0,null,
    sum(servlev.分组业务掉线率_X)/sum(servlev.分组业务掉线率_Y))*100,2) AS "分组域业务掉话率(%)",

/* softho.小区软切换成功率 AS "软切换成功率(%)", */
round(decode(sum(softho.小区软切换成功率_Y),0,null,
    sum(softho.小区软切换成功率_X)/sum(softho.小区软切换成功率_Y))*100,2) AS "软切换成功率(%)",


/* softho.软切换比例 AS "软切换比例(%)", */
round(decode(sum(softho.软切换比例_Y),0,null,
    sum(softho.软切换比例_X)/sum(softho.软切换比例_Y))*100,2) AS "软切换成功率(%)",

/* intsysho.同频硬切换成功率 AS "同频硬切换成功率(%)", */
round(decode(sum(intsysho.同频硬切换成功率_Y),0,null,
    sum(intsysho.同频硬切换成功率_X)/sum(intsysho.同频硬切换成功率_Y))*100,2) AS "同频硬切换成功率(%)",

/* intsysho.RNC异频硬切换成功率 AS "RNC异频硬切换成功率(%)", */
round(decode(sum(intsysho.RNC异频硬切换成功率_Y),0,null,
    sum(intsysho.RNC异频硬切换成功率_X)/sum(intsysho.RNC异频硬切换成功率_Y))*100,2) AS "RNC异频硬切换成功率(%)",

/* cellres.小区上行平均rtwp AS "RTWP平均值(dBm)", */
avg(cellres.小区上行平均rtwp) AS "RTWP平均值(dBm)",

/* servlev.小区寻呼拥塞率 AS "小区寻呼拥塞率(%)", */
round(decode(sum(servlev.小区寻呼拥塞率_Y),0,null,
    sum(servlev.小区寻呼拥塞率_X)/sum(servlev.小区寻呼拥塞率_Y))*100,2) AS "小区寻呼拥塞率(%)",



round(SUM(traffic.语音含切话务量)/4,2) AS "语音(ERL)",

round(SUM(celltp.数据下行MB)/4,2) AS "数据下行(MB)",

round(SUM(celltp.数据上行MB)/4,2) AS "数据上行(MB)"




FROM
(SELECT
cellres.WCEL_ID,
cellres.PERIOD_START_TIME  AS PERIOD_START_TIME,

Round(Avg(10 * Log(10, (((0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_0 / 10)) / 10) * cellres.PRXTOT_DENOM_0 + 0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_1 / 10)) / 10) * cellres.PRXTOT_DENOM_1 + 0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_2 / 10)) / 10) * cellres.PRXTOT_DENOM_2 + 0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_3 / 10)) / 10) * cellres.PRXTOT_DENOM_3 + 0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_4 / 10)) / 10) * cellres.PRXTOT_DENOM_4) / Decode(cellres.PRXTOT_DENOM_0 + cellres.PRXTOT_DENOM_1 + cellres.PRXTOT_DENOM_2 + cellres.PRXTOT_DENOM_3 + cellres.PRXTOT_DENOM_4, 0, Null, cellres.PRXTOT_DENOM_0 + cellres.PRXTOT_DENOM_1 + cellres.PRXTOT_DENOM_2 + cellres.PRXTOT_DENOM_3 + cellres.PRXTOT_DENOM_4) + decode( (Power(10,(hsdpa.HSUPA_UL_PWR_AVG / 10)) / 1000 * hsdpa.HSUPA_UL_PWR_AVG) / Decode(hsdpa.HSUPA_UL_PWR_AVG, 0, Null, hsdpa.HSUPA_UL_PWR_AVG),null,0, (Power(10,(hsdpa.HSUPA_UL_PWR_AVG / 10)) / 1000 * hsdpa.HSUPA_UL_PWR_AVG) / Decode(hsdpa.HSUPA_UL_PWR_AVG, 0, Null
, hsdpa.HSUPA_UL_PWR_AVG)) ) / 0.001))),8) AS 小区上行平均RTWP

From
NOKRWW_PS_CELLRES_MNC1_RAW cellres

LEFT JOIN
NOKRWW_PS_HSDPAW_MNC1_RAW hsdpa
ON cellres.period_start_time = hsdpa.period_start_time
--AND cellres.RNC_ID = hsdpa.RNC_ID
--AND cellres.WBTS_ID = hsdpa.WBTS_ID
AND cellres.WCEL_ID = hsdpa.WCEL_ID
AND hsdpa.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND hsdpa.period_start_time < To_Date(&end_date, 'yyyy-mm-dd')

--LEFT JOIN C_W_CUSTOM c ON c.wcel_objid = cellres.wcel_id

WHERE
cellres.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND cellres.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
--AND C.CITY IS NOT NULL

GROUP BY
cellres.WCEL_ID,
cellres.PERIOD_START_TIME

) cellres,





(SELECT
intsysho.WCEL_ID,
intsysho.PERIOD_START_TIME  AS PERIOD_START_TIME,

/* Round(decode(sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt),0, Null,
(sum(intsysho.succ_inter_hho_att_rt+intsysho.succ_inter_hho_att_nrt)/
sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt)))*100,4) As RNC异频硬切换成功率, */

sum(intsysho.succ_inter_hho_att_rt+intsysho.succ_inter_hho_att_nrt) As RNC异频硬切换成功率_X,
sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt)  As RNC异频硬切换成功率_Y,

/* Round(decode(sum(intsysho.hho_att_caused_sho_incap_rt+intsysho.immed_hho_csd_sho_incap_rt+
intsysho.hho_att_caused_sho_incap_nrt+intsysho.immed_hho_csd_sho_incap_nrt),0,Null,
(sum(intsysho.succ_hho_caused_sho_incap_rt+intsysho.succ_hho_sho_incap_nrt)/
sum(intsysho.hho_att_caused_sho_incap_rt+intsysho.immed_hho_csd_sho_incap_rt+
intsysho.hho_att_caused_sho_incap_nrt+intsysho.immed_hho_csd_sho_incap_nrt)))*100,4) As 同频硬切换成功率 */

sum(intsysho.succ_hho_caused_sho_incap_rt+intsysho.succ_hho_sho_incap_nrt) As 同频硬切换成功率_X,
sum(intsysho.hho_att_caused_sho_incap_rt+intsysho.immed_hho_csd_sho_incap_rt+
    intsysho.hho_att_caused_sho_incap_nrt+intsysho.immed_hho_csd_sho_incap_nrt)  As 同频硬切换成功率_Y



From
Nokrww_Ps_Intsysho_Mnc1_Raw intsysho

WHERE
intsysho.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND intsysho.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')

GROUP BY
intsysho.WCEL_ID,
intsysho.PERIOD_START_TIME

) intsysho,






(SELECT
servlev.WCEL_ID,
servlev.PERIOD_START_TIME  AS PERIOD_START_TIME,


/* Round(Decode(Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR
- servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
servlev.RRC_CONN_SETUP_ATT_REPEAT + rrc.CELL_FACH_STATE_CELL_PCH_INA +
rrc.CELL_DCH_STATE_TO_CELL_PCH), 0, Null, Sum(servlev.RRC_CONN_ACC_COMP +
servlev.RRC_CON_SETUP_COMP_DIRECTED + rrc.CELL_FACH_STATE_CELL_PCH_INA +
rrc.CELL_DCH_STATE_TO_CELL_PCH) / (Sum(servlev.RRC_CONN_STP_ATT +
servlev.RRC_CONN_SETUP_COMP_AFT_DIR - servlev.RRC_CONN_STP_REJ_EMERG_CALL -
servlev.RRC_CONN_ACC_REL_CELL_RESEL - servlev.RRC_CONN_SETUP_ATT_REPEAT +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH)))*100, 4) As RRC建立成功率, */

Sum(servlev.RRC_CONN_ACC_COMP + servlev.RRC_CON_SETUP_COMP_DIRECTED +
    rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As RRC建立成功率_X,

Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR -
    servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
    servlev.RRC_CONN_SETUP_ATT_REPEAT + rrc.CELL_FACH_STATE_CELL_PCH_INA +
    rrc.CELL_DCH_STATE_TO_CELL_PCH) As RRC建立成功率_Y,

/* Round(Decode(Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH), 0,
Null, Sum(servlev.RAB_ACC_COMP_PS_CONV + servlev.RAB_ACC_COMP_PS_STREA +
servlev.RAB_ACC_COMP_PS_INTER + servlev.RAB_ACC_COMP_PS_BACKG +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) /
(Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH)))*100, 4) As 分组RAB建立成功率, */


Sum(servlev.RAB_ACC_COMP_PS_CONV + servlev.RAB_ACC_COMP_PS_STREA +
    servlev.RAB_ACC_COMP_PS_INTER + servlev.RAB_ACC_COMP_PS_BACKG +
    rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As 分组RAB建立成功率_X,

Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
    servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
    rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As 分组RAB建立成功率_Y,

/* Round(Decode(Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
servlev.RAB_ACT_COMP_PS_INTER + servlev.RAB_ACT_COMP_PS_BACKG +
servlev.RAB_ACT_REL_PS_CONV_SRNC + servlev.RAB_ACT_REL_PS_CONV_P_EMP +
servlev.RAB_ACT_REL_PS_STREA_SRNC + servlev.RAB_ACT_REL_PS_STREA_P_EMP +
servlev.RAB_ACT_REL_PS_INTER_SRNC + servlev.RAB_ACT_REL_PS_BACKG_SRNC +
servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH), 0,
Null, Sum(servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE -
servlev.RAB_ACT_FAIL_PS_INT_PCH - servlev.RAB_ACT_FAIL_PS_BACKG_PCH) /
Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
servlev.RAB_ACT_COMP_PS_INTER + servlev.RAB_ACT_COMP_PS_BACKG +
servlev.RAB_ACT_REL_PS_CONV_SRNC + servlev.RAB_ACT_REL_PS_CONV_P_EMP +
servlev.RAB_ACT_REL_PS_STREA_SRNC + servlev.RAB_ACT_REL_PS_STREA_P_EMP +
servlev.RAB_ACT_REL_PS_INTER_SRNC + servlev.RAB_ACT_REL_PS_BACKG_SRNC +
servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH))*100, 4) As 分组业务掉线率, */

Sum(servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
  servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
  servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
  servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
  servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
  servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
  servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
  servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
  servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
  servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
  servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
  servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE -
  servlev.RAB_ACT_FAIL_PS_INT_PCH - servlev.RAB_ACT_FAIL_PS_BACKG_PCH) As 分组业务掉线率_X,

Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
  servlev.RAB_ACT_COMP_PS_INTER + servlev.RAB_ACT_COMP_PS_BACKG +
  servlev.RAB_ACT_REL_PS_CONV_SRNC + servlev.RAB_ACT_REL_PS_CONV_P_EMP +
  servlev.RAB_ACT_REL_PS_STREA_SRNC + servlev.RAB_ACT_REL_PS_STREA_P_EMP +
  servlev.RAB_ACT_REL_PS_INTER_SRNC + servlev.RAB_ACT_REL_PS_BACKG_SRNC +
  servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
  servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
  servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
  servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
  servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
  servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
  servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
  servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
  servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
  servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
  servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
  servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE +
  rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As 分组业务掉线率_Y,



/* Round(Decode(Sum(servlev.RAB_ACT_COMP_CS_VOICE +
servlev.RAB_ACT_REL_CS_VOICE_SRNC + servlev.RAB_ACT_REL_CS_VOICE_P_EMP +
servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE),
0, Null, Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU +
servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
servlev.RAB_ACT_FAIL_CS_VOICE_UE) / Sum(servlev.RAB_ACT_COMP_CS_VOICE +
servlev.RAB_ACT_REL_CS_VOICE_SRNC + servlev.RAB_ACT_REL_CS_VOICE_P_EMP +
servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE))*100, 4) As 语音业务掉话率, */

Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
    servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
    servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE) As 语音业务掉话率_X,

Sum(servlev.RAB_ACT_COMP_CS_VOICE + servlev.RAB_ACT_REL_CS_VOICE_SRNC +
    servlev.RAB_ACT_REL_CS_VOICE_P_EMP + servlev.RAB_ACT_FAIL_CS_VOICE_IU +
    servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
    servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
  servlev.RAB_ACT_FAIL_CS_VOICE_UE) As 语音业务掉话率_Y,

/* 
Round(Decode(Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER +
servlev.RAB_STP_ATT_PS_BACKG), 0, Null, Sum(servlev.RAB_STP_FAIL_CS_VOICE_FROZBS
+ servlev.RAB_STP_FAIL_CS_CONV_FROZBS + servlev.RAB_STP_FAIL_CS_STREA_FROZBS +
servlev.RAB_STP_FAIL_PS_CONV_FROZBS + servlev.RAB_STP_FAIL_PS_STREA_FROZBS +
servlev.RAB_STP_FAIL_PS_INTER_FROZBS + servlev.RAB_STP_FAIL_PS_BACKG_FROZBS +
servlev.RAB_STP_FAIL_CS_VOICE_RNC + servlev.RAB_STP_FAIL_CS_CONV_RNC +
servlev.RAB_STP_FAIL_CS_STREA_RNC + servlev.RAB_STP_FAIL_PS_CONV_RNC +
servlev.RAB_STP_FAIL_PS_STREA_RNC + servlev.RAB_STP_FAIL_PS_INTER_RNC +
servlev.RAB_STP_FAIL_PS_BACKG_RNC + servlev.RAB_STP_FAIL_CS_VOICE_AC +
servlev.RAB_STP_FAIL_CS_CONV_AC + servlev.RAB_STP_FAIL_CS_STREA_AC +
servlev.RAB_STP_FAIL_PS_CONV_AC + servlev.RAB_STP_FAIL_PS_STREA_AC +
servlev.RAB_STP_FAIL_PS_INTER_AC + servlev.RAB_STP_FAIL_PS_BACKG_AC +
servlev.RAB_STP_FAIL_CS_V_IUB_AAL2 + servlev.RAB_STP_FAIL_CS_CO_IUB_AAL2 +
servlev.RAB_STP_FAIL_CS_ST_IUB_AAL2 + servlev.RAB_STP_FAIL_PS_ST_IUB_AAL2) /
Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG))*100, 4) As 小区拥塞率, 
 */

Sum(servlev.RAB_STP_FAIL_CS_VOICE_FROZBS
    + servlev.RAB_STP_FAIL_CS_CONV_FROZBS + servlev.RAB_STP_FAIL_CS_STREA_FROZBS +
    servlev.RAB_STP_FAIL_PS_CONV_FROZBS + servlev.RAB_STP_FAIL_PS_STREA_FROZBS +
    servlev.RAB_STP_FAIL_PS_INTER_FROZBS + servlev.RAB_STP_FAIL_PS_BACKG_FROZBS +
    servlev.RAB_STP_FAIL_CS_VOICE_RNC + servlev.RAB_STP_FAIL_CS_CONV_RNC +
    servlev.RAB_STP_FAIL_CS_STREA_RNC + servlev.RAB_STP_FAIL_PS_CONV_RNC +
    servlev.RAB_STP_FAIL_PS_STREA_RNC + servlev.RAB_STP_FAIL_PS_INTER_RNC +
    servlev.RAB_STP_FAIL_PS_BACKG_RNC + servlev.RAB_STP_FAIL_CS_VOICE_AC +
    servlev.RAB_STP_FAIL_CS_CONV_AC + servlev.RAB_STP_FAIL_CS_STREA_AC +
    servlev.RAB_STP_FAIL_PS_CONV_AC + servlev.RAB_STP_FAIL_PS_STREA_AC +
    servlev.RAB_STP_FAIL_PS_INTER_AC + servlev.RAB_STP_FAIL_PS_BACKG_AC +
    servlev.RAB_STP_FAIL_CS_V_IUB_AAL2 + servlev.RAB_STP_FAIL_CS_CO_IUB_AAL2 +
    servlev.RAB_STP_FAIL_CS_ST_IUB_AAL2 + servlev.RAB_STP_FAIL_PS_ST_IUB_AAL2) AS 小区拥塞率_X,

Sum(servlev.RAB_STP_ATT_CS_VOICE + servlev.RAB_STP_ATT_CS_CONV +
    servlev.RAB_STP_ATT_CS_STREA + servlev.RAB_STP_ATT_PS_CONV +
    servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG) AS 小区拥塞率_Y,


/* 
Round(Decode(Sum(servlev.RAB_STP_ATT_CS_VOICE), 0, Null,
Sum(servlev.RAB_ACC_COMP_CS_VOICE) / (Sum(servlev.RAB_STP_ATT_CS_VOICE)))*100, 4) As 语音RAB建立成功率,
 */

Sum(servlev.RAB_ACC_COMP_CS_VOICE) AS 语音RAB建立成功率_X,
Sum(servlev.RAB_STP_ATT_CS_VOICE) AS 语音RAB建立成功率_Y,

/* 
Round(decode(SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH),Null,0,
(SUM(rrc.FAIL_PAG_NO_RESP_CELL_PCH + rrc.FAIL_PAG_NO_RESP_URA_PCH)/
SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH)))*100, 4) As 小区寻呼拥塞率
 */

SUM(rrc.FAIL_PAG_NO_RESP_CELL_PCH + rrc.FAIL_PAG_NO_RESP_URA_PCH) As 小区寻呼拥塞率_X,
SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH) As 小区寻呼拥塞率_Y

From
NOKRWW_PS_SERVLEV_MNC1_RAW servlev

Left Join
NOKRWW_PS_RRC_MNC1_RAW rrc
ON servlev.period_start_time = rrc.period_start_time
AND servlev.WCEL_ID = rrc.WCEL_ID
AND rrc.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND rrc.period_start_time < To_Date(&end_date, 'yyyy-mm-dd')

WHERE
servlev.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND servlev.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')


GROUP BY
servlev.WCEL_ID,
servlev.PERIOD_START_TIME

) servlev,





(SELECT
softho.WCEL_ID,
softho.PERIOD_START_TIME  AS PERIOD_START_TIME,
/* 
Round(Decode(Sum(softho.CELL_ADD_REQ_ON_SHO_FOR_RT +
    softho.CELL_DEL_REQ_ON_SHO_FOR_RT + softho.CELL_REPL_REQ_ON_SHO_FOR_RT +
    softho.CELL_ADD_REQ_ON_SHO_FOR_NRT + softho.CELL_DEL_REQ_ON_SHO_FOR_NRT +
    softho.CELL_REPL_REQ_ON_SHO_FOR_NRT), 0, Null,
    Sum(softho.SUCC_UPDATES_ON_SHO_FOR_RT + softho.SUCC_UPDATES_ON_SHO_FOR_NRT) /
    Sum(softho.CELL_ADD_REQ_ON_SHO_FOR_RT + softho.CELL_DEL_REQ_ON_SHO_FOR_RT +
    softho.CELL_REPL_REQ_ON_SHO_FOR_RT + softho.CELL_ADD_REQ_ON_SHO_FOR_NRT +
    softho.CELL_DEL_REQ_ON_SHO_FOR_NRT + softho.CELL_REPL_REQ_ON_SHO_FOR_NRT))*100, 4) As 小区软切换成功率,
  */   

Sum(softho.SUCC_UPDATES_ON_SHO_FOR_RT + softho.SUCC_UPDATES_ON_SHO_FOR_NRT)  As 小区软切换成功率_X,
Sum(softho.CELL_ADD_REQ_ON_SHO_FOR_RT + softho.CELL_DEL_REQ_ON_SHO_FOR_RT +
    softho.CELL_REPL_REQ_ON_SHO_FOR_RT + softho.CELL_ADD_REQ_ON_SHO_FOR_NRT +
    softho.CELL_DEL_REQ_ON_SHO_FOR_NRT + softho.CELL_REPL_REQ_ON_SHO_FOR_NRT) As 小区软切换成功率_Y,
  

/* 
round(decode(sum((nvl((softho.ONE_CELL_IN_ACT_SET_FOR_RT + softho.ONE_CELL_IN_ACT_SET_FOR_NRT)*1,0)+
    nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*2,0)+
    nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*3,0))),0,NULL,
    sum((nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*1,0)+
    nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*2,0))) /
    sum((nvl((softho.ONE_CELL_IN_ACT_SET_FOR_RT + softho.ONE_CELL_IN_ACT_SET_FOR_NRT)*1,0)+
    nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*2,0)+
    nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*3,0)))*100),3) AS 软切换比例
 */
sum((nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*1,0)+
    nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*2,0))) AS 软切换比例_X,
sum((nvl((softho.ONE_CELL_IN_ACT_SET_FOR_RT + softho.ONE_CELL_IN_ACT_SET_FOR_NRT)*1,0)+
    nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*2,0)+
    nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*3,0))) AS 软切换比例_Y



From
NOKRWW_PS_SOFTHO_MNC1_RAW softho

WHERE
softho.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND softho.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')

GROUP BY
softho.WCEL_ID,
softho.PERIOD_START_TIME 

) softho,



(SELECT
traffic.WCEL_ID,
traffic.PERIOD_START_TIME  AS PERIOD_START_TIME,

round(SUM((traffic.DUR_FOR_AMR_4_75_UL_IN_SRNC+ traffic.DUR_FOR_AMR_5_15_UL_IN_SRNC +
traffic.DUR_FOR_AMR_5_9_UL_IN_SRNC+ traffic.DUR_FOR_AMR_6_7_UL_IN_SRNC+
traffic.DUR_FOR_AMR_7_4_UL_IN_SRNC+ traffic.DUR_FOR_AMR_7_95_UL_IN_SRNC+
traffic.DUR_FOR_AMR_10_2_UL_IN_SRNC+ traffic.DUR_FOR_AMR_12_2_UL_IN_SRNC)/(
traffic.PERIOD_DURATION*100*60)),2) As 语音含切话务量



From
NOKRWW_PS_TRAFFIC_MNC1_RAW traffic

WHERE
traffic.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND traffic.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')

GROUP BY
traffic.WCEL_ID,
traffic.PERIOD_START_TIME 

) traffic,



(SELECT
celltp.WCEL_ID,
celltp.PERIOD_START_TIME  AS PERIOD_START_TIME,

--Round(Sum(celltp.NRT_DCH_DL_DATA_VOL / 1000000), 8) As R99_DL数据吞吐量,
--(Sum((celltp.NRT_DCH_UL_DATA_VOL + celltp.NRT_DCH_HSDPA_UL_DATA_VOL) / 1000000), 8) As R99_UL数据吞吐量,
--Round(Sum(celltp.HS_DSCH_DATA_VOL / 1000000), 8) As HSDPA数据吞吐量,
--Round(Sum(celltp.NRT_EDCH_UL_DATA_VOL / 1000000), 8) As HSUPA数据吞吐量

Round(Sum(celltp.NRT_DCH_DL_DATA_VOL + celltp.HS_DSCH_DATA_VOL) / 1000000, 8) AS 数据下行MB,

Round(Sum(celltp.NRT_DCH_UL_DATA_VOL + celltp.NRT_DCH_HSDPA_UL_DATA_VOL +
celltp.NRT_EDCH_UL_DATA_VOL) / 1000000, 8) AS 数据上行MB
From
NOKRWW_PS_CELLTP_MNC1_RAW celltp

WHERE
celltp.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND celltp.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
 
GROUP BY
    celltp.WCEL_ID,
    celltp.PERIOD_START_TIME

) celltp,


c_w_Custom c




WHERE
    servlev.PERIOD_START_TIME = cellres.PERIOD_START_TIME and servlev.WCEL_ID = cellres.WCEL_ID
AND softho.PERIOD_START_TIME = cellres.PERIOD_START_TIME and softho.WCEL_ID = cellres.WCEL_ID
AND intsysho.PERIOD_START_TIME = cellres.PERIOD_START_TIME and intsysho.WCEL_ID = cellres.WCEL_ID
AND traffic.PERIOD_START_TIME = cellres.PERIOD_START_TIME and traffic.WCEL_ID = cellres.WCEL_ID
AND celltp.PERIOD_START_TIME = cellres.PERIOD_START_TIME and celltp.WCEL_ID = cellres.WCEL_ID

AND c.wcel_objid = cellres.WCEL_ID 

GROUP BY
--cellres.WCEL_ID,
c.city,
cellres.PERIOD_START_TIME