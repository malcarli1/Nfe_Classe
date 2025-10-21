/*****************************************************************************
 * SISTEMA  : GERAL                                                          *
 * PROGRAMA : NFE_CLASSE.PRG                                                 *
 * OBJETIVO : CLASSE PARA GERA��O DE XML DE DFE'S - NFE(55) E NFCE(65)       *
 * AUTOR    : Marcelo Antonio L�zzaro Carli                                  *
 * ALTERADO : Rubens Aluotto                                                 *
 *          : Marcelo de Paula                                               *
 *          : Marcelo Brigatti                                               *
 *          : Maur�lio Franchin J�nior                                       *
 *          : Jair Barreto                                                   *
 * DATA     : 10.06.2025                                                     *
 * ULT. ALT.: 21.10.2025                                                     *
 *****************************************************************************/
#include <hbclass.ch>

*   AS Num       INIT 0 pode conter decimais
*   AS Int ou AS Integer n�o cont�m decimais 4.5 vai ser 4

CLASS Malc_GeraXml
   // Configura��es iniciais b�sicas
   VAR cXml                    AS Character INIT []                               // xml gerado
   VAR cUf                     AS Character INIT [35]                             // Grupo B  // SP = 35
   VAR cNf                     AS Character INIT []                               // Grupo B
   VAR cCnpj                   AS Character INIT []                               // Cnpj/Cpf Emitente
   VAR cAmbiente               AS Character INIT [2]                              // Ambiente de Homologa��o 
   VAR cSerie                  AS Character INIT [1]
   VAR cModelo                 AS Character INIT [55]                             // 55 Nfe ou 65 nfce
   VAR cNrdoc                  AS Character INIT [] 
   VAR cVersao                 AS Character INIT [4.00]                           // Grupo A
   VAR cId                     AS Character INIT []                               // Grupo A
   VAR cCertNomecer            AS Character INIT []                               // Nome do certificado retornado
   VAR cCertEmissor            AS Character INIT []                               // Nome do Emissor do certificado retornado
   VAR dCertDataini            AS Date      INIT CToD( [] )                       // Data Inicial de Validade do certificado retornado
   VAR dCertDatafim            AS Date      INIT CToD( [] )                       // Data Final de Validade do certificado retornado
   VAR cCertImprDig            AS Character INIT []                               // Impress�o Digital do certificado retornado
   VAR cCertSerial             AS Character INIT []                               // N�mero Serial do certificado retornado
   VAR nCertVersao             AS Num       INIT 0                                // Vers�o do certificado retornado
   VAR lCertInstall            AS Logical   INIT .F.                              // Verifica se o Certificado est� Instalado no Reposit�rio do Windows
   VAR lCertVencido            AS Logical   INIT .F.                              // Verifica se o Certificado est� Vencido

    // Tag ide - Grupo B
   VAR cNatop                  AS Character INIT [] 
   VAR cMunfg                  AS Character INIT [] 
   VAR dDataE                  AS Date      INIT Date()
   VAR cTimeE                  AS Character INIT Time()
   VAR dDataS                  AS Date      INIT Date()
   VAR cTimeS                  AS Character INIT Time()
   VAR cTpnf                   AS Character INIT [1]                              // 0 - entrada, 1 - sa�da
   VAR cIdest                  AS Character INIT [1]                              // 1 - Interna, 2 - Interestadual, 3 - Exterior
   VAR cTpImp                  AS Character INIT [1]                              // Tipo de Impress�o    1 - Retrato / 2 - Paisagem
   VAR cTpEmis                 AS Character INIT [1]                              // Tipo de Emiss�o      1 - Normal  / 2 - Conting�ncia FS-IA / 3 - (DESATIVADO) / 4 - Conting�ncia EPEC / 5 - Conting�ncia FS-DA / 6 - Conting�ncia SVC-AN / 7 - Conting�ncia SVC-RS / 9 - Conting�ncia off-line da NFC-e 
   VAR cFinnfe                 AS Character INIT [1]                              // 1 = NF-e normal; 2 = NF-e complementar; 3 = NF-e de ajuste; 4 = Devolu��o de mercadoria.
   VAR cIndfinal               AS Character INIT [1]                              // Indica opera��o com consumidor final (0 - N�o ; 1 - Consumidor Final)
   VAR cIndpres                AS Character INIT [1]                              // Indicador de Presen�a do comprador no estabelecimento comercial no momento da opera��o.
   VAR cIndintermed            AS Character INIT [0]
   VAR cProcemi                AS Character INIT [0]                              // 0 - emiss�o de NF-e com aplicativo do contribuinte
   VAR cVerproc                AS Character INIT [4.00_B30]
   VAR dDhCont                 AS Character INIT []                               // Data-hora conting�ncia       FSDA - tpEmis = 5
   VAR cxJust                  AS Character INIT []                               // Justificativa conting�ncia   FSDA - tpEmis = 5
   VAR cRefnfe                 AS Character INIT []                               // Grupo BA
   VAR cCepe                   AS Character INIT []  
   VAR cTpnfdebito             AS Character INIT []                               // Reforma tribut�ria
   VAR cTpnfcredito            AS Character INIT []                               // Reforma tribut�ria
   VAR cTpcompragov            AS Character INIT []                               // Reforma tribut�ria
   VAR nPredutor               AS Num       INIT 0                                // Reforma tribut�ria 
 
   // Tag emit - Grupo C
   VAR cXnomee                 AS Character INIT []
   VAR cXfant                  AS Character INIT []
   VAR cXlgre                  AS Character INIT []  
   VAR cNroe                   AS Character INIT []  
   VAR cXcple                  AS Character INIT []  
   VAR cXBairroe               AS Character INIT []  
   VAR cXmune                  AS Character INIT []  
   VAR cUfe                    AS Character INIT []  
   VAR cCepe                   AS Character INIT []  
   VAR cPais                   AS Character INIT [1058]
   VAR cXpaise                 AS Character INIT [BRASIL]
   VAR cFonee                  AS Character INIT []  
   VAR cIee                    AS Character INIT []  
   VAR cIme                    AS Character INIT []  
   VAR cCnaee                  AS Character INIT []  
   VAR cCrt                    AS Character INIT []  
  
   // Tag dest - Grupo E
   VAR cCnpjd                  AS Character INIT []  
   VAR cXnomed                 AS Character INIT []  
   VAR cXlgrd                  AS Character INIT []  
   VAR cXcpld                  AS Character INIT []  
   VAR cNrod                   AS Character INIT []  
   VAR cXBairrod               AS Character INIT []  
   VAR cCmund                  AS Character INIT []  
   VAR cXmund                  AS Character INIT []  
   VAR cUfd                    AS Character INIT []  
   VAR cCepd                   AS Character INIT []  
   VAR cPaisd                  AS Character INIT [1058]
   VAR cXpaisd                 AS Character INIT [BRASIL]
   VAR cFoned                  AS Character INIT []  
   VAR cIndiedest              AS Character INIT [1]
   VAR cIed                    AS Character INIT []  
   VAR cEmaild                 AS Character INIT []  
   VAR cAutxml                 AS Character INIT []  
   VAR cIdestrangeiro          AS Character INIT []  

   // Tag retirada - Grupo F
   VAR cCnpjr                  AS Character INIT []  
   VAR cXnomer                 AS Character INIT []  
   VAR cXfantr                 AS Character INIT []  
   VAR cXlgrr                  AS Character INIT []  
   VAR cXcplr                  AS Character INIT []  
   VAR cNror                   AS Character INIT []  
   VAR cXBairror               AS Character INIT [] 
   VAR cCmunr                  AS Character INIT [] 
   VAR cXmunr                  AS Character INIT [] 
   VAR cUfr                    AS Character INIT [] 
   VAR cCepr                   AS Character INIT [] 
   VAR cPaisr                  AS Character INIT [1058]
   VAR cXpaisr                 AS Character INIT [BRASIL]
   VAR cFoner                  AS Character INIT [] 
   VAR cEmailr                 AS Character INIT [] 
   VAR cIer                    AS Character INIT [] 

   // Tag entrega - Grupo G
   VAR cCnpjg                  AS Character INIT [] 
   VAR cXnomeg                 AS Character INIT [] 
   VAR cXfantg                 AS Character INIT [] 
   VAR cXlgrg                  AS Character INIT [] 
   VAR cXcplg                  AS Character INIT [] 
   VAR cNrog                   AS Character INIT [] 
   VAR cXBairrog               AS Character INIT [] 
   VAR cCmung                  AS Character INIT [] 
   VAR cXmung                  AS Character INIT [] 
   VAR cUfg                    AS Character INIT [] 
   VAR cCepg                   AS Character INIT [] 
   VAR cPaisg                  AS Character INIT [1058]
   VAR cXpaisg                 AS Character INIT [BRASIL]
   VAR cFoneg                  AS Character INIT [] 
   VAR cEmailg                 AS Character INIT [] 
   VAR cIeg                    AS Character INIT [] 

   // Tag prod - Grupo I - Produtos e Servi�os da NFe
   VAR nItem                   AS Num       INIT 1
   VAR cProd                   AS Character INIT [] 
   VAR cEan                    AS Character INIT [] 
   VAR cEantrib                AS Character INIT [] 
   VAR cXprod                  AS Character INIT [] 
   VAR cNcm                    AS Character INIT [] 
   VAR cCest                   AS Character INIT [] 
   VAR cCfOp                   AS Character INIT [] 
   VAR cUcom                   AS Character INIT [UN]
   VAR nQcom                   AS Num       INIT 0
   VAR nVuncom                 AS Num       INIT 0
   VAR nVprod                  AS Num       INIT 0
   VAR nVfrete                 AS Num       INIT 0
   VAR nVseg                   AS Num       INIT 0
   VAR nVdesc                  AS Num       INIT 0                                                                    
   VAR nVoutro                 AS Num       INIT 0
   VAR cIndtot                 AS Character INIT [1]                                                  
   VAR cInfadprod              AS Character INIT []                               // Grupo V
   VAR cXped                   AS Character INIT []                               // Grupo I05
   VAR nNitemped               AS Num       INIT 0                                            // Grupo I05
   VAR cNfci                   AS Character INIT []                               // Grupo I07

   // TAG DI - Grupo I01 - Configuracoes para IMPORTACAO CFOP com in�cio "3"      // Colabora��o Rubens Aluotto - 16/06/2025
   VAR cNdi                    AS Character INIT [] 
   VAR dDdi                    AS Date      INIT CToD( [] )
   VAR cXlocdesemb             AS Character INIT [] 
   VAR cUfdesemb               AS Character INIT [] 
   VAR dDdesemb                AS Date      INIT CToD( [] )
   VAR nTpviatransp            AS Num       INIT 0
   VAR nVafrmm                 AS Num       INIT 0
   VAR nTpintermedio           AS Num       INIT 0
   VAR cCnpja                  AS Character INIT [] 
   VAR cUfterceiro             AS Character INIT [] 
   VAR cCexportador            AS Character INIT [] 

   // TAG adi - Grupo I01 - Grupo de Adi��es (SubGrupo da TAG DI) 
   VAR nNadicao                AS Num       INIT 0                                // N�mero da Adi��o 
   VAR nNseqadic               AS Num       INIT 0                                // N�mero sequencial do �tem dentro da Adi��o
   VAR cCfabricante            AS Character INIT []                               // C�digo do fabricante estrangeiro, usado nos sistemas internos de informa��o do emitente da NF-e 
   VAR nVdescdi                AS Num       INIT 0                                // Valor do desconto do item da DI ? Adi��o
   VAR cNdraw                  AS Character INIT []                               // N�mero do ato concess�rio de Drawback (O n�mero do Ato Concess�rio de Suspens�o deve ser preenchido com 11 d�gitos (AAAANNNNNND)
   VAR nNre                    AS Num       INIT 0                                // N�mero do Registro de Exporta��o
   VAR cChnfe                  AS Character INIT []                               // Chave de Acesso da NF-e recebida para exporta��o NF-e recebida com fim espec�fico de exporta��o. No caso de opera��o com CFOP 3.503, informar a chave de acesso da NF-e que efetivou a exporta��o 
   VAR nQexport                AS Num       INIT 0                                // Quantidade do item realmente exportado A unidade de medida desta quantidade � a unidade de comercializa��o deste item. No caso de opera��o com CFOP 3.503, informar a quantidade de mercadoria devolvida

   // Grupo JA. Detalhamento Espec�fico de Ve�culos novos
   VAR cTpOp                   AS Character INIT [] 
   VAR cChassi                 AS Character INIT [] 
   VAR cCor                    AS Character INIT [] 
   VAR cXcor                   AS Character INIT [] 
   VAR cPot                    AS Character INIT []              
   VAR cCilin                  AS Character INIT [] 
   VAR nPesolvei               AS Num       INIT 0                                             
   VAR nPesobvei               AS Num       INIT 0 
   VAR cNserie                 AS Character INIT [] 
   VAR cTpcomb                 AS Character INIT []                                            
   VAR cNmotor                 AS Character INIT [] 
   VAR nCmt                    AS Character INIT [] 
   VAR cDist                   AS Character INIT [] 
   VAR cAnomod                 AS Character INIT [] 
   VAR cAnofab                 AS Character INIT [] 
   VAR cTpveic                 AS Character INIT [] 
   VAR cEspveic                AS Character INIT [] 
   VAR cVin                    AS Character INIT [] 
   VAR cCondveic               AS Character INIT [] 
   VAR cCmod                   AS Character INIT []                                                  
   VAR cCordenatran            AS Character INIT [] 
   VAR cLota                   AS Character INIT [] 
   VAR cTprest                 AS Character INIT [] 

   // Tag med - Grupo K. Detalhamento Espec�fico de Medicamento e de mat�rias-primas farmac�uticas
   VAR cProdanvisa             AS Character INIT [] 
   VAR cXmotivoisencao         AS Character INIT [] 
   VAR nVpmc                   AS Num       INIT 0

   // Tag arma - Grupo L. Detalhamento Espec�fico de Armamentos
   VAR cTparma                 AS Character INIT [] 
   VAR cNserie_a               AS Character INIT [] 
   VAR cNcano                  AS Character INIT [] 
   VAR cDescr_a                AS Character INIT [] 

   // Tag comb - Grupo LA - Combust�veis
   VAR cCprodanp               AS Character INIT []                               // C�digo de produto da ANP
   VAR cDescanp                AS Character INIT []                               // Descri��o do produto conforme ANP
   VAR nQtemp                  AS Num       INIT 0                                // Quantidade de combust�vel faturada � temperatura ambiente.
   VAR nQbcprod                AS Num       INIT 0                                // Informar a BC da CIDE em quantidade
   VAR nValiqprod              AS Num       INIT 0                                // Informar o valor da al�quota em reais da CIDE
   VAR nVcide                  AS Num       INIT 0                                // Informar o valor da CIDE

   // Tag Icms - Grupo N
   VAR nVicms                  AS Num       INIT 0
   VAR cOrig                   AS Character INIT [0]
   VAR cCsticms                AS Character INIT [] 
   VAR cModbc                  AS Character INIT [3]
   VAR nVbc                    AS Num       INIT 0
   VAR nPicms                  AS Num       INIT 0
   VAR cModbcst                AS Character INIT [3]
   VAR nPmvast                 AS Num       INIT 0
   VAR nPredbcst               AS Num       INIT 0
   VAR nVbcst                  AS Num       INIT 0
   VAR nPicmst                 AS Num       INIT 0
   VAR nVicmsst                AS Num       INIT 0
   VAR nPredbc                 AS Num       INIT 0
   VAR nPcredsn                AS Num       INIT 0
   VAR nVcredicmssn            AS Num       INIT 0
   VAR nVbcstret               AS Num       INIT 0
   VAR nPst                    AS Num       INIT 0
   VAR nVicmssubstituto        AS Num       INIT 0
   VAR nVicmstret             AS Num       INIT 0

   // Tag Grupo NA. ICMS para a UF de destino                                     // Marcelo Brigatti
   VAR nVbcufdest              AS Num       INIT 0
   VAR nVbcfcpufdest           AS Num       INIT 0
   VAR nPfcpufdest             AS Num       INIT 0
   VAR nPicmsufdest            AS Num       INIT 0
   VAR nPicmsinter             AS Num       INIT 0
   VAR nPicmsinterpart         AS Num       INIT 0
   VAR nVfcpufdest             AS Num       INIT 0
   VAR nVicmsufdest            AS Num       INIT 0
   VAR nVicmsufremet           AS Num       INIT 0

   // Tag Ipi - Grupo O
   VAR cCEnq                   AS Character INIT [999]
   VAR cCstipi                 AS Character INIT [53]
   VAR cCstipint               AS Character INIT [] 
   VAR nVipi                   AS Num       INIT 0
   VAR nVbcipi                 AS Num       INIT 0
   VAR nPipi                   AS Num       INIT 0

   // Imposto de Importa��o 
   // TAG II - Grupo P - Grupo Imposto de Importa��o                              // (Informar apenas quando o item for sujeito ao II) 
   VAR nVbci                   AS Num       INIT 0                                // Valor BC do Imposto de Importa��o
   VAR nVdespadu               AS Num       INIT 0                                // Valor despesas aduaneiras
   VAR nVii                    AS Num       INIT 0                                // Valor Imposto de Importa��o
   VAR nViof                   AS Num       INIT 0                                // Valor Imposto sobre Opera��es Financeiras 

   // Tag Pis/Cofins - Grupo Q e S
   VAR cCstPis                 AS Character INIT []                               // (01, 02) CSTs do PIS s�o mutuamente exclusivas s� pode existir um tipo
   VAR cCstPisqtd              AS Character INIT []                               // (03)
   VAR cCstPisnt               AS Character INIT []                               // (04, 05, 06, 07, 08, 09)
   VAR cCstPisoutro            AS Character INIT []                               // (49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)
   VAR cCstCofins              AS Character INIT []                               // (01, 02) CSTs do Cofins s�o mutuamente exclusivas s� pode existir um tipo                 
   VAR cCstCofinsqtd           AS Character INIT []                               // (03)                                                                                            
   VAR cCstCofinsnt            AS Character INIT []                               // (04, 05, 06, 07, 08, 09)                                                                        
   VAR cCstCofinsoutro         AS Character INIT []                               // (49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)
   VAR nBcPis                  AS Num       INIT 0
   VAR nAlPis                  AS Num       INIT 0
   VAR nVpis                   AS Num       INIT 0
   VAR nBcCofins               AS Num       INIT 0
   VAR nAlCofins               AS Num       INIT 0
   VAR nVCofins                AS Num       INIT 0

   // Tag total - Grupo W - Total da NFe
   VAR nVbc_t                  AS Num       INIT 0
   VAR nVicms_t                AS Num       INIT 0
   VAR nVicmsdeson_t           AS Num       INIT 0
   VAR nVfcpufdest_t           AS Num       INIT 0
   VAR nVicmsufdest_t          AS Num       INIT 0
   VAR nVicmsufremet_t         AS Num       INIT 0
   VAR nVfcp_t                 AS Num       INIT 0
   VAR nVbcst_t                AS Num       INIT 0
   VAR nVst_t                  AS Num       INIT 0
   VAR nVfcpst_t               AS Num       INIT 0
   VAR nVfcpstret_t            AS Num       INIT 0
   VAR nVSeg_t                 AS Num       INIT 0
   VAR nVii_t                  AS Num       INIT 0
   VAR nVipi_t                 AS Num       INIT 0
   VAR nVipidevol_t            AS Num       INIT 0       
   VAR nVpis_t                 AS Num       INIT 0
   VAR nVCofins_t              AS Num       INIT 0
   VAR nMonoBas                AS Num       INIT 0
   VAR nMonoAliq               AS Num       INIT 0
   VAR nVprod_t                AS Num       INIT 0
   VAR nVFrete_t               AS Num       INIT 0
   VAR nVDesc_t                AS Num       INIT 0
   VAR nVipidevol              AS Num       INIT 0
   VAR nVOutro_t               AS Num       INIT 0
   VAR nVnf                    AS Num       INIT 0
   VAR nVtottrib               AS Num       INIT 0                                // Grupo M
   VAR nVtottribt              AS Num       INIT 0                                // Grupo Totais
   VAR lVtottrib               AS Logical   INIT .T.                              // Vari�vel para permitir ou n�o informar os valores dos tributos na informa��o adicional dos itens 

   // Tag transp - Grupo X
   VAR cModFrete               AS Character INIT [] 
   VAR cXnomet                 AS Character INIT [] 
   VAR cCnpjt                  AS Character INIT [] 
   VAR cIet                    AS Character INIT [] 
   VAR cXEndert                AS Character INIT [] 
   VAR cXmunt                  AS Character INIT [] 
   VAR cUft                    AS Character INIT [] 
   VAR cPlaca                  AS Character INIT [] 
   VAR cUfplacat               AS Character INIT [] 
   VAR cRntc                   AS Character INIT [] 
   VAR nQvol                   AS Num       INIT 0
   VAR cEsp                    AS Character INIT [] 
   VAR cMarca                  AS Character INIT [] 
   VAR cNvol                   AS Character INIT [] 
   VAR nPesol                  AS Num       INIT 0
   VAR nPesob                  AS Num       INIT 0

   // Tag cobr - Grupo Y - SubGrupos fat, dup
   VAR cNfat                   AS Character INIT [] 
   VAR nVorigp                 AS Num       INIT 0
   VAR nVdescp                 AS Num       INIT 0
   VAR nVliqup                 AS Num       INIT 0
   VAR cNDup                   AS Character INIT [] 
   VAR dDvencp                 AS Date      INIT CToD( [] )
   VAR nVdup                   AS Num       INIT 0

   // Tag Pag - Grupo YA. Informa��es de Pagamento
   VAR cIndPag                 AS Character INIT [0]
   VAR cTpag                   AS Character INIT [] 
   VAR cXpag                   AS Character INIT [] 
   VAR nVpag                   AS Num       INIT 0
   VAR nVtroco                 AS Num       INIT 0
   VAR nTpintegra              AS Num       INIT 0                                // 1=Pagamento integrado com o sistema de automa��o da empresa (Ex.: equipamento TEF, Com�rcio Eletr�nico) | 2= Pagamento n�o integrado com o sistema de automa��o da empresa 
   VAR cCnpjpag                AS Character INIT [] 
   VAR cTband                  AS Character INIT [] 
   VAR cAut                    AS Character INIT [] 

   // Tag infAdic - Grupo Z - informa��es Fisco / Complementar
   VAR lComplementar           AS Logical   INIT .F.
   VAR nVIcmsSufDest           AS Num       INIT 0
   VAR nVIcmsSufRemet          AS Num       INIT 0
   VAR cCodDest                AS Character INIT [] 
   VAR cInfcpl                 AS Character INIT []                               // Grupo Z - infCpl
   VAR cInfFisc                AS Character INIT []                               // Grupo Z - infAdFisco

   // TAG exporta - Grupo ZA - Configuracoes para EXPORTACAO CFOP com in�cio "7"  // Colabora��o Rubens Aluotto - 16/06/2025
   VAR cUfSaidapais            AS Character INIT [] 
   VAR cXlocexporta            AS Character INIT [] 
   VAR cXlocdespacho           AS Character INIT [] 

   // Tag infRespTec - Grupo ZD - respons�vel t�cnico
   VAR cRespcnpj               AS Character INIT [] 
   VAR cRespNome               AS Character INIT [] 
   VAR cRespemail              AS Character INIT [] 
   VAR cRespfone               AS Character INIT [] 

   // Configura��o B�sica de Indicadores da RTC para Classtrib
   VAR cTipoDeAliquota         AS Character INIT [1]                              // 1 - Padr�o, 2 - Uniforme setorial, 3 - Uniforme nacional (refer�ncia), 4 - Fixa, 5 - Sem al�quota, 6 - Uniforme setorial
   VAR cPredibs                AS Character INIT []                               // "", "30", "40", "50", "60", "70", "80", "100"
   VAR cPredcbs                AS Character INIT []                               // "", "30", "40", "50", "60", "70", "80", "100"
   VAR cInd_RedutorBC          AS Character INIT []                               // "", "S", "N"
   VAR cInd_gTribRegular       AS Character INIT []                               // "", "0", "1"
   VAR cInd_CredPres           AS Character INIT []                               // "", "1"
   VAR cIndMono                AS Character INIT []                               // "", "0", "1"
   VAR cIndMonoReten           AS Character INIT []                               // "", "0", "1"
   VAR cIndMonoRet             AS Character INIT []                               // "", "0", "1"
   VAR cIndMonoDif             AS Character INIT []                               // "", "0", "1"
   VAR cCredito_para           AS Character INIT []                               // 1 - "", 2 - Fornecedor, 3 - Adquirente. Cr�dito Presumido de IBS\nArt. 447. Fica concedido ao contribuinte sujeito ao regime regular do IBS e habilitado nos termos do art. 442 desta Lei Complementar cr�dito presumido de IBS relativo � aquisi��o de bem material industrializado de origem nacional contemplado pela redu��o a zero da al�quota do IBS nos termos do art. 445 desta Lei Complementar,
                                                                                  // 4 - Adquirente. Art. 168. Al�quota fixa por produto,
                                                                                  // 5 - Adquirente. UTILIZADO SOMENTE NA VENDA, � O �NICO CASO.  Art. 171. Fase de transi��o e ap�s da transi��o,
                                                                                  // 6 - Adquirente. Art. 168.  cCredPres 1,
                                                                                  // 7 - Fornecedor: �nica situa��o: Regime automotivo - projetos incentivados, observado o art. 312 da Lei Complementar n� 214, de 2025.  cCredPress 5",

   // TAG is - Reforma tribut�ria
   VAR cClasstribis            AS Character INIT [] 
   VAR nVbcis                  AS Num       INIT 0
   VAR nVis                    AS Num       INIT 0
   VAR nPisis                  AS Num       INIT 0
   VAR nPisespec               AS Num       INIT 0
   VAR cUtrib_is               AS Character INIT [] 
   VAR nQtrib_is               AS Num       INIT 0

   // TAG Ibscbs - Reforma tribut�ria
   VAR cCclasstrib             AS Character INIT []                                                                     // C�digo da Classifica��o Tribut�ria do IBS/CBS                                                                                             
   VAR nVbcibs                 AS Num       INIT 0                                                                      // Valor da Base de c�lculo comum a IBS/CBS                                                                                                  
   VAR nPibsuf                 AS Num       INIT 0.1                              // fixo para 2026 depois vai mudar    // Al�quota do IBS Estadual                                                                                                                  
   VAR nPdifgibuf              AS Num       INIT 0                                                                      // Percentual de diferimento                                                                                                                 
   VAR nVdevtribgibuf          AS Num       INIT 0                                                                      // Valor do diferimento                                                                                                                      
   VAR nPredaliqgibuf          AS Num       INIT 0                                                                      // Percentual da redu��o de Al�quota do cClassTrib                                                                                                                                             7  Valor do tributo devolvido. No fornecimento de energia el�trica, �gua, esgoto e g�s natural e em outras hip�teses definidas no regulamento
   VAR nVibsuf                 AS Num       INIT 0                                                                      // Valor do IBS de compet�ncia da UF                                                                                                                                   
   VAR nPibsmun                AS Num       INIT 0                                                                      // Al�quota do IBS Municipal                                                                                                                               
   VAR nPdifgibsmun            AS Num       INIT 0                                                                      // Percentual de diferimento                                                                                                                               
   VAR nVcbop                  AS Num       INIT 0                                                                      //                                                                                                                                     
   VAR nVdevtribgibsmun        AS Num       INIT 0                                                                      //                                                                                                                           
   VAR nPredaliqibsmun         AS Num       INIT 0                                                                      // Percentual da redu��o de Al�quota do cClassTrib                             
   VAR nVibsmun                AS Num       INIT 0                                                                      // Valor do IBS de compet�ncia do munic�pio                                                                                                                   
   VAR nPcbs                   AS Num       INIT 0.9                              // fixo para 2026 depois vai mudar    // Al�quota da CBS                                                                                                                                            
   VAR nPpDifgcbs              AS Num       INIT 0                                                                      // Percentual de diferimento                                                                                                                                                                                                                                            
   VAR nVcbsopgcbs             AS Num       INIT 0                                                                      // Valor do diferimento                                                                                                                                     
   VAR nVdevtribgcbs           AS Num       INIT 0                                                                      // Valor da CBS devolvida. No fornecimento de energia el�trica, �gua, esgoto e g�s natural e em outras hip�teses definidas no regulamento                   
   VAR nPredaliqgcbs           AS Num       INIT 0                                                                      // Percentual da redu��o de Al�quota do cClassTrib                                                                                                          
   VAR nVcbs                   AS Num       INIT 0                                                                      // Valor da CBS                                                                                                                                             
   VAR nVibs_c                 AS Num       INIT 0                                // tag gTransfCred                    // 
   VAR nVcbs_c                 AS Num       INIT 0                                // tag gTransfCred                    // 
   VAR nPaliqefetregibsuf      AS Num       INIT 0                                                                      // Al�quota efetiva da UF Informado a Al�quota caso n�o cumprida a condi��o resolut�ria/suspensiva                                                          
   VAR nVtribregibsuf          AS Num       INIT 0                                                                      // Informado como seria o valor do Tributo da UF caso n�o cumprida a condi��o resolut�ria/suspensiva                                                        
   VAR nPaliqefetregibsMun     AS Num       INIT 0                                                                      // Al�quota efetiva do Munic�pio Informado a Al�quota caso n�o cumprida a condi��o resolut�ria/suspensiva                                                   
   VAR nVtribregibsMun         AS Num       INIT 0                                                                      // Informado como seria o valor do Tributo do Munic�pio caso n�o cumprida a condi��o resolut�ria/suspensiva                                                 
   VAR nPaliqefetregcbs        AS Num       INIT 0                                                                      // Al�quota efetiva da CBS Informado a Al�quota caso n�o cumprida a condi��o resolut�ria/suspensiva                                                         
   VAR nVtribregcbs            AS Num       INIT 0                                                                      // Informado como seria o valor do Tributo CBS caso n�o cumprida a condi��o resolut�ria/suspensiva                                                          
   VAR cCredPresgibs           AS Character INIT []                                                                     // C�digo do Cr�dito Presumido (ver Tabela)                                                                                                                 
   VAR nPcredpresgibs          AS Num       INIT 0                                                                      // Percentual de cr�dito presumido                                                                                                                          
   VAR nVcredpresgibs          AS Num       INIT 0                                                                      // Valor do cr�dito presumido                                                                                                                               
   VAR cCredPrescbs            AS Character INIT []                                                                     // C�digo do Cr�dito Presumido (ver Tabela)                                                                                                                 
   VAR nPcredprescbs           AS Num       INIT 0                                                                      // Percentual de cr�dito presumido                                                                                                                          
   VAR nVcredprescbs           AS Num       INIT 0                                                                      // Valor do cr�dito presumido                                                                                                                 
   VAR nVissqn                 AS Num       INIT 0                                                                      //   
   VAR nVServs                 AS Num       INIT 0                                                                      //   
   VAR nVfcp                   AS Num       INIT 0                                                                      // 

   // Tag ISTot - Reforma tribut�ria
   VAR nVis_t                  AS Num       INIT 0
   VAR nVbcibscbs_t            AS Num       INIT 0
   VAR nVdifgibsuf_t           AS Num       INIT 0
   VAR nVdevtribgibsuf_t       AS Num       INIT 0
   VAR nVibsufgibsuf_t         AS Num       INIT 0
   VAR nVdDifgibsmun_t         AS Num       INIT 0
   VAR nVdevtribgibsmun_t      AS Num       INIT 0
   VAR nVibsmungibsmun_t       AS Num       INIT 0
   VAR nVibsgibs_t             AS Num       INIT 0
   VAR nVcredpresgibs_t        AS Num       INIT 0
   VAR nVcredprescondsuscbs    AS Num       INIT 0
   VAR nVcredprescondsuscbs_t  AS Num       INIT 0
   VAR nVcredprescondsusibs    AS Num       INIT 0
   VAR nVcredprescondsusibs_t  AS Num       INIT 0
   VAR nVdifgcbs_t             AS Num       INIT 0
   VAR nVdevtribgcbs_t         AS Num       INIT 0
   VAR nVcbsgcbs_t             AS Num       INIT 0
   VAR nVcredprescbs_t         AS Num       INIT 0
   VAR nVnftot                 AS Num       INIT 0
   VAR nvIBSMono_t             AS Num       INIT 0
   VAR nvCBSMono_t             AS Num       INIT 0
   VAR nvIBSMonoReten_t        AS Num       INIT 0
   VAR nvCBSMonoReten_t        AS Num       INIT 0
   VAR nvIBSMonoRet_t          AS Num       INIT 0
   VAR nvCBSMonoRet_t          AS Num       INIT 0

   // Tag gIBSCBSMono  - Reforma tribut�ria
   VAR nQbcmono                AS Num       INIT 0
   VAR nAdremibs               AS Num       INIT 0
   VAR nAdremcbs               AS Num       INIT 0
   VAR nVibsmono               AS Num       INIT 0
   VAR nVcbsmono               AS Num       INIT 0
   VAR nQbcmonoreten           AS Num       INIT 0
   VAR nAdremibsreten          AS Num       INIT 0
   VAR nVibsmonoreten          AS Num       INIT 0
   VAR nAdremcbsreten          AS Num       INIT 0
   VAR nVcbsmonoreten          AS Num       INIT 0
   VAR nQbcmonoret             AS Num       INIT 0
   VAR nAdremibsret            AS Num       INIT 0
   VAR nVibsmonoret            AS Num       INIT 0
   VAR nAdremcbsret            AS Num       INIT 0
   VAR nVcbsmonoret            AS Num       INIT 0
   VAR nPdifibs                AS Num       INIT 0 
   VAR nVibsmonodif            AS Num       INIT 0
   VAR nPdifcbs                AS Num       INIT 0
   VAR nVcbsmonodif            AS Num       INIT 0
   VAR nVtotibsmonoItem        AS Num       INIT 0
   VAR nVtotcbsmonoItem        AS Num       INIT 0

   METHOD New()                CONSTRUCTOR
   METHOD fCria_Xml()          
   METHOD fCria_ChaveAcesso()
   METHOD fCria_Ide()
   METHOD fCria_AddNfref()
   METHOD fCria_Compragov()                                                       // Reforma tribut�ria
   METHOD fCria_Autxml()
   METHOD fCria_Emitente()
   METHOD fCria_Destinatario()
   METHOD fCria_Endereco()                                                        // cTipo = entrega ou retirada
   METHOD fCria_Retirada()                                                        // gerar e manter a compatibilidade com o m�todo endereco
   METHOD fCria_Entrega()                                                         // gerar e manter a compatibilidade com o m�todo endereco
   METHOD fCria_Produto() 
   METHOD fCria_ProdutoIcms()
   METHOD fCria_ProdutoIcms_Na()
   METHOD fCria_ProdutoIpi()
   METHOD fCria_ProdutoPisCofins()
   METHOD fCria_ProdImporta()
   METHOD fCria_ProdExporta()
   METHOD fCria_ProdVeiculo() 
   METHOD fCria_ProdMedicamento()
   METHOD fCria_ProdArmamento()
   METHOD fCria_ProdCombustivel()
   METHOD fCria_ProdutoII()
   METHOD fCria_ProdutoIs()                                                       // Reforma tribut�ria
   METHOD fCria_ProdutoIbscbs()                                                   // Reforma tribut�ria
   METHOD fCria_Totais()
   METHOD fCria_TotaisRtc()                                                       // Reforma tribut�ria
   METHOD fCria_Gibscbsmono()                                                     // Reforma tribut�ria
   METHOD fCria_Transportadora() 
   METHOD fCria_Cobranca()
   METHOD fCria_Pagamento()
   METHOD fCria_Informacoes() 
   METHOD fCria_Responsavel()
   METHOD fCria_Fechamento()

   METHOD fRetiraSinal()                                                          // cStr , cEliminar
   METHOD fRetiraAcento()                                                         // cStr 
   METHOD XmlTag()                                                                // cTag, xValue, nDecimals, lConvert
   METHOD DateXml()                                                               // dDate
   METHOD StringXML()                                                             // cTexto
   METHOD DateTimeXml()                                                           // dDate, cTime, cUF, lUTC, cUserTimeZone
   METHOD DomingoDePascoa()                                                       // nAno
   METHOD TercaDeCarnaval()                                                       // nAno
   METHOD HorarioVeraoInicio()                                                    // nAno
   METHOD HorarioVeraoTermino()                                                   // nAno
   METHOD CalculaDigito()                                                         // cNumero, cModulo
   METHOD SoNumero()                                                              // cTxt
   METHOD SoNumeroCnpj()                                                          // cTxt
   METHOD LimpaPropriedadesImposto()                                              // Jair  Barreto
   METHOD fCertificadopfx()
