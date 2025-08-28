/*****************************************************************************
 * SISTEMA  : ROTINA EVENTUAL                                                *
 * PROGRAMA : DEMO_API.PRG   		                                     *
 * OBJETIVO : Consumir Serviços da APi                                       *
 * AUTOR    : Marcelo Antonio Lázzaro Carli                                  *
 * DATA     : 23.06.2025                                                     *
 * ULT. ALT.: 28.08.2025                                                     *
 *****************************************************************************/
#include <minigui.ch>

// https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/calculadora/documentacao

Procedure Main()
   Local cBody:= cBody1:= cBody2:= cBody3:= cBody4:= cBody5:= []

   REQUEST HB_LANG_PT
   REQUEST HB_CODEPAGE_PTISO
   REQUEST HB_CODEPAGE_PT850  &&& PARA INDEXAR CAMPOS ACENTUADOS
   REQUEST DBFCDX, DBFFPT
   HB_LangSelect([PT])
   HB_SETCODEPAGE([PT850])    &&& PARA INDEXAR CAMPOS ACENTUADOS
   RDDSETDEFAULT([DBFCDX])
   Set Date Briti             &&& data no formato dd/mm/aaaados
   Set Dele On                &&& ignora registros marcados por deleção
   Set Score Off
   Set Exact On
   Setcancel(.F.)             &&& evitar cancelar sistema c/ ALT + C
   Set Cent On                &&& ano com 4 dígitos
   Set Epoch to 2000          &&& ano a partir de 2000
  
   cBody:= '{"valorIntegralCobrado": 105, "ajusteValorOperacao": 5, "juros": 5, "multas": 5, "acrescimos": 5, "encargos": 5, "descontosCondicionais": 5, "fretePorDentro": 5, "outrosTributos": 5, "demaisImportancias": 5, "icms": 5, "iss": 5, "pis": 5, "cofins": 5, "bonificacao": 5, "devolucaoVendas": 5}'
   
   cBody1:= '{"valorFornecimento": 105, "ajusteValorOperacao": 5, "juros": 5, "multas": 5, "acrescimos": 5, "encargos": 5, "descontosCondicionais": 5, "fretePorDentro": 5, "outrosTributos": 5, "impostoSeletivo": 5, "demaisImportancias": 5, "icms": 5, "iss": 5, "pis": 5, "cofins": 5 }'

   cBody2:= [<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe versao="4.00" Id="NFe35250712345678000190550010000000521000052101"><ide><cUF>35</cUF><cNF>00005210</cNF><natOp>VENDA DE MERCADORIA</natOp><mod>55</mod><serie>1</serie><nNF>52</nNF><dhEmi>2025-07-10T10:12:00-03:00</dhEmi><dhSaiEnt>2025-07-10T10:12:00-03:00</dhSaiEnt><tpNF>1</tpNF><idDest>1</idDest><cMunFG>3550308</cMunFG><tpImp>1</tpImp><tpEmis>1</tpEmis><cDV>1</cDV><tpAmb>2</tpAmb><finNFe>1</finNFe><indFinal>1</indFinal><indPres>0</indPres><procEmi>0</procEmi><verProc>4.00_B30</verProc></ide><emit><CNPJ>12345678000190</CNPJ><xNome>Empresa ficticia Ltda Me</xNome><xFant>Mentira e Mentirinhas</xFant><enderEmit><xLgr>Rua do Sossego</xLgr><nro>sn</nro><xBairro>Centro</xBairro><cMun>3550308</cMun><xMun>Sao Paulo</xMun><UF>SP</UF><CEP>04815130</CEP><cPais>1058</cPais><xPais>BRASIL</xPais><fone>11999990234</fone></enderEmit><IE>551303380162</IE><IM>1234</IM><CNAE>4751201</CNAE><CRT>1</CRT></emit><dest><CNPJ>99999999000191</CNPJ><xNome>NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL</xNome><enderDest><xLgr>Rua do Sossego mais sossegada</xLgr><nro>1234</nro><xBairro>Centro</xBairro><cMun>3550308</cMun><xMun>Sao Paulo</xMun><UF>SP</UF><CEP>17514250</CEP><cPais>1058</cPais><xPais>BRASIL</xPais><fone>14998881234</fone></enderDest><indIEDest>2</indIEDest><email>marceloalcarli@gmail.com</email></dest><autXML><CNPJ>99999999000191</CNPJ></autXML><autXML><CNPJ>99999999000292</CNPJ></autXML><autXML><CNPJ>99999999000293</CNPJ></autXML><det nItem="1"><prod><cProd>7908454806175</cProd><cEAN>SEM GTIN</cEAN><xProd>CHICOTE DA IGNICAO</xProd><NCM>84835090</NCM><CEST>1111111</CEST><CFOP>5405</CFOP><uCom>UN</uCom><qCom>1.0000</qCom><vUnCom>4.7700000000</vUnCom><vProd>4.77</vProd><cEANTrib>SEM GTIN</cEANTrib><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vUnTrib>4.7700000000</vUnTrib><indTot>1</indTot></prod><imposto><vTotTrib>4.77</vTotTrib><ICMS><ICMSSN500><orig>0</orig><CSOSN>500</CSOSN><vBCSTRet>0.00</vBCSTRet><pST>0.0000</pST><vICMSSubstituto>0.00</vICMSSubstituto><vICMSSTRet>0.00</vICMSSTRet><pRedBCEfet>0.0000</pRedBCEfet><vBCEfet>0.00</vBCEfet><pICMSEfet>0.0000</pICMSEfet><vICMSEfet>0.00</vICMSEfet></ICMSSN500></ICMS><PIS><PISAliq><CST>01</CST><vBC>0.00</vBC><pPIS>0.0000</pPIS><vPIS>0.00</vPIS></PISAliq></PIS><COFINS><COFINSAliq><CST>01</CST><vBC>0.00</vBC><pCOFINS>0.0000</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS><IS><CSTIS>000</CSTIS><cClassTribIS>000000</cClassTribIS><vBCIS>10.00</vBCIS><pIS>1.00</pIS><pISEspec>0.0000</pISEspec><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vIS>0.10</vIS></IS><IBSCBS><CST>010</CST><cClassTrib>00000001</cClassTrib><gIBSCBS><vBC>10.00</vBC><gIBSUF><pIBSUF>0.0000</pIBSUF><gDif><pDif>0.0000</pDif><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vIBSUF>0.00</vIBSUF></gIBSUF><gIBSMun><pIBSMun>0.0000</pIBSMun><gDif><pDif>0.0000</pDif><vCBSOp>0</vCBSOp><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vIBSMun>0.00</vIBSMun></gIBSMun><gCBS><pCBS>0.0000</pCBS><gDif><pDif>0.0000</pDif><vCBSOp>0</vCBSOp><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vCBS>0.00</vCBS></gCBS><gTribRegular><CSTReg/><cClassTribReg/><pAliqEfetRegIBSUF>0.0000</pAliqEfetRegIBSUF><vTribRegIBSUF>0.00</vTribRegIBSUF><pAliqEfetRegIBSMun>0.0000</pAliqEfetRegIBSMun><vTribRegIBSMun>0.00</vTribRegIBSMun><pAliqEfetRegCBS>0.0000</pAliqEfetRegCBS><vTribRegCBS>0.00</vTribRegCBS></gTribRegular><gIBSCredPres><cCredPres>01</cCredPres><pCredPres>0.0000</pCredPres><vCredPres>0.00</vCredPres></gIBSCredPres><gCBSCredPres><cCredPres>01</cCredPres><pCredPres>0.0000</pCredPres><vCredPres>0.00</vCredPres></gCBSCredPres></gIBSCBS></IBSCBS></imposto><infAdProd>Valor aproximado dos tributos federais, estaduais e municipais: R$ 4.77 Fonte IBPT.</infAdProd></det><det nItem="2"><prod><cProd>7908454806175</cProd><cEAN>SEM GTIN</cEAN><xProd>CHICOTE DA IGNICAO</xProd><NCM>84835090</NCM><CEST>1111111</CEST><CFOP>5405</CFOP><uCom>UN</uCom><qCom>1.0000</qCom><vUnCom>4.7700000000</vUnCom><vProd>4.77</vProd><cEANTrib>SEM GTIN</cEANTrib><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vUnTrib>4.7700000000</vUnTrib><indTot>1</indTot><arma><tpArma>0</tpArma><nSerie>1234567890</nSerie><nCano>8888888TV8UOP</nCano><descr>Descricao da arma com ate 256 caracteres</descr></arma><arma><tpArma>1</tpArma><nSerie>KJO1234567890</nSerie><nCano>AAA8888888TV8UO</nCano><descr>Descricao da arma com ate 256 caracteres</descr></arma><arma><tpArma>0</tpArma><nSerie>BC000123</nSerie><nCano>NCC000123</nCano><descr>CALIBRE:9mm,- COMPRIMENTO DO CANO:95mm (3.74),- ESPECIE:PISTOLA,- FUNCIONAMENTO:2,- MARCA:FABRICANTE,- QTD.CANOS:1,- NUMERO DE TIROS:15,- QTD.RAIAS:06,- SENTIDO RAIAS:2</descr></arma></prod><imposto><vTotTrib>4.77</vTotTrib><ICMS><ICMSSN500><orig>0</orig><CSOSN>500</CSOSN><vBCSTRet>0.00</vBCSTRet><pST>0.0000</pST><vICMSSubstituto>0.00</vICMSSubstituto><vICMSSTRet>0.00</vICMSSTRet><pRedBCEfet>0.0000</pRedBCEfet><vBCEfet>0.00</vBCEfet><pICMSEfet>0.0000</pICMSEfet><vICMSEfet>0.00</vICMSEfet></ICMSSN500></ICMS><PIS><PISAliq><CST>01</CST><vBC>0.00</vBC><pPIS>0.0000</pPIS><vPIS>0.00</vPIS></PISAliq></PIS><COFINS><COFINSAliq><CST>01</CST><vBC>0.00</vBC><pCOFINS>0.0000</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS><IS><CSTIS>000</CSTIS><cClassTribIS>000000</cClassTribIS><vBCIS>10.00</vBCIS><pIS>1.00</pIS><pISEspec>0.0000</pISEspec><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vIS>0.10</vIS></IS><IBSCBS><CST>010</CST><cClassTrib>00000001</cClassTrib><gIBSCBS><vBC>10.00</vBC><gIBSUF><pIBSUF>0.0000</pIBSUF><gDif><pDif>0.0000</pDif><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vIBSUF>0.00</vIBSUF></gIBSUF><gIBSMun><pIBSMun>0.0000</pIBSMun><gDif><pDif>0.0000</pDif><vCBSOp>0</vCBSOp><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vIBSMun>0.00</vIBSMun></gIBSMun><gCBS><pCBS>0.0000</pCBS><gDif><pDif>0.0000</pDif><vCBSOp>0</vCBSOp><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vCBS>0.00</vCBS></gCBS><gTribRegular><CSTReg/><cClassTribReg/><pAliqEfetRegIBSUF>0.0000</pAliqEfetRegIBSUF><vTribRegIBSUF>0.00</vTribRegIBSUF><pAliqEfetRegIBSMun>0.0000</pAliqEfetRegIBSMun><vTribRegIBSMun>0.00</vTribRegIBSMun><pAliqEfetRegCBS>0.0000</pAliqEfetRegCBS><vTribRegCBS>0.00</vTribRegCBS></gTribRegular><gIBSCredPres><cCredPres>01</cCredPres><pCredPres>0.0000</pCredPres><vCredPres>0.00</vCredPres></gIBSCredPres><gCBSCredPres><cCredPres>01</cCredPres><pCredPres>0.0000</pCredPres><vCredPres>0.00</vCredPres></gCBSCredPres></gIBSCBS></IBSCBS></imposto><infAdProd>Valor aproximado dos tributos federais, estaduais e municipais: R$ 4.77 Fonte IBPT.</infAdProd></det><det nItem="3"><prod><cProd>7908454806175</cProd><cEAN>SEM GTIN</cEAN><xProd>CHICOTE DA IGNICAO</xProd><NCM>84835090</NCM><CEST>1111111</CEST><CFOP>5405</CFOP><uCom>UN</uCom><qCom>1.0000</qCom><vUnCom>4.7700000000</vUnCom><vProd>4.77</vProd><cEANTrib>SEM GTIN</cEANTrib><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vUnTrib>4.7700000000</vUnTrib><indTot>1</indTot></prod><imposto><vTotTrib>4.77</vTotTrib><ICMS><ICMSSN500><orig>0</orig><CSOSN>500</CSOSN><vBCSTRet>0.00</vBCSTRet><pST>0.0000</pST><vICMSSubstituto>0.00</vICMSSubstituto><vICMSSTRet>0.00</vICMSSTRet><pRedBCEfet>0.0000</pRedBCEfet><vBCEfet>0.00</vBCEfet><pICMSEfet>0.0000</pICMSEfet><vICMSEfet>0.00</vICMSEfet></ICMSSN500></ICMS><PIS><PISAliq><CST>01</CST><vBC>0.00</vBC><pPIS>0.0000</pPIS><vPIS>0.00</vPIS></PISAliq></PIS><COFINS><COFINSAliq><CST>01</CST><vBC>0.00</vBC><pCOFINS>0.0000</pCOFINS><vCOFINS>0.00</vCOFINS></COFINSAliq></COFINS><IS><CSTIS>000</CSTIS><cClassTribIS>000000</cClassTribIS><vBCIS>10.00</vBCIS><pIS>1.00</pIS><pISEspec>0.0000</pISEspec><uTrib>UN</uTrib><qTrib>1.0000</qTrib><vIS>0.10</vIS></IS><IBSCBS><CST>010</CST><cClassTrib>00000001</cClassTrib><gIBSCBS><vBC>10.00</vBC><gIBSUF><pIBSUF>0.0000</pIBSUF><gDif><pDif>0.0000</pDif><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vIBSUF>0.00</vIBSUF></gIBSUF><gIBSMun><pIBSMun>0.0000</pIBSMun><gDif><pDif>0.0000</pDif><vCBSOp>0</vCBSOp><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vIBSMun>0.00</vIBSMun></gIBSMun><gCBS><pCBS>0.0000</pCBS><gDif><pDif>0.0000</pDif><vCBSOp>0</vCBSOp><vDif>0.00</vDif></gDif><gDevTrib><vDevTrib>0.00</vDevTrib></gDevTrib><gRed><pRedAliq>0.0000</pRedAliq><pAliqEfet>0.0000</pAliqEfet></gRed><vCBS>0.00</vCBS></gCBS><gTribRegular><CSTReg/><cClassTribReg/><pAliqEfetRegIBSUF>0.0000</pAliqEfetRegIBSUF><vTribRegIBSUF>0.00</vTribRegIBSUF><pAliqEfetRegIBSMun>0.0000</pAliqEfetRegIBSMun><vTribRegIBSMun>0.00</vTribRegIBSMun><pAliqEfetRegCBS>0.0000</pAliqEfetRegCBS><vTribRegCBS>0.00</vTribRegCBS></gTribRegular><gIBSCredPres><cCredPres>01</cCredPres><pCredPres>0.0000</pCredPres><vCredPres>0.00</vCredPres></gIBSCredPres><gCBSCredPres><cCredPres>01</cCredPres><pCredPres>0.0000</pCredPres><vCredPres>0.00</vCredPres></gCBSCredPres></gIBSCBS></IBSCBS></imposto><infAdProd>Valor aproximado dos tributos federais, estaduais e municipais: R$ 4.77 Fonte IBPT.</infAdProd></det><total><ICMSTot><vBC>0.00</vBC><vICMS>0.00</vICMS><vICMSDeson>0.00</vICMSDeson><vFCPUFDest>0.00</vFCPUFDest><vICMSUFDest>0.00</vICMSUFDest><vICMSUFRemet>0.00</vICMSUFRemet><vFCP>0.00</vFCP><vBCST>0.00</vBCST><vST>0.00</vST><vFCPST>0.00</vFCPST><vFCPSTRet>0.00</vFCPSTRet><vProd>9.54</vProd><vFrete>0.00</vFrete><vSeg>0.00</vSeg><vDesc>0.00</vDesc><vII>0.00</vII><vIPI>0.00</vIPI><vIPIDevol>0.00</vIPIDevol><vPIS>0.00</vPIS><vCOFINS>0.00</vCOFINS><vOutro>0.00</vOutro><vNF>9.54</vNF><vTotTrib>9.54</vTotTrib></ICMSTot></total><ISTot><vIS>0.10</vIS></ISTot><IBSCBSTot><vBCIBSCBS>0.00</vBCIBSCBS><gIBS><gIBSUF><vDif>0.00</vDif><vDevTrib>0.00</vDevTrib><vIBSUF>0.00</vIBSUF></gIBSUF><gIBSMun><vDif>0.00</vDif><vDevTrib>0.00</vDevTrib><vIBSMun>0.00</vIBSMun></gIBSMun><vIBS>0.00</vIBS><vCredPres>0.00</vCredPres><vCredPresCondSus>0.00</vCredPresCondSus></gIBS><gCBS><vDif>0.00</vDif><vDevTrib>0.00</vDevTrib><vCBS>0.00</vCBS><vCredPres>0.00</vCredPres><vCredPresCondSus>0.00</vCredPresCondSus></gCBS></IBSCBSTot><transp><modFrete>9</modFrete></transp><cobr><fat><nFat>Fatura numero 1</nFat><vOrig>1.00</vOrig><vDesc>1.00</vDesc><vLiq>1.00</vLiq></fat><dup><nDup>001 Duplicata</nDup><dVenc>2025-04-01</dVenc><vDup>1.00</vDup></dup><dup><nDup>002 Duplicata</nDup><dVenc>2025-05-01</dVenc><vDup>2.00</vDup></dup><dup><nDup>003 Duplicata</nDup><dVenc>2025-06-01</dVenc><vDup>5.00</vDup></dup></cobr><pag><detPag><indPag>0</indPag><tPag>01</tPag><vPag>1.00</vPag></detPag><detPag><indPag>0</indPag><tPag>02</tPag><vPag>1.00</vPag></detPag><detPag><indPag>1</indPag><tPag>03</tPag><vPag>7.54</vPag></detPag><vTroco>0.01</vTroco></pag><infAdic><infAdFisco>teste ao fisco</infAdFisco><infCpl>teste</infCpl></infAdic><infRespTec><CNPJ>99999999000191</CNPJ><xContato>responsavel tecnico</xContato><email>tecnico@tecnico.com.br</email><fone>11123456789</fone></infRespTec></infNFe></NFe>]

   cBody3:= '{"id": "6194602ea71cbf9431c236de4409d920", "versao": "0.0.1", "dataHoraEmissao": "2026-01-01T09:50:05-03:00", "municipio": 4314902, "uf": "RS", "itens": [ {"numero": 1, "ncm": "24021000", "nbs": "109052100", "cst": "000", "baseCalculo": 200, "quantidade": 1, "unidade": "LT", "impostoSeletivo": { "cst": "000", "baseCalculo": 200, "quantidade": 1, "unidade": "LT", "impostoInformado": 12, "cClassTrib": "000000" }, "tributacaoRegular": { "cst": "000", "cClassTrib": "000000" }, "cClassTrib": "000001" } ]}'

   cBody4:= '{ "objetos": [ {"nObj": 0, "tribCalc": { "IS": { "CSTIS": 0, "cClassTribIS": "string", "vBCIS": 0, "pIS": 0, "pISEspec": 0, "uTrib": "string", "qTrib": 0, "vIS": 0, "memoriaCalculo": "string" }, "IBSCBS": { "CST": 0, "cClassTrib": "string", "gIBSCBS": { "vBC": 0, "gIBSUF": { "pIBSUF": 0, "gDif": { "pDif": 0, "vDif": 0 }, "gDevTrib": { "vDevTrib": 0 }, "gRed": { "pRedAliq": 0, "pAliqEfet": 0 }, "vIBSUF": 0, "memoriaCalculo": "string" }, "gIBSMun": { "pIBSMun": 0, "gDif": { "pDif": 0, "vDif": 0 }, "gDevTrib": { "vDevTrib": 0 }, "gRed": { "pRedAliq": 0, "pAliqEfet": 0 }, "vIBSMun": 0, "memoriaCalculo": "string" }, "gCBS": { "pCBS": 0, "gDif": { "pDif": 0, "vDif": 0 }, "gDevTrib": { "vDevTrib": 0 }, "gRed": { "pRedAliq": 0, "pAliqEfet": 0 }, "vCBS": 0, "memoriaCalculo": "string" }, "gTribRegular": { "CSTReg": 0, "cClassTribReg": "string", "pAliqEfetRegIBSUF": 0, "vTribRegIBSUF": 0, "pAliqEfetRegIBSMun": 0, "vTribRegIBSMun": 0, "pAliqEfetRegCBS": 0, "vTribRegCBS": 0 }, "gIBSCredPres": { "cCredPres": 0, "pCredPres": 0, "vCredPres": 0, "vCredPresCondSus": 0 }, "gCBSCredPres": { "cCredPres": 0, "pCredPres": 0, "vCredPres": 0, "vCredPresCondSus": 0 }, "gTribCompraGov": { "pAliqIBSUF": 0, "vTribIBSUF": 0, "pAliqIBSMun": 0, "vTribIBSMun": 0, "pAliqCBS": 0, "vTribCBS": 0 } }, "gIBSCBSMono": { "qBCMono": 0, "adRemIBS": 0, "adRemCBS": 0, "vIBSMono": 0, "vCBSMono": 0, "qBCMonoReten": 0, "adRemIBSReten": 0, "vIBSMonoReten": 0, "adRemCBSReten": 0, "vCBSMonoReten": 0, "qBCMonoRet": 0, "adRemIBSRet": 0, "vIBSMonoRet": 0, "adRemCBSRet": 0, "vCBSMonoRet": 0, "pDifIBS": 0, "vIBSMonoDif": 0, "pDifCBS": 0, "vCBSMonoDif": 0, "vTotIBSMonoItem": 0, "vTotCBSMonoItem": 0 }, "gTransfCred": { "vIBS": 0, "vCBS": 0 }, "gCredPresIBSZFM": { "tpCredPresIBSZFM": 0, "vCredPresIBSZFM": 0 } } } } ], "total": { "tribCalc": { "ISTot": { "vIS": 0 }, "IBSCBSTot": { "vBCIBSCBS": 0, "gIBS": { "gIBSUF": { "vDif": 0, "vDevTrib": 0, "vIBSUF": 0 }, "gIBSMun": { "vDif": 0, "vDevTrib": 0, "vIBSMun": 0 }, "vIBS": 0, "vCredPres": 0, "vCredPresCondSus": 0 }, "gCBS": { "vDif": 0, "vDevTrib": 0, "vCBS": 0, "vCredPres": 0, "vCredPresCondSus": 0 }, "gMono": { "vIBSMono": 0, "vCBSMono": 0, "vIBSMonoReten": 0, "vCBSMonoReten": 0, "vIBSMonoRet": 0, "vCBSMonoRet": 0 } } } } }'

   cBody5:= '{"dataHoraEmissao": "2027-01-01T09:50:05-03:00","codigoMunicipioOrigem": 4314902,"ufMunicipioOrigem": "RS", "cst": "000","baseCalculo": 200,"trechos": [ { "numero": 1, "municipio": 4314902, "uf": "RS", "extensao": 10 } ], "cClassTrib": "000002"}'

   Set Font to "MS Sans Serif", 8
   DEFINE WINDOW f_demo AT 0, 0 WIDTH 800 HEIGHT 600 TITLE [Gerar Xml] ICON [demo.ico] MAIN NOSIZE NOMAXIMIZE
        DEFINE MAIN MENU 
  	     POPUP [&Manutenções]
                 MENUITEM [&1. Calcula IS]          ACTION {|| DownloadTexto([POST], [https://piloto-cbs.tributos.gov.br/servico/calculadora/base-calculo/is-mercadorias], cBody)}
                 MENUITEM [&2. Calcula CBS/IBS]     ACTION {|| DownloadTexto([POST], [https://piloto-cbs.tributos.gov.br/servico/calculadora/base-calculo/cbs-ibs-mercadorias], cBody1)}
                 MENUITEM [&3. Validar Xml]         ACTION {|| DownloadTexto([POST], [https://piloto-cbs.tributos.gov.br/servico/calculadora/validar-xml?tipo=tipo&subtipo=subtipo], cBody2)}
                 MENUITEM [&4. Calcula Tributos]    ACTION {|| DownloadTexto([POST], [https://piloto-cbs.tributos.gov.br/servico/calculadora/regime-geral], cBody3)}
                 MENUITEM [&5. Gerar Xml]           ACTION {|| DownloadTexto([POST], [https://piloto-cbs.tributos.gov.br/servico/calculadora/gerar-xml], cBody4)}
                 SEPARATOR		
                 MENUITEM [&6. Calculadora]         ACTION {|| DownloadTexto([POST], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/base-calculo/is-mercadorias])}
                 MENUITEM [&7. Ufs]                 ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/ufs])}
                 MENUITEM [&8. Municípios/SP]       ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/ufs/municipios?siglaUf=SP])}
                 MENUITEM [&9. CST - IS]            ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/situacoes-tributarias/imposto-seletivo?data=2027-01-01])}
                 MENUITEM [&A. CST - CBS/IBS]       ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/situacoes-tributarias/cbs-ibs?data=2026-01-01])}
                 MENUITEM [&B. NCM]                 ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/ncm?ncm=24021000&data=2026-01-01])}
                 MENUITEM [&C. NBS]                 ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/nbs?nbs=114052200&data=2026-01-01])}
                 MENUITEM [&D. Fund. Legal]         ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/fundamentacoes-legais?data=2027-01-01])}
                 MENUITEM [&E. Classtrib]           ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/classificacoes-tributarias/1?data=2026-01-01])}
                 MENUITEM [&F. Classtrib - IS]      ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/classificacoes-tributarias/imposto-seletivo?data=2027-01-01])}
                 MENUITEM [&G. Classtrib - CBS/IBS] ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/classificacoes-tributarias/cbs-ibs?data=2026-01-01])}
                 MENUITEM [&H. CBS - União]         ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/classificacoes-tributarias/cbs-ibs?data=2026-01-01])}
                 MENUITEM [&I. IBS - Estado]        ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/aliquota-uf?codigoUf=35&data=2026-01-01])}
                 MENUITEM [&J. IBS - Município]     ACTION {|| DownloadTexto([GET], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/dados-abertos/aliquota-municipio?codigoMunicipio=4314902&data=2026-01-01])}
                 MENUITEM [&K. IVA - Pedágio]       ACTION {|| DownloadTexto([POST], [https://piloto-cbs.tributos.gov.br/servico/calculadora-consumo/api/calculadora/pedagio], cBody5)}
                 SEPARATOR		
                 MENUITEM [Sair do Sistema] ACTION {|| ThisWindow.Release}
             END POPUP	           

             POPUP [&Fim]         
                 MENUITEM [Sair do Sistema] ACTION {|| ThisWindow.Release}
   	     END POPUP
        END MENU
          
        On Key ESCAPE of f_demo ACTION {|| ThisWindow.Release}
   END WINDOW

   DoMethod([f_demo], [Center])
   DoMethod([f_demo], [Maximize])
   DoMethod([f_demo], [Activate])
Return (Nil)

****************** Rotina Genérica para Download *******************************
Function DownloadTexto(cMetodo, cUrl, cBody)
   Local oSoap, cRetorno:= []

   BEGIN SEQUENCE WITH __BreakBlock()
      oSoap:= Win_OleCreateObject([MSXML2.ServerXMLHTTP.6.0])
      oSoap:SetTimeouts(30000, 30000, 30000, 30000)
      oSoap:Open(cMetodo, cUrl, .F.)
      oSoap:SetRequestHeader([Content-Type], [application/json])
      oSoap:SetRequestHeader([Accept], [application/json])

      If !Empty(cBody)
         oSoap:Send(cBody)
      Else
         oSoap:Send()
      Endif
      oSoap:WaitForResponse(5000)
      cRetorno:= oSoap:ResponseBody()
   END SEQUENCE

   Hb_MemoWrit([consulta.txt], cRetorno)

   MsgInfo(cRetorno, [Sucesso na Consulta])

   Release oSoap
Return(cRetorno)
****************** Fim Rotina Genérica para Download ***************************

Static Procedure fBuscarpfx()
*   Local oXml:= Malc_GeraXml():New()  // Chamar a classe para gerar xml nfse no objeto oXml 
   Local cCert:= GetFile({{[Certificados], [*.pfx]}}, [Buscar Certificados], GetCurrentFolder() + [\], .F., .T. )

   If !Hb_FileExists(cCert)
      MsgExclamation([Arquivo PFX não encontrado.], [Erro])
      Return (.F.)
   Endif
 
   If Upper(Right(cCert, 4)) # [.PFX]
      MsgExclamation([Não é um Arquivo PFX.], [Erro])
      Return (.F.)
   Endif

   cSenha:= InputBox ([Entre com a Senha do Certificado:], [Senha do Certificado - A1], [])
   If Empty(cSenha)
      MsgExclamation([Falta senha do arquivo PFX.], [Erro])
      Return (.F.)
   Endif

   oXml:fCertificadopfx(cCert, cSenha)

   If !Empty(oXml:cCertNomecer)
      Msginfo( "Certificado: " + oXml:cCertNomecer)
      Msginfo( "Emissor: " + oXml:cCertEmissor)
      Msginfo( "Validade: " + Dtoc(oXml:dCertDataini) + " até " + Dtoc(oXml:dCertDatafim))
      Msginfo( "Thumbprint: " + oXml:cCertImprDig)
      Msginfo( "Serial number: " + oXml:cCertSerial)
      Msginfo( "Versão: " + Hb_Ntos(oXml:nCertVersao))
      Msginfo( "Instalado ?: " + Iif(oXml:lCertInstall, [SIM], [NÃO]) )
      Msginfo( "Vencido ?: " + Iif(oXml:lCertVencido, [SIM], [NÃO]) )
   Else
      Msginfo( "Erro no Certificado /  Senha", [Erro])
   Endif
Return (Nil)

Static Procedure fGerarxml()
*   Local oXml:= Malc_GeraXml():New(), i:= 0 // Chamar a classe para gerar xml nfe/nfce no objeto oXml 

   WaitWindow([Gerando Nfe ] + oXml:cVersao + [. Aguarde término do processo...], .T.)  /// pegou a versão padrão do lay-out da nfe/nfce

   * Padronização utilizada na nomenclatura das tags
   * oXml:cNf      => cNf o primeiro caracter (c) indica que é um valor caractér
   * oXml:dDatae   => dDatae  o primeiro caracter (d) indica que é um valor Date
   * oXml:nVlFrete => nVlFrete o primeiro caracter (n) indica que é um valor numérico
   * foi tentado manter o nome da varíavel da classe com o nome da tag, mas como existe algumas repetidas houve a distinção entre elas 
   * por exemplo   => oXml:cXnomee => razão social do emitente e oXml:cXnomed  => razão social do destinatário

   *** Cria o xml
   oXml:cNf      := [52]
   oXml:cUf      := [35] // se fosse omitido esse valor o padrão é 35 ou seja sp
   oXml:cCnpj    := [12.345.678/0001-90]    // pode ser enviado com pontos e barras ou sem sinais que será removido pela classe
   oXml:cNrdoc   := oXml:cNf + Strzero(Day(Date()), 2) 
   oXml:cSerie   := [1]
   oXml:cModelo  := [55] // se fosse omitido esse valor o padrão é 55 ou seja nfe
   oXml:cAmbiente:= [2]  // se fosse omitido esse valor o padrão é 2 Ambiente de Homologação 

   oXml:fCria_Xml()  // criando arquivo, chave e demais informações básicas
 
   *** Identificação - Tag Ide
   oXml:cNatop   := [VENDA DE MERCADORIA] 
   oXml:dDatae   := Date()
   oXml:cTimee   := Time()
   oXml:dDatas   := Date()
   oXml:cTimes   := Time()
   oXml:cTpnf    := [1]
   oXml:cIdest   := [1]
   oXml:cMunfg   := [3550308]
   oXml:cFinnfe  := [1]
   oXml:cIndfinal:= [0]
   oXml:cIndpres := [0]

   *** teste para nota para exterior / trocar por este valor
   * oXml:cIdest := [3]

   oXml:fCria_Ide()  // criando a tag ide

   *** pode repetir até 500 notas referenciadas
   oXml:cRefnfe:= [35250600123456000100550010000386485700411249]
   oXml:fCria_AddNfref()

   oXml:cRefnfe:= [35250600123456000100550010000386485700411250]
   oXml:fCria_AddNfref()

   oXml:cRefnfe:= [35250600123456000100550010000386485700411251]
   oXml:fCria_AddNfref()

   *** Emitente
   oXml:cXnomee  := [Empresa fictícia Ltda Me]
   oXml:cXfant   := [Mentira e Mentirinhas]
   oXml:cXlgre   := [Rua do Sossegão]
   oXml:cNroe    := [sn]
   oXml:cXBairroe:= [Centro]
   oXml:cXmune   := [São Paulo]   // com ou sem acentuação
   oXml:cUfE     := [SP]
   oXml:cCepe    := [04.815-130] // com ou sem acentuação
   oXml:cFonee   := [(11)99999-0234] // com ou sem acentuação
   oXml:cIee     := [551303380162]
   oXml:cIme     := [1234]
   oXml:cCnaee   := [4751201]
   oXml:cCrt     := [1]

   oXml:fCria_Emitente() // criando a tag emitente
  
   *** Destinatário
   oXml:cCnpjd    := [99999999000191]
   oXml:cXnomed   := [Empresa teste]
   oXml:cXlgrd    := [Rua do Sossego mais sossegada]
   oXml:cNrod     := [1234]
   oXml:cXBairrod := [Centro]
   oXml:cCmund    := [3550308] // com ou sem acentuação
   oXml:cXmund    := [Sao Paulo]
   oXml:cUfd      := [SP]
   oXml:cCepd     := [17514250]
   oXml:cFoned    := [(14)99888-1234]
   oXml:cIndiedest:= [2]
   oXml:cIed      := [197358979888]
   oXml:cEmaild   := [marceloalcarli@gmail.com]

   oXml:cXlgrr    := oXml:cXlgrd  // se deseja que seja incluído a tag de retirada retirar e colocar as demais tags do local de retirada
   oXml:cXlgrg    := oXml:cXlgrd  // se deseja que seja incluído a tag de entrega retirar e colocar as demais tags do local de entrega

   *** teste para nota para exterior / trocar por este valor
   * oXml:cIdestrangeiro:= [20250707]
   * oXml:cCmund        := [9999999]
   * oXml:cXmund        := [EXTERIOR]
   * oXml:cUfd          := [EX]
   * oXml:cPaisd        := [1694]
   * oXml:cXpaisd       := [COLOMBIA]
   * oXml:cIndiedest    := [9]

   oXml:fCria_Destinatario() // criando a tag destinatário

   *** Pode repetir até 10 vezes
   oXml:cAutxml   := [99999999000191]
   oXml:fCria_Autxml()     

   oXml:cAutxml   := [99999999000292]
   oXml:fCria_Autxml()     

   oXml:cAutxml   := [99999999000293]
   oXml:fCria_Autxml()     
      
   For i:= 1 to 3
       // Cria Produto
       oXml:nItem    := i
       oXml:cProd    := [7908454806175]
       oXml:cXprod   := [CHICOTE DA IGNICAO]
       oXml:cNcm     := [84835090]
       oXml:cCest    := [1111111]
       oXml:cCfOp    := [5.405]
       oXml:cUcom    := [UN]
       oXml:nQcom    := 1
       oXml:nVuncom  := 4.77
*      oXml:nVprod   := 4.77  // se não informar vai calcular automaticamente
       oXml:nVtottrib:= 4.77
       oXml:cCstIcms := [500]
       oXml:cOrig    := [0]
       oXml:nVdesc   := .50
       oXml:nVfrete  := .20
       oXml:nVseg    := .1
       oXml:nVoutro  := .01

       // teste para nota para exterior / comentar estas tags
       oXml:cCstPis   := [49]
       oXml:cCstCofins:= [49]

       // teste para nota para exterior / trocar por este valor
       * oXml:cCfOp       := [7101]
       * oXml:cCstIcms    := [041]
       * oXml:cCEnq       := [002]
       * oXml:cCstipint   := [54]
       * oXml:cCstPisnt   := [08]
       * oXml:cCstCofinsnt:= [08]
/*
       // Reforma Tributária  - RTC
       oXml:cCstis       := [000]
       oXml:cClasstribis := [000000]
       oXml:nVbcis       := 10
       oXml:nPisis       := 1
       oXml:cUtrib_is    := [UN]
       oXml:nQtrib_is    := 1
       oXml:nPredaliqgcbs:= 0.6

       oXml:cCstibs      := [010]
       oXml:cCclasstrib  := [00000001]
       oXml:nVbcibs      := 10
       oXml:cCredPresgibs:= [01]
       oXml:cCredPrescbs := [01]
*/
       oXml:fCria_Produto() // criando a tag dos produtos

       ** alterar para poder incluir dentro da det prod
       If i == 2  // como acrescentar tag arma no produto 2
          // Pode ocorrer até 500 vezes
          oXml:cTparma  := [0]
          oXml:cNserie_a:= [1234567890]
          oXml:cNcano   := [8888888TV8UOP]
          oXml:cDescr_a := [Descrição da arma com até 256 caracteres]

          oXml:fCria_ProdArmamento()

          oXml:cTparma  := [1]
          oXml:cNserie_a:= [KJO1234567890]
          oXml:cNcano   := [AAA8888888TV8UOP]
          oXml:cDescr_a := [Descrição da arma com até 256 caracteres]

          oXml:fCria_ProdArmamento()

          oXml:cTparma  := [0]
          oXml:cNserie_a:= [BC000123]
          oXml:cNcano   := [NCC000123]
          oXml:cDescr_a := [CALIBRE:9mm,- COMPRIMENTO DO CANO:95mm (3.74),- ESPECIE:PISTOLA,- FUNCIONAMENTO:2,- MARCA:FABRICANTE,- QTD.CANOS:1,- NUMERO DE TIROS:15,- QTD.RAIAS:06,- SENTIDO RAIAS:2]

          oXml:fCria_ProdArmamento()
       Endif
   Next i

*****************

   // Reforma Tributária  - RTC
   oXml:nVis_t    := (oXml:nVbcis * oXml:nQtrib_is) * (oXml:nPisis / 100)

   oXml:fCria_Totais() // criando a tag dos totais

   *** Transportadora
   oXml:cModFrete:= [9]
*  oXml:cXnomet  := 
*  oXml:cCnpjt   := 
*  oXml:cIet     := 
*  oXml:cXEndert := 
*  oXml:cXmunt   := 
*  oXml:cUft     := 
*  oXml:cPlaca   := 
*  oXml:cUfplacat:= 
*  oXml:cRntc    := 
*  oXml:nQvol    := 
*  oXml:cEsp     := 
*  oXml:cMarca   := 
*  oXml:cNvol    := 
*  oXml:nPesol   := 
*  oXml:nPesob   := 

   // teste para nota para exterior / trocar por este valor
*  oXml:cModFrete:= [1]
*  oXml:cXnomet  := [BRASIL TRANSPORTES LTDA]
*  oXml:cCnpjt   := [13.520.ABC/0001-69]
*  oXml:cIet     := [442131310119]
*  oXml:cXEndert := [Rua do sossego]
*  oXml:cXmunt   := [MARÍLIA]
*  oXml:cUft     := [SP]
*  oXml:nQvol    := 7
*  oXml:cEsp     := [PALETES]
*  oXml:nPesol   := 464.81
*  oXml:nPesob   := 816.90

   oXml:fCria_Transportadora() // criando a tag da transportadora

   oXml:cNfat  := [Fatura numero 1]
   oXml:nVorigp:= 1.00
   oXml:nVdescp:= 1.00
   oXml:nVliqup:= 1.00

   *** Cobrança pode repetir até 120 vezes
   oXml:cNDup  := [001 Duplicata]   
   oXml:dDvencp:= Ctod([01/04/2025])
   oXml:nVdup  := 1.00

   oXml:fCria_Cobranca() // criando a tag de cobrança

   oXml:cNDup  := [002 Duplicata]   
   oXml:dDvencp:= Ctod([01/05/2025])
   oXml:nVdup  := 2.00

   oXml:fCria_Cobranca() // criando a tag de cobrança

   oXml:cNDup  := [003 Duplicata]   
   oXml:dDvencp:= Ctod([01/06/2025])
   oXml:nVdup  := 5.00

   oXml:fCria_Cobranca() // criando a tag de cobrança

   *** Tipo de pagamento pode repetir até 100 vezes
   oXml:cIndPag:= [0]   // a vista
   oXml:cTpag  := [01]
   oXml:nVpag  := 1.00

   oXml:fCria_Pagamento()

   oXml:cIndPag:= [0]   // a vista
   oXml:cTpag  := [02]
   oXml:nVpag  := 1.00

   oXml:fCria_Pagamento()

   oXml:cIndPag:= [1]   // a prazo
   oXml:cTpag  := [03]
   oXml:nVpag  := 7.54
   oXml:nVtroco:= 0.01  // COLOCAR O TROCO NA ÚLTIMA FORMA DE PAGAMENTO OU SE FOR ÚNICA FORMA

   oXml:fCria_Pagamento()

   *** Informações Adicionais
   oXml:cInfcpl := [teste]
   oXml:cInfFisc:= [teste ao fisco]

   oXml:fCria_Informacoes() // criando a tag de informações

   *** observação: só será preenchido se o cfop começar com 7
   *** fica aqui demonstrado como alimentar as tags e local de inserção
   oXml:cUfSaidapais := [RJ]
   oXml:cXlocexporta := [Porto do Rio de janeiro]
   oXml:cXlocdespacho:= [Pier 150A]

   oXml:fCria_ProdExporta()

   *** Responsável Técnico
   oXml:cRespcnpj := [99999999000191]
   oXml:cRespNome := [responsável técnico]
   oXml:cRespemail:= [tecnico@tecnico.com.br]
   oXml:cRespfone := [11123456789]

   oXml:fCria_Responsavel()

   *** Fechamento da Nfe   
   oXml:fCria_Fechamento()  // criando a tag de fechamento do xml

   // Grava Arquivo XML colocar qq nome de preferencia
   hb_MemoWrit(oXml:cId + [-01-SemAssinatura.xml], oXml:cXml)
   hb_MemoWrit(oXml:cId + [-nfe.xml], oXml:cXml)  // padrão para envio pelo monitor da unimake
   WaitWindow()
Return (Nil)

*#include <nfe_classe_r25.prg>