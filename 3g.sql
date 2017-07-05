SELECT
(CASE
WHEN cellres.city = 'Baoji' THEN '����'
WHEN cellres.city = 'Xianyang' THEN '����'
WHEN cellres.city = 'Tongchuan' THEN 'ͭ��'
WHEN cellres.city = 'Hanzhong' THEN '����'
WHEN cellres.city = 'Yulin' THEN '����'
WHEN cellres.city = 'Yanan' THEN '�Ӱ�'
WHEN cellres.city = 'Shangluo' THEN '����'
WHEN cellres.city = 'Other' THEN '����'
ELSE NULL END) as "����",

cellres.PERIOD_START_TIME AS "����",
servlev.RRC�����ɹ��� AS "RRC���ӽ����ɹ���(%)",
servlev.����rab�����ɹ��� AS "��·��RAB�����ɹ���(%)",
servlev.����rab�����ɹ��� AS "������RAB�����ɹ���(%)",
servlev.����ҵ������� AS "��·��ҵ�������(%)",
servlev.����ҵ������� AS "������ҵ�������(%)",
softho.С�����л��ɹ��� AS "���л��ɹ���(%)",
softho.���л����� AS "���л�����(%)",
intsysho.ͬƵӲ�л��ɹ��� AS "ͬƵӲ�л��ɹ���(%)",
intsysho.RNC��ƵӲ�л��ɹ��� AS "RNC��ƵӲ�л��ɹ���(%)",
cellres.С������ƽ��rtwp AS "RTWPƽ��ֵ(dBm)",
servlev.С��Ѱ��ӵ���� AS "С��Ѱ��ӵ����(%)",
traffic.�������л����� AS "����(ERL)",
celltp.��������MB AS "��������(MB)",
celltp.��������MB AS "��������(MB)"
FROM
(SELECT
-- c.wcel_rnc_id AS RNC_ID,
c.city AS CITY,
To_Date(To_Char(cellres.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS PERIOD_START_TIME,
Round(Avg(10 * Log(10, (((0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_0 / 10)) / 10) * cellres.PRXTOT_DENOM_0 + 0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_1 / 10)) / 10) * cellres.PRXTOT_DENOM_1 + 0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_2 / 10)) / 10) * cellres.PRXTOT_DENOM_2 + 0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_3 / 10)) / 10) * cellres.PRXTOT_DENOM_3 + 0.001 * Power(10, ( -112 + (cellres.AVE_PRXTOT_CLASS_4 / 10)) / 10) * cellres.PRXTOT_DENOM_4) / Decode(cellres.PRXTOT_DENOM_0 + cellres.PRXTOT_DENOM_1 + cellres.PRXTOT_DENOM_2 + cellres.PRXTOT_DENOM_3 + cellres.PRXTOT_DENOM_4, 0, Null, cellres.PRXTOT_DENOM_0 + cellres.PRXTOT_DENOM_1 + cellres.PRXTOT_DENOM_2 + cellres.PRXTOT_DENOM_3 + cellres.PRXTOT_DENOM_4) + decode( (Power(10,(hsdpa.HSUPA_UL_PWR_AVG / 10)) / 1000 * hsdpa.HSUPA_UL_PWR_AVG) / Decode(hsdpa.HSUPA_UL_PWR_AVG, 0, Null, hsdpa.HSUPA_UL_PWR_AVG),null,0, (Power(10,(hsdpa.HSUPA_UL_PWR_AVG / 10)) / 1000 * hsdpa.HSUPA_UL_PWR_AVG) / Decode(hsdpa.HSUPA_UL_PWR_AVG, 0, Null
, hsdpa.HSUPA_UL_PWR_AVG)) ) / 0.001))),8) AS С������ƽ��RTWP

From
NOKRWW_PS_CELLRES_WCEL_DAY cellres

LEFT JOIN
NOKRWW_PS_HSDPAW_WCEL_DAY hsdpa
ON cellres.period_start_time = hsdpa.period_start_time
--AND cellres.RNC_ID = hsdpa.RNC_ID
--AND cellres.WBTS_ID = hsdpa.WBTS_ID
AND cellres.WCEL_ID = hsdpa.WCEL_ID
AND hsdpa.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND hsdpa.period_start_time < To_Date(&end_date, 'yyyy-mm-dd')