ENDCLASS

* ---------------> Metodo para inicializar a cria��o da Classe <-------------- *
METHOD New()
   ::cXml:= []
Return Self

* ---------------> Metodo para inicializar a cria��o do XML <----------------- *
METHOD fCria_Xml()
   ::fCria_ChaveAcesso()

   ::cXml+= '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'
   ::cXml+= '<infNFe versao="' + ::cVersao + '" Id="NFe' + ::cId + '">'
Return (Nil)

* --------------> Metodo para gerar a chave de acesso da NFe <---------------- *
METHOD fCria_ChaveAcesso()
   Local cKey:= Alltrim(::cUf)
         cKey+= SubStr(Dtoc(Date()), 9, 2) + SubStr(Dtoc(Date()), 4, 2)
         cKey+= ::SoNumeroCnpj(::cCnpj)
         cKey+= Iif(!(::cModelo $ [55_65]), [55], Left(::cModelo, 2) + Padl(::cSerie, 3, [0]))
         cKey+= Padl(::cNf, 9, [0])
         cKey+= [1]
         cKey+= Padl(::cNrdoc, 8, [0])
Return (::cId:= cKey + ::CalculaDigito(cKey, [11]))

* ------------> Metodo para gerar a tag de identifica��o da NFe <------------- *
METHOD fCria_Ide()
   ::cXml+= "<ide>"                                                                                                              // In�cio da TAG (ide)
          ::cXml+= ::XmlTag( "cUF"    , Left(::cUf, 2))                                                                          // UF do Emitente no caso SP = 35
          ::cXml+= ::XmlTag( "cNF"    , Padl(Alltrim(::cNrdoc), 8, [0]))                                                         // Controle da Nota ou n�mero do pedido
          ::cXml+= ::XmlTag( "natOp"  , Left(::fRetiraAcento(::cNatop), 60))                                                     // Natureza da Opera��o
          ::cXml+= ::XmlTag( "mod"    , Iif(!(::cModelo $ [55_65]), [55], Left(::cModelo, 2)))                                   // Modelo do Documento 55 - Nfe ou 65 Nfce
          ::cXml+= ::XmlTag( "serie"  , Iif(Empty(::cSerie), [1], Left(::cSerie, 3)))                                            // S�rie 
          ::cXml+= ::XmlTag( "nNF"    , Left(::cNf, 9))                                                                          // N�mero da Nota Fiscal
          ::cXml+= ::XmlTag( "dhEmi"  , ::DateTimeXml(::dDataE, ::cTimeE))                                                       // Data Emiss�o Formato yyyy-mm-dd

          If !Empty(::dDataS)
             If ::cModelo # [65]
                ::cXml+= ::XmlTag( "dhSaiEnt" , ::DateTimeXml(::dDataS, ::cTimeS))                                                // Data da Sa�da da mercadoria
             Endif 
          Endif  
 
          ::cXml+= ::XmlTag( "tpNF"     , Iif(!(::cTpnf $ [0_1]), [0], Left(::cTpnf, 1)))                                        // Tipo de Emiss�o da NF  0 - Entrada, 1 - Sa�da, 2 - Sa�da-Devolu��o, 3 - Sa�da-Garantia
          ::cXml+= ::XmlTag( "idDest"   , Iif(!(::cIdest $ [1_2_3]), [1], Left(::cIdest, 1)))                                    // Identificador de Local de destino da opera��o (1 - Interna, 2 - Interestadual, 3 - Exterior)
          ::cXml+= ::XmlTag( "cMunFG"   , Left(::cMunfg, 7))                                                                     // IBGE do Emitente

          If ::cIndpres == [5]                                                                                                   
             ::cXml+= ::XmlTag( "cMunFGIBS", Left(::cMunfg, 7))                                                                  // Informar o munic�pio de ocorr�ncia do fato gerador do fato gerador do IBS / CBS. Campo preenchido somente quando ?indPres = 5 (Opera��o presencial, fora do estabelecimento)?, e n�o tiver endere�o do destinat�rio (Grupo: E05) ou Local de entrega (Grupo: G01).
          Endif 

          If ::cModelo == [65]
             ::cXml+= ::XmlTag( "tpImp" , Iif(!(::cTpimp $ [4_5]), [4], Left(::cTpimp, 1))) 
          Elseif ::cModelo == [55]
             ::cXml+= ::XmlTag( "tpImp" , Iif(!(::cTpimp $ [0_1_2_3]), [1], Left(::cTpimp, 1)))                                  // Tipo de Impress�o 0 - Sem gera��o de DANFE; 1 - DANFE normal, Retrato; 2 - DANFE normal, Paisagem; 3 - DANFE Simplificado; 4 - DANFE NFC-e; 5 - DANFE NFC-e em mensagem eletr�nica
          Endif 

          ::cXml+= ::XmlTag( "tpEmis"   , Iif(!(::cTpemis $ [1_2_3_4_5_6_7_9]), [1], Left(::cTpemis, 1)))                        // 1=Emiss�o normal (n�o em conting�ncia); 2=Conting�ncia FS-IA, com impress�o do DANFE em Formul�rio de Seguran�a - Impressor Aut�nomo; 3=Conting�ncia SCAN (Sistema de Conting�ncia do Ambiente Nacional); *Desativado * NT 2015/002 4=Conting�ncia EPEC (Evento Pr�vio da Emiss�o em Conting�ncia); 5=Conting�ncia FS-DA, com impress�o do DANFE em Formul�rio de Seguran�a - Documento Auxiliar; 6=Conting�ncia SVC-AN (SEFAZ Virtual de Conting�ncia do AN); 7=Conting�ncia SVC-RS (SEFAZ Virtual de Conting�ncia do RS); 9=Conting�ncia off-line da NFC-e;
          ::cXml+= ::XmlTag( "cDV"      , Right(::cId, 1))                                                                       // D�gito da Chave de Acesso
          ::cXml+= ::XmlTag( "tpAmb"    , Iif(Empty(::cAmbiente), [2], Left(::cAmbiente, 1)))                                    // Identifica��o do Ambiente  1 - Produ��o,  2 - Homologa��o

          If ::cModelo == [65]
             ::cXml+= ::XmlTag( "finNFe", [1])                                                                                   // 1 - NF-e normal; 2 - NF-e complementar; 3 - NF-e de ajuste; 4 - Devolu��o de mercadoria; 5 - Nota de cr�dito; 6 - Nota de d�bito
          Elseif ::cModelo == [55]
             ::cXml+= ::XmlTag( "finNFe", Iif(!(::cFinnfe $ [1_2_3_4_5_6]), [1], Left(::cFinnfe, 1)))                            // 1 - NF-e normal; 2 - NF-e complementar; 3 - NF-e de ajuste; 4 - Devolu��o de mercadoria; 5 - Nota de cr�dito; 6 - Nota de d�bito
          Endif 

          If ::cFinnfe == [6]                                                                                                    // Nota de D�bito
             ::cXml+= ::XmlTag( "tpNFDebito"  , Iif(!(::tpNFDebito $ [01_02_03_04_05_06_07]), [01], Left(::tpNFDebito, 2)))      // 01=Transfer�ncia de cr�ditos para Cooperativas; 02=Anula��o de Cr�dito por Sa�das Imunes/Isentas; 03=D�bitos de notas fiscais n�o processadas na apura��o; 04=Multa e juros; 05=Transfer�ncia de cr�dito de sucess�o; 06=Pagamento antecipado; 07=Perda em estoque                                                      
          Elseif ::cFinnfe == [5]                                                                                                // Nota de Cr�dito
             ::cXml+= ::XmlTag( "tpNFCredito" , Iif(!(::tpNFCredito $ [01_02_03]), [01], Left(::tpNFCredito, 2)))                // 01 = Multa e juros; 02 = Apropria��o de cr�dito presumido de IBS sobre o saldo devedor na ZFM (art. 450, � 1�, LC 214/25); 03 = Retorno 
          Endif 

          If ::cAmbiente == [2] .or. ::cModelo == [65]
             ::cXml+= ::XmlTag( "indFinal" , [1])                                                                                // Indica opera��o com consumidor final (0 - N�o ; 1 - Consumidor Final)
          Else
             ::cXml+= ::XmlTag( "indFinal" , Iif(!(::cIndfinal $ [0_1]), [0], Left(::cIndfinal, 1)))                             // Indica opera��o com consumidor final (0 - N�o ; 1 - Consumidor Final)
          Endif 

          ::cXml+= ::XmlTag( "indPres"  , Iif(!(::cIndpres $ [0_1_2_3_4_5_9]), [0], Left(::cIndpres, 1)))                        // Indicador de Presen�a do comprador no estabelecimento comercial no momento da opera��o.
                                                                                                                                 // 1 - Opera��o presencial;
                                                                                                                                 // 2 - N�o presencial, internet;
                                                                                                                                 // 3 - N�o presencial, tele-atendimento;
                                                                                                                                 // 4 - NFC-e entrega em domic�lio;
                                                                                                                                 // 5 - Opera��o presencial, fora do estabelecimento; (inclu�do NT2016.002)
                                                                                                                                 // 9 - N�o presencial, outros.
          If !(::cIndpres $ [0_1_5])                                                                                             // Se Informado indicativo de presen�a, tag: indPres, DIFERENTE de 2, 3, 4 ou 9 ? Proibido o preenchimento do campo Indicativo do Intermediador (tag: indIntermed)
             ::cXml+= ::XmlTag( "indIntermed" , Iif(!(::cIndintermed $ [0_1]), [0], Left(::cIndintermed, 1)))                    // Indicador de intermediador/marketplace, 0 - Opera��o sem intermediador (em site ou plataforma pr�pria), 1 - Opera��o em site ou plataforma de terceiros (intermediadores/marketplace)
          Endif 

          ::cXml+= ::XmlTag( "procEmi"  , Iif(!(::cProcemi $ [0_1_2_3]), [1], Left(::cProcemi, 1)))                                // 0 - emiss�o de NF-e com aplicativo do contribuinte;
                                                                                                                                 // 1 - emiss�o de NF-e avulsa pelo Fisco;
                                                                                                                                 // 2 - emiss�o de NF-e avulsa, pelo contribuinte com seu certificado digital, atrav�s do site do Fisco;
                                                                                                                                 // 3 - emiss�o NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
          ::cXml+= ::XmlTag( "verProc"  , Left(::cVerproc, 20))                                                                  // Informar a vers�o do aplicativo emissor de NF-e.

          If ::cTpemis # [1]                                                                                                     // 1 - Emiss�o normal (n�o em conting�ncia
             ::cXml+= ::XmlTag( "dhCont" , ::DateTimeXml(::dDhcont, ::cTimeE))                                                   // Data-hora conting�ncia       FSDA - tpEmis = 5
             ::cXml+= ::XmlTag( "xJust"  , Left(::cXjust, 256))                                                                  // Justificativa conting�ncia   FSDA - tpEmis = 5
          Endif 

          If ::cModelo == [55]
             ::fCria_Compragov()
          Endif
   ::cXml+= "</ide>"
Return (Nil)

* -----------------> Metodo para gerar   AS refer�ncias da NF <----------------- *
METHOD fCria_AddNfref()                                                                                                          // Marcelo Brigatti
   If !Empty(::cRefnfe) .and. ::cModelo == [55] .and. (::cFinnfe == [2] .or. ::cFinnfe == [4])
      If "</ide><NFref>" $ ::cXml
         ::cXml:= StrTran(::cXml, "</ide><NFref>", "<NFref>")
      Endif 

      If "</NFref></ide>" $ ::cXml
         ::cXml:= StrTran(::cXml, "</NFref></ide>", "</NFref>")  
      Endif 

      If "</ide>" $ ::cXml
         ::cXml:= StrTran(::cXml, "</ide>", "")
      Endif 

      ::cXml+= "<NFref>"
             ::cXml+= ::XmlTag("refNFe" , Left(::fRetiraSinal(::cRefnfe), 44))
      ::cXml+= "</NFref>"

      ::cXml+= "</ide>"
   Endif 
Return (Nil)

* ------------------> Metodo para gerar a tag gCompragov <-------------------- *
METHOD fCria_Compragov()
   If !Empty(::cTpcompragov)
      ::cXml+= "<gCompraGov>"                                                                                                    
             ::cXml+= ::XmlTag( "tpCompraGov" , Iif(!(::cTpcompragov $ [1_2_3_4]), [1], Left(::cTpcompragov, 1)))                // 1=Uni�o 2=Estado 3=Distrito Federal 4=Munic�pio
             ::cXml+= ::XmlTag( "pRedutor"    , ::nPredutor, 4)                            
      ::cXml+= "</gCompraGov>"
   Endif                                                                             
Return (Nil)

* -----------------> Metodo para gerar a tag do emitente <-------------------- *
METHOD fCria_Emitente()
   ::cXml+= "<emit>"                                                                                                             // In�cio da TAG (emit)
          ::cXml+= ::XmlTag( "CNPJ" , Left(::SoNumeroCnpj(::cCnpj), 14))                                                         // CNPJ do Emitente
          ::cXml+= ::XmlTag( "xNome" , Left(::fRetiraAcento(::cXnomee), 60))                                                     // Raz�o Social emitente

          If !Empty(::cXfant)
             ::cXml+= ::XmlTag( "xFant" , Left(::fRetiraAcento(::cXfant), 60))                                                   // Nome Fantasia Emitente
          Endif 

          ::cXml+= "<enderEmit>"
                 ::cXml+= ::XmlTag( "xLgr"    , Left(::fRetiraAcento(::cXlgre), 60))                                             // Endere�o Emitente
                 ::cXml+= ::XmlTag( "nro"     , Left(::cNroe, 60))                                                               // N�mero do Endere�o do Emitente

                 If !Empty(::cXcple)
                    ::cXml+= ::XmlTag( "xCpl" , Left(::fRetiraAcento(::cXcple), 60))
                 Endif 

                 ::cXml+= ::XmlTag( "xBairro" , Left(::fRetiraAcento(::cXBairroe), 60))                                          // Bairro do Emitente
                 ::cXml+= ::XmlTag( "cMun"    , Left(::SoNumero(::cMunfg), 7))                                                   // C�digo IBGE do emitente
                 ::cXml+= ::XmlTag( "xMun"    , Left(::fRetiraAcento(::cXmune), 60))                                             // Cidade do Emitente
      	         ::cXml+= ::XmlTag( "UF"      , Left(::cUfE, 2))                                                                 // UF do Emitente
     	         ::cXml+= ::XmlTag( "CEP"     , Left(::SoNumero(::cCepe), 8))                                                    // CEP do Emitente
    	         ::cXml+= ::XmlTag( "cPais"   , Left(::cPais, 4))                                                                // C�digo do Pa�s emitente
    	         ::cXml+= ::XmlTag( "xPais"   , Left(::fRetiraAcento(::cXpaise), 60))                                            // Pa�s Emitente da NF

                 If !Empty(::SoNumero(::cFonee))
	                ::cXml+= ::XmlTag( "fone"    , Left(::SoNumero(::cFonee), 14))                                               // Telefone do Emitente
                 Endif 
          ::cXml+= "</enderEmit>"
          
          ::cXml+= ::XmlTag( "IE" , Left(::SoNumero(::cIee), 14))                                                                // Inscri��o Estadual do Emitente

          If !Empty(::cIme)                                                                                                      // N�o obrigat�rio
             ::cXml+= ::XmlTag( "IM" , Left(::SoNumero(::cIme), 15))                                                             // Inscri��o Municipal do Emitente
          Endif 

          If !Empty(::cCnaee)                                                                                                    // N�o obrigat�rio
             ::cXml+= ::XmlTag( "CNAE" , Left(::SoNumero(::cCnaee), 7))                                                          // CNAE do Emitente
          Endif 

          ::cXml+= ::XmlTag( "CRT" , Iif(Val(::cCrt) <= 1 .or. !(::cCrt $ [1_2_3]), [1], ::cCrt))                                // C�digos de Detalhamento do Regime e da Situa��o TABELA A ? C�digo de Regime Tribut�rio ? CRT
                                                                                                                                 // 1 ? Simples Nacional
                                                                                                                                 // 2 ? Simples Nacional ? excesso de sublimite da receita bruta
                                                                                                                                 // 3 ? Regime Normal NOTAS EXPLICATIVAS
   ::cXml+= "</emit>"                                                                                                            // Final da TAG Emitente
Return (Nil)

* -----------------> Metodo para gerar a tag do destinat�rio <---------------- *
METHOD fCria_Destinatario()
   Local lGerarDest:= lGerarEnder:= .F.

   // Decidir se deve gerar <dest>
   lGerarDest:= (::cModelo == [55]) .or. (::cModelo == [65] .and. (!Empty(::cXnomed) .or. !Empty(::cCnpjd)))

   If lGerarDest
      ::cXml += "<dest>"

      // CNPJ/CPF
      If !Empty(::cCnpjd)
         If Len(::SoNumeroCnpj(::cCnpjd)) < 14                                                                                   // Pessoa F�sica - CPF
            ::cXml+= ::XmlTag("CPF", Left(::SoNumeroCnpj(::cCnpjd), 11))
         Else                                                                                                                    // Pessoa Jur�dica - CNPJ
            ::cXml+= ::XmlTag("CNPJ", Left(::SoNumeroCnpj(::cCnpjd), 14))
         Endif
      Endif

      // Id estrangeiro
      If !Empty(::cIdestrangeiro) .AND. ::cUfd == [EX]
         ::cXml+= ::XmlTag("idEstrangeiro", Left(::cIdestrangeiro, 20))
      Endif

      // Nome
      If ::cAmbiente == [2]                                                                                                      // Homologa��o
         ::cXml+= ::XmlTag("xNome", "NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL")
      Elseif !Empty(::cXnomed)                                                                                                   // Produ��o: s� se tiver nome
         ::cXml+= ::XmlTag("xNome", Left(::fRetiraAcento(::cXnomed), 60))
      Endif

      // enderDest: gerar apenas se modelo 55 e houver dados de endere�o
      lGerarEnder:= ::cModelo == [55] .and. (!Empty(::cXlgrd) .or. !Empty(::cNrod) .or. !Empty(::cXBairrod) .or. !Empty(::cCmund) .or. !Empty(::cXmund))

      If lGerarEnder
         ::cXml+= "<enderDest>"
         ::cXml+= ::XmlTag("xLgr", Left(::fRetiraAcento(::cXlgrd), 60))
         ::cXml+= ::XmlTag("nro", Left(::cNrod, 60))

         If !Empty(::cXcpld)
            ::cXml+= ::XmlTag("xCpl", Left(::cXcpld, 60))
         Endif

         ::cXml+= ::XmlTag("xBairro", Left(::fRetiraAcento(::cXBairrod), 60))

         If ::cUfd == "EX"
            ::cXml+= ::XmlTag("cMun", "9999999")
            ::cXml+= ::XmlTag("xMun", "EXTERIOR")
            ::cXml+= ::XmlTag("UF", "EX")
         Else
            ::cXml+= ::XmlTag("cMun", Left(::cCmund, 7))
            ::cXml+= ::XmlTag("xMun", Left(::fRetiraAcento(::cXmund), 60))
            ::cXml+= ::XmlTag("UF", Left(::cUfd, 2))
            ::cXml+= ::XmlTag("CEP", Left(::SoNumero(::cCepd), 8))
         Endif

         IF !Empty(::cPaisd)
            ::cXml+= ::XmlTag("cPais", Left(::cPaisd, 4))
         Endif

         If !Empty(::cXpaisd)
            ::cXml+= ::XmlTag("xPais", Left(::cXpaisd, 60))
         Endif

         If !Empty(::SoNumero(::cFoned))
            ::cXml+= ::XmlTag("fone", Left(::SoNumero(::cFoned), 14))
         Endif

         ::cXml+= "</enderDest>"
      Endif

      // indIEDest
      ::cXml+= ::XmlTag("indIEDest", If(::cModelo == [65] .or. ::cUfd == [EX], [9], Left(::cIndiedest, 1)))

      // IE s� se modelo 55 e n�o exterior
      If !Empty(::cIed) .and. !(::cUfd == [EX]) .and. !(::cModelo == [65]) .and. ::cIndiedest == [1]
         ::cXml+= ::XmlTag("IE", Left(::SoNumero(::cIed), 14))
      Endif

      // Email (opcional em ambos os modelos)
      If !Empty(::cEmaild)
         ::cXml+= ::XmlTag("email", Left(::cEmaild, 60))
      Endif

      ::cXml+= "</dest>"
   Endif
Return (Nil)

* ----------> Metodo para gerar a tag do // Contador Respons�vel <------------ *
METHOD fCria_Autxml()   // Marcelo Brigatti
   If !Empty(::cAutxml)
      ::cXml+= '<autXML>'
         If Len(::SoNumeroCnpj(::cAutxml)) < 14
            ::cXml+= ::XmlTag( "CPF"  , Left(::SoNumero(::cAutxml), 11))
         Else
            ::cXml+= ::XmlTag( "CNPJ" , Left(::SoNumeroCnpj(::cAutxml), 14))
         Endif 
      ::cXml+= '</autXML>'
   Endif 
Return (Nil)