LEFT JOIN
C_W_CUSTOM c
ON c.wcel_objid = cellres.wcel_id

WHERE
cellres.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND cellres.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
AND C.CITY IS NOT NULL

GROUP BY
--c.wcel_rnc_id ,
c.city ,
To_Date(To_Char(cellres.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd')


) cellres,





(SELECT
-- c.wcel_rnc_id AS RNC_ID,
c.city AS CITY,
To_Date(To_Char(intsysho.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS PERIOD_START_TIME,

Round(decode(sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt),0, Null,
(sum(intsysho.succ_inter_hho_att_rt+intsysho.succ_inter_hho_att_nrt)/
sum(intsysho.inter_hho_att_rt+intsysho.inter_hho_att_nrt)))*100,4) As RNC��ƵӲ�л��ɹ���,

Round(decode(sum(intsysho.hho_att_caused_sho_incap_rt+intsysho.immed_hho_csd_sho_incap_rt+
intsysho.hho_att_caused_sho_incap_nrt+intsysho.immed_hho_csd_sho_incap_nrt),0,Null,
(sum(intsysho.succ_hho_caused_sho_incap_rt+intsysho.succ_hho_sho_incap_nrt)/
sum(intsysho.hho_att_caused_sho_incap_rt+intsysho.immed_hho_csd_sho_incap_rt+
intsysho.hho_att_caused_sho_incap_nrt+intsysho.immed_hho_csd_sho_incap_nrt)))*100,4) As ͬƵӲ�л��ɹ���



From
Nokrww_Ps_Intsysho_Wcel_Day intsysho

LEFT JOIN
C_W_CUSTOM c
ON c.wcel_objid = intsysho.wcel_id


WHERE
intsysho.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND intsysho.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
AND C.CITY IS NOT NULL

GROUP BY
--c.wcel_rnc_id ,
c.city ,
To_Date(To_Char(intsysho.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd')

) intsysho,






(SELECT
-- c.wcel_rnc_id AS RNC_ID,
c.city AS CITY,
To_Date(To_Char(servlev.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS PERIOD_START_TIME,
Round(Decode(Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR
- servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
servlev.RRC_CONN_SETUP_ATT_REPEAT + rrc.CELL_FACH_STATE_CELL_PCH_INA +
rrc.CELL_DCH_STATE_TO_CELL_PCH), 0, Null, Sum(servlev.RRC_CONN_ACC_COMP +
servlev.RRC_CON_SETUP_COMP_DIRECTED + rrc.CELL_FACH_STATE_CELL_PCH_INA +
rrc.CELL_DCH_STATE_TO_CELL_PCH) / (Sum(servlev.RRC_CONN_STP_ATT +
servlev.RRC_CONN_SETUP_COMP_AFT_DIR - servlev.RRC_CONN_STP_REJ_EMERG_CALL -
servlev.RRC_CONN_ACC_REL_CELL_RESEL - servlev.RRC_CONN_SETUP_ATT_REPEAT +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH)))*100, 4) As RRC�����ɹ���,

--Sum(servlev.RRC_CONN_ACC_COMP + servlev.RRC_CON_SETUP_COMP_DIRECTED +
--    rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As X_RRC�����ɹ���,

--Sum(servlev.RRC_CONN_STP_ATT + servlev.RRC_CONN_SETUP_COMP_AFT_DIR -
--    servlev.RRC_CONN_STP_REJ_EMERG_CALL - servlev.RRC_CONN_ACC_REL_CELL_RESEL -
--    servlev.RRC_CONN_SETUP_ATT_REPEAT + rrc.CELL_FACH_STATE_CELL_PCH_INA +
--    rrc.CELL_DCH_STATE_TO_CELL_PCH) As Y_RRC�����ɹ���,

Round(Decode(Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH), 0,
Null, Sum(servlev.RAB_ACC_COMP_PS_CONV + servlev.RAB_ACC_COMP_PS_STREA +
servlev.RAB_ACC_COMP_PS_INTER + servlev.RAB_ACC_COMP_PS_BACKG +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) /
(Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH)))*100, 4) As ����RAB�����ɹ���,

--Sum(servlev.RAB_ACC_COMP_PS_CONV + servlev.RAB_ACC_COMP_PS_STREA +
--    servlev.RAB_ACC_COMP_PS_INTER + servlev.RAB_ACC_COMP_PS_BACKG +
--    rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As X_����RAB�����ɹ���,

--Sum(servlev.RAB_STP_ATT_PS_CONV + servlev.RAB_STP_ATT_PS_STREA +
--    servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG +
--    rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As Y_����RAB�����ɹ���,

Round(Decode(Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
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
rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH))*100, 4) As ����ҵ�������,

--Sum(servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
--  servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
--  servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
--  servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
--  servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
--  servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
--  servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
--  servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
--  servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
--  servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
--  servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
--  servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE -
--  servlev.RAB_ACT_FAIL_PS_INT_PCH - servlev.RAB_ACT_FAIL_PS_BACKG_PCH) As X_����ҵ�������,

--Sum(servlev.RAB_ACT_COMP_PS_CONV + servlev.RAB_ACT_COMP_PS_STREA +
--  servlev.RAB_ACT_COMP_PS_INTER + servlev.RAB_ACT_COMP_PS_BACKG +
--  servlev.RAB_ACT_REL_PS_CONV_SRNC + servlev.RAB_ACT_REL_PS_CONV_P_EMP +
--  servlev.RAB_ACT_REL_PS_STREA_SRNC + servlev.RAB_ACT_REL_PS_STREA_P_EMP +
--  servlev.RAB_ACT_REL_PS_INTER_SRNC + servlev.RAB_ACT_REL_PS_BACKG_SRNC +
--  servlev.RAB_ACT_FAIL_PS_CONV_IU + servlev.RAB_ACT_FAIL_PS_CONV_RADIO +
--  servlev.RAB_ACT_FAIL_PS_CONV_BTS + servlev.RAB_ACT_FAIL_PS_CONV_IUR +
--  servlev.RAB_ACT_FAIL_PS_CONV_RNC + servlev.RAB_ACT_FAIL_PS_CONV_UE +
--  servlev.RAB_ACT_FAIL_PS_STREA_IU + servlev.RAB_ACT_FAIL_PS_STREA_RADIO +
--  servlev.RAB_ACT_FAIL_PS_STREA_BTS + servlev.RAB_ACT_FAIL_PS_STREA_IUR +
--  servlev.RAB_ACT_FAIL_PS_STREA_RNC + servlev.RAB_ACT_FAIL_PS_STREA_UE +
--  servlev.RAB_ACT_FAIL_PS_INTER_IU + servlev.RAB_ACT_FAIL_PS_INTER_RADIO +
--  servlev.RAB_ACT_FAIL_PS_INTER_BTS + servlev.RAB_ACT_FAIL_PS_INTER_IUR +
--  servlev.RAB_ACT_FAIL_PS_INTER_RNC + servlev.RAB_ACT_FAIL_PS_INTER_UE +
--  servlev.RAB_ACT_FAIL_PS_BACKG_IU + servlev.RAB_ACT_FAIL_PS_BACKG_RADIO +
--  servlev.RAB_ACT_FAIL_PS_BACKG_BTS + servlev.RAB_ACT_FAIL_PS_BACKG_IUR +
--  servlev.RAB_ACT_FAIL_PS_BACKG_RNC + servlev.RAB_ACT_FAIL_PS_BACKG_UE +
--  rrc.CELL_FACH_STATE_CELL_PCH_INA + rrc.CELL_DCH_STATE_TO_CELL_PCH) As Y_����ҵ�������,



Round(Decode(Sum(servlev.RAB_ACT_COMP_CS_VOICE +
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
servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE))*100, 4) As ����ҵ�������,

--Sum(servlev.RAB_ACT_FAIL_CS_VOICE_IU + servlev.RAB_ACT_FAIL_CS_VOICE_RADIO +
--    servlev.RAB_ACT_FAIL_CS_VOICE_BTS + servlev.RAB_ACT_FAIL_CS_VOICE_IUR +
--    servlev.RAB_ACT_FAIL_CS_VOICE_RNC + servlev.RAB_ACT_FAIL_CS_VOICE_UE) As X_����ҵ�������,

--Sum(servlev.RAB_ACT_COMP_CS_VOICE + servlev.RAB_ACT_REL_CS_VOICE_SRNC +
--    servlev.RAB_ACT_REL_CS_VOICE_P_EMP + servlev.RAB_ACT_FAIL_CS_VOICE_IU +
--    servlev.RAB_ACT_FAIL_CS_VOICE_RADIO + servlev.RAB_ACT_FAIL_CS_VOICE_BTS +
--    servlev.RAB_ACT_FAIL_CS_VOICE_IUR + servlev.RAB_ACT_FAIL_CS_VOICE_RNC +
--  servlev.RAB_ACT_FAIL_CS_VOICE_UE) As Y_����ҵ�������,

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
servlev.RAB_STP_ATT_PS_STREA + servlev.RAB_STP_ATT_PS_INTER + servlev.RAB_STP_ATT_PS_BACKG))*100, 4) As С��ӵ����,

Round(Decode(Sum(servlev.RAB_STP_ATT_CS_VOICE), 0, Null,
Sum(servlev.RAB_ACC_COMP_CS_VOICE) / (Sum(servlev.RAB_STP_ATT_CS_VOICE)))*100, 4) As ����RAB�����ɹ���,



Round(decode(SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH),Null,0,
(SUM(rrc.FAIL_PAG_NO_RESP_CELL_PCH + rrc.FAIL_PAG_NO_RESP_URA_PCH)/
SUM(rrc.CELL_UPD_AFTER_PAG_CELL_PCH + rrc.CELL_UPD_AFTER_PAG_URA_PCH)))*100, 4) As С��Ѱ��ӵ����

From
NOKRWW_PS_SERVLEV_MNC1_RAW servlev

Left Join
NOKRWW_PS_RRC_MNC1_RAW rrc
ON servlev.period_start_time = rrc.period_start_time
--AND servlev.RNC_ID = rrc.RNC_ID
--AND servlev.WBTS_ID = rrc.WBTS_ID
AND servlev.WCEL_ID = rrc.WCEL_ID
AND rrc.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND rrc.period_start_time < To_Date(&end_date, 'yyyy-mm-dd')



LEFT JOIN
C_W_CUSTOM c
ON c.wcel_objid = servlev.WCEL_ID


WHERE
servlev.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND servlev.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
AND C.CITY IS NOT NULL

GROUP BY
--c.wcel_rnc_id ,
c.city ,
To_Date(To_Char(servlev.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd')


) servlev,





(SELECT
-- c.wcel_rnc_id AS RNC_ID,
c.city AS CITY,
To_Date(To_Char(softho.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS PERIOD_START_TIME,

Round(Decode(Sum(softho.CELL_ADD_REQ_ON_SHO_FOR_RT +
    softho.CELL_DEL_REQ_ON_SHO_FOR_RT + softho.CELL_REPL_REQ_ON_SHO_FOR_RT +
    softho.CELL_ADD_REQ_ON_SHO_FOR_NRT + softho.CELL_DEL_REQ_ON_SHO_FOR_NRT +
    softho.CELL_REPL_REQ_ON_SHO_FOR_NRT), 0, Null,
    Sum(softho.SUCC_UPDATES_ON_SHO_FOR_RT + softho.SUCC_UPDATES_ON_SHO_FOR_NRT) /
    Sum(softho.CELL_ADD_REQ_ON_SHO_FOR_RT + softho.CELL_DEL_REQ_ON_SHO_FOR_RT +
    softho.CELL_REPL_REQ_ON_SHO_FOR_RT + softho.CELL_ADD_REQ_ON_SHO_FOR_NRT +
    softho.CELL_DEL_REQ_ON_SHO_FOR_NRT + softho.CELL_REPL_REQ_ON_SHO_FOR_NRT))*100, 4) As С�����л��ɹ���,

round(decode(sum((nvl((softho.ONE_CELL_IN_ACT_SET_FOR_RT + softho.ONE_CELL_IN_ACT_SET_FOR_NRT)*1,0)+
    nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*2,0)+
    nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*3,0))),0,NULL,
    sum((nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*1,0)+
    nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*2,0))) /
    sum((nvl((softho.ONE_CELL_IN_ACT_SET_FOR_RT + softho.ONE_CELL_IN_ACT_SET_FOR_NRT)*1,0)+
    nvl((softho.TWO_CELLS_IN_ACT_SET_FOR_RT + softho.TWO_CELLS_IN_ACT_SET_FOR_NRT)*2,0)+
    nvl((softho.THREE_CELLS_IN_ACT_SET_RT + softho.THREE_CELLS_IN_ACT_SET_NRT)*3,0)))*100),3) AS ���л�����






From
NOKRWW_PS_SOFTHO_WCEL_DAY softho

LEFT JOIN
C_W_CUSTOM c
ON c.wcel_objid = softho.wcel_id


WHERE
softho.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND softho.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
AND C.CITY IS NOT NULL

GROUP BY
--c.wcel_rnc_id ,
c.city ,
To_Date(To_Char(softho.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd')


) softho,



(SELECT
-- c.wcel_rnc_id AS RNC_ID,
c.city AS CITY,
To_Date(To_Char(traffic.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS PERIOD_START_TIME,

Round(SUM((traffic.DUR_FOR_AMR_4_75_UL_IN_SRNC+ traffic.DUR_FOR_AMR_5_15_UL_IN_SRNC +
traffic.DUR_FOR_AMR_5_9_UL_IN_SRNC+ traffic.DUR_FOR_AMR_6_7_UL_IN_SRNC+
traffic.DUR_FOR_AMR_7_4_UL_IN_SRNC+ traffic.DUR_FOR_AMR_7_95_UL_IN_SRNC+
traffic.DUR_FOR_AMR_10_2_UL_IN_SRNC+ traffic.DUR_FOR_AMR_12_2_UL_IN_SRNC)/(
traffic.PERIOD_DURATION*100*60)),2) As �������л�����

From
NOKRWW_PS_TRAFFIC_MNC1_RAW traffic

LEFT JOIN
C_W_CUSTOM c
ON c.wcel_objid = traffic.wcel_id


WHERE
traffic.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND traffic.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
AND C.CITY IS NOT NULL

GROUP BY
--c.wcel_rnc_id ,
c.city ,
To_Date(To_Char(traffic.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd')


) traffic,



(SELECT
-- c.wcel_rnc_id AS RNC_ID,
c.city AS CITY,
To_Date(To_Char(celltp.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd') AS PERIOD_START_TIME,

--Round(Sum(celltp.NRT_DCH_DL_DATA_VOL / 1000000), 8) As R99_DL����������,
--(Sum((celltp.NRT_DCH_UL_DATA_VOL + celltp.NRT_DCH_HSDPA_UL_DATA_VOL) / 1000000), 8) As R99_UL����������,
--Round(Sum(celltp.HS_DSCH_DATA_VOL / 1000000), 8) As HSDPA����������,
--Round(Sum(celltp.NRT_EDCH_UL_DATA_VOL / 1000000), 8) As HSUPA����������

Round(Sum(celltp.NRT_DCH_DL_DATA_VOL + celltp.HS_DSCH_DATA_VOL) / 1000000, 8) AS ��������MB,

Round(Sum(celltp.NRT_DCH_UL_DATA_VOL + celltp.NRT_DCH_HSDPA_UL_DATA_VOL +
celltp.NRT_EDCH_UL_DATA_VOL) / 1000000, 8) AS ��������MB
From
NOKRWW_PS_CELLTP_WCEL_DAY celltp

LEFT JOIN
C_W_CUSTOM c
ON c.wcel_objid = celltp.wcel_id


WHERE
celltp.period_start_time >= To_Date(&start_date, 'yyyy-mm-dd')
AND celltp.period_start_time <  To_Date(&end_date, 'yyyy-mm-dd')
AND C.CITY IS NOT NULL

GROUP BY
--c.wcel_rnc_id ,
c.city ,
To_Date(To_Char(celltp.PERIOD_START_TIME, 'yyyy-mm-dd'), 'yyyy-mm-dd')

) celltp



WHERE
servlev.CITY = cellres.CITY AND servlev.PERIOD_START_TIME = cellres.PERIOD_START_TIME
AND softho.CITY = cellres.CITY AND softho.PERIOD_START_TIME = cellres.PERIOD_START_TIME
AND intsysho.CITY = cellres.CITY AND intsysho.PERIOD_START_TIME = cellres.PERIOD_START_TIME
AND traffic.CITY = cellres.CITY AND traffic.PERIOD_START_TIME = cellres.PERIOD_START_TIME
AND celltp.CITY = cellres.CITY AND celltp.PERIOD_START_TIME = cellres.PERIOD_START_TIME



order by
cellres.city