* ----------> Metodo gen�rico Endereco <-------------------------------------- *
METHOD fCria_Endereco(cTipo)
   Local lCond, cCnpj, cXNome, cXFant, cXlgr, cNro, cXcpl, cXBairro, cMun, cXMun, cUf, cCep, cPais, cXPais, cFone, cEmail, cIE

   Do Case
      Case Lower(cTipo) == [retirada]
           lCond   := (Alltrim(::cXlgrd) # Alltrim(::cXlgrr))
           cCnpj   := ::cCnpjr
           cXNome  := ::cXnomer
           cXFant  := ::cXfantr
           cXlgr   := ::cXlgrr
           cNro    := ::cNror
           cXcpl   := ::cXcplr
           cXBairro:= ::cXBairror
           cMun    := ::cMunfg
           cXMun   := ::cXmunr
           cUf     := ::cUfE
           cCep    := ::cCepr
           cPais   := ::cPaisr
           cXPais  := ::cXpaisr
           cFone   := ::cFoner
           cEmail  := ::cEmailr
           cIE     := ::cIer
      Case Lower(cTipo) == [entrega]
           lCond   := (Alltrim(::cXlgrd) # Alltrim(::cXlgrg))
           cCnpj   := ::cCnpjg
           cXNome  := ::cXnomeg
           cXFant  := ::cXfantg
           cXlgr   := ::cXlgrg
           cNro    := ::cNrog
           cXcpl   := ::cXcplg
           cXBairro:= ::cXBairrog
           cMun    := ::cMunfg
           cXMun   := ::cXmung
           cUf     := ::cUfg
           cCep    := ::cCepg
           cPais   := ::cPaisg
           cXPais  := ::cXpaisg
           cFone   := ::cFoneg
           cEmail  := ::cEmailg
           cIE     := ::cIeg
      Endcase

      If lCond
         ::cXml+= "<" + cTipo + ">"

         If Len(cCnpj) < 14
            ::cXml+= ::XmlTag("CPF"  , Left(cCnpj, 11))
         Else
            ::cXml+= ::XmlTag("CNPJ" , Left(cCnpj, 14))
         Endif

         ::cXml+= ::XmlTag("xNome"   , Left(::fRetiraAcento(cXNome), 60))

         If !Empty(cXFant)
            ::cXml+= ::XmlTag("xFant", Left(::fRetiraAcento(cXFant), 60))
         Endif

         ::cXml+= ::XmlTag("xLgr"    , Left(::fRetiraAcento(cXlgr), 60))
         ::cXml+= ::XmlTag("nro"     , Left(cNro, 60))

         If !Empty(cXcpl)
            ::cXml+= ::XmlTag("xCpl" , Left(::fRetiraAcento(cXcpl), 60))
         Endif

         ::cXml+= ::XmlTag("xBairro" , Left(::fRetiraAcento(cXBairro), 60))
         ::cXml+= ::XmlTag("cMun"    , Left(cMun, 7))
         ::cXml+= ::XmlTag("xMun"    , Left(::fRetiraAcento(cXMun), 60))
         ::cXml+= ::XmlTag("UF"      , Left(cUf, 2))
         ::cXml+= ::XmlTag("CEP"     , Left(cCep, 8))
         ::cXml+= ::XmlTag("cPais"   , Left(cPais, 4))
         ::cXml+= ::XmlTag("xPais"   , Left(::fRetiraAcento(cXPais), 60))

         If !Empty(cFone)
            ::cXml+= ::XmlTag("fone" , Left(cFone, 14))
         Endif

         If !Empty(cEmail)
            ::cXml+= ::XmlTag("email", Left(cEmail, 60))
         Endif

         ::cXml+= ::XmlTag("IE"      , Left(cIE, 14))
         ::cXml+= "</" + cTipo + ">"
   ENDIF
Return (Nil)

* ----------> Metodo para gerar a tag do endere�o de retirada <--------------- *
METHOD fCria_Retirada()
Return(::fCria_Endereco([retirada]))

* ----------> Metodo para gerar a tag do endere�o de entrega <---------------- *
METHOD fCria_Entrega()
Return(::fCria_Endereco([entrega]))
   
* ---------------> Metodo para gerar a tag dos itens da NFE <----------------- *
METHOD fCria_Produto()
   ::cXml+= [<det nItem="] + Left(NumberXml( ::nItem, 0 ), 3) + [">]
          ::cXml+= "<prod>"
                 ::cXml+= ::XmlTag( "cProd"    , Left(::cProd, 60))

		 If !Empty(::cEan)
                    ::cXml+= ::XmlTag( "cEAN"  , Left(::cEan, 14))
                 Else
                    ::cXml+= ::XmlTag( "cEAN"  , [SEM GTIN])
                 Endif 

                 If ::cAmbiente == [2] .and. ::cModelo == [65] .and. ::nItem == 1
                    ::cXml+= ::XmlTag( "xProd" , [NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL])
                 Else
                    ::cXml+= ::XmlTag( "xProd" , Left(::fRetiraAcento(::cXprod), 120))
                 Endif 

                 ::cXml+= ::XmlTag( "NCM"      , Iif(Empty(::cNcm), [00], Left(::cNcm, 8)))                                      // Obrigat�ria informa��o do NCM completo (8 d�gitos). Nota: Em caso de item de servi�o ou item que n�o tenham produto (ex. transfer�ncia de cr�dito, cr�dito do ativo imobilizado, etc.), informar o valor 00 (dois zeros). (NT 2014/004)

        	 If Len(::cNcm) > 8
        	    ::cXml+= ::XmlTag( "EXTIPI" , [0] + Right(::cNcm, 2))                                                            // Excess�o de IPI 
        	 Endif    

                 If !Empty(::cCest)
                    ::cXml+= ::XmlTag( "CEST"  , Left(::SoNumero(::cCest), 7))
                 Endif 

                 ::cXml    += ::XmlTag( "CFOP"  , Left(::SoNumero(::cCfOp), 4))
                 ::cXml    += ::XmlTag( "uCom"  , Left(::cUcom, 6))
                 ::cXml    += ::XmlTag( "qCom"  , ::nQcom, 4)
                 ::cXml    += ::XmlTag( "vUnCom", ::nVuncom, 10)
                 ::cXml    += ::XmlTag( "vProd" , ::nVprod:= Round(::nQcom * ::nVuncom, 2))
                 ::nVprod_t+= ::nVprod                                                                                           // j� acumula o valor dos produtos para os totais

		 If !Empty(::cEantrib)
                    ::cXml+= ::XmlTag( "cEANTrib" , Left(::cEantrib, 14))
                 Else
                    ::cXml+= ::XmlTag( "cEANTrib" , [SEM GTIN])
                 Endif 

                 ::cXml+= ::XmlTag( "uTrib"    , Left(::cUcom, 6))
                 ::cXml+= ::XmlTag( "qTrib"    , ::nQcom, 4)
                 ::cXml+= ::XmlTag( "vUnTrib"  , ::nVuncom, 10)

                 If !Empty(::nVfrete)
                    ::cXml += ::XmlTag( "vFrete", ::nVfrete)
                 Endif 
                 ::nVFrete_t+= ::nVfrete                                                                                         // j� acumula o valor dos fretes para os totais

                 If !Empty(::nVseg)
                    ::cXml+= ::XmlTag( "vSeg"  , ::nVseg)
                 Endif 
                 ::nVseg_t+= ::nVseg                                                                                             // j� acumula o valor dos seguros para os totais

                 If !Empty(::nVdesc)
                    ::cXml += ::XmlTag( "vDesc" , ::nVdesc)
                 Endif 
                 ::nVDesc_t+= ::nVdesc                                                                                           // j� acumula o valor dos descontos para os totais

                 If !Empty(::nVoutro)
                    ::cXml  += ::XmlTag( "vOutro" , ::nVoutro)
                 Endif 
                 ::nVOutro_t+= ::nVoutro                                                                                         // j� acumula o valor dos descontos para os totais
 
                 ::cXml+= ::XmlTag( "indTot", Iif(!(::cIndtot $ [0_1]), [0], Left(::cIndtot, 1)))                                // Indica se valor do Item (vProd) entra no valor total da NF-e (vProd). 0=Valor do item (vProd) n�o comp�e o valor total da NF-e 1=Valor do item (vProd) comp�e o valor total da NF-e (vProd) (v2.0)

                 If !Empty(::cXped)                                                                                              // Marcelo Brigatti 
                    ::cXml+= ::XmlTag( "xPed"      , Left(::cXped, 15))                                                          // n�mero do pedido de compra
                    ::cXml+= ::XmlTag( "nItemPed"  , ::SoNumero(::nNitemped), 6)                                                 // n�mero do �tem do pedido de compra 
                 Endif   

                 If !Empty(::cNfci)                
                    ::cXml+= ::XmlTag( "nFCI"      , Left(::cNfci, 36))                                                          // Informa��o relacionada com a Resolu��o 13/2012 do Senado Federal. Formato: Algarismos, letras mai�sculas de "A" a "F" e o caractere h�fen. Exemplo: B01F70AF-10BF-4B1F-848C-65FF57F616FE
                 Endif   

                 ::fCria_ProdCombustivel()                                                                                       // somente 1 vez correto aqui 1-1
                 ::fCria_ProdVeiculo()                                                                                           // somente 1 vez correto aqui 1-1
                 ::fCria_ProdMedicamento()                                                                                       // somente 1 vez correto aqui 1-1

                 // est� errado aqui feito somente para testar xml ou se tiver uma s� produto de importa��o
                 If Len(AllTrim(::cNdi)) > 0
                    ::fCria_ProdImporta()
                 Endif 
          ::cXml+= "</prod>"
           
          ::cXml+= "<imposto>"                                                                                                   // BLOCO M - IMPOSTOS
                 If ::nVtottrib > 0 .and. SubStr(::cCfOp, 2, 3) # [010]                                                          // lei transpar�ncia
                    ::cXml      += ::XmlTag("vTotTrib", ::nVtottrib)
                    ::nVtottribt+= ::nVtottrib                                                                                   // j� acumula o valor dos tributos para os totais
                 Endif 

                 ::fCria_ProdutoIcms()
                 ::fCria_ProdutoIpi() 
                 ::fCria_ProdutoII()
                 ::fCria_ProdutoPisCofins()
                 ::fCria_ProdutoIs()
                 ::fCria_ProdutoIbscbs()
          ::cXml+= "</imposto>"

          If !Empty(::cInfadprod)
             ::cXml+= ::XmlTag( "infAdProd", Left( ::cInfadprod, 500))
          Else
             If ::lVtottrib == .T. .and. ::nVtottrib # 0                                                                         // lei transpar�ncia informa��es adicionais do produtos
                ::cXml+= ::XmlTag( "infAdProd", Left(Iif(::nVtottrib > 0, [Valor aproximado dos tributos federais, estaduais e municipais: R$ ] + NumberXml(::nVtottrib, 2) + [ Fonte IBPT. ], []) + ::cInfadprod , 500))
             Endif 
          Endif                   
   ::cXml+= "</det>"
Return (Nil)

* ----------------> Metodo para gerar a tag de veicProd <----------------- *
METHOD fCria_ProdVeiculo()  // Grupo JA. Detalhamento Espec�fico de Ve�culos novos                                                                               
   If !Empty(::cChassi)
      ::cXml+= "<veicProd>"
             ::cXml+= ::XmlTag( "tpOp"         , Iif(!(::cTpOp $ [0_1_2_3]), [0], Left(::cTpOp, 1)))                                                              // 1=Venda concession�ria, 2=Faturamento direto para consumidor final 3=Venda direta para grandes consumidores (frotista, governo, ...) 0=Outros
             ::cXml+= ::XmlTag( "chassi"       , Left(::SoNumero(::cChassi), 17))                                                                                 // Chassi do ve�culo - VIN (c�digo-identifica��o-ve�culo)
             ::cXml+= ::XmlTag( "cCor"         , Left(::cCor, 4))                                                                                                 // Cor - C�digo de cada montadora
             ::cXml+= ::XmlTag( "xCor"         , Left(::cXcor, 40))                                                                                               // Descri��o da Cor 
             ::cXml+= ::XmlTag( "pot"          , Left(::cPot, 4))                                                                                                 // Pot�ncia Motor (CV)             
             ::cXml+= ::XmlTag( "cilin"        , Left(::cCilin, 9))                                                                                               // Pot�ncia m�xima do motor do ve�culo em cavalo vapor (CV). (pot�ncia-ve�culo)
             ::cXml+= ::XmlTag( "pesoL"        , ::nPesolvei, 4)                                                                                                  // Em toneladas - 4 casas decimais                                                     
             ::cXml+= ::XmlTag( "pesoB"        , ::nPesobvei, 4)                                                                                                  // Peso Bruto Total - em tonelada - 4 casas decimais
             ::cXml+= ::XmlTag( "nSerie"       , Left(::cNserie, 9))                                                                                              // Serial (s�rie)
             ::cXml+= ::XmlTag( "tpComb"       , Iif(!(::cTpcomb $ [01_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17_18]), [01], Left(::cTpcomb, 2)))           // Utilizar Tabela RENAVAM (v2.0) 01 - �lcool, 02 - Gasolina, 03 - Diesel, 04 - Gasog�nio, 05 - G�s Metano, 06 - El�trico/Fonte Interna, 07 - El�trico/Fonte Externa, 08 - Gasolina/G�s Natural Combust�vel, 09 - �lcool/G�s Natural Combust�vel, 10 - Diesel/G�s Natural Combust�vel, 11 - Vide/Campo/Observa��o, 12 - �lcool/G�s Natural Veicular, 13 - Gasolina/G�s Natural Veicular, 14 - Diesel/G�s Natural Veicular, 15 - G�s Natural Veicular, 16 - �lcool/Gasolina, 17 - Gasolina/�lcool/G�s Natural Veicular, 18 - Gasolina/el�trico                                                    
             ::cXml+= ::XmlTag( "nMotor"       , Left(::cNmotor, 21))                                                                                             // N�mero de Motor
             ::cXml+= ::XmlTag( "CMT"          , ::nCmt, 4)                                                                                                       // CMT - Capacidade M�xima de Tra��o - em Toneladas 4 casas decimais (v2.0)
             ::cXml+= ::XmlTag( "dist"         , Left(::cDist, 4))                                                                                                // Dist�ncia entre eixos
             ::cXml+= ::XmlTag( "anoMod"       , Left(::cAnomod, 4))                                                                                              // Ano Modelo de Fabrica��o
             ::cXml+= ::XmlTag( "anoFab"       , Left(::cAnofab, 4))                                                                                              // Ano de Fabrica��o
             ::cXml+= ::XmlTag( "tpVeic"       , Iif(!(::cTpveic $ [02_03_04_05_06_07_08_10_11_13_14_17_18_19_20_21_22_23_24_25_26]), [02], Left(::cTpveic, 2)))  // Utilizar Tabela RENAVAM, conforme exemplos abaixo: 02=CICLOMOTO; 03=MOTONETA; 04=MOTOCICLO; 05=TRICICLO; 06=AUTOM�VEL; 07=MICRO-�NIBUS; 08=�NIBUS; 10=REBOQUE; 11=SEMIRREBOQUE; 13=CAMIONETA; 14=CAMINH�O; 17=CAMINH�O TRATOR; 18=TRATOR RODAS; 19=TRATOR ESTEIRAS; 20=TRATOR MISTO; 21=QUADRICICLO; 22=ESP / �NIBUS; 23=CAMINHONETE; 24=CARGA/CAM; 25=UTILIT�RIO; 26=MOTOR-CASA
             ::cXml+= ::XmlTag( "espVeic"      , Iif(!(::cEspveic $ [1_2_3_4_5_6]), [1], Left(::cEspveic, 1)))                                                    // Utilizar Tabela RENAVAM 1=PASSAGEIRO; 2=CARGA; 3=MISTO;4=CORRIDA; 5=TRA��O; 6=ESPECIAL;
             ::cXml+= ::XmlTag( "VIN"          , Iif(!(::cVin $ [N_R]), [N], Left(::cVin, 1)))                                                                    // Condi��o do VIN Informa-se o ve�culo tem VIN (chassi) remarcado. R=Remarcado; N=Normal
             ::cXml+= ::XmlTag( "condVeic"     , Iif(!(::cCondveic $ [1_2_3]), [1], Left(::cCondveic, 1)))                                                        // Condi��o do Ve�culo 1=Acabado; 2=Inacabado; 3=Semiacabado
             ::cXml+= ::XmlTag( "cMod"         , Left(::cCmod, 6))                                                                                                // C�digo Marca Modelo                                                  
             ::cXml+= ::XmlTag( "cCorDENATRAN" , Iif(!(::cCordenatran $ [01_02_03_04_05_06_07_08_09_10_11_13_14_15_16]), [01], Left(::cCorDENATRAN, 2)))          // Segundo   AS regras de pr�-cadastro do DENATRAN (v2.0) 01=AMARELO, 02=AZUL, 03=BEGE,04=BRANCA, 05=CINZA, 06=-DOURADA,07=GREN�, 08=LARANJA, 09=MARROM,10=PRATA, 11=PRETA, 12=ROSA, 13=ROXA,14=VERDE, 15=VERMELHA, 16=FANTASIA
             ::cXml+= ::XmlTag( "lota"         , Left(::cLota, 3))                                                                                                // Quantidade m�xima permitida de passageiros sentados, inclusive o motorista. (v2.0)
             ::cXml+= ::XmlTag( "tpRest"       , Iif(!(::cTprest $ [0_1_2_3_4_9]), [0], Left(::cTprest, 1)))                                                      // Restri��o 0=N�o h�; 1=Aliena��o Fiduci�ria; 2=Arrendamento Mercantil; 3=Reserva de Dom�nio; 4=Penhor de Ve�culos; 9=Outras. (v2.0)
      ::cXml+= "</veicProd>"
   Endif 
Return (Nil)

* ----------------> Metodo para gerar a Tag arma <---------------------------- *
METHOD fCria_ProdArmamento()  // Tag arma - Grupo L. Detalhamento Espec�fico de Armamentos
   Local cTexto:= cTexto1:= [], nPosIni, nPosFim

   If !Empty(::cNserie_a)
      If [<det nItem="] + Left(NumberXml(::nItem, 0 ), 3) + [">] $ ::cXml
         cTexto:= fRemoveDet(::cXml, ::nItem)

         cTexto1+= "<arma>"
                cTexto1+= ::XmlTag( "tpArma" , Iif(!(::cTparma $ [0_1]), [0], Left(::cTparma, 1)))                               // Indicador do tipo de arma de fogo 0=Uso permitido; 1=Uso restrito
                cTexto1+= ::XmlTag( "nSerie" , Left(::cNserie_a, 15))                                                            // N�mero de s�rie da arma
                cTexto1+= ::XmlTag( "nCano"  , Left(::cNcano, 15))                                                               // N�mero de s�rie do cano
                cTexto1+= ::XmlTag( "descr"  , Left(::fRetiraAcento(::cDescr_a), 256))                                           // Descri��o completa da arma, compreendendo: calibre, marca, capacidade, tipo de funcionamento, comprimento e demais elementos que permitam a sua perfeita identifica��o.
         cTexto1+= "</arma>"

         cTexto := StrTran(cTexto, "</prod>", cTexto1 + "</prod>")
         nPosIni:= Hb_At([<det nItem="] + Left(NumberXml(::nItem, 0 ), 3) + [">] , ::cXml)
         nPosFim:= Hb_At("</det>", ::cXml, nPosIni) + 6
         ::cXml := Substr(::cXml, 1, nPosIni - 1) + cTexto + Substr(::cXml, nPosFim)
      Endif 
   Endif 

   Release cTexto, cTexto1, nPosIni, nPosFim
Return (Nil)

* ---------------------> Fun��o para remover tag de Detalhe <------------------ *
Static Function fRemoveDet(cTxtXml, nItem)
   Local nPosIni, nPosFim

   nPosIni := Hb_At([<det nItem="] + Left(NumberXml(nItem, 0 ), 3) + [">] , cTxtXml)
   nPosFim := Hb_At("</indTot>", cTxtXml, nPosIni) + 9
   cTxtXml := Substr(cTxtXml, nPosIni, nPosFim)

   Release nPosIni, nPosFim
Return (cTxtXml)

* ----------------> Metodo para gerar a tag de Detalhe Medicam. <------------- *
METHOD fCria_ProdMedicamento() // Grupo K. Detalhamento Espec�fico de Medicamento e de mat�rias-primas farmac�uticas
   If !Empty(::nVpmc)
      ::cXml+= "<med>"
             ::cXml+= ::XmlTag( "cProdANVISA"       , Left(::cProdanvisa, 13))                                                   // C�digo de Produto da ANVISA - Utilizar o n�mero do registro ANVISA ou preencher com o literal ?ISENTO?, no caso de medicamento isento de registro na ANVISA. (Inclu�do na NT2016.002. Atualizado na NT 2018.005)

             If !Empty(::cXmotivoisencao)
                ::cXml+= ::XmlTag( "xMotivoIsencao" , Left(::cXmotivoisencao, 255))                                              // Motivo da isen��o da ANVISA - Obs.: Para medicamento isento de registro na ANVISA, informar o n�mero da decis�o que o isenta, como por exemplo o n�mero da Resolu��o da Diretoria Colegiada da ANVISA (RDC). (Criado na NT 2018.005) 
             Endif 

             ::cXml+= ::XmlTag( "vPMC"              , ::nVpmc)                                                                   // Pre�o m�ximo consumidor
      ::cXml+= "</med>"
   Endif 
Return (Nil)

* ----------------> Metodo para gerar a tag de combust�veis <----------------- *
METHOD fCria_ProdCombustivel()                                                                                                   // Marcelo de Paula, Marcelo Brigatti

   // N�mero ANP para combust�veis
   If ::cCfOp $ [1662_2662_5651_5652_5653_5654_5655_5656_5657_5658_5659_5660_5661_5662_5663_5664_5665_5666_5667_6651_6652_6653_6654_6655_6656_6657_6658_6659_6660_6661_6662_6663_6664_6665_6666_6667_7651_7654_7667]
      ::cXml+= "<comb>"
             ::cXml+= ::XmlTag( "cProdANP" , Left(::SoNumero(::cCprodanp), 9))                                                   // C�digo de produto da ANP
             ::cXml+= ::XmlTag( "descANP"  , Left(::cDescanp, 95))                                                               // Descri��o do produto conforme ANP
             If ::nQtemp > 0
                ::cXml+= ::XmlTag( "qTemp" , ::nQtemp, 4)                                                                        // Quantidade de combust�vel faturada � temperatura ambiente.
             EndIf   
             ::cXml+= ::XmlTag( "UFCons"   , Left(::cUfd, 2))

             If ::nQbcprod  > 0
                    ::cXml+= "<CIDE>"
                           ::cXml+= ::XmlTag( "qBCProd"    , ::nQbcprod, 4)                                                      // Informar a BC da CIDE em quantidade
                           ::cXml+= ::XmlTag( "vAliqProd"  , ::nValiqprod, 4)                                                    // Informar o valor da al�quota em reais da CIDE
                           ::cXml+= ::XmlTag( "vCIDE"      , ::nVcide)                                                           // Informar o valor da CIDE
                    ::cXml+= "</CIDE>"
             Endif 
      ::cXml+= "</comb>"
   Endif 
Return (Nil)

* --------------------> Metodo para gerar a tag do ICMS <--------------------- *
METHOD fCria_ProdutoIcms()
   If ::cCsticms  $ [000_010_020_030_040_041_050_051_060_070_090_101_102_103_201_202_203_300_400_500_900]
      ::cXml+= "<ICMS>"                                                                                                          // BLOCO N - ICMS NORMAL E ST
             Do Case
                Case ::cCsticms == [000]
                     ::cXml+= "<ICMS00>"
                            ::cXml    += ::XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"   , SubStr(::cCsticms, 2, 2))
                            ::cXml    += ::XmlTag( "modBC" , Iif(!(::cModbc $ [0_1_2_3]), [0], Left(::cModbc, 1)))               // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                            ::cXml    += ::XmlTag( "vBC"   , ::nVbc)
                            ::cXml    += ::XmlTag( "pICMS" , ::nPicms, 4)
                            ::cXml    += ::XmlTag( "vICMS" , Iif( ::nVicms # 0, ::nVicms, ::nVicms:= Round(::nVbc * (::nPicms / 100), 2) ) )
                            ::nVbc_t  += ::nVbc                                                                                  // j� acumula o valor da base de c�lculo para os totais
                            ::nVicms_t+= ::nVicms                                                                                // j� acumula o valor do icms para os totais
                     ::cXml+= "</ICMS00>"
                Case ::cCsticms == [010]
                     ::cXml+= "<ICMS10>"
                            ::cXml    += ::XmlTag( "orig"    , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"     , SubStr(::cCsticms, 2, 2))
                            ::cXml    += ::XmlTag( "modBC"   , Iif(!(::cModbc $ [0_1_2_3]), [0], Left(::cModbc, 1)))             // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                            ::cXml    += ::XmlTag( "vBC"     , ::nVbc)
                            ::cXml    += ::XmlTag( "pICMS"   , ::nPicms, 4)
                            ::cXml    += ::XmlTag( "vICMS"   , Iif( ::nVicms # 0, ::nVicms, ::nVicms:= Round(::nVbc * (::nPicms / 100), 2) ) )
                            ::cXml    += ::XmlTag( "modBCST" , Iif(!(::cModbcst $ [0_1_2_3_4_5_6]), [3], Left(::cModbcst, 1)))   // Modalidade de determina��o da BC do ICMS ST. 0=Pre�o tabelado ou m�ximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor), 6 = Valor da Opera��o (NT 2019.001)
                            ::cXml    += ::XmlTag( "pMVAST"  , ::nPmvast, 4)
                            ::cXml    += ::XmlTag( "vBCST"   , ::nVbcst)
                            ::cXml    += ::XmlTag( "pICMSST" , ::nPicmst, 4)
                            ::cXml    += ::XmlTag( "vICMSST" , ::nVicmsst:= Round(::nVbcst * (::nPicmst / 100), 2) )
                            ::nVbc_t  += ::nVbc                                                                                  // j� acumula o valor da base de c�lculo para os totais
                            ::nVbcst_t+= ::nVbcst                                                                                // j� acumula o valor dos base de c�lculo da subs. tribut�ria para os totais
                            ::nVicms_t+= ::nVicms                                                                                // j� acumula o valor do icms para os totais
                     ::cXml+= "</ICMS10>"
                Case ::cCsticms == [020]
                     ::cXml+= "<ICMS20>"
                            ::cXml    += ::XmlTag( "orig"   , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"    , SubStr(::cCsticms, 2, 2))
                            ::cXml    += ::XmlTag( "modBC"  , Iif(!(::cModbc $ [0_1_2_3]), [0], Left(::cModbc, 1)))              // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                            ::cXml    += ::XmlTag( "pRedBC" , ::nPredbc, 4)
                            ::cXml    += ::XmlTag( "vBC"    , ::nVbc)
                            ::cXml    += ::XmlTag( "pICMS"  , ::nPicms, 4)
                            ::cXml    += ::XmlTag( "vICMS"  , ::nVicms:= Round(::nVbc * (::nPicms / 100), 2) )
                         ::nVbc_t  += ::nVbc                                                                                     // j� acumula o valor da base de c�lculo para os totais
                         ::nVicms_t+= ::nVicms                                                                                   // j� acumula o valor do icms para os totais
                     ::cXml+= "</ICMS20>"
                Case ::cCsticms == [030]
                     ::cXml+= "<ICMS30>"
                            ::cXml    += ::XmlTag( "orig"     , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"      , SubStr(::cCsticms, 2, 2))
                            ::cXml    += ::XmlTag( "modBCST"  , Iif(!(::cModbcst $ [0_1_2_3_4_5_6]), [3], Left(::cModbcst, 1)))  // Modalidade de determina��o da BC do ICMS ST. 0=Pre�o tabelado ou m�ximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor), 6 = Valor da Opera��o (NT 2019.001)
                            ::cXml    += ::XmlTag( "pMVAST"   , ::nPmvast, 4)
                            ::cXml    += ::XmlTag( "pRedBCST" , ::nPredbcst, 4)
                            ::cXml    += ::XmlTag( "vBCST"    , ::nVbct)
                            ::cXml    += ::XmlTag( "pICMSST"  , ::nPicmst, 4)
                            ::cXml    += ::XmlTag( "vICMSST"  , ::nVicmsst:= Round(::nVbcst * (::nPicmst / 100), 2) )
                            ::nVbcst_t+= ::nVbcst                                                                                // j� acumula o valor dos base de c�lculo da subs. tribut�ria para os totais
                     ::cXml+= "</ICMS30>"
                Case ::cCsticms $ [040_041_050]
                     ::cXml+= "<ICMS40>"
                            ::cXml    += ::XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"   , SubStr(::cCsticms, 2, 2))
                     ::cXml+= "</ICMS40>"
                Case ::cCsticms == [051]
                     ::cXml+= "<ICMS51>"
                            ::cXml    += ::XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"   , SubStr(::cCsticms, 2, 2))
                            ::cXml    += ::XmlTag( "modBC" , Iif(!(::cModbc $ [0_1_2_3]), [0], Left(::cModbc, 1)))               // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                     ::cXml+= "</ICMS51>"
                Case ::cCsticms == [060]
                     ::cXml+= "<ICMS60>"
                            ::cXml    += ::XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"   , SubStr(::cCsticms, 2, 2))
                            If ::nVbcstret # 0
                               ::cXml    += ::XmlTag( "vBCSTRet"       , ::nVbcstret)
                               ::cXml    += ::XmlTag( "pST"            , ::nPst, 4)
                               ::cXml    += ::XmlTag( "vICMSSubstituto", ::nVicmssubstituto)
                               ::cXml    += ::XmlTag( "vICMSSTRet"     , ::nVicmstret)
                            Endif
                     ::cXml+= "</ICMS60>"
                Case ::cCsticms == [070]
                     ::cXml+= "<ICMS70>"
                            ::cXml    += ::XmlTag( "orig"    , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"     , SubStr(::cCsticms, 2, 2))
                            ::cXml    += ::XmlTag( "modBC"   , Iif(!(::cModbc $ [0_1_2_3]), [0], Left(::cModbc, 1)))             // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                            ::cXml    += ::XmlTag( "pRedBC"  , ::nPredbc, 4)
                            ::cXml    += ::XmlTag( "vBC"     , ::nVbc)
                            ::cXml    += ::XmlTag( "pICMS"   , ::nPicms, 4)
                            ::cXml    += ::XmlTag( "vICMS" , Iif( ::nVicms # 0, ::nVicms, ::nVicms:= Round(::nVbc * (::nPicms / 100), 2) ) )
                            ::cXml    += ::XmlTag( "modBCST" , Iif(!(::cModbcst $ [0_1_2_3_4_5]), [3], Left(::cModbcst, 1)))     // Modalidade de determina��o da BC do ICMS ST. 0=Pre�o tabelado ou m�ximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor) // S� at� o 5 aqui
                            ::cXml    += ::XmlTag( "pMVAST"  , ::nPmvast, 4)
                            ::cXml    += ::XmlTag( "vBCST"   , ::nVbcst)
                            ::cXml    += ::XmlTag( "pICMSST" , ::nPicmst, 4)
                            ::cXml    += ::XmlTag( "vICMSST" , ::nVicmsst:= Round(::nVbcst * (::nPicmst / 100), 2) )
                            ::cXml    += ::XmlTag( "pBCOp"   , 1, 4)
                            ::cXml    += ::XmlTag( "UFST"    , Left(::cUfd, 2))
                            ::nVbc_t  += ::nVbc                                                                                  // j� acumula o valor da base de c�lculo para os totais
                            ::nVbcst_t+= ::nVbcst                                                                                // j� acumula o valor dos base de c�lculo da subs. tribut�ria para os totais
                            ::nVicms_t+= ::nVicms                                                                                // j� acumula o valor do icms para os totais
                     ::cXml+= "</ICMS70>"
                Case ::cCsticms == [090]
                     ::cXml+= "<ICMS90>"
                            ::cXml    += ::XmlTag( "orig"    , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CST"     , SubStr(::cCsticms, 2, 2))
                            ::cXml    += ::XmlTag( "modBC"   , Iif(!(::cModbc $ [0_1_2_3]), [0], Left(::cModbc, 1)))             // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                            If !Empty(::nPredbc)
                               ::cXml += ::XmlTag( "pRedBC"  , ::nPredbc, 4)
                            Endif
                            ::cXml    += ::XmlTag( "vBC"     , ::nVbc)
                            ::cXml    += ::XmlTag( "pICMS"   , ::nPicms, 4)
                            ::cXml    += ::XmlTag( "vICMS"   , Iif( ::nVicms # 0, ::nVicms, ::nVicms:= Round(::nVbc * (::nPicms / 100), 2) ) )
                            ::nVbc_t  += ::nVbc                                                                                  // j� acumula o valor da base de c�lculo para os totais
                            ::nVicms_t+= ::nVicms                                                                                // j� acumula o valor do icms para os totais
                     ::cXml+= "</ICMS90>"
                Case ::cCsticms == [101] .and. ::cCrt == 1
                     ::cXml+= "<ICMSSN101>"
                            ::cXml    += ::XmlTag( "orig"        , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CSOSN"       , Left(::cCsticms, 3))
                            ::cXml    += ::XmlTag( "pCredSN"     , ::nPcredsn, 4)
                            ::cXml    += ::XmlTag( "vCredICMSSN" , ::nVcredicmssn)
                     ::cXml+= "</ICMSSN101>"
                Case ::cCsticms $ [102_103_300_400] .and. ::cCrt == 1
                     ::cXml+= "<ICMSSN102>"
                            ::cXml    += ::XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CSOSN" , Left(::cCsticms, 3))
                     ::cXml+= "</ICMSSN102>"
                Case ::cCsticms == [201] .and. ::cCrt == 1
                     ::cXml+= "<ICMSSN201>"
                            ::cXml    += ::XmlTag( "orig"     , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CSOSN"    , Left(::cCsticms, 3))
                            ::cXml    += ::XmlTag( "modBCST"  , Iif(!(::cModbcst $ [0_1_2_3_4_5]), [3], Left(::cModbcst, 1)))    // Modalidade de determina��o da BC do ICMS ST. 0=Pre�o tabelado ou m�ximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor) // S� at� o 5 aqui
                     ::cXml+= "</ICMSSN201>"
                Case ::cCsticms $ [202_203] .and. ::cCrt == 1
                     ::cXml+= "<ICMSSN202>"
                            ::cXml    += ::XmlTag( "orig"     , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CSOSN"    , Left(::cCsticms, 3))
                            ::cXml    += ::XmlTag( "modBCST"  , Iif(!(::cModbcst $ [0_1_2_3_4_5]), [3], Left(::cModbcst, 1)))    // Modalidade de determina��o da BC do ICMS ST. 0=Pre�o tabelado ou m�ximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor) // S� at� o 5 aqui
                     ::cXml+= "</ICMSSN202>"
                Case ::cCsticms == [500] .and. ::cCrt == 1
                     ::cXml+= "<ICMSSN500>"
                            ::cXml    += ::XmlTag( "orig"           , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CSOSN"          , Left(::cCsticms, 3))
                            ::cXml    += ::XmlTag( "vBCSTRet"       , 0)
                            ::cXml    += ::XmlTag( "pST"            , 0, 4)
                            ::cXml    += ::XmlTag( "vICMSSubstituto", 0)
                            ::cXml    += ::XmlTag( "vICMSSTRet"     , 0)
                            ::cXml    += ::XmlTag( "pRedBCEfet"     , 0, 4)
                            ::cXml    += ::XmlTag( "vBCEfet"        , 0)
                            ::cXml    += ::XmlTag( "pICMSEfet"      , 0, 4)
                            ::cXml    += ::XmlTag( "vICMSEfet"      , 0)
                      ::cXml+= "</ICMSSN500>"
                Case ::cCsticms == [900] .and. ::cCrt == 1
                     ::cXml+= "<ICMSSN900>"
                            // Verifica se tem valor do ICMS
                            ::cXml    += ::XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                            ::cXml    += ::XmlTag( "CSOSN" , Left(::cCsticms, 3))
                            If ::nVicms # 0
                               ::cXml    += ::XmlTag( "modBC"       , Iif(!(::cModbc $ [0_1_2_3]), [0], Left(::cModbc, 1)))      // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                               ::cXml    += ::XmlTag( "vBC"         , ::nVbc)
                               ::cXml    += ::XmlTag( "pICMS"       , ::nPicms, 4)
                               ::cXml    += ::XmlTag( "vICMS"       , Iif( ::nVicms # 0, ::nVicms, ::nVicms:= Round(::nVbc * (::nPicms / 100), 2) ) )
                               ::cXml    += ::XmlTag( "modBCST"     , Iif(!(::cModbcst $ [0_1_2_3_4_5]), [3], Left(::cModbcst, 1))) // Modalidade de determina��o da BC do ICMS ST. 0=Pre�o tabelado ou m�ximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor) // S� at� o 5 aqui
                               ::cXml    += ::XmlTag( "vBCST"       , ::nVbcst)
                               ::cXml    += ::XmlTag( "pICMSST"     , ::nPicmst, 4)
                               ::cXml    += ::XmlTag( "vICMSST"     , ::nVicmsst:= Round(::nVbcst * (::nPicmst / 100), 2) )
                               ::cXml    += ::XmlTag( "pCredSN"     , ::nPcredsn, 4)
                               ::cXml    += ::XmlTag( "vCredICMSSN" , ::nVcredicmssn)
                               ::nVbc_t  += ::nVbc                                                                               // j� acumula o valor da base de c�lculo para os totais
                               ::nVbcst_t+= ::nVbcst                                                                             // j� acumula o valor dos base de c�lculo da subs. tribut�ria para os totais
                               ::nVicms_t+= ::nVicms                                                                             // j� acumula o valor do icms para os totais
                            Endif 
                     ::cXml+= "</ICMSSN900>"
             Endcase
      ::cXml+= "</ICMS>"
   Endif
Return (Nil)

* --------------------> Metodo para gerar a tag do ICMS NA <------------------ *
METHOD fCria_ProdutoIcms_Na()  //Grupo NA. ICMS para a UF de destino
   If !Empty(::nVbcufdest)
      ::cXml+= "<ICMSUFDest>"
             ::cXml           += ::XmlTag( "vBCUFDest"      , ::nVbcufdest)                                                      // Valor da BC do ICMS na UF de destino
             ::cXml           += ::XmlTag( "vBCFCPUFDest"   , ::nVbcfcpufdest)                                                   // Valor da Base de C�lculo do FCP na UF de destino. (Inclu�do na NT2016.002)
             ::cXml           += ::XmlTag( "pFCPUFDest"     , ::nPfcpufdest, 4)                                                  // Percentual adicional inserido na al�quota interna da UF de destino, relativo ao Fundo de Combate � Pobreza (FCP) naquela UF
             ::cXml           += ::XmlTag( "pICMSUFDest"    , ::nPicmsufdest, 4)                                                 // Al�quota adotada nas opera��es internas na UF de destino para o produto / mercadoria. A al�quota do Fundo de Combate a Pobreza, se existente para o produto / mercadoria, deve ser informada no campo pr�prio (pFCPUFDest) n�o devendo ser somada � essa al�quota interna.
             ::cXml           += ::XmlTag( "pICMSInter"     , ::nPicmsinter)                                                     // Al�quota interestadual das UF envolvidas: - 4% al�quota interestadual para produtos importados; - 7% para os Estados de origem do Sul e Sudeste (exceto ES), destinado para os Estados do Norte, Nordeste, Centro- Oeste e Esp�rito Santo; - 12% para os demais casos.
             ::cXml           += ::XmlTag( "pICMSInterPart" , ::nPicmsinterpart, 4)                                              // Percentual de ICMS Interestadual para a UF de destino: - 40% em 2016; - 60% em 2017; - 80% em 2018; - 100% a partir de 2019.
             ::cXml           += ::XmlTag( "vFCPUFDest"     , ::nVfcpufdest)                                                     // Valor do ICMS relativo ao Fundo de Combate � Pobreza (FCP) da UF de destino. (Atualizado na NT2016.002)
             ::cXml           += ::XmlTag( "vICMSUFDest"    , ::nVicmsufdest)                                                    // Valor do ICMS Interestadual para a UF de destino, j� considerando o valor do ICMS relativo ao Fundo de Combate � Pobreza naquela UF.
             ::cXml           += ::XmlTag( "vICMSUFRemet"   , ::nVicmsufremet)                                                   // Valor do ICMS Interestadual para a UF do remetente. Nota: A partir de 2019, este valor ser� zero.
             ::nVfcpufdest_t  += ::nVfcpufdest                                                                                   // j� acumula o valor para os totais
             ::nVicmsufdest_t += ::Vicmsufdest                                                                                   // j� acumula o valor para os totais
             ::nVicmsufremet_t+= ::nVicmsufremet                                                                                 // j� acumula o valor para os totais
      ::cXml+= "</ICMSUFDest>"
   Endif 
Return (Nil)

* --------------------> Metodo para gerar a tag do IPI <---------------------- *
METHOD fCria_ProdutoIpi()
   If ::nVipi > 0 .or. !Empty(::cCstipint)
      ::cXml+= "<IPI>"
             ::cXml+= ::XmlTag( "cEnq" , Left(::cCEnq, 3))

             If ::cCstipi $ [00_49_50_99]
                ::cXml+= "<IPITrib>"                                                                                             // Grupo do CST 00, 49, 50 e 99
                       ::cXml   += ::XmlTag( "CST"  , Iif(!(::cCstipi $ [00_49_50_99]), [00], Left(::cCstipi, 2)))               // C�digo da situa��o tribut�ria do IPI 00=Entrada com recupera��o de cr�dito 49=Outras entradas 50=Sa�da tributada 99=Outras sa�das
                       ::cXml   += ::XmlTag( "vBC"  , ::nVbcipi)
                       ::cXml   += ::XmlTag( "pIPI" , ::nPipi, 4)
                       ::cXml   += ::XmlTag( "vIPI" , ::nVipi:= Round(::nVbcipi * (::nPipi / 100), 2))
                       ::nVipi_t+= ::nVipi                                                                                       // j� acumula o valor dos produtos para os totais
                ::cXml+= "</IPITrib>"
             Endif 

             If ::cCstipint $ [01_02_03_04_51_52_53_54_55]
                ::cXml+= "<IPINT>"
                       ::cXml+= ::XmlTag( "CST"  , Iif(!(::cCstipint $ [01_02_03_04_05_51_52_53_54_55]), [01], Left(::cCstipint, 2))) // C�digo da situa��o tribut�ria do IPI 01=Entrada tributada com al�quota zero 02=Entrada isenta 03=Entrada n�o-tributada 04=Entrada imune 05=Entrada com suspens�o 51=Sa�da tributada com al�quota zero 52=Sa�da isenta 53=Sa�da n�o-tributada 54=Sa�da imune 55=Sa�da com suspens�o
                ::cXml+= "</IPINT>"
             Endif 
      ::cXml+= "</IPI>"   
   Endif 
Return (Nil)

* ------------------> Metodo para gerar a tag IS = Imposto Seletivo <--------- *
METHOD fCria_ProdutoIs()                                                                                                         // Reforma tribut�ria
   If !Empty(::cClasstribis)
      ::cXml+= "<IS>"
             ::cXml  += ::XmlTag( "CSTIS"        , Left(::cClasstribis, 3))                                                      // Utilizar tabela C�DIGO DE CLASSIFICA��O TRIBUT�RIA DO IMPOSTO SELETIVO
             ::cXml  += ::XmlTag( "cClasstribis" , Left(::cClasstribis, 6))                                                      // Utilizar tabela C�DIGO DE CLASSIFICA��O TRIBUT�RIA DO IMPOSTO SELETIVO
             ::cXml  += ::XmlTag( "vBCIS"        , ::nVbcis)                                                                     // Valor da Base de C�lculo do Imposto Seletivo
             ::cXml  += ::XmlTag( "pIS"          , ::nPisis)                                                                     // Al�quota do Imposto Seletivo
             ::cXml  += ::XmlTag( "pISEspec"     , ::nPisespec, 4)                                                               // Al�quota espec�fica por unidade de medida apropriada
             ::cXml  += ::XmlTag( "uTrib"        , Left(::cUtrib_is, 6))                                                         // Unidade de Medida Tribut�vel
             ::cXml  += ::XmlTag( "qTrib"        , ::nQtrib_is, 4)                                                               // Quantidade Tribut�vel
             ::cXml  += ::XmlTag( "vIS"          , ::nVis:= Round((::nVbcis * ::nQtrib_is) * (::nPisis / 100), 2))               // Valor do Imposto Seletivo
             ::nVis_t+= nVis
      ::cXml+= "</IS>"
   Endif 
Return (Nil)

* ----------------------> Metodo para gerar a tag IBSCBS <-------------------- *
METHOD fCria_ProdutoIbscbs()  // Reforma tribut�ria
   If !Empty(::cCclasstrib)
      If Left(::cCclasstrib, 3) $ [000_200_410_510_620] .or. (Left(::cCclasstrib, 3) $ [550_800] .and. ::cModelo # [65])

         ::cXml+= "<IBSCBS>"
                ::cXml+= ::XmlTag( "CST"       , Left(::cCclasstrib, 3))
                ::cXml+= ::XmlTag( "cClassTrib", Left(::cCclasstrib, 6))
                       
                ::cXml+= "<gIBSCBS>"
                       ::nVbcibs:= ::nVprod + ::nVServs + ::nVFrete + ::nVSeg + ::nVOutro + ::nVii - ::nVDesc - ::nVpis - ::nVCofins - ::nVicms - ::nVicmsufdest - ::nVfcp - ::nVfcpufdest - Round(::nMonoBas * ::nMonoAliq, 2) - ::nVissqn + ::nVis
                       ::cXml+= ::XmlTag( "vBC" , ::nVbcibs)
                       ::nVbcibscbs_t+= ::nVbcibs                                                                                // j� acumula o valor os totais

                       ::cXml+= "<gIBSUF>"
                              ::cXml+= ::XmlTag( "pIBSUF" , ::nPibsuf, 4)

                              If ::nPdifgibuf # 0 .and. Left(::cCclasstrib, 3) == [510]
                                 ::cXml+= "<gDif>"
                                        ::cXml         += ::XmlTag( "pDif" , ::nPdifgibuf, 4)
                                        ::cXml         += ::XmlTag( "vDif" , Round(::nVbcibs * ::nPibsuf * (::nPdifgibuf / 100), 2) )
                                        ::nVdifgibsuf_t+= Round(::nVbcibs * ::nPibsuf * (::nPdifgibuf / 100), 2)                 // j� acumula o valor os totais
                                 ::cXml+= "</gDif>"
                              Endif

                              If ::nVdevtribgibuf # 0
                                 ::cXml+= "<gDevTrib>"
                                        ::cXml             += ::XmlTag( "vDevTrib" , ::nVdevtribgibuf)
                                        ::nVdevtribgibsuf_t+= ::nVdevtribgibuf                                                   // j� acumula o valor os totais
                                 ::cXml+= "</gDevTrib>"
                              Endif

                              If ::nPredaliqgibuf # 0 .and. Left(::cCclasstrib, 3) == [200]
                                 ::cXml+= "<gRed>"
                                        ::cXml+= ::XmlTag( "pRedAliq"  , ::nPredaliqgibuf, 4)
                                        ::cXml+= ::XmlTag( "pAliqEfet" , ::nPibsuf * (1 - ::nPredaliqgibuf), 4)
                                 ::cXml+= "</gRed>"
                              Endif
                                       
                              ::cXml+= ::XmlTag( "vIBSUF" , ::nVibsuf:= Round(::nVbcibs * (::nPibsuf / 100), 2) )
                       ::cXml+= "</gIBSUF>"
                       ::cXml+= "<gIBSMun>"
                              ::cXml+= ::XmlTag( "pIBSMun" , ::nPibsmun, 4)

                              If ::nPdifgibsmun # 0 .and. Left(::cCclasstrib, 3) == [510]
                                 ::cXml+= "<gDif>"
                                        ::cXml           += ::XmlTag( "pDif"   , ::nPdifgibsmun, 4)
                                        ::cXml           += ::XmlTag( "vDif"   , Round(::nVbcibs * (::nPibsmun / 100) * (::nPdifgibsmun / 100), 2) ) 
                                        ::nVdDifgibsmun_t+= Round(::nVbcibs * (::nPibsmun / 100) * (::nPdifgibsmun / 100), 2)    // j� acumula o valor os totais
                                 ::cXml+= "</gDif>"
                              Endif

                              If ::nVdevtribgibsmun # 0
                                 ::cXml+= "<gDevTrib>"
                                        ::cXml+= ::XmlTag( "vDevTrib"  , ::nVdevtribgibsmun)
                                        ::nVdevtribgibsmun_t+= ::nVdevtribgibsmun                                                // j� acumula o valor os totais
                                 ::cXml+= "</gDevTrib>"
                              Endif

                              If ::nPredaliqibsmun # 0 .and. Left(::cCclasstrib, 3) == [200]
                                 ::cXml+= "<gRed>"
                                        ::cXml+= ::XmlTag( "pRedAliq"  , ::nPredaliqibsmun, 4)
                                        ::cXml+= ::XmlTag( "pAliqEfet" , ::nPibsmun * (1 - ::nPredaliqibsmun), 4)
                                 ::cXml+= "</gRed>"
                              Endif

                              ::cXml+= ::XmlTag( "vIBSMun" , ::nVibsmun:= Round(::nVbcibs * ::nPibsmun, 2) )
                              ::nVibsmungibsmun_t+= ::nVibsmun                                                                   // j� acumula o valor os totais
                       ::cXml+= "</gIBSMun>"
                       ::cXml+= ::XmlTag( "vIBS" , ::nVibsuf + ::nVibsmun )
                       ::nVibsufgibsuf_t+= (::nVibsuf + ::nVibsmun)                                                              // j� acumula o valor os totais

                       ::cXml+= "<gCBS>"
                              ::cXml+= ::XmlTag( "pCBS" , ::nPcbs, 4)

                              If ::nPpDifgcbs # 0 .and. Left(::cCclasstrib, 3) == [510]
                                 ::cXml+= "<gDif>"
                                        ::cXml+= ::XmlTag( "pDif"   , ::nPpDifgcbs, 4)
                                        ::cXml+= ::XmlTag( "vDif"   , Round(::nVbcibs * ::nPcbs * (::nPpDifgcbs / 100), 2) )  
                                 ::cXml+= "</gDif>"
                              Endif

                              If ::nVdevtribgcbs # 0
                                 ::cXml+= "<gDevTrib>"
                                        ::cXml+= ::XmlTag( "vDevTrib" , ::nVdevtribgcbs)
                                        ::nVdevtribgcbs+= ::nVdevtribgcbs                                                        // j� acumula o valor os totais
                                 ::cXml+= "</gDevTrib>"
                              Endif

                              If ::nPredaliqgcbs # 0 .and. Left(::cCclasstrib, 3) == [200]
                                 ::cXml+= "<gRed>"
                                        ::cXml+= ::XmlTag( "pRedAliq"  , ::nPredaliqgcbs, 4)
                                        ::cXml+= ::XmlTag( "pAliqEfet" , ::nPcbs * (1 - ::nPredaliqgcbs), 4)
                                 ::cXml+= "</gRed>"
                              Endif

                              ::cXml       += ::XmlTag( "vCBS" , ::nVcbs:= Round(::nVbcibs * (::nPcbs / 100), 2) )
                              ::nVcbsgcbs_t+= ::nVcbs                                                                            // j� acumula o valor os totais
                       ::cXml+= "</gCBS>"

                       If ::nPaliqefetregibsuf # 0 .and. Left(::cCclasstrib, 3) == [550]
                          ::cXml+= "<gTribRegular>"
                                 ::cXml+= ::XmlTag( "CSTReg"             , Left(::cCclasstrib, 3))
                                 ::cXml+= ::XmlTag( "cClassTribReg"      , Left(::cCclasstrib, 6))
                                 ::cXml+= ::XmlTag( "pAliqEfetRegIBSUF"  , ::nPaliqefetregibsuf, 4)
                                 ::cXml+= ::XmlTag( "vTribRegIBSUF"      , ::nVtribregibsuf)
                                 ::cXml+= ::XmlTag( "pAliqEfetRegIBSMun" , ::nPaliqefetregibsMun, 4)
                                 ::cXml+= ::XmlTag( "vTribRegIBSMun"     , ::nVtribregibsMun)
                                 ::cXml+= ::XmlTag( "pAliqEfetRegCBS"    , ::nPaliqefetregcbs, 4)
                                 ::cXml+= ::XmlTag( "vTribRegCBS"        , ::nVtribregcbs)
                          ::cXml+= "</gTribRegular>"
                       Endif

                       If !Empty(::cCredPresgibs) .and. ::cCredPresgibs $ [1_2_3_4_5] .and. ::cModelo == [55]
                          ::cXml+= "<gIBSCredPres>"
                                 ::cXml                  += ::XmlTag( "cCredPres" , Left(::cCredPresgibs, 2))
                                 ::cXml                  += ::XmlTag( "pCredPres" , ::nPcredpresgibs, 4)
                                 ::cXml                  += ::XmlTag( "vCredPres" , ::nVcredpresgibs:= Round(::nVbcibs * ::nPcredpresgibs, 2) )
                                 ::nVcredpresgibs_t      += ::nVcredpresgibs                                                     // j� acumula o valor os totais
                                 ::cXml                  += ::XmlTag( "vCredPresCondSus" , ::nVcredprescondsusibs)
                                 ::nVcredprescondsusibs_t+= ::nVcredprescondsusibs                                               // j� acumula o valor os totais
                           ::cXml+= "</gIBSCredPres>"
                       Endif

                       If !Empty(::cCredPrescbs) .and. ::cCredPrescbs $ [1_2_3_4_5] .and. ::cModelo == [55]
                          ::cXml+= "<gCBSCredPres>"
                                 ::cXml                  += ::XmlTag( "cCredPres" , Left(::cCredPrescbs, 2))
                                 ::cXml                  += ::XmlTag( "pCredPres" , ::nPcredprescbs, 4)
                                 ::cXml                  += ::XmlTag( "vCredPres" , Round(::nVcredprescbs * ::nPcredprescbs, 2) )
                                 ::nVcredprescbs_t       += ::nVcredprescbs                                                      // j� acumula o valor os totais
                                 ::cXml                  += ::XmlTag( "vCredPresCondSus" , ::nVcredprescondsuscbs)
                                 ::nVcredprescondsuscbs_t+= ::nVcredprescondsuscbs                                               // j� acumula o valor os totais
                          ::cXml+= "</gCBSCredPres>"
                       Endif
                ::cXml+= "</gIBSCBS>"
          ::cXml+= "</IBSCBS>"

          If Left(::cCclasstrib, 3) == [620]
             ::fCria_Gibscbsmono()
          Endif 

          If Left(::cCclasstrib, 3) == [800] .and. ::cFinnfe == [6]
             ::cXml+= "<gTransfCred>"
                    ::cXml+= ::XmlTag( "vIBS" , ::nVibs_c )
                    ::cXml+= ::XmlTag( "vCBS" , ::nVcbs_c )
             ::cXml+= "</gTransfCred>"
          Endif
      Endif
   Endif 
Return (Nil)

* -------------------> Metodo para gerar a tag gIBSCBSMono <------------------ *
METHOD fCria_Gibscbsmono()   // Reforma tribut�ria
   If ::nQbcmono # 0 .and. ::cIndMono == [1]
      ::cXml+= "<gIBSCBSMono>"
             ::cXml       += ::XmlTag( "qBCMono"         , ::nQbcmono)
             ::cXml       += ::XmlTag( "adRemIBS"        , ::nAdremibs, 4)
             ::cXml       += ::XmlTag( "adRemCBS"        , ::nAdremcbs, 4)
             ::cXml       += ::XmlTag( "vIBSMono"        , ::nVibsmono:= Round(nQbcmono * ::nAdremibs, 2) )
             ::cXml       += ::XmlTag( "vCBSMono"        , ::nVcbsmono:= Round(nQbcmono * ::nAdremcbs, 2))
             ::nvIBSMono_t+= ::nVibsmono                                                                                         // j� acumula o valor para os totais
             ::nvCBSMono_t+= ::nVcbsmono                                                                                         // j� acumula o valor para os totais

             If ::cIndMonoReten == [1]
                ::cXml            += ::XmlTag( "qBCMonoReten"    , ::nQbcmonoreten, 0)
                ::cXml            += ::XmlTag( "adRemIBSReten"   , ::nAdremibsreten, 4)
                ::cXml            += ::XmlTag( "vIBSMonoReten"   , ::nIbsmonoreten:= Round(::nQbcmonoreten * ::nAdremibsreten, 2) )
                ::cXml            += ::XmlTag( "adRemCBSReten"   , ::nAdremcbsreten, 4)
                ::cXml            += ::XmlTag( "vCBSMonoReten"   , ::nVcbsmonoreten:= Round(::nQbcmonoreten * ::nAdremcbsreten, 2) )
                ::nvIBSMonoReten_t+= ::nVibsmonoreten                                                                            // j� acumula o valor para os totais
                ::nvCBSMonoReten_t+= ::nVcbsmonoreten                                                                            // j� acumula o valor para os totais
             Endif

             If ::cIndMonoRet == [1]
                ::cXml          += ::XmlTag( "qBCMonoRet"      , ::nQbcmonoret, 0)
                ::cXml          += ::XmlTag( "adRemIBSRet"     , ::nAdremibsret, 4)
                ::cXml          += ::XmlTag( "vIBSMonoRet"     , ::nVibsmonoret:= Round(::nQbcmonoret * ::nAdremibsret, 2) )
                ::cXml          += ::XmlTag( "adRemCBSRet"     , ::nAdremcbsret, 4)
                ::cXml          += ::XmlTag( "vCBSMonoRet"     , ::nVcbsmonoret:= Round(::nQbcmonoret * ::nAdremcbsret, 2) )
                ::nvIBSMonoRet_t+= ::nVibsmonoret                                                                                // j� acumula o valor para os totais
                ::nvCBSMonoRet_t+= ::nVcbsmonoret                                                                                // j� acumula o valor para os totais
             Endif

             If ::cIndMonoDif == [1]
                ::cXml+= ::XmlTag( "pDifIBS"         , ::nPdifibs, 4)                                                            // Percentual do diferimento do imposto monof�sico. A ser aplicado em vIBSMono.
                ::cXml+= ::XmlTag( "vIBSMonoDif"     , ::nVibsmonodif)                                                           // Valor do IBS monof�sico diferido. A ser deduzido do valor do IBS. 
                ::cXml+= ::XmlTag( "pDifCBS"         , ::nPdifcbs, 4)                                                            // Percentual do diferimento do imposto monof�sico. A ser aplicado em vCBSMono
                ::cXml+= ::XmlTag( "vCBSMonoDif"     , ::nVcbsmonodif)                                                           // Valor da CBS Monof�sica diferida. A ser deduzido do valor da CBS
                ::cXml+= ::XmlTag( "vTotIBSMonoItem" , ::nVtotibsmonoItem)                                                       // Total de IBS Monof�sico. 
                ::cXml+= ::XmlTag( "vTotCBSMonoItem" , ::nVtotcbsmonoItem)                                                       // Total da CBS Monof�sica. 
             Endif
      ::cXml+= "</gIBSCBSMono>"
   Endif 
Return (Nil)

* ----------------> Metodo para gerar   AS tags do PIS e COFINS <--------------- *
METHOD fCria_ProdutoPisCofins()                                                                                                  // Marcelo Brigatti
   If !Empty(::cCstPis)
             ::cXml+= "<PIS>"
                   ::cXml+= "<PISAliq>"
                         ::cXml   += ::XmlTag( "CST"     , Iif(!(::cCstPis $ [01_02]), [01], Left(::cCstPis, 2)))                // 01=Opera��o Tribut�vel (base de c�lculo = valor da opera��o al�quota normal (cumulativo/n�o cumulativo));  02=Opera��o Tribut�vel (base de c�lculo = valor da opera��o (al�quota diferenciada))
                         ::cXml   += ::XmlTag( "vBC"     , ::nBcPis )                   
                         ::cXml   += ::XmlTag( "pPIS"    , ::nAlPis, 4 )                 
                         ::cXml   += ::XmlTag( "vPIS"    , ::nVpis:= Round(::nBcPis * (::nAlPis / 100), 2) ) 
                         ::nVpis_t+= ::nVpis                                                                                     // j� acumula o valor do PIS para os totais
                   ::cXml+= "</PISAliq>"
             ::cXml+= "</PIS>"
             ::cXml+= "<COFINS>"
                   ::cXml+= "<COFINSAliq>"
                         ::cXml      += ::XmlTag( "CST"     , Iif(!(::cCstCofins $ [01_02]), [01], Left(::cCstCofins, 2)))
                         ::cXml      += ::XmlTag( "vBC"     , ::nBcCofins )                   
                         ::cXml      += ::XmlTag( "pCOFINS" , ::nAlCofins, 4 )                
                         ::cXml      += ::XmlTag( "vCOFINS" , ::nVCofins:= Round(::nBcCofins * (::nAlCofins / 100), 2) )
                         ::nVCofins_t+= ::nVCofins                                                                               // j� acumula o valor do COFINS para os totais
                   ::cXml+= "</COFINSAliq>"
             ::cXml+= "</COFINS>"
   ElseIf !Empty(::cCstPisqtd)
             ::cXml+= "<PIS>"
                   ::cXml+= "<PISQtde>"
                         ::cXml   += ::XmlTag( "CST"       , Iif(!(::cCstPisqtd $ [03]), [03], Left(::cCstPisqtd, 2)))           // Opera��o Tribut�vel (base de c�lculo = quantidade vendida x al�quota por unidade de produto)
                         ::cXml   += ::XmlTag( "qBCProd"   , ::nQcom )                                                           // Quantidade do produto vendida
                         ::cXml   += ::XmlTag( "vAliqProd" , ::nAlPis, 4 )                
                         ::cXml   += ::XmlTag( "vPIS"      , ::nVpis:= Round(::nQcom * (::nAlPis / 100), 2) )
                         ::nVpis_t+= ::nVpis                                                                                     // j� acumula o valor do PIS para os totais
                   ::cXml+= "</PISAQtde>"
             ::cXml+= "</PIS>"
             ::cXml+= "<COFINS>"
                   ::cXml+= "<COFINSQtde>"
                         ::cXml      += ::XmlTag( "CST"       , Iif(!(::cCstCofinsqtd $ [03]), [03], Left(::cCstCofinsqtd, 2)))
                         ::cXml      += ::XmlTag( "qBCProd"   , ::nQcom )                                                        // Quantidade do produto vendida
                         ::cXml      += ::XmlTag( "vAliqProd" , ::nAlPis, 4 )                                                                             
                         ::cXml      += ::XmlTag( "vCOFINS"   , ::nVCofins:= Round(::nQcom * (::nAlCofins / 100), 2) )
                         ::nVCofins_t+= ::nVCofins                                                                               // j� acumula o valor do COFINS para os totais
                   ::cXml+= "</COFINSQtde>"
             ::cXml+= "</COFINS>"
   ElseIf !Empty(::cCstPisnt)
             ::cXml+= "<PIS>"
                   ::cXml+= "<PISNT>"
                         ::cXml+= ::XmlTag( "CST"       , Iif(!(::cCstPisnt $ [04_05_06_07_08_09]), [04], Left(::cCstPisnt, 2))) // C�digo de Situa��o Tribut�ria do PIS 04=Opera��o Tribut�vel (tributa��o monof�sica (al�quota zero)); 05=Opera��o Tribut�vel (Substitui��o Tribut�ria); 06=Opera��o Tribut�vel (al�quota zero); 07=Opera��o Isenta da Contribui��o; 08=Opera��o Sem Incid�ncia da Contribui��o; 09=Opera��o com Suspens�o da Contribui��o;
                   ::cXml+= "</PISNT>"
             ::cXml+= "</PIS>"
             ::cXml+= "<COFINS>"
                   ::cXml+= "<COFINSNT>"
                         ::cXml+= ::XmlTag( "CST"       , Iif(!(::cCstCofinsnt $ [04_05_06_07_08_09]), [04], Left(::cCstCofinsnt, 2))) 
                   ::cXml+= "</COFINSNT>"
             ::cXml+= "</COFINS>"
   ElseIf !Empty(::cCstPisoutro)
             ::cXml+= "<PIS>"
                   ::cXml+= "<PISOutr>"
                         ::cXml   += ::XmlTag( "CST"     , Iif(!(::cCstPisoutro $ [49_50_51_52_53_54_55_56_60_61_62_63_64_65_66_67_70_71_72_73_74_75_98_99]), [49], Left(::cCstPisoutro, 2))) // C�digo de Situa��o Tribut�ria do PIS
                         ::cXml   += ::XmlTag( "vBC"     , ::nBcPis )                   
                         ::cXml   += ::XmlTag( "pPIS"    , ::nAlPis, 4 )                 
                         ::cXml   += ::XmlTag( "vPIS"    , ::nVpis:= Round(::nBcPis * (::nAlPis / 100), 2) ) 
                         ::nVpis_t+= ::nVpis                                                                                     // j� acumula o valor do PIS para os totais
                   ::cXml+= "</PISOutr>"
             ::cXml+= "</PIS>"
             ::cXml+= "<COFINS>"
                   ::cXml+= "<COFINSOutr>"
                         ::cXml      += ::XmlTag( "CST"       , Iif(!(::cCstCofinsoutro $ [49_50_51_52_53_54_55_56_60_61_62_63_64_65_66_67_70_71_72_73_74_75_98_99]), [49], Left(::cCstCofinsoutro, 2))) 
                         ::cXml      += ::XmlTag( "vBC"       , ::nBcCofins )                   
                         ::cXml      += ::XmlTag( "pCOFINS"   , ::nAlCofins, 4 )                
                         ::cXml      += ::XmlTag( "vCOFINS"   , ::nVCofins:= Round(::nBcCofins * (::nAlCofins / 100), 2) )
                         ::nVCofins_t+= ::nVCofins                                                                               // j� acumula o valor do COFINS para os totais
                   ::cXml+= "</COFINSOutr>"
             ::cXml+= "</COFINS>"
   Endif  
Return (Nil)

* ---------------> Metodo para gerar a tag de Totais da NFe <----------------- *
METHOD fCria_Totais()
   ::cXml+= "<total>"
          ::cXml+= "<ICMSTot>"
                 ::cXml+= ::XmlTag( "vBC"          , ::nVbc_t)
                 ::cXml+= ::XmlTag( "vICMS"        , ::nVicms_t)
                 ::cXml+= ::XmlTag( "vICMSDeson"   , ::nVicmsdeson_t)

                 If !Empty(::nVfcpufdest_t)
                    ::cXml+= ::XmlTag( "vFCPUFDest"  , ::nVfcpufdest_t)                                                          // Complementa o C�lculo com a Diferen�a de ICMS
                 Endif

                 If !Empty(::nVicmsufdest_t)
                    ::cXml+= ::XmlTag( "vICMSUFDest" , ::nVicmsufdest_t)                                                         // Complementa o C�lculo com a Diferen�a de ICMS
                 Endif

                 If !Empty(::nVicmsufremet_t)
                    ::cXml+= ::XmlTag( "vICMSUFRemet", ::nVicmsufremet_t)                                                        // Complementa o C�lculo com a Diferen�a de ICMS
                 Endif

                 ::cXml+= ::XmlTag( "vFCP"         , ::nVfcp_t)                                                                  // Campo referente a FCP Para vers�o 4.0
                 ::cXml+= ::XmlTag( "vBCST"        , ::nVbcst_t)
                 ::cXml+= ::XmlTag( "vST"          , ::nVst_t)
                 ::cXml+= ::XmlTag( "vFCPST"       , ::nVfcpst_t)                                                                // Campo referente a FCP Para vers�o 4.0
                 ::cXml+= ::XmlTag( "vFCPSTRet"    , ::nVfcpstret_t)                                                             // Campo referente a FCP Para vers�o 4.0

                 If ::nMonoBas # 0
                    ::cXml+= ::XmlTag( "qBCMonoRet"   , ::nMonoBas)
                    ::cXml+= ::XmlTag( "vICMSMonoRet" , Round(::nMonoBas * ::nMonoAliq, 2))
                 Endif 

                 ::cXml+= ::XmlTag( "vProd"        , ::nVprod_t)                                                                 // If(::cFinnfe == [1], 0, ::nVprod_t))
                 ::cXml+= ::XmlTag( "vFrete"       , ::nVFrete_t)
                 ::cXml+= ::XmlTag( "vSeg"         , ::nVSeg_t)
                 ::cXml+= ::XmlTag( "vDesc"        , ::nVDesc_t)
                 ::cXml+= ::XmlTag( "vII"          , ::nVii_t)
                 ::cXml+= ::XmlTag( "vIPI"         , ::nVipi_t)
                 ::cXml+= ::XmlTag( "vIPIDevol"    , ::nVipidevol_t)        
                 ::cXml+= ::XmlTag( "vPIS"         , ::nVpis_t)
                 ::cXml+= ::XmlTag( "vCOFINS"      , ::nVCofins_t)
                 ::cXml+= ::XmlTag( "vOutro"       , ::nVOutro_t)
         
                 If ::nVnf == 0
                    ::cXml+= ::XmlTag( "vNF"       , ::nVnf:= ::nVprod_t - ::nVDesc_t - ::nVicmsdeson_t + ::nVst_t + ::nVfcpst_t + ::nVFrete_t + ::nVSeg_t + ::nVOutro_t + ::nVii_t + ::nVipi_t + ::nVipidevol_t)

                    If ::cTpOp == [2]                                                                                            // Exce��o 1: Faturamento direto de ve�culos novos: Se informada opera��o de Faturamento Direto para ve�culos novos (tpOp = 2, id:J02): 
                       ::cXml+= ::XmlTag( "vNF"    , ::nVnf:= ::nVprod_t - ::nVDesc_t - ::nVicmsdeson_t + ::nVFrete_t + ::nVSeg_t + ::nVOutro_t + ::nVii_t + ::nVipi_t)
                    Endif
                 Else
                    ::cXml+= ::XmlTag( "vNF"       , ::nVnf)
                 Endif

                 If !Empty(::nVtottribt)
                    ::cXml+= ::XmlTag( "vTotTrib"  , ::nVtottribt)
                 Endif
          ::cXml+= "</ICMSTot>"
   ::cXml+= "</total>"

   If !Empty(::cCclasstrib)
      ::fCria_TotaisRtc() 
   Endif
Return (Nil)

* --------------> Metodo para gerar a tag de Total RTC da NFe <--------------- *
METHOD fCria_TotaisRtc()
   If "</total>" $ ::cXml
      ::cXml:= StrTran(::cXml, "</total>", "")  
   Endif  

   If !Empty(::nVis_t)
      ::cXml+= "<ISTot>"
             ::cXml+= ::XmlTag( "vIS" , ::nVis_t)
      ::cXml+= "</ISTot>"
   Endif

   ::cXml+= "<IBSCBSTot>"
          ::cXml+= ::XmlTag( "vBCIBSCBS" , ::nVbcibscbs_t)
          ::cXml+= "<gIBS>"
                 ::cXml+= "<gIBSUF>"
                        ::cXml+= ::XmlTag( "vDif"      , ::nVdifgibsuf_t)
                        ::cXml+= ::XmlTag( "vDevTrib"  , ::nVdevtribgibsuf_t)
                        ::cXml+= ::XmlTag( "vIBSUF"    , ::nVibsufgibsuf_t)
                 ::cXml+= "</gIBSUF>"
                 ::cXml+= "<gIBSMun>"
                        ::cXml+= ::XmlTag( "vDif"      , ::nVdDifgibsmun_t)
                        ::cXml+= ::XmlTag( "vDevTrib"  , ::nVdevtribgibsmun_t)
                        ::cXml+= ::XmlTag( "vIBSMun"   , ::nVibsmungibsmun_t)
                 ::cXml+= "</gIBSMun>"
                 ::cXml+= ::XmlTag( "vIBS"             , ::nVibsgibs_t:= ::nVibsufgibsuf_t + ::nVibsmungibsmun_t )
                 ::cXml+= ::XmlTag( "vCredPres"        , ::nVcredpresgibs_t)
                 ::cXml+= ::XmlTag( "vCredPresCondSus" , ::nVcredprescondsusibs_t)
          ::cXml+= "</gIBS>"
          ::cXml+= "<gCBS>"
                 ::cXml+= ::XmlTag( "vDif"             , ::nVdifgcbs_t)
                 ::cXml+= ::XmlTag( "vDevTrib"         , ::nVdevtribgcbs_t)
                 ::cXml+= ::XmlTag( "vCBS"             , ::nVcbsgcbs_t)
                 ::cXml+= ::XmlTag( "vCredPres"        , ::nVcredprescbs_t)
                 ::cXml+= ::XmlTag( "vCredPresCondSus" , ::nVcredprescondsuscbs_t)
          ::cXml+= "</gCBS>"

          If !Empty(::nvIBSMono_t) .or. !Empty(::nvCBSMono_t) .or. !Empty(::nvIBSMonoReten_t) .or. !Empty(::nvCBSMonoReten_t) .or. !Empty(::nvIBSMonoRet_t) .or. !Empty(::nvCBSMonoRet_t)
             ::cXml+= "<gMono>"
                    ::cXml+= ::XmlTag( "vIBSMono"      , ::nvIBSMono_t)
                    ::cXml+= ::XmlTag( "vCBSMono"      , ::nvCBSMono_t)
                    ::cXml+= ::XmlTag( "vIBSMonoReten" , ::nvIBSMonoReten_t)
                    ::cXml+= ::XmlTag( "vCBSMonoReten" , ::nvCBSMonoReten_t)
                    ::cXml+= ::XmlTag( "vIBSMonoRet"   , ::nvIBSMonoRet_t)
                    ::cXml+= ::XmlTag( "vCBSMonoRet"   , ::nvCBSMonoRet_t)
             ::cXml+= "</gMono>"
          Endif
   ::cXml+= "</IBSCBSTot>"
/*
   ::nvNftot:= ::nVis_t + ::nVbcibscbs_t

   If !Empty(::nvNftot)
      ::cXml+= ::XmlTag( "vNFTot" , ::nvNftot)  //  Valor total da NF-e com IBS / CBS / IS
   Endif
*/   
   ::cXml+= "</total>"
Return (Nil)

* ---------------> Metodo para gerar a tag do Transportador <----------------- *
METHOD fCria_Transportadora()
   If ::cModelo # [65]
      ::cXml+= "<transp>"
             ::cXml+= ::XmlTag( "modFrete" , Iif(!(::cModFrete $ [0_1_2_3_4_9]), [0], Left(::cModFrete, 1)))                     // Modalidade do frete 0=Contrata��o do Frete por conta do Remetente (CIF); 1=Contrata��o do Frete por conta do Destinat�rio (FOB); 2=Contrata��o do Frete por conta de Terceiros; 3=Transporte Pr�prio por conta do Remetente; 4=Transporte Pr�prio por conta do Destinat�rio;9=Sem Ocorr�ncia de Transporte. (Atualizado na NT2016.002)

             If ::cModFrete # [9]
                ::cXml+= "<transporta>"
                       If !Empty(::cXnomet)
                          If !Empty(::cCnpjt) .and. Len(::SoNumeroCnpj(::cCnpjt)) < 14                                           // Pessoa F�sica - Cpf
                             ::cXml+= ::XmlTag( "CPF"  , Left(::SoNumeroCnpj(::cCnpjt), 11))
       		          Elseif !Empty(::cCnpjt)                                                                                    // Pessoa Juridica - Cnpj
                             ::cXml+= ::XmlTag( "CNPJ" , Left(::SoNumeroCnpj(::cCnpjt), 14))
                          Endif 

                          ::cXml+= ::XmlTag( "xNome" , Left(::fRetiraAcento(::cXnomet), 60))

                          If !Empty(::cIet)
                             ::cXml+= ::XmlTag( "IE" , Left(::SoNumero(::cIet), 14))
                          Endif 

                          If !Empty(::cXEndert)
                             ::cXml+= ::XmlTag( "xEnder" , Left(::fRetiraAcento(::cXEndert), 60))
                          Endif 

                          If !Empty(::cXmunt)
                             ::cXml+= ::XmlTag( "xMun" , Left(::fRetiraAcento(::cXmunt), 60))
                          Endif 

                          If !Empty(::cUft)
                             ::cXml+= ::XmlTag( "UF" , Left(::fRetiraAcento(::cUft), 2))
                          Endif 
                       Else   
                          ::cXml+= ::XmlTag( "xNome" , [o Proprio])
                       Endif 
                ::cXml+= "</transporta>"

                If !Empty(::fRetiraSinal(::cPlaca))
                   ::cXml+= "<veicTransp>"
                          ::cXml+= ::XmlTag( "placa" , Left(::fRetiraSinal(::cPlaca), 7))
                          ::cXml+= ::XmlTag( "UF"    , Left(::fRetiraAcento(::cUfplacat), 2))

                          If !Empty(::cRntc)
                             ::cXml+= ::XmlTag( "RNTC" , Left(::fRetiraAcento(::cRntc), 20))
                          Endif 
                   ::cXml+= "</veicTransp>"
                Endif 
             Endif    

             // Informa��es de Volumes
             If !Empty(::nQvol) .or. !Empty(::cEsp) .or. !Empty(::cNvol) .or. !Empty(::nPesol) .or. !Empty(::nPesob)
                ::cXml+= "<vol>"
                       If !Empty(::nQvol)
                          ::cXml+= ::XmlTag( "qVol" , ::nQvol, 0)
                       Endif 
               
                       If !Empty(::cEsp)
                          ::cXml+= ::XmlTag( "esp" , Left(::fRetiraAcento(::cEsp), 60))
                       Endif 

                       If !Empty(::cMarca)
                          ::cXml+= ::XmlTag( "marca" , Left(::fRetiraAcento(::cMarca), 60))
                       Endif 

                       If !Empty(::cNvol)
                          ::cXml+= ::XmlTag( "nVol" , Left(::fRetiraAcento(::cNvol), 60))
                       Endif 

                       If !Empty(::nPesol)
                          ::cXml+= ::XmlTag( "pesoL" , ::nPesol, 3)
                       Endif 

                       If !Empty(::nPesob)
                          ::cXml+= ::XmlTag( "pesoB" , ::nPesob, 3)
                       Endif  
                ::cXml+= "</vol>"
             Endif 
      ::cXml+= "</transp>"
   Else
      ::cXml+= "<transp>"
             ::cXml+= ::XmlTag( "modFrete" , [9])
      ::cXml+= "</transp>"
   Endif 
Return (Nil)

* ------------------> Metodo para gerar a tag de Cobran�a <------------------- *
METHOD fCria_Cobranca()  // Grupo Y. Dados da Cobran�a
   If !Empty(::cNfat)
      If !("<cobr>") $ ::cXml
         ::cXml+= "<cobr>" 
      Endif 
         If !("<fat>") $ ::cXml
            ::cXml+= "<fat>"
                   ::cXml+= ::XmlTag( "nFat"     , Left(::cNfat, 60))                                                            // N�mero da Fatura
                   ::cXml+= ::XmlTag( "vOrig"    , ::nVorigp)                                                                    // Valor Original da Fatura
         
                   If !Empty(::nVdescp)
                      ::cXml+= ::XmlTag( "vDesc" , ::nVdescp)                                                                    // Valor do desconto
                   Endif 

                   ::cXml+= ::XmlTag( "vLiq"     , ::nVliqup)                                                                    // Valor L�quido da Fatura
            ::cXml+= "</fat>"
         Endif 
         If "</fat></cobr><dup>" $ ::cXml
            ::cXml:= StrTran(::cXml, "</fat></cobr><dup>", "</fat><dup>")
         EndIf   

         If !Empty(::nVdup) .and. ::cIndPag # [0]
             ::cXml+= "<dup>"
                    ::cXml+= ::XmlTag( "nDup"  , Left(::cNDup, 60))                                                              // Obrigat�ria informa��o do n�mero de parcelas com 3 algarismos, sequenciais e consecutivos. Ex.: ?001?,?002?,?003?,... Observa��o: este padr�o de preenchimento ser� Obrigat�rio somente a partir de 03/09/2018
                    ::cXml+= ::XmlTag( "dVenc" , ::DateXml(::dDvencp))                                                           // Formato: ?AAAA-MM-DD?. Obrigat�ria a informa��o da data de vencimento na ordem crescente das datas. Ex.: ?2018-06-01?,?2018-07-01?, ?2018-08-01?,...
                    ::cXml+= ::XmlTag( "vDup"  , ::nVdup)                                                                        // Valor da Parcela
             ::cXml+= "</dup>"
         
             If !("</vDup></dup></cobr><dup>") $ ::cXml
                ::cXml+= "</cobr>"
             Else
                ::cXml:= StrTran(::cXml, "</dup></cobr>", "</dup>")  
             Endif 
         Endif 
      If !("</cobr>") $ ::cXml
         ::cXml+= "</cobr>" 
      Endif 
   Endif 
Return (Nil)

* ------------> Metodo para gerar a tag de Pagamentos <----------------------- *
METHOD fCria_Pagamento() // Grupo YA. Informa��es de Pagamento
   If !("<pag>") $ ::cXml
      ::cXml+= "<pag>" 
   Endif  

   ::cXml+= "<detPag>" 
          If !(::cTpag $ [90_99])
             ::cXml+= ::XmlTag( "indPag" , Iif(!(::cIndPag $ [0_1]), [0], Left(::cIndPag, 1)))                                   // Indica��o da Forma de Pagamento 0= Pagamento � Vista 1= Pagamento � Prazo (Inclu�do na NT2016.002)
          Endif     

          ::cXml+= ::XmlTag( "tPag"      , Iif(!(::cTpag $ [01_02_03_04_05_10_11_12_13_15_16_17_18_19_90_99]), [01], Left(::cTpag, 2)))  // Meio de pagamento 01=Dinheiro 02=Cheque 03=Cart�o de Cr�dito 04=Cart�o de D�bito 05=Cr�dito Loja 10=Vale Alimenta��o 11=Vale Refei��o 12=Vale Presente 13=Vale Combust�vel 15=Boleto Banc�rio 16=Dep�sito Banc�rio 17=Pagamento Instant�neo (PIX) 18=Transfer�ncia banc�ria, Carteira Digital 19=Programa de fidelidade, Cashback, Cr�dito Virtual 90= Sem pagamento 99=Outros (Atualizado na NT2016.002, NT2020.006)

          If ::cTpag == [99]
             ::cXml+= ::XmlTag( "xPag" , Left(::cXpag, 60))                                                                      // Descri��o do meio de pagamento. Preencher informando o meio de pagamento utilizado quando o c�digo do meio de pagamento for informado como 99-outros.
          Endif  
  
          If ::cTpag # [90]
             ::cXml+= ::XmlTag( "vPag" , ::nVpag)
          Else
             ::cXml+= ::XmlTag( "vPag" , 0)                                                                                      // Valor do Pagamento
          Endif  

          If ::nTpintegra # 0 // n�o repete 
             ::cXml+= "<card>"
                    ::cXml+= ::XmlTag( "tpIntegra" , Iif(!(Hb_Ntos(::nTpintegra) $ [1_2]), [1], Hb_Ntos(::nTpintegra, 1)))       // 1=Pagamento integrado com o sistema de automa��o da empresa (Ex.: equipamento TEF, Com�rcio Eletr�nico) | 2= Pagamento n�o integrado com o sistema de automa��o da empresa 

                    If !Empty(::cCnpjpag)
                       ::cXml+= ::XmlTag( "CNPJ"   , Left(::SoNumeroCnpj(::cCnpjpag), 14))                                       // Informar o CNPJ da institui��o de pagamento, adquirente ou subadquirente. Caso o pagamento seja processado pelo intermediador da transa��o, informar o CNPJ deste (Atualizado na NT 2020.006                                                       // CNPJ do Emitente
                    Endif  
  
                    If !Empty(::cTband)  
                       ::cXml+= ::XmlTag( "tBand"  , Iif(!(::cTband $ [01_02_03_04_05_06_07_08_09_99]), [0], Left(::cTband, 2))) // Bandeira da operadora de cart�o de cr�dito e/ou d�bito 01=Visa 02=Mastercard 03=American Express 04=Sorocred 05=Diners Club 06=Elo 07=Hipercard 08=Aura 09=Cabal 99=Outros (Atualizado na NT2016.002
                    Endif  

                    If !Empty(::cAut)
                       ::cXml+= ::XmlTag( "cAut"   , Left(::cAut, 20))                                                           // Identifica o n�mero da autoriza��o da transa��o da opera��o com cart�o de cr�dito e/ou d�bito
                    Endif  
             ::cXml+= "</card>"
          Endif   
   ::cXml+= "</detPag>" 

   If !Empty(::nVtroco) // n�o repete
      ::cXml+= ::XmlTag( "vTroco" , ::nVtroco)                                                                                   // Valor do troco (Inclu�do na NT2016.002
   Endif  

   If !("</vPag></detPag></pag><detPag>") $ ::cXml .or. !("</pag>") $ ::cXml
      ::cXml+= "</pag>"
   Else
      ::cXml:= StrTran(::cXml, "</detPag></pag>", "</detPag>")  
   Endif  

   If !("</pag>") $ ::cXml
      ::cXml+= "</pag>" 
   Endif  
Return (Nil)

* ------------> Metodo para gerar a tag de Informa��es Adicionais <----------- *
METHOD fCria_Informacoes()
   ::cXml+= "<infAdic>"
          If ::lComplementar                                                                                                     // Informa��es DIFAL
             If ::nVIcmsSufDest > 0
                ::cInfFisc+= "DIFAL para UF destino R$ " + NumberXml(::nVIcmsSufDest, 2) + hb_OsNewLine()
             Endif 

             If ::nVIcmsSufRemet > 0
                ::cInfFisc+= "DIFAL para UF Origem R$ " + NumberXml(::nVIcmsSufRemet, 2) + hb_OsNewLine()
             Endif    

             If !Empty(::nVpis_t)                                                                                                // Destaque valor do PIS/COFINS
                ::cInfFisc+= "Valor de PIS para movimento R$ " + NumberXml(::nVpis_t, 2) + hb_OsNewLine()
                ::cInfFisc+= "Valor de COFINS para movimento R$ " + NumberXml(::nVCofins_t, 2) + hb_OsNewLine()
             Endif 
             If ::cUfd # [EX] .and. !Empty(::cCodDest)
 		::cInfFisc+= "C�d:" + ::cCodDest + hb_OsNewLine()
             Endif 
          Endif 

          If !Empty(AllTrim(::cInfFisc))
             ::cXml+= ::XmlTag( "infAdFisco" , Left(::fRetiraAcento(StrTran(::cInfFisc, hb_OsNewLine(), "; ")), 2000))
          Endif 

          If !Empty(AllTrim(::cInfcpl))
             ::cXml+= ::XmlTag( "infCpl" , Left(::fRetiraAcento(StrTran(::cInfcpl, hb_OsNewLine(), '; ')), 5000))
*            ::cXml+= ::XmlTag( "infCpl" , Left(CharRem("���-:\(){}[]`�?'", ::fRetiraAcento(StrTran(::cInfcpl, hb_OsNewLine(), '; '))), 5000))
          Endif 
   ::cXml+= "</infAdic>"
Return (Nil)

* ----------> Metodo para gerar a tag de Declara��o de Importa��o <----------- *
METHOD fCria_ProdImporta()                                                                                                       // Colabora��o Rubens Aluotto, Marcelo Brigatti
   If Substr(Alltrim(::cCfop), 1, 1) == [3]
      ::cXml+= "<DI>"
             ::cXml+= ::XmlTag( "nDI" , Left(::cNdi, 12))                                                                        // n�mero do docto de importa��o DI/DSI/DA - 1-10 C  
             ::cXml+= ::XmlTag( "dDI" , ::DateXml(::dDdi))                                                                       // Data do documento de importa��o - AAAA-MM-DD
             ::cXml+= ::XmlTag( "xLocDesemb" , Left(::fRetiraAcento(::cXlocdesemb), 60))                                         // Local do Desembarque da importa��o  
             ::cXml+= ::XmlTag( "UFDesemb" , Left(::cUfdesemb, 2))                                                               // sigla da UF onde ocorreu o desembara�o aduaneiro - 2 C 
             ::cXml+= ::XmlTag( "dDesemb" , ::DateXml(::dDdesemb))                                                               // Data do desembara�o aduaneiro - AAAA-MM-DD
             ::cXml+= ::XmlTag( "tpViaTransp" , Iif(!(Hb_Ntos(::nTpviatransp) $ [1_2_3_4_5_6_7]), [1], Hb_Ntos(::nTpviatransp))) // Via de transporte internacional informada na Declara��o de Importa��o (DI)
                                                                                                                                 // 1 - mar�tima, 2 - fluvial, 3 - Lacustre, 4 - a�rea, 5 - postal, 6 - ferrovia, 7 - rodovia
             If ::nTpviatransp == 1
                ::cXml+= ::XmlTag( "vAFRMM" , ::nVafrmm)                                                                         // valor somente informar no caso do tpViaTransp == 1 ( 15,2 n )
             Endif 

             ::cXml+= ::XmlTag( "tpIntermedio" , Iif(!(Hb_Ntos(::nTpintermedio) $ [1_2_3]), [1], Hb_Ntos(::nTpintermedio)))      // Forma de importa��o quanto a intermedia��o. 1 - importa��o por conta pr�pria, 2 - importa��o por conta e ordem, 3 - importa��o por encomenda
             If !(Empty(::cCnpja)) 
                ::cXml+= ::XmlTag( "CNPJ" , Left(::SoNumeroCnpj(::cCnpja), 14))                                                  // cnpj do adquirinte ou encomendante  </CNPJ>
             Endif 
             If ::nTpintermedio # 1 .and. ::cUfterceiro # [EX]
                ::cXml+= ::XmlTag( "UFTerceiro" , Left(::cUfterceiro, 2))                                                        // Obrigat�ria a informa��o no caso de importa��o por conta e ordem ou por encomenda. N�o aceita o valor "EX".
             Endif 
 
             ::cXml+= ::XmlTag( "cExportador" , Left(::fRetiraAcento(::cCexportador), 60))                                       // c�digo do exportador 1-60 c  

             // For i:= 1 to 100
             If !Empty(::nNadicao)
                ::cXml+= "<adi>"    // BLOCO I
                       ::cXml+= ::XmlTag( "nAdicao" , ::nNadicao, 0)                                                             // n�mero da adicao 1-3
                       ::cXml+= ::XmlTag( "nSeqAdic" , ::nNseqadic, 0)                                                           // n�mero sequencial do �tem dentro da adi��o 1-3
                       ::cXml+= ::XmlTag( "cFabricante" , Left(::cCfabricante, 60))                                              // C�digo do fabricante estrangeiro - 1-60 c
                       If ::nVdescdi > 0
                          ::cXml+= ::XmlTag( "vDescDI" , ::nVdescdi)                                                             // Valor do desconto do �tem da DI - adi��o n 15,2 ( se houver )
                       Endif    
                       If !(Empty(::cNdraw)) 
                          ::cXml+= ::XmlTag( "nDraw" , Left(::SoNumero(::cNdraw), 11))                                           // O n�mero do Ato Concess�rio de Suspens�o deve ser preenchido com 11 d�gitos (AAAANNNNNND) e o n�mero do Ato Concess�rio de Drawback Isen��o deve ser preenchido com 9 d�gitos (AANNNNNND). (Observa��o inclu�da na NT 2013/005 v. 1.10)
                       Endif    
                ::cXml+= "</adi>"
             Endif 
             // Next
       ::cXml+= "</DI>"

       // For i:= 1 to 500
       // Grupo I03. Produtos e Servi�os / Grupo de Exporta��o
       If !Empty(::cNdraw)
          ::cXml+= "<detExport>"                                                                                                 // Grupo de informa��es de exporta��o para o item
                 ::cXml+= ::XmlTag( "nDraw" , Left(::SoNumero(::cNdraw), 11))                                                    // O n�mero do Ato Concess�rio de Suspens�o deve ser preenchido com 11 d�gitos (AAAANNNNNND) e o n�mero do Ato Concess�rio de Drawback Isen��o deve ser preenchido com 9 d�gitos (AANNNNNND). (Observa��o inclu�da na NT 2013/005 v. 1.10)
          ::cXml+= "</detExport>"    

          ::cXml+= "<exportInd>"                                                                                                 // Grupo sobre exporta��o indireta
            ::cXml+= ::XmlTag( "nRE"     , Left(::SoNumero(::nNre), 12), 0)                                                      // N�mero do Registro de Exporta��o
            ::cXml+= ::XmlTag( "chNFe"   , Left(::cChnfe, 44))                                                                   // Chave de Acesso da NF-e recebida para exporta��o NF-e recebida com fim espec�fico de exporta��o. No caso de opera��o com CFOP 3.503, informar a chave de acesso da NF-e que efetivou a exporta��o 
            ::cXml+= ::XmlTag( "qExport" , ::nQexport, 4)                                                                        // Quantidade do item realmente exportado A unidade de medida desta quantidade � a unidade de comercializa��o deste item. No caso de opera��o com CFOP 3.503, informar a quantidade de mercadoria devolvida
          ::cXml+= "</exportInd>"
       Endif 
       // Next
   Endif 
Return (Nil)

* -----------------> Metodo para gerar a tag de Exporta��o <------------------ *
METHOD fCria_ProdExporta()                                                                                                       // Colabora��o Rubens Aluotto - 16/06/2025
   If !Empty(::cUfSaidapais) .and. Substr(::SoNumero(::cCfOp), 1, 1) == [7]
      ::cXml+= "<exporta>"
             ::cXml+= ::XmlTag( "UFSaidaPais" , Left(::cUfSaidapais, 2))
             ::cXml+= ::XmlTag( "xLocExporta" , Left(::cXlocexporta, 60))
             ::cXml+= ::XmlTag( "xLocDespacho", Left(::cXlocdespacho, 60))
      ::cXml+= "</exporta>"
   Endif 
Return (Nil)

* ------------> Metodo para gerar a tag do Respons�vel T�cnico <-------------- *
METHOD fCria_Responsavel()
   If !Empty(::cRespNome) .and. !Empty(::cRespcnpj) .and. !Empty(::cRespemail)
      ::cXml+= "<infRespTec>" 
             ::cXml+= ::XmlTag( "CNPJ"     , Left(::SoNumeroCnpj(::cRespcnpj), 14))                                              // CNPJ do Respons�vel T�cnico
             ::cXml+= ::XmlTag( "xContato" , Left(::fRetiraAcento(::cRespNome), 60))                                             // Contato do Respons�vel T�cnico
             ::cXml+= ::XmlTag( "email"    , Left(::fRetiraAcento(::cRespemail), 60))                                            // E-mail do Respons�vel T�cnico
             ::cXml+= ::XmlTag( "fone"     , Left(::fRetiraSinal(::cRespfone), 14))                                              // Telefone do Respons�vel T�cnico
      ::cXml+= "</infRespTec>" 
   Endif 
Return (Nil)

* -----------> Metodo para gerar a tag do Imposto de Importa��o <------------- *
METHOD fCria_ProdutoII()  // Marcelo Brigatti
   If Substr(Alltrim(::cCfOp), 1, 1) == [3]
      ::cXml+= "<II>"    // BLOCO P
            ::cXml  += ::XmlTag( "vBC"      , ::nVbci )
            ::cXml  += ::XmlTag( "vDespAdu" , ::nVdespadu )
            ::cXml  += ::XmlTag( "vII"      , ::nVii )
            ::cXml  += ::XmlTag( "vIOF"     , ::nViof )
            ::nVii_t+= ::nVii                                                                                                    // j� acumula o valor dos produtosii para os totais
      ::cXml+= "</II>"
   Endif 
Return (Nil)

* -----------> Metodo para Limpar Constantes de Imposto <--------------------- *                                                 // Jair Barreto
METHOD LimpaPropriedadesImposto()            
   ::cOrig:= ::cCsticms:= ::cModbc:= ::cModbcst:= []
   ::nVbc:= ::nPicms:= ::nVicms:= ::nPredbc:= 0
   ::nPmvast:= ::nPredbcst:= ::nVbcst:= ::nPicmst:= ::nVicmsst:= 0
   ::nPcredsn:= ::nVcredicmssn:= 0
   ::cCstipi:= ::cEnq:= ::cCstipint:= []
   ::nVbcipi:= ::nPipi:= ::nVipi:= 0
   ::cCstPis:= ::cCstCofins:= ::cCstPisnt:= ::cCstCofinsnt:= []
   ::nBcPis:= ::nAlPis:= ::nBcCofins:= ::nAlCofins:= 0
   ::nVbcufdest:= ::nPfcpufdest:= ::nPicmsufdest:= ::nPicmsinter:= ::nPicmsinterpart:= 0
   ::nVfcpufdest:= ::nVicmsufdest:= ::nVicmsufremet:= 0
Return (Nil)

* -----------------------> Metodo para fechar o XML <------------------------- *
METHOD fCria_Fechamento()
   ::cXml+= "</infNFe>"
   ::cXml+= "</NFe>"
Return (Nil)

* -----------------------> Metodo para Ler Certificado .PFX <----------------- *
METHOD fCertificadopfx(cCertificadoArquivo, cCertificadoSenha)
   Local oCertificado

   BEGIN SEQUENCE WITH __BreakBlock()
     oCertificado:= win_oleCreateObject( "CAPICOM.Certificate" )
     oCertificado:Load( cCertificadoArquivo , cCertificadoSenha, 1, 0 )

     ::cCertNomecer:= oCertificado:SubjectName
     ::cCertEmissor:= oCertificado:IssuerName
     ::dCertDataini:= oCertificado:ValidFromDate
     ::dCertDatafim:= oCertificado:ValidToDate
     ::cCertImprDig:= oCertificado:Thumbprint
     ::cCertSerial := oCertificado:SerialNumber
     ::nCertVersao := oCertificado:Version
     ::lCertInstall:= oCertificado:Archived

     If Dtos(oCertificado:ValidToDate) < Dtos(Date())
        ::lCertVencido:= .T.
     Else
        ::lCertVencido:= .F.
     Endif
   END SEQUENCE

   Release oCertificado
Return( Nil )

* ----> Metodo para Retirar Caracteres/Sinais de uma String <----------------- *
METHOD fRetiraSinal(cStr, cEliminar)
   hb_Default(@cEliminar, "��� /;-:,\.(){}[]`�?' ")
Return (CharRem(cEliminar, cStr))

* -----------------------> Metodo Retira acentos de uma string <-------------- *
METHOD fRetiraAcento(cStr)
   Local aFrom := {[�],[�],[�],[�],[�],[�],[A],[A],[A],[�] ,[�],[C],[C],[�],[�],[�],[�],[E],[E],[�],[�],[�],[�],[L],[L],[N],[�],[�],[�],[�],[�],[�],[�],[?] ,[R],[R],[S],[?],[S],[T],[�],[�],[�],[�],[U],[�],[?],[Z],[?],[Z],[�],[�],[�],[�],[�],[�],[a],[a],[a],[�] ,[�],[c],[c],[�],[�],[�],[�],[e],[e],[�],[�],[�],[�],[l],[l],[n],[�],[�],[�],[�],[�],[�],[�],[?] ,[r],[r],[s],[?],[s],[t],[�],[�],[�],[�],[u],[�],[�],[z],[?],[z],[�] ,[&],[�] ,[�] ,[?],[�],[�],[�],[�],[�],[�] ,[�],[�],[?],[?],[?],[�],[?],[�],[A�],[A�],[Ai],[A�],[Ao.],[?],[�]}
   Local aTo   := {[A],[A],[A],[A],[A],[A],[A],[A],[A],[AE],[C],[C],[C],[E],[E],[E],[E],[E],[E],[I],[I],[I],[I],[L],[L],[N],[N],[O],[O],[O],[O],[O],[O],[OE],[R],[R],[S],[S],[S],[T],[U],[U],[U],[U],[U],[Y],[Y],[Z],[Z],[Z],[a],[a],[a],[a],[a],[a],[a],[a],[a],[ae],[c],[c],[c],[e],[e],[e],[e],[e],[e],[i],[i],[i],[i],[l],[l],[n],[n],[o],[o],[o],[o],[o],[o],[oe],[r],[r],[s],[s],[s],[t],[u],[u],[u],[u],[u],[y],[y],[z],[z],[z],[ss],[E],[o.],[a.],[c],[i],[u],[a],[a],[a],[E],[a],[�],[e],[e],[o],[o],[a],[],[o],[c],[a],[e],[u],[],[]}, i

   hb_Default( @cStr,"" )

   For i:= 1 To Len( aFrom )
      cStr:= StrTran(cStr, aFrom[i], aTo[i])
   Next
Return (cStr)

* -------------> Metodo para Gerar uma tag XML com tratamento de tipos <------ *
METHOD XmlTag(cTag, xValue, nDecimals, lConvert)
   Local cXml

   hb_Default(@nDecimals, 2)
   hb_Default(@lConvert, .T.)

   If lConvert
      If ValType(xValue) == "D"
         xValue:= ::DateXml(xValue)
      Elseif ValType(xValue) == "N"
         xValue:= NumberXml(xValue, nDecimals)
      Else
         xValue:= ::StringXML(xValue)
      Endif
   Endif

   If Len(xValue) == 0
      cXml:= "<" + cTag + "/>"
   Else
      cXml:= "<" + cTag + ">" + xValue + "</" + cTag + ">"
   ENDIF
Return (cXml)

* -------------> Metodo Converte data para formato XML <---------------------- *
METHOD DateXml(dDate)
Return (Transf(Dtos(dDate), "@R 9999-99-99"))

* -------------> Metodo Converte n�mero para formato XML <-------------------- *
Static Function NumberXml(nValue, nDecimals)
   hb_Default(@nDecimals, 0)

   If nValue < 0
      nValue:= 0
   Endif
Return (Ltrim(Str(nValue, 16, nDecimals)))

* -------------> Metodo Trata caracteres especiais para XML <----------------- *
METHOD StringXML(cTexto)
   cTexto:= AllTrim(cTexto)

   Do While Space(2) $ cTexto
      cTexto:= StrTran(cTexto, Space(2), Space(1))
   Enddo

   cTexto:= StrTran(cTexto, "&", "E")
   cTexto:= StrTran(cTexto, ["], "&quot;")
   cTexto:= StrTran(cTexto, "'", "&#39;")
   cTexto:= StrTran(cTexto, "<", "&lt;")
   cTexto:= StrTran(cTexto, ">", "&gt;")
   cTexto:= StrTran(cTexto, "�", "&#176;")
   cTexto:= StrTran(cTexto, "�", "&#170;")
Return (cTexto)

* -------------> Metodo Converte data e hora para XML <----------------------- *
METHOD DateTimeXml(dDate, cTime, cUF, lUTC, cUserTimeZone)
   Local cText, lHorarioVerao

   hb_Default(@dDate, Date())
   hb_Default(@cTime, Time())
   hb_Default(@cUF, "SP")
   hb_Default(@lUTC, .T.)

   lHorarioVerao:= (dDate >= ::HorarioVeraoInicio(Year(dDate)) .or. dDate <= ::HorarioVeraoTermino(Year(dDate)-1))
   cText:= Transf(Dtos(dDate), "@R 9999-99-99") + "T" + cTime

   Do Case
      Case !Empty(cUserTimeZone) ; cText += cUserTimeZone
      Case !lUTC ; cText += ""
      Case cUF $ "AC" ; cText += "-05:00"
      Case cUF $ "MT,MS" .and. lHorarioVerao ; cText += "-03:00"
      Case cUF $ "DF,ES,GO,MG,PR,RJ,RS,SC" .and. lHorarioVerao ; cText += "-02:00"
      Otherwise ; cText += "-03:00"
   Endcase
Return (cText)

* -------------> Metodo Domingo de P�scoa <----------------------------------- *
METHOD DomingoDePascoa(nAno)
   Local nA,nB,nC,nD,nE,nF,nG,nH,nI,nK,nL,nM,nMes,nDia

   nA:= nAno % 19
   nB:= Int(nAno / 100)
   nC:= nAno % 100
   nD:= Int(nB / 4)
   nE:= nB % 4
   nF:= Int((nB + 8) / 25)
   nG:= Int((nB - nF + 1) / 3)
   nH:= (19 * nA + nB - nD - nG + 15) % 30
   nI:= Int(nC / 4)
   nK:= nC % 4
   nL:= (32+2*nE+2*nI-nH-nK) % 7
   nM:= Int((nA+11*nH+22*nL) / 451)
   nMes:= Int((nH+nL-7*nM+114) / 31)
   nDia:= ((nH+nL-7*nM+114)%31) + 1
Return (Stod(StrZero(nAno ,4) + StrZero(nMes, 2)+ StrZero(nDia, 2)))

* -------------> Metodo Ter�a de Carnaval <----------------------------------- *
METHOD TercaDeCarnaval(nAno)
Return (::DomingoDePascoa(nAno) - 47)


* -------------> Metodo Hor�rio de ver�o in�cio <----------------------------- *
METHOD HorarioVeraoInicio(nAno)
   Local dPrimeiroDeOutubro, dPrimeiroDomingoDeOutubro, dTerceiroDomingoDeOutubro

   If nAno == 2018
      dTerceiroDomingoDeOutubro:= Stod("20181104")
   Else
      dPrimeiroDeOutubro:= Stod(StrZero(nAno, 4) + "1001")
      dPrimeiroDomingoDeOutubro:= dPrimeiroDeOutubro + IIF(Dow(dPrimeiroDeOutubro) == 1, 0, 7 - Dow(dPrimeiroDeOutubro) + 1)
      dTerceiroDomingoDeOutubro:= dPrimeiroDomingoDeOutubro + 14
   Endif
Return (dTerceiroDomingoDeOutubro)

* -------------> Metodo Hor�rio de ver�o t�rmino <---------------------------- *
METHOD HorarioVeraoTermino(nAno)
   Local dPrimeiroDeFevereiro, dPrimeiroDomingoDeFevereiro, dTerceiroDomingoDeFevereiro

   dPrimeiroDeFevereiro:= Stod(StrZero(nAno + 1, 4) + "0201")
   dPrimeiroDomingoDeFevereiro:= dPrimeiroDeFevereiro + IIF(Dow(dPrimeiroDeFevereiro) == 1, 0, 7 - Dow(dPrimeiroDeFevereiro) + 1)
   dTerceiroDomingoDeFevereiro:= dPrimeiroDomingoDeFevereiro + 14

   If dTerceiroDomingoDeFevereiro == ::TercaDeCarnaval(nAno + 1) - 2
      dTerceiroDomingoDeFevereiro += 7
   Endif
Return (dTerceiroDomingoDeFevereiro)

* -------------> Metodo C�lculo de d�gito m�dulo 11 <------------------------- *
METHOD CalculaDigito(cNumero, cModulo)
   Local nFator, nPos, nSoma, nResto, nModulo, cCalculo
 
   hb_Default(@cModulo, [11])

   If Empty(cNumero)
      Return ([])
   Endif

   cCalculo:= AllTrim(cNumero)
   nModulo := Val(cModulo)
   nFator  := 2
   nSoma   := 0

   If nModulo == 10
      For nPos:= Len(cCalculo) TO 1 STEP -1
          nSoma += Val(Substr(cCalculo, nPos, 1)) * nFator
          nFator+= 1
      Next
   Else
      For nPos:= Len(cCalculo) TO 1 STEP -1
         nSoma += (Asc(Substr(cCalculo, nPos, 1)) - 48) * nFator
         If nFator == 9
            nFator:= 2
         Else
            nFator += 1
         Endif
      Next
   Endif

   nResto:= 11 - Mod(nSoma, 11)
   If nResto > 9
      nResto:= 0
   Endif
Return (Str(nResto, 1))

* -------------> Metodo Retorna somente n�meros de uma string <--------------- *
METHOD SoNumero(cTxt)
   Local cSoNumeros:= "", cChar

   For EACH cChar IN cTxt
      If cChar $ "0123456789"
         cSoNumeros += cChar
      Endif
   Next
Return (cSoNumeros)

* -------------> Metodo Retorna somente n�meros e letras (CNPJ) <------------- *
METHOD SoNumeroCnpj(cTxt)
   Local cSoNumeros:= "", cChar

   For EACH cChar IN cTxt
      If (cChar >= "0" .and. cChar <= "9") .or. (cChar >= "A" .and. cChar <= "Z")
         cSoNumeros += cChar
      Endif
   Next
Return (cSoNumeros)

* ---> Fim da Altera��o da fun��o original da sefazclass - ze_miscfunc.prg <-- *
