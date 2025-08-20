/*****************************************************************************
 * SISTEMA  : TCONTROL                                                       *
 * PROGRAMA : NFE_CLASSE.PRG   		                                     *
 * OBJETIVO : CLASSE PARA GERA��O DE XML DE DFE'S - NFE(55) E NFCE(65)       *
 * AUTOR    : Marcelo Antonio L�zzaro Carli                                  *
 * ALTERADO : Rubens Aluotto                                                 *
 *          : Marcelo de Paula                                               *
 *          : Marcelo Brigatti                                               *
 * DATA     : 10.06.2025                                                     *
 * ULT. ALT.: 18.08.2025                                                     *
 *****************************************************************************/
#include <hbclass.ch>

CLASS Malc_GeraXml
   // Configura��es iniciais b�sicas
   VAR cXml                  INIT []
   VAR cUf                   INIT [35]                                         // Grupo B // SP = 35
   VAR cNf                   INIT []                                           // Grupo B
   VAR cCnpj                 INIT []                                           // Cnpj/Cpf Emitente
   VAR cAmbiente             INIT [2]                                          // Ambiente de Homologa��o 
   VAR cSerie                INIT [1]
   VAR cModelo               INIT [55]                                         // 55 Nfe ou 65 nfce
   VAR cNrdoc                INIT []
   VAR cVersao               INIT [4.00]                                       // Grupo A
   VAR cId                   INIT []                                           // Grupo A
   VAR cCertNomecer          INIT []                                           // Nome do certificado retornado
   VAR cCertEmissor          INIT []                                           // Nome do Emissor do certificado retornado
   VAR dCertDataini          INIT CToD( [] )                                   // Data Inicial de Validade do certificado retornado
   VAR dCertDatafim          INIT CToD( [] )                                   // Data Final de Validade do certificado retornado
   VAR cCertImprDig          INIT []                                           // Impress�o Digital do certificado retornado
   VAR cCertSerial           INIT []                                           // N�mero Serial do certificado retornado
   VAR nCertVersao           INIT 0                                            // Vers�o do certificado retornado
   VAR lCertInstall          INIT .F.                                          // Verifica se o Certificado est� Instalado no Reposit�rio do Windows
   VAR lCertVencido          INIT .F.                                          // Verifica se o Certificado est� Vencido

   // Tag ide - Grupo B
   VAR cNatop                INIT []
   VAR cMunfg                INIT []
   VAR dDataE                INIT Date()
   VAR cTimeE                INIT Time()
   VAR dDataS                INIT Date()
   VAR cTimeS                INIT Time()
   VAR cTpnf                 INIT [1]                                          // 0 - entrada, 1 - sa�da
   VAR cIdest                INIT [1]                                          // 1 - Interna, 2 - Interestadual, 3 - Exterior
   VAR cTpImp                INIT [1]                                          // Tipo de Impress�o    1 - Retrato / 2 - Paisagem
   VAR cTpEmis               INIT [1]                                          // Tipo de Emiss�o      1 - Normal  / 2 - Conting�ncia FS-IA / 3 - (DESATIVADO) / 4 - Conting�ncia EPEC / 5 - Conting�ncia FS-DA / 6 - Conting�ncia SVC-AN / 7 - Conting�ncia SVC-RS / 9 - Conting�ncia off-line da NFC-e 
   VAR cFinnfe               INIT [1]                                          // 1 = NF-e normal; 2 = NF-e complementar; 3 = NF-e de ajuste; 4 = Devolu��o de mercadoria.
   VAR cIndfinal             INIT [1]                                          // Indica opera��o com consumidor final (0 - N�o ; 1 - Consumidor Final)
   VAR cIndpres              INIT [1]                                          // Indicador de Presen�a do comprador no estabelecimento comercial no momento da opera��o.
   VAR cIndintermed          INIT [0]
   VAR cProcemi              INIT [0]                                          // 0 - emiss�o de NF-e com aplicativo do contribuinte
   VAR cVerproc              INIT [4.00_B30]
   VAR dDhCont               INIT []                                           // Data-hora conting�ncia       FSDA - tpEmis = 5
   VAR cxJust                INIT []                                           // Justificativa conting�ncia   FSDA - tpEmis = 5
   VAR cRefnfe               INIT []                                           // Grupo BA
   VAR cCepe                 INIT []  
   VAR cTpnfdebito           INIT []                                           // Reforma tribut�ria
   VAR cTpnfcredito          INIT []                                           // Reforma tribut�ria
   VAR cTpentegov            INIT []                                           // Reforma tribut�ria
   VAR nPredutor             INIT 0                                            // Reforma tribut�ria 
   VAR nTpOperGov            INIT 0
 
   // Tag emit - Grupo C
   VAR cXnomee               INIT []
   VAR cXfant                INIT []
   VAR cXlgre                INIT []
   VAR cNroe                 INIT []
   VAR cXcple                INIT []
   VAR cXBairroe             INIT []
   VAR cXmune                INIT []
   VAR cUfe                  INIT []
   VAR cCepe                 INIT []
   VAR cPais                 INIT [1058]
   VAR cXpaise               INIT [BRASIL]
   VAR cFonee                INIT []
   VAR cIee                  INIT []
   VAR cIme                  INIT []
   VAR cCnaee                INIT []
   VAR cCrt                  INIT []
  
   // Tag dest - Grupo E
   VAR cCnpjd                INIT []
   VAR cXnomed               INIT []
   VAR cXlgrd                INIT []
   VAR cXcpld                INIT []
   VAR cNrod                 INIT []
   VAR cXBairrod             INIT []
   VAR cCmund                INIT []
   VAR cXmund                INIT []
   VAR cUfd                  INIT []
   VAR cCepd                 INIT []
   VAR cPaisd                INIT [1058]
   VAR cXpaisd               INIT [BRASIL]
   VAR cFoned                INIT []
   VAR cIndiedest            INIT [1]
   VAR cIed                  INIT []
   VAR cEmaild               INIT []
   VAR cAutxml               INIT []
   VAR cIdestrangeiro        INIT []

   // Tag retirada - Grupo F
   VAR cCnpjr                INIT []
   VAR cXnomer               INIT []
   VAR cXfantr               INIT []
   VAR cXlgrr                INIT []
   VAR cXcplr                INIT []
   VAR cNror                 INIT []
   VAR cXBairror             INIT []
   VAR cCmunr                INIT []
   VAR cXmunr                INIT []
   VAR cUfr                  INIT []
   VAR cCepr                 INIT []
   VAR cPaisr                INIT [1058]
   VAR cXpaisr               INIT [BRASIL]
   VAR cFoner                INIT []
   VAR cEmailr               INIT []
   VAR cIer                  INIT []

   // Tag entrega - Grupo G
   VAR cCnpjg                INIT []
   VAR cXnomeg               INIT []
   VAR cXfantg               INIT []
   VAR cXlgrg                INIT []
   VAR cXcplg                INIT []
   VAR cNrog                 INIT []
   VAR cXBairrog             INIT []
   VAR cCmung                INIT []
   VAR cXmung                INIT []
   VAR cUfg                  INIT []
   VAR cCepg                 INIT []
   VAR cPaisg                INIT [1058]
   VAR cXpaisg               INIT [BRASIL]
   VAR cFoneg                INIT []
   VAR cEmailg               INIT []
   VAR cIeg                  INIT []

   // Tag prod - Grupo I - Produtos e Servi�os da NFe
   VAR nItem                 INIT 1
   VAR cProd                 INIT []
   VAR cEan                  INIT []
   VAR cEantrib              INIT []
   VAR cXprod                INIT []
   VAR cNcm                  INIT []
   VAR cCest                 INIT []
   VAR cCfOp                 INIT []
   VAR cUcom                 INIT [UN]
   VAR nQcom                 INIT 0
   VAR nVuncom               INIT 0
   VAR nVprod                INIT 0
   VAR nVfrete               INIT 0
   VAR nVseg                 INIT 0
   VAR nVdesc                INIT 0                                                                    
   VAR nVoutro               INIT 0
   VAR cIndtot               INIT [1]                                                  
   VAR cInfadprod            INIT []                                           // Grupo V
   VAR cXped                 INIT []                                           // Grupo I05
   VAR nNitemped             INIT 0                                            // Grupo I05
   VAR cNfci                 INIT []                                           // Grupo I07

   // TAG DI - Grupo I01 - Configuracoes para IMPORTACAO CFOP com in�cio "3"   // Colabora��o Rubens Aluotto - 16/06/2025
   VAR cNdi                  INIT []
   VAR dDdi                  INIT Ctod([])
   VAR cXlocdesemb           INIT []
   VAR cUfdesemb             INIT []
   VAR dDdesemb              INIT Ctod([])
   VAR nTpviatransp          INIT 0
   VAR nVafrmm               INIT 0
   VAR nTpintermedio         INIT 0
   VAR cCnpja                INIT []
   VAR cUfterceiro           INIT []
   VAR cCexportador          INIT []

   // TAG adi - Grupo I01 - Grupo de Adi��es (SubGrupo da TAG DI) 
   VAR nNadicao              INIT 0                                           // N�mero da Adi��o 
   VAR nNseqadic             INIT 0                                           // N�mero sequencial do �tem dentro da Adi��o
   VAR cCfabricante          INIT []                                          // C�digo do fabricante estrangeiro, usado nos sistemas internos de informa��o do emitente da NF-e 
   VAR nVdescdi              INIT 0                                           // Valor do desconto do item da DI � Adi��o
   VAR cNdraw                INIT []                                          // N�mero do ato concess�rio de Drawback (O n�mero do Ato Concess�rio de Suspens�o deve ser preenchido com 11 d�gitos (AAAANNNNNND)
   VAR nNre                  INIT 0                                           // N�mero do Registro de Exporta��o
   VAR cChnfe                INIT []                                          // Chave de Acesso da NF-e recebida para exporta��o NF-e recebida com fim espec�fico de exporta��o. No caso de opera��o com CFOP 3.503, informar a chave de acesso da NF-e que efetivou a exporta��o 
   VAR nQexport              INIT 0                                           // Quantidade do item realmente exportado A unidade de medida desta quantidade � a unidade de comercializa��o deste item. No caso de opera��o com CFOP 3.503, informar a quantidade de mercadoria devolvida

   // Grupo JA. Detalhamento Espec�fico de Ve�culos novos
   VAR cTpOp                 INIT []
   VAR cChassi               INIT []
   VAR cCor                  INIT []
   VAR cXcor                 INIT []
   VAR cPot                  INIT []             
   VAR cCilin                INIT []
   VAR nPesolvei             INIT 0                                             
   VAR nPesobvei             INIT 0 
   VAR cNserie               INIT []
   VAR cTpcomb               INIT []                                           
   VAR cNmotor               INIT []
   VAR nCmt                  INIT []
   VAR cDist                 INIT []
   VAR cAnomod               INIT []
   VAR cAnofab               INIT []
   VAR cTpveic               INIT []
   VAR cEspveic              INIT []
   VAR cVin                  INIT []
   VAR cCondveic             INIT []
   VAR cCmod                 INIT []                                                 
   VAR cCordenatran          INIT []
   VAR cLota                 INIT []
   VAR cTprest               INIT []

   // Tag med - Grupo K. Detalhamento Espec�fico de Medicamento e de mat�rias-primas farmac�uticas
   VAR cProdanvisa           INIT []
   VAR cXmotivoisencao       INIT []
   VAR nVpmc                 INIT 0

   // Tag arma - Grupo L. Detalhamento Espec�fico de Armamentos
   VAR cTparma               INIT []
   VAR cNserie_a             INIT []
   VAR cNcano                INIT []
   VAR cDescr_a              INIT []

   // Tag comb - Grupo LA - Combust�veis
   VAR cCprodanp             INIT []                                           // C�digo de produto da ANP
   VAR cDescanp              INIT []                                           // Descri��o do produto conforme ANP
   VAR nQtemp                INIT 0                                            // Quantidade de combust�vel faturada � temperatura ambiente.
   VAR nQbcprod              INIT 0                                            // Informar a BC da CIDE em quantidade
   VAR nValiqprod            INIT 0                                            // Informar o valor da al�quota em reais da CIDE
   VAR nVcide                INIT 0                                            // Informar o valor da CIDE

   // Tag Icms - Grupo N
   VAR cOrig                 INIT [0]
   VAR cCsticms              INIT []
   VAR nModbc                INIT 3
   VAR nVbc                  INIT 0
   VAR nPicms                INIT 0
   VAR nVlicms               INIT 0
   VAR nModbcst              INIT 3
   VAR nPmvast               INIT 0
   VAR nPredbcst             INIT 0
   VAR nVbcst                INIT 0
   VAR nPicmst               INIT 0
   VAR nVicmsst              INIT 0
   VAR nPredbc               INIT 0
   VAR nPcredsn              INIT 0
   VAR nVcredicmssn          INIT 0

   // Tag Grupo NA. ICMS para a UF de destino                                  // Marcelo Brigatti
   VAR nVbcufdest            INIT 0
   VAR nVbcfcpufdest         INIT 0
   VAR nPfcpufdest           INIT 0
   VAR nPicmsufdest          INIT 0
   VAR nPicmsinter           INIT 0
   VAR nPicmsinterpart       INIT 0
   VAR nVfcpufdest           INIT 0
   VAR nVicmsufdest          INIT 0
   VAR nVicmsufremet         INIT 0

   // Tag Ipi - Grupo O
   VAR cCEnq                 INIT [999]
   VAR cCstipi               INIT [53]
   VAR cCstipint             INIT []
   VAR nVipi                 INIT 0
   VAR nVbcipi               INIT 0
   VAR nPipi                 INIT 0

   // Imposto de Importa��o 
   // TAG II - Grupo P - Grupo Imposto de Importa��o                           // (Informar apenas quando o item for sujeito ao II) 
   VAR nVbci                 INIT 0                                            // Valor BC do Imposto de Importa��o
   VAR nVdespadu             INIT 0                                            // Valor despesas aduaneiras
   VAR nVii                  INIT 0                                            // Valor Imposto de Importa��o
   VAR nViof                 INIT 0                                            // Valor Imposto sobre Opera��es Financeiras 

   // Tag Pis/Cofins - Grupo Q e S
   VAR cCstPis               INIT []                                           // (01, 02) CSTs do PIS s�o mutuamente exclusivas s� pode existir um tipo
   VAR cCstPisqtd            INIT []                                           // (03)
   VAR cCstPisnt             INIT []                                           // (04, 05, 06, 07, 08, 09)
   VAR cCstPisoutro          INIT []                                           // (49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)
   VAR cCstCofins            INIT []                                           // (01, 02) CSTs do Cofins s�o mutuamente exclusivas s� pode existir um tipo                 
   VAR cCstCofinsqtd         INIT []                                           // (03)                                                                                            
   VAR cCstCofinsnt          INIT []                                           // (04, 05, 06, 07, 08, 09)                                                                        
   VAR cCstCofinsoutro       INIT []                                           // (49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)
   VAR nBcPis                INIT 0
   VAR nAlPis                INIT 0
   VAR nBcCofins             INIT 0
   VAR nAlCofins             INIT 0

   // Tag total - Grupo W - Total da NFe
   VAR nVicms                INIT 0
   VAR nVbc_t                INIT 0
   VAR nVicms_t              INIT 0
   VAR nVicmsdeson_t         INIT 0
   VAR nVfcpufdest_t         INIT 0
   VAR nVicmsufdest_t        INIT 0
   VAR nVicmsufremet_t       INIT 0
   VAR nVfcp_t               INIT 0
   VAR nVbcST_t              INIT 0
   VAR nVst_t                INIT 0
   VAR nVfcpst_t             INIT 0
   VAR nVfcpstret_t          INIT 0
   VAR nVSeg_t               INIT 0
   VAR nVii_t                INIT 0
   VAR nVipi_t               INIT 0
   VAR nVipidevol_t          INIT 0       
   VAR nVpist_t              INIT 0
   VAR nVCofins_t            INIT 0
   VAR nMonoBas              INIT 0
   VAR nMonoAliq             INIT 0
   VAR nVprodt               INIT 0
   VAR nVFretet              INIT 0
   VAR nVseg                 INIT 0
   VAR nDesct                INIT 0
   VAR nVipidevol            INIT 0
   VAR nVpist                INIT 0
   VAR nVCofinst             INIT 0
   VAR nVOutrot              INIT 0
   VAR nVnf                  INIT 0
   VAR nVtottrib             INIT 0                                            // Grupo M
   VAR nVtottribt            INIT 0                                            // Grupo Totais
   VAR lVtottrib             INIT .T.                                          // Vari�vel para permitir ou n�o informar os valores dos tributos na informa��o adicional dos itens 

   // Tag transp - Grupo X
   VAR cModFrete             INIT []
   VAR cXnomet               INIT []
   VAR cCnpjt                INIT []
   VAR cIet                  INIT []
   VAR cXEndert              INIT []
   VAR cXmunt                INIT []
   VAR cUft                  INIT []
   VAR cPlaca                INIT []
   VAR cUfplacat             INIT []
   VAR cRntc                 INIT []
   VAR nQvol                 INIT 0
   VAR cEsp                  INIT []
   VAR cMarca                INIT []
   VAR cNvol                 INIT []
   VAR nPesol                INIT 0
   VAR nPesob                INIT 0

   // Tag cobr - Grupo Y - SubGrupos fat, dup
   VAR cNfat                 INIT []
   VAR nVorigp               INIT 0
   VAR nVdescp               INIT 0
   VAR nVliqup               INIT 0
   VAR cNDup                 INIT []
   VAR dDvencp               INIT Ctod([])
   VAR nVdup                 INIT 0

   // Tag Pag - Grupo YA. Informa��es de Pagamento
   VAR cIndPag               INIT [0]
   VAR cTpag                 INIT []
   VAR cXpag                 INIT []
   VAR nVpag                 INIT 0
   VAR nVtroco               INIT 0
   VAR nTpintegra            INIT 0                                            // 1=Pagamento integrado com o sistema de automa��o da empresa (Ex.: equipamento TEF, Com�rcio Eletr�nico) | 2= Pagamento n�o integrado com o sistema de automa��o da empresa 
   VAR cCnpjpag              INIT []
   VAR cTband                INIT []
   VAR cAut                  INIT []

   // Tag infAdic - Grupo Z - informa��es Fisco / Complementar
   VAR lComplementar         INIT .F.
   VAR nVIcmsSufDest         INIT 0
   VAR nVIcmsSufRemet        INIT 0
   VAR nVpis                 INIT 0
   VAR nVcofins              INIT 0
   VAR cCodDest              INIT []
   VAR cInfcpl               INIT []                                           // Grupo Z - infCpl
   VAR cInfFisc              INIT []                                           // Grupo Z - infAdFisco

   // TAG exporta - Grupo ZA - Configuracoes para EXPORTACAO CFOP com in�cio "7" // Colabora��o Rubens Aluotto - 16/06/2025
   VAR cUfSaidapais          INIT []
   VAR cXlocexporta          INIT []
   VAR cXlocdespacho         INIT []

   // Tag infRespTec - Grupo ZD - respons�vel t�cnico
   VAR cRespcnpj             INIT []
   VAR cRespNome             INIT []
   VAR cRespemail            INIT []
   VAR cRespfone             INIT []

   // TAG is - Reforma tribut�ria
   VAR cClasstribiS          INIT []
   VAR nVbcis                INIT 0
   VAR nPisis                INIT 0
   VAR nPisespec             INIT 0
   VAR cUtrib_is             INIT []
   VAR nQtrib_is             INIT 0

   // TAG Ibscbs - Reforma tribut�ria
   VAR cCclasstrib           INIT []
   VAR nVbcibs               INIT 0
   VAR nPibsuf               INIT 0.1 // fixo para 2026 depois vai mudar
   VAR nPdifgibuf            INIT 0
   VAR nVdevtribgibuf        INIT 0
   VAR nPredaliqgibuf        INIT 0
   VAR nVibsuf               INIT 0
   VAR nPibsmun              INIT 0
   VAR nPifgibsmun           INIT 0
   VAR nVcbop                INIT 0
   VAR nVdevtribgibsmun      INIT 0
   VAR nPredaliqibsmun       INIT 0
   VAR nVibsmun              INIT 0
   VAR nPcbs                 INIT 0.9 // fixo para 2026 depois vai mudar
   VAR nPpDifgcbs            INIT 0
   VAR nVcbsopgcbs           INIT 0
   VAR nVdevtribgcbs         INIT 0
   VAR nPredaliqgcbs         INIT 0
   VAR nVcbs                 INIT 0
   VAR cClasstribreg         INIT []
   VAR nPaliqefetregibsuf    INIT 0
   VAR nVtribregibsuf        INIT 0
   VAR nPaliqefetregibsMun   INIT 0
   VAR nVtribregibsMun       INIT 0
   VAR nPaliqefetregcbs      INIT 0
   VAR nVtribregcbs          INIT 0
   VAR cCredPresgibs         INIT []
   VAR nPcredpresgibs        INIT 0
   VAR nVcredpresgibs        INIT 0
   VAR cCredPrescbs          INIT []
   VAR nPcredprescbs         INIT 0
   VAR nVcredprescbs         INIT 0
   VAR nVissqn               INIT 0
   VAR nVServs               INIT 0
   VAR nVfcp                 INIT 0

   // Tag ISTot - Reforma tribut�ria
   VAR nVisistot             INIT 0
   VAR nVbcibscbs            INIT 0
   VAR nVdifgibsuf           INIT 0
   VAR nVdevtribgibsuf       INIT 0
   VAR nVibsufgibsuf         INIT 0
   VAR nVdDifgibsmun         INIT 0
   VAR nVdevtribgibsmun      INIT 0
   VAR nVibsmungibsmun       INIT 0
   VAR nVibsgibs             INIT 0
   VAR nVcredpresgibs        INIT 0
   VAR nVcredprescondsusgibs INIT 0
   VAR nVdifgcbs             INIT 0
   VAR nVdevtribgcbs         INIT 0
   VAR nVcbsgcbs             INIT 0
   VAR nVcredpresgcbs        INIT 0
   VAR nVcredprescondsusgcbs INIT 0
   VAR nVnftot               INIT 0

   // Tag gIBSCBSMono  - Reforma tribut�ria
   VAR nQbcmono              INIT 0
   VAR nAdremibs             INIT 0
   VAR nAdremcbs             INIT 0
   VAR nVibsmono             INIT 0
   VAR nVcbsmono             INIT 0
   VAR nQbcmonoreten         INIT 0
   VAR nAdremibsreten        INIT 0
   VAR nVibsmonoreten        INIT 0
   VAR nAdremcbsreten        INIT 0
   VAR nVcbsmonoreten        INIT 0
   VAR nQbcmonoret           INIT 0
   VAR nAdremibsret          INIT 0
   VAR nVibsmonoret          INIT 0
   VAR nAdremcbsret          INIT 0
   VAR nVcbsmonoret          INIT 0
   VAR nPdifibs              INIT 0 
   VAR nVibsmonodif          INIT 0
   VAR nPdifcbs              INIT 0
   VAR nVcbsmonodif          INIT 0
   VAR nVtotibsmonoItem      INIT 0
   VAR nVtotcbsmonoItem      INIT 0

   METHOD fCria_Xml()          CONSTRUCTOR
   METHOD fCria_ChaveAcesso()
   METHOD fCria_Ide()
   METHOD fCria_AddNfref()
   METHOD fCria_Compragov()                                                    // Reforma tribut�ria
   METHOD fCria_Autxml()
   METHOD fCria_Emitente()
   METHOD fCria_Destinatario()
   METHOD fCria_Retirada() 
   METHOD fCria_Entrega()
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
   METHOD fCria_ProdutoIs()                                                    // Reforma tribut�ria
   METHOD fCria_ProdutoIbscbs()                                                // Reforma tribut�ria
   METHOD fCria_Totais()
   METHOD fCria_Istot()                                                        // Reforma tribut�ria
   METHOD fCria_Gibscbsmono()                                                  // Reforma tribut�ria
   METHOD fCria_Transportadora() 
   METHOD fCria_Cobranca()
   METHOD fCria_Pagamento()
   METHOD fCria_Informacoes() 
   METHOD fCria_Responsavel()
   METHOD fCria_Fechamento()

   METHOD fCertificadopfx(cCertificadoArquivo, cCertificadoSenha)
ENDCLASS

* ---------------> Metodo para inicializar a cria��o do XML <----------------- *
METHOD fCria_Xml() CLASS Malc_GeraXml
   ::fCria_ChaveAcesso()

   ::cXml+= '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'
   ::cXml+= '<infNFe versao="' + ::cVersao + '" Id="NFe' + ::cId + '">'
Return Self

* --------------> Metodo para gerar a chave de acesso da NFe <---------------- *
METHOD fCria_ChaveAcesso() CLASS Malc_GeraXml
   Local cKey:= Alltrim(::cUf)
         cKey+= SubStr(Dtoc(Date()), 9, 2) + SubStr(Dtoc(Date()), 4, 2)
         cKey+= SoNumeroCnpj(::cCnpj)
         cKey+= Iif(!(::cModelo $ [55_65]), [55], Left(::cModelo, 2) + Padl(::cSerie, 3, [0]))
         cKey+= Padl(::cNf, 9, [0])
         cKey+= [1]
         cKey+= Padl(::cNrdoc, 8, [0])
Return (::cId:= cKey + CalculaDigito(cKey, [11]))

* ------------> Metodo para gerar a tag de identifica��o da NFe <------------- *
METHOD fCria_Ide() CLASS Malc_GeraXml
   ::cXml+= "<ide>"                                                                                                              // In�cio da TAG (ide)
          ::cXml+= XmlTag( "cUF"    , Left(::cUf, 2))                                                                            // UF do Emitente no caso SP = 35
          ::cXml+= XmlTag( "cNF"    , Padl(Alltrim(::cNrdoc), 8, [0]))                                                           // Controle da Nota ou n�mero do pedido
          ::cXml+= XmlTag( "natOp"  , Left(fRetiraAcento(::cNatop), 60))                                                         // Natureza da Opera��o
          ::cXml+= XmlTag( "mod"    , Iif(!(::cModelo $ [55_65]), [55], Left(::cModelo, 2)))                                     // Modelo do Documento 55 - Nfe ou 65 Nfce
          ::cXml+= XmlTag( "serie"  , Iif(Empty(::cSerie), [1], Left(::cSerie, 3)))                                              // S�rie 
          ::cXml+= XmlTag( "nNF"    , Left(::cNf, 9))                                                                            // N�mero da Nota Fiscal
          ::cXml+= XmlTag( "dhEmi"  , DateTimeXml(::dDataE, ::cTimeE))                                                           // Data Emiss�o Formato yyyy-mm-dd

          If !Empty(::dDataS)
             If ::cModelo # [65]
                ::cXml+= XmlTag( "dhSaiEnt" , DateTimeXml(::dDataS, ::cTimeS))                                                   // Data da Sa�da da mercadoria
             Endif 
          Endif  
 
          ::cXml+= XmlTag( "tpNF"     , Iif(!(::cTpnf $ [0_1]), [0], Left(::cTpnf, 1)))                                          // Tipo de Emiss�o da NF  0 - Entrada, 1 - Sa�da, 2 - Sa�da-Devolu��o, 3 - Sa�da-Garantia
          ::cXml+= XmlTag( "idDest"   , Iif(!(::cIdest $ [1_2_3]), [1], Left(::cIdest, 1)))                                      // Identificador de Local de destino da opera��o (1 - Interna, 2 - Interestadual, 3 - Exterior)
          ::cXml+= XmlTag( "cMunFG"   , Left(::cMunfg, 7))                                                                       // IBGE do Emitente

          If ::cIndpres == [5]                                                                                                   
             ::cXml+= XmlTag( "cMunFGIBS", Left(::cMunfg, 7))                                                                    // Informar o munic�pio de ocorr�ncia do fato gerador do fato gerador do IBS / CBS. Campo preenchido somente quando �indPres = 5 (Opera��o presencial, fora do estabelecimento)�, e n�o tiver endere�o do destinat�rio (Grupo: E05) ou Local de entrega (Grupo: G01).
          Endif 

          If ::cModelo == [65]
             ::cXml+= XmlTag( "tpImp" , Iif(!(::cTpimp $ [4_5]), [4], Left(::cTpimp, 1))) 
          Elseif ::cModelo == [55]
             ::cXml+= XmlTag( "tpImp" , Iif(!(::cTpimp $ [0_1_2_3]), [1], Left(::cTpimp, 1)))                                    // Tipo de Impress�o 0 - Sem gera��o de DANFE; 1 - DANFE normal, Retrato; 2 - DANFE normal, Paisagem; 3 - DANFE Simplificado; 4 - DANFE NFC-e; 5 - DANFE NFC-e em mensagem eletr�nica
          Endif 

          ::cXml+= XmlTag( "tpEmis"   , Iif(!(::cTpemis $ [1_2_3_4_5_6_7_9]), [1], Left(::cTpemis, 1)))                          // 1=Emiss�o normal (n�o em conting�ncia); 2=Conting�ncia FS-IA, com impress�o do DANFE em Formul�rio de Seguran�a - Impressor Aut�nomo; 3=Conting�ncia SCAN (Sistema de Conting�ncia do Ambiente Nacional); *Desativado * NT 2015/002 4=Conting�ncia EPEC (Evento Pr�vio da Emiss�o em Conting�ncia); 5=Conting�ncia FS-DA, com impress�o do DANFE em Formul�rio de Seguran�a - Documento Auxiliar; 6=Conting�ncia SVC-AN (SEFAZ Virtual de Conting�ncia do AN); 7=Conting�ncia SVC-RS (SEFAZ Virtual de Conting�ncia do RS); 9=Conting�ncia off-line da NFC-e;
          ::cXml+= XmlTag( "cDV"      , Right(::cId, 1))                                                                         // D�gito da Chave de Acesso
          ::cXml+= XmlTag( "tpAmb"    , Iif(Empty(::cAmbiente), [2], Left(::cAmbiente, 1)))                                      // Identifica��o do Ambiente  1 - Produ��o,  2 - Homologa��o

          If ::cModelo == [65]
             ::cXml+= XmlTag( "finNFe", [1])                                                                                     // 1 - NF-e normal; 2 - NF-e complementar; 3 - NF-e de ajuste; 4 - Devolu��o de mercadoria; 5 - Nota de cr�dito; 6 - Nota de d�bito
          Elseif ::cModelo == [55]
             ::cXml+= XmlTag( "finNFe", Iif(!(::cFinnfe $ [1_2_3_4_5_6]), [1], Left(::cFinnfe, 1)))                              // 1 - NF-e normal; 2 - NF-e complementar; 3 - NF-e de ajuste; 4 - Devolu��o de mercadoria; 5 - Nota de cr�dito; 6 - Nota de d�bito
          Endif 

          If ::cFinnfe == [6]                                                                                                    // Nota de D�bito
             ::cXml+= XmlTag( "tpNFDebito"  , Iif(!(::tpNFDebito $ [01_02_03_04_05_06_07]), [01], Left(::tpNFDebito, 2)))        // 01=Transfer�ncia de cr�ditos para Cooperativas; 02=Anula��o de Cr�dito por Sa�das Imunes/Isentas; 03=D�bitos de notas fiscais n�o processadas na apura��o; 04=Multa e juros; 05=Transfer�ncia de cr�dito de sucess�o; 06=Pagamento antecipado; 07=Perda em estoque                                                      
          Elseif ::cFinnfe == [5]                                                                                                // Nota de Cr�dito
             ::cXml+= XmlTag( "tpNFCredito" , Iif(!(::tpNFCredito $ [01_02_03]), [01], Left(::tpNFCredito, 2)))                  // 01 = Multa e juros; 02 = Apropria��o de cr�dito presumido de IBS sobre o saldo devedor na ZFM (art. 450, � 1�, LC 214/25); 03 = Retorno 
          Endif 

          If ::cAmbiente == [2] .or. ::cModelo == [65]
             ::cXml+= XmlTag( "indFinal" , [1])                                                                                  // Indica opera��o com consumidor final (0 - N�o ; 1 - Consumidor Final)
          Else
             ::cXml+= XmlTag( "indFinal" , Iif(!(::cIndfinal $ [0_1]), [0], Left(::cIndfinal, 1)))                               // Indica opera��o com consumidor final (0 - N�o ; 1 - Consumidor Final)
          Endif 

          ::cXml+= XmlTag( "indPres"  , Iif(!(::cIndpres $ [0_1_2_3_4_5_9]), [0], Left(::cIndpres, 1)))                          // Indicador de Presen�a do comprador no estabelecimento comercial no momento da opera��o.
                                                                                                                                 // 1 - Opera��o presencial;
                                                                                                                                 // 2 - N�o presencial, internet;
                                                                                                                                 // 3 - N�o presencial, tele-atendimento;
                                                                                                                                 // 4 - NFC-e entrega em domic�lio;
                                                                                                                                 // 5 - Opera��o presencial, fora do estabelecimento; (inclu�do NT2016.002)
                                                                                                                                 // 9 - N�o presencial, outros.
          If !(::cIndpres $ [0_1_5])                                                                                             // Se Informado indicativo de presen�a, tag: indPres, DIFERENTE de 2, 3, 4 ou 9 � Proibido o preenchimento do campo Indicativo do Intermediador (tag: indIntermed)
             ::cXml+= XmlTag( "indIntermed" , Iif(!(::cIndintermed $ [0_1]), [0], Left(::cIndintermed, 1)))                      // Indicador de intermediador/marketplace, 0 - Opera��o sem intermediador (em site ou plataforma pr�pria), 1 - Opera��o em site ou plataforma de terceiros (intermediadores/marketplace)
          Endif 

          ::cXml+= XmlTag( "procEmi"  , Iif(!(::cProcemi $ [0_1_2_3]), [1], Left(::cProcemi, 1)))                                // 0 - emiss�o de NF-e com aplicativo do contribuinte;
                                                                                                                                 // 1 - emiss�o de NF-e avulsa pelo Fisco;
                                                                                                                                 // 2 - emiss�o de NF-e avulsa, pelo contribuinte com seu certificado digital, atrav�s do site do Fisco;
                                                                                                                                 // 3 - emiss�o NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
          ::cXml+= XmlTag( "verProc"  , Left(::cVerproc, 20))                                                                    // Informar a vers�o do aplicativo emissor de NF-e.

          If ::cTpemis # [1]                                                                                                     // 1 - Emiss�o normal (n�o em conting�ncia
             ::cXml+= XmlTag( "dhCont" , DateTimeXml(::dDhcont, ::cTimeE))                                                       // Data-hora conting�ncia       FSDA - tpEmis = 5
             ::cXml+= XmlTag( "xJust"  , Left(::cXjust, 256))                                                                    // Justificativa conting�ncia   FSDA - tpEmis = 5
          Endif 

          ::fCria_Compragov()
   ::cXml+= "</ide>"
Return (Nil)

* -----------------> Metodo para gerar as refer�ncias da NF <----------------- *
METHOD fCria_AddNfref() CLASS Malc_GeraXml                                                                                       // Marcelo Brigatti
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
             ::cXml+= XmlTag("refNFe" , Left(fRetiraSinal(::cRefnfe), 44))
      ::cXml+= "</NFref>"

      ::cXml+= "</ide>"
   Endif 
Return (Nil)

* ------------------> Metodo para gerar a tag gCompragov <-------------------- *
METHOD fCria_Compragov() CLASS Malc_GeraXml
   If !Empty(::cTpentegov)
      ::cXml+= "<gCompraGov>"                                                                                                    
             ::cXml+= XmlTag( "tpEnteGov" , Iif(!(::cTpentegov $ [1_2_3_4]), [1], Left(::cTpentegov, 1)))                        // 1=Uni�o 2=Estado 3=Distrito Federal 4=Munic�pio
             ::cXml+= XmlTag( "pRedutor"  , ::nPredutor, 4)                            
             ::cXml+= XmlTag( "tpOperGov" , Iif(!(::cTpOperGov $ [1_2]), [1], Left(::cTpOperGov, 1)))                            // 1=Fornecimento 2=Recebimento do pagamento, conforme fato gerador do IBS/CBS definido no Art. 10 � 2�
      ::cXml+= "</gCompraGov>"
   Endif                                                                             
Return (Nil)

* -----------------> Metodo para gerar a tag do emitente <-------------------- *
METHOD fCria_Emitente() CLASS Malc_GeraXml
   ::cXml+= "<emit>"                                                                                                             // In�cio da TAG (emit)
          ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpj), 14))                                                             // CNPJ do Emitente
          ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomee), 60))                                                         // Raz�o Social emitente

          If !Empty(::cXfant)
             ::cXml+= XmlTag( "xFant" , Left(fRetiraAcento(::cXfant), 60))                                                       // Nome Fantasia Emitente
          Endif 

          ::cXml+= "<enderEmit>"
                 ::cXml+= XmlTag( "xLgr"    , Left(fRetiraAcento(::cXlgre), 60))                                                 // Endere�o Emitente
                 ::cXml+= XmlTag( "nro"     , Left(::cNroe, 60))                                                                 // N�mero do Endere�o do Emitente

                 If !Empty(::cXcple)
                    ::cXml+= XmlTag( "xCpl" , Left(fRetiraAcento(::cXcple), 60))
                 Endif 

                 ::cXml+= XmlTag( "xBairro" , Left(fRetiraAcento(::cXBairroe), 60))                                              // Bairro do Emitente
                 ::cXml+= XmlTag( "cMun"    , Left(SoNumero(::cMunfg), 7))                                                       // C�digo IBGE do emitente
                 ::cXml+= XmlTag( "xMun"    , Left(fRetiraAcento(::cXmune), 60))                                                 // Cidade do Emitente
      	         ::cXml+= XmlTag( "UF"      , Left(::cUfE, 2))                                                                   // UF do Emitente
     	         ::cXml+= XmlTag( "CEP"     , Left(SoNumero(::cCepe), 8))                                                        // CEP do Emitente
    	         ::cXml+= XmlTag( "cPais"   , Left(::cPais, 4))                                                                  // C�digo do Pa�s emitente
    	         ::cXml+= XmlTag( "xPais"   , Left(fRetiraAcento(::cXpaise), 60))                                                // Pa�s Emitente da NF

                 If !Empty(SoNumero(::cFonee))
	                ::cXml+= XmlTag( "fone"    , Left(SoNumero(::cFonee), 14))                                                   // Telefone do Emitente
                 Endif 
          ::cXml+= "</enderEmit>"
          
          ::cXml+= XmlTag( "IE" , Left(SoNumero(::cIee), 14))                                                                    // Inscri��o Estadual do Emitente

          If !Empty(::cIme)                                                                                                      // N�o obrigat�rio
             ::cXml+= XmlTag( "IM" , Left(SoNumero(::cIme), 15))                                                                 // Inscri��o Municipal do Emitente
          Endif 

          If !Empty(::cCnaee)                                                                                                    // N�o obrigat�rio
             ::cXml+= XmlTag( "CNAE" , Left(SoNumero(::cCnaee), 7))                                                              // CNAE do Emitente
          Endif 

          ::cXml+= XmlTag( "CRT" , Iif(Val(::cCrt) <= 1 .or. !(::cCrt $ [1_2_3]), [1], ::cCrt))                                  // C�digos de Detalhamento do Regime e da Situa��o TABELA A � C�digo de Regime Tribut�rio � CRT
                                                                                                                                 // 1 � Simples Nacional
                                                                                                                                 // 2 � Simples Nacional � excesso de sublimite da receita bruta
                                                                                                                                 // 3 � Regime Normal NOTAS EXPLICATIVAS
   ::cXml+= "</emit>"                                                                                                            // Final da TAG Emitente
Return (Nil)

* -----------------> Metodo para gerar a tag do destinat�rio <---------------- *
METHOD fCria_Destinatario() CLASS Malc_GeraXml
   If !Empty(::cCnpjd)
      ::cXml+= "<dest>"
             If !Empty(::cCnpjd)
                If Len(SoNumeroCnpj(::cCnpjd)) < 14                                                                              // Pessoa F�sica - Cpf
                   ::cXml+= XmlTag( "CPF"  , Left(SoNumeroCnpj(::cCnpjd), 11))
                Else                                                                                                             // Pessoa Juridica
                   ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpjd), 14))
                Endif 
             Endif    

             If !Empty(::cIdestrangeiro)
                If ::cUfd == [EX]
                   ::cXml+= XmlTag( "idEstrangeiro" , Left(::cIdestrangeiro, 20))
                Endif 
             Endif    

             If ::cAmbiente == [2]                                                                                               // Homologa��o
                ::cXml+= XmlTag( "xNome" , [NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL])
             Else                                                                                                                // Produ��o
                ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomed), 60))
             Endif    

             // Grupo Obrigat�rio para a NF-e (modelo 55).
             ::cXml+= "<enderDest>"    
                    ::cXml+= XmlTag( "xLgr"     , Left(fRetiraAcento(::cXlgrd), 60))
                    ::cXml+= XmlTag( "nro"      , Left(::cNrod, 60))

                    If !Empty(::cXcpld)
                       ::cXml+= XmlTag( "xCpl"  , Left(::cXcpld, 60))
                    Endif 

                    ::cXml+= XmlTag( "xBairro"  , Left(fRetiraAcento(::cXBairrod), 60))

                    If ::cUfd == [EX]                                                                                            // Importa��o/Exporta��o
                       ::cXml+= XmlTag( "cMun"  , [9999999])
                       ::cXml+= XmlTag( "xMun"  , [EXTERIOR])
                       ::cXml+= XmlTag( "UF"    , [EX])
                    Else                                                                                                         // Com�rcio Interno
                       ::cXml+= XmlTag( "cMun"  , Left(::cCmund, 7))
                       ::cXml+= XmlTag( "xMun"  , Left(fRetiraAcento(::cXmund), 60))
                       ::cXml+= XmlTag( "UF"    , Left(::cUfd, 2))
                       ::cXml+= XmlTag( "CEP"   , Left(SoNumero(::cCepd), 8))
                    Endif 

	            If !Empty(::cPaisd)
                       ::cXml+= XmlTag( "cPais" , Left(::cPaisd, 4))
                    Endif 

	            If !Empty(::cXpaisd)
                       ::cXml+= XmlTag( "xPais" , Left(::cXpaisd, 60))
                    Endif 

	            If !Empty(SoNumero(::cFoned))
                       ::cXml+= XmlTag( "fone"  , Left(SoNumero(::cFoned), 14))
                     Endif 
             ::cXml+= "</enderDest>"

   	     ::cXml+= XmlTag( "indIEDest" , If(::cModelo == [65] .or. ::cUfd == [EX], "9", Left(::cIndiedest, 1)))                   //   1 = Contribuinte ICMS (informar a IE do destinat�rio);

             If !Empty(::cIed) .and. !(::cUfd == [EX]) .and. !(::cModelo == [65]) .and. ::cIndiedest == [1]                      //   9 = N�o Contribuinte, que pode ou n�o possuir Inscri��o Estadual no Cadastro de Contribuintes do ICMS.
                ::cXml+= XmlTag( "IE" , Left(SoNumero(::cIed), 14))                                                              //   Nota 1: No caso de NFC-e informar indIEDest=9 e n�o informar a tag IE do destinat�rio; 
             Endif                                                                                                               //   Nota 2: No caso de opera��o com o Exterior informar indIEDest=9 e n�o informar a tag IE do destinat�rio;
                                                                                                                                 //   Nota 3: No caso de Contribuinte Isento de Inscri��o (indIEDest=2), n�o informar a tag IE do destinat�rio.
             If !Empty(::cEmaild)
                ::cXml+= XmlTag( "email" , Left(::cEmaild, 60))
             Endif    
      ::cXml+= "</dest>"
   Endif

   ::fCria_Retirada() 
   ::fCria_Entrega()
Return (Nil)

* ----------> Metodo para gerar a tag do // Contador Respons�vel <------------ *
METHOD fCria_Autxml() CLASS Malc_GeraXml   // Marcelo Brigatti
   If !Empty(::cAutxml)
      ::cXml+= '<autXML>'
         If Len(SoNumeroCnpj(::cAutxml)) < 14
            ::cXml+= XmlTag( "CPF"  , Left(SoNumero(::cAutxml), 11))
         Else
            ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cAutxml), 14))
         Endif 
      ::cXml+= '</autXML>'
   Endif 
Return (Nil)

* ----------> Metodo para gerar a tag do endere�o de retirada <--------------- *
METHOD fCria_Retirada() CLASS Malc_GeraXml                                                                                       // Marcelo Brigatti
   If Alltrim(::cXlgrd) # Alltrim(::cXlgrr)  // Informar somente se diferente do endere�o do remetente.                          // If !Empty(SoNumeroCnpj(::cCnpjr))  // Informar somente se diferente do endere�o do remetente.                                  
      ::cXml+= "<retirada>"
             If Len(SoNumeroCnpj(::cCnpjr)) < 14                                                                                 // Pessoa F�sica - Cpf
                ::cXml+= XmlTag( "CPF"  , Left(SoNumeroCnpj(::cCnpjr), 11))
             Else                                                                                                                // Pessoa Juridica
                ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpjr), 14))
             Endif 

             ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomer), 60))                                                      // Raz�o Social retirada

             If !Empty(::cXfantr)
                ::cXml+= XmlTag( "xFant" , Left(fRetiraAcento(::cXfantr), 60))                                                   // Nome Fantasia retirada
             Endif 

             ::cXml+= XmlTag( "xLgr"    , Left(fRetiraAcento(::cXlgrr), 60))                                                     // Endere�o retirada
             ::cXml+= XmlTag( "nro"     , Left(::cNror, 60))                                                                     // N�mero do Endere�o do retirada

             If !Empty(::cXcplr)
                ::cXml+= XmlTag( "xCpl" , Left(fRetiraAcento(::cXcplr), 60))
             Endif 

             ::cXml+= XmlTag( "xBairro" , Left(fRetiraAcento(::cXBairror), 60))                                                  // Bairro do retirada
             ::cXml+= XmlTag( "cMun"    , Left(SoNumero(::cMunfg), 7))                                                           // C�digo IBGE do retirada
             ::cXml+= XmlTag( "xMun"    , Left(fRetiraAcento(::cXmunr), 60))                                                     // Cidade do retirada
             ::cXml+= XmlTag( "UF"      , Left(::cUfE, 2))                                                                       // UF do retirada
	         ::cXml+= XmlTag( "CEP"     , Left(SoNumero(::cCepr), 8))                                                            // CEP do retirada
	         ::cXml+= XmlTag( "cPais"   , Left(::cPaisr, 4))                                                                     // C�digo do Pa�s retirada
	         ::cXml+= XmlTag( "xPais"   , Left(fRetiraAcento(::cXpaisr), 60))                                                    // Pa�s retirada da NF

             If !Empty(SoNumero(::cFoner))
	            ::cXml+= XmlTag( "fone"    , Left(SoNumero(::cFoner), 14))                                                       // Telefone do retirada
             Endif 

             If !Empty(::cEmailr)
                ::cXml+= XmlTag( "email" , Left(::cEmailr, 60))
             Endif    

             ::cXml+= XmlTag( "IE" , Left(SoNumero(::cIer), 14))
      ::cXml+= "</retirada>"
   Endif 
Return (Nil)
                 
* -----------> Metodo para gerar a tag do endere�o de entrega <--------------- *
METHOD fCria_Entrega() CLASS Malc_GeraXml                                                                                        // Marcelo Brigatti
   If Alltrim(::cXlgrd) # Alltrim(::cXlgrg)  // Informar somente se diferente do endere�o destinat�rio.                          // If !Empty(SoNumeroCnpj(::cCnpjg))  // Informar somente se diferente do endere�o destinat�rio.                                 // If Alltrim(::cXlgrd) # Alltrim(::cXlgrg)  // Informar somente se diferente do endere�o destinat�rio.
      ::cXml+= "<entrega>"
             If Len(SoNumeroCnpj(::cCnpjg)) < 14                                                                                 // Pessoa F�sica - Cpf
                ::cXml+= XmlTag( "CPF"  , Left(SoNumeroCnpj(::cCnpjg), 11))
             Else                                                                                                                // Pessoa Juridica
                ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpjg), 14))
             Endif 

             ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomeg), 60))                                                      // Raz�o Social entrega

             If !Empty(::cXfantg)
                ::cXml+= XmlTag( "xFant" , Left(fRetiraAcento(::cXfantg), 60))                                                   // Nome Fantasia entrega
             Endif 

             ::cXml+= XmlTag( "xLgr"    , Left(fRetiraAcento(::cXlgrg), 60))                                                     // Endere�o entrega
             ::cXml+= XmlTag( "nro"     , Left(::cNrog, 60))                                                                     // N�mero do Endere�o do entrega

             If !Empty(::cXcplg)
                ::cXml+= XmlTag( "xCpl" , Left(fRetiraAcento(::cXcplg), 60))
             Endif 

             ::cXml+= XmlTag( "xBairro" , Left(fRetiraAcento(::cXBairrog), 60))                                                  // Bairro do entrega
             ::cXml+= XmlTag( "cMun"    , Left(SoNumero(::cMunfg), 7))                                                           // C�digo IBGE do entrega
             ::cXml+= XmlTag( "xMun"    , Left(fRetiraAcento(::cXmung), 60))                                                     // Cidade do entrega
	         ::cXml+= XmlTag( "UF"      , Left(::cUfg, 2))                                                                       // UF do entrega
    	     ::cXml+= XmlTag( "CEP"     , Left(SoNumero(::cCepg), 8))                                                            // CEP do entrega
	         ::cXml+= XmlTag( "cPais"   , Left(::cPaisg, 4))                                                                     // C�digo do Pa�s entrega
	         ::cXml+= XmlTag( "xPais"   , Left(fRetiraAcento(::cXpaisg), 60))                                                    // Pa�s entrega da NF

             If !Empty(SoNumero(::cFoneg))
	            ::cXml+= XmlTag( "fone"    , Left(SoNumero(::cFoneg), 14))                                                       // Telefone do entrega
             Endif 

             If !Empty(::cEmailg)
                ::cXml+= XmlTag( "email" , Left(::cEmailg, 60))
             Endif    

             ::cXml+= XmlTag( "IE" , Left(SoNumero(::cIeg), 14))
      ::cXml+= "</entrega>"
   Endif 
Return (Nil)
   
* ---------------> Metodo para gerar a tag dos itens da NFE <----------------- *
METHOD fCria_Produto() CLASS Malc_GeraXml
   ::cXml+= [<det nItem="] + Left(NumberXml( ::nItem, 0 ), 3) + [">]
          ::cXml+= "<prod>"
                 ::cXml+= XmlTag( "cProd"    , Left(::cProd, 60))

		 If !Empty(::cEan)
                    ::cXml+= XmlTag( "cEAN"  , Left(::cEan, 14))
                 Else
                    ::cXml+= XmlTag( "cEAN"  , [SEM GTIN])
                 Endif 

                 If ::cAmbiente == [2] .and. ::cModelo == [65] .and. ::nItem == 1
                    ::cXml+= XmlTag( "xProd" , [NOTA FISCAL EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL])
                 Else
                    ::cXml+= XmlTag( "xProd" , Left(fRetiraAcento(::cXprod), 120))
                 Endif 

                 ::cXml+= XmlTag( "NCM"      , Iif(Empty(::cNcm), [00], Left(::cNcm, 8)))                                        // Obrigat�ria informa��o do NCM completo (8 d�gitos). Nota: Em caso de item de servi�o ou item que n�o tenham produto (ex. transfer�ncia de cr�dito, cr�dito do ativo imobilizado, etc.), informar o valor 00 (dois zeros). (NT 2014/004)

        	 If Len(::cNcm) > 8
        	    ::cXml+= XmlTag( "EXTIPI" , [0] + Right(::cNcm, 2))                                                              // Excess�o de IPI 
        	 Endif    

                 If !Empty(::cCest)
                    ::cXml+= XmlTag( "CEST"  , Left(SoNumero(::cCest), 7))
                 Endif 

                 ::cXml+= XmlTag( "CFOP"     , Left(SoNumero(::cCfOp), 4))
                 ::cXml+= XmlTag( "uCom"     , Left(::cUcom, 6))
                 ::cXml+= XmlTag( "qCom"     , ::nQcom, 4)
                 ::cXml+= XmlTag( "vUnCom"   , ::nVuncom, 10)
                 ::cXml+= XmlTag( "vProd"    , ::nVprod)

		         If !Empty(::cEantrib)
                    ::cXml+= XmlTag( "cEANTrib" , Left(::cEantrib, 14))
                 Else
                    ::cXml+= XmlTag( "cEANTrib" , [SEM GTIN])
                 Endif 

                 ::cXml+= XmlTag( "uTrib"    , Left(::cUcom, 6))
                 ::cXml+= XmlTag( "qTrib"    , ::nQcom, 4)
                 ::cXml+= XmlTag( "vUnTrib"  , ::nVuncom, 10)

                 If !Empty(::nVfrete)
                    ::cXml+= XmlTag( "vFrete", ::nVfrete)
                 Endif 

                 If !Empty(::nVseg)
                    ::cXml+= XmlTag( "vSeg"  , ::nVseg)
                 Endif 

                 If !Empty(::nVdesc)
                    ::cXml+= XmlTag( "vDesc" , ::nVdesc)
                 Endif 

                 If !Empty(::nVoutro)
                    ::cXml+= XmlTag( "vOutro" , ::nVoutro)
                 Endif 
 
                 ::cXml+= XmlTag( "indTot", Iif(!(::cIndtot $ [0_1]), [0], Left(::cIndtot, 1)))                                  // Indica se valor do Item (vProd) entra no valor total da NF-e (vProd). 0=Valor do item (vProd) n�o comp�e o valor total da NF-e 1=Valor do item (vProd) comp�e o valor total da NF-e (vProd) (v2.0)

                 If !Empty(::cXped)                                                                                              // Marcelo Brigatti 
                    ::cXml+= XmlTag( "xPed"      , Left(::cXped, 15))                                                            // n�mero do pedido de compra
                    ::cXml+= XmlTag( "nItemPed"  , SoNumero(::nNitemped), 6)                                                     // n�mero do �tem do pedido de compra 
                 Endif   

                 If !Empty(::cNfci)                
                    ::cXml+= XmlTag( "nFCI"      , Left(::cNfci, 36))                                                            // Informa��o relacionada com a Resolu��o 13/2012 do Senado Federal. Formato: Algarismos, letras mai�sculas de "A" a "F" e o caractere h�fen. Exemplo: B01F70AF-10BF-4B1F-848C-65FF57F616FE
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
                    ::cXml+= XmlTag("vTotTrib", ::nVtottrib)
                 Endif 

                 ::fCria_ProdutoIcms()
                 ::fCria_ProdutoIpi() 
                 ::fCria_ProdutoII()
                 ::fCria_ProdutoPisCofins()
                 ::fCria_ProdutoIs()
                 ::fCria_ProdutoIbscbs()
          ::cXml+= "</imposto>"

          If Len(AllTrim(::cInfadprod)) > 0
             ::cXml+= XmlTag( "infAdProd", Left( ::cInfadprod, 500))
          Else
             If ::lVtottrib == .T. .And. ::nVtottrib # 0                                                                         // lei transpar�ncia informa��es adicionais do produtos
                ::cXml+= XmlTag( "infAdProd", Left(Iif(::nVtottrib > 0, [Valor aproximado dos tributos federais, estaduais e municipais: R$ ] + NumberXml(::nVtottrib, 2) + [ Fonte IBPT. ], []) + ::cInfadprod , 500))
             Endif 
          Endif                   
   ::cXml+= "</det>"
Return (Nil)

* ----------------> Metodo para gerar a tag de veicProd <----------------- *
METHOD fCria_ProdVeiculo() CLASS Malc_GeraXml  // Grupo JA. Detalhamento Espec�fico de Ve�culos novos                                                                               
   If !Empty(::cChassi)
      ::cXml+= "<veicProd>"
             ::cXml+= XmlTag( "tpOp"         , Iif(!(::cTpOp $ [0_1_2_3]), [0], Left(::cTpOp, 1)))                                                              // 1=Venda concession�ria, 2=Faturamento direto para consumidor final 3=Venda direta para grandes consumidores (frotista, governo, ...) 0=Outros
             ::cXml+= XmlTag( "chassi"       , Left(Sonumero(::cChassi), 17))                                                                                   // Chassi do ve�culo - VIN (c�digo-identifica��o-ve�culo)
             ::cXml+= XmlTag( "cCor"         , Left(::cCor, 4))                                                                                                 // Cor - C�digo de cada montadora
             ::cXml+= XmlTag( "xCor"         , Left(::cXcor, 40))                                                                                               // Descri��o da Cor 
             ::cXml+= XmlTag( "pot"          , Left(::cPot, 4))                                                                                                 // Pot�ncia Motor (CV)             
             ::cXml+= XmlTag( "cilin"        , Left(::cCilin, 9))                                                                                               // Pot�ncia m�xima do motor do ve�culo em cavalo vapor (CV). (pot�ncia-ve�culo)
             ::cXml+= XmlTag( "pesoL"        , ::nPesolvei, 4)                                                                                                  // Em toneladas - 4 casas decimais                                                     
             ::cXml+= XmlTag( "pesoB"        , ::nPesobvei, 4)                                                                                                  // Peso Bruto Total - em tonelada - 4 casas decimais
             ::cXml+= XmlTag( "nSerie"       , Left(::cNserie, 9))                                                                                              // Serial (s�rie)
             ::cXml+= XmlTag( "tpComb"       , Iif(!(::cTpcomb $ [01_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17_18]), [01], Left(::cTpcomb, 2)))           // Utilizar Tabela RENAVAM (v2.0) 01 - �lcool, 02 - Gasolina, 03 - Diesel, 04 - Gasog�nio, 05 - G�s Metano, 06 - El�trico/Fonte Interna, 07 - El�trico/Fonte Externa, 08 - Gasolina/G�s Natural Combust�vel, 09 - �lcool/G�s Natural Combust�vel, 10 - Diesel/G�s Natural Combust�vel, 11 - Vide/Campo/Observa��o, 12 - �lcool/G�s Natural Veicular, 13 - Gasolina/G�s Natural Veicular, 14 - Diesel/G�s Natural Veicular, 15 - G�s Natural Veicular, 16 - �lcool/Gasolina, 17 - Gasolina/�lcool/G�s Natural Veicular, 18 - Gasolina/el�trico                                                    
             ::cXml+= XmlTag( "nMotor"       , Left(::cNmotor, 21))                                                                                             // N�mero de Motor
             ::cXml+= XmlTag( "CMT"          , ::nCmt, 4)                                                                                                       // CMT - Capacidade M�xima de Tra��o - em Toneladas 4 casas decimais (v2.0)
             ::cXml+= XmlTag( "dist"         , Left(::cDist, 4))                                                                                                // Dist�ncia entre eixos
             ::cXml+= XmlTag( "anoMod"       , Left(::cAnomod, 4))                                                                                              // Ano Modelo de Fabrica��o
             ::cXml+= XmlTag( "anoFab"       , Left(::cAnofab, 4))                                                                                              // Ano de Fabrica��o
             ::cXml+= XmlTag( "tpVeic"       , Iif(!(::cTpveic $ [02_03_04_05_06_07_08_10_11_13_14_17_18_19_20_21_22_23_24_25_26]), [02], Left(::cTpveic, 2)))  // Utilizar Tabela RENAVAM, conforme exemplos abaixo: 02=CICLOMOTO; 03=MOTONETA; 04=MOTOCICLO; 05=TRICICLO; 06=AUTOM�VEL; 07=MICRO-�NIBUS; 08=�NIBUS; 10=REBOQUE; 11=SEMIRREBOQUE; 13=CAMIONETA; 14=CAMINH�O; 17=CAMINH�O TRATOR; 18=TRATOR RODAS; 19=TRATOR ESTEIRAS; 20=TRATOR MISTO; 21=QUADRICICLO; 22=ESP / �NIBUS; 23=CAMINHONETE; 24=CARGA/CAM; 25=UTILIT�RIO; 26=MOTOR-CASA
             ::cXml+= XmlTag( "espVeic"      , Iif(!(::cEspveic $ [1_2_3_4_5_6]), [1], Left(::cEspveic, 1)))                                                    // Utilizar Tabela RENAVAM 1=PASSAGEIRO; 2=CARGA; 3=MISTO;4=CORRIDA; 5=TRA��O; 6=ESPECIAL;
             ::cXml+= XmlTag( "VIN"          , Iif(!(::cVin $ [N_R]), [N], Left(::cVin, 1)))                                                                    // Condi��o do VIN Informa-se o ve�culo tem VIN (chassi) remarcado. R=Remarcado; N=Normal
             ::cXml+= XmlTag( "condVeic"     , Iif(!(::cCondveic $ [1_2_3]), [1], Left(::cCondveic, 1)))                                                        // Condi��o do Ve�culo 1=Acabado; 2=Inacabado; 3=Semiacabado
             ::cXml+= XmlTag( "cMod"         , Left(::cCmod, 6))                                                                                                // C�digo Marca Modelo                                                  
             ::cXml+= XmlTag( "cCorDENATRAN" , Iif(!(::cCordenatran $ [01_02_03_04_05_06_07_08_09_10_11_13_14_15_16]), [01], Left(::cCorDENATRAN, 2)))          // Segundo as regras de pr�-cadastro do DENATRAN (v2.0) 01=AMARELO, 02=AZUL, 03=BEGE,04=BRANCA, 05=CINZA, 06=-DOURADA,07=GREN�, 08=LARANJA, 09=MARROM,10=PRATA, 11=PRETA, 12=ROSA, 13=ROXA,14=VERDE, 15=VERMELHA, 16=FANTASIA
             ::cXml+= XmlTag( "lota"         , Left(::cLota, 3))                                                                                                // Quantidade m�xima permitida de passageiros sentados, inclusive o motorista. (v2.0)
             ::cXml+= XmlTag( "tpRest"       , Iif(!(::cTprest $ [0_1_2_3_4_9]), [0], Left(::cTprest, 1)))                                                      // Restri��o 0=N�o h�; 1=Aliena��o Fiduci�ria; 2=Arrendamento Mercantil; 3=Reserva de Dom�nio; 4=Penhor de Ve�culos; 9=Outras. (v2.0)
      ::cXml+= "</veicProd>"
   Endif 
Return (Nil)

* ----------------> Metodo para gerar a Tag arma <---------------------------- *
METHOD fCria_ProdArmamento() CLASS Malc_GeraXml  // Tag arma - Grupo L. Detalhamento Espec�fico de Armamentos
   Local cTexto:= cTexto1:= [], nPosIni, nPosFim

   If !Empty(::cNserie_a)
      If [<det nItem="] + Left(NumberXml( ::nItem, 0 ), 3) + [">] $ ::cXml
         cTexto:= fRemoveDet(::cXml, ::nItem)

         cTexto1+= "<arma>"
                cTexto1+= XmlTag( "tpArma" , Iif(!(::cTparma $ [0_1]), [0], Left(::cTparma, 1)))                                 // Indicador do tipo de arma de fogo 0=Uso permitido; 1=Uso restrito
                cTexto1+= XmlTag( "nSerie" , Left(::cNserie_a, 15))                                                              // N�mero de s�rie da arma
                cTexto1+= XmlTag( "nCano"  , Left(::cNcano, 15))                                                                 // N�mero de s�rie do cano
                cTexto1+= XmlTag( "descr"  , Left(fRetiraAcento(::cDescr_a), 256))                                               // Descri��o completa da arma, compreendendo: calibre, marca, capacidade, tipo de funcionamento, comprimento e demais elementos que permitam a sua perfeita identifica��o.
         cTexto1+= "</arma>"

         cTexto := StrTran(cTexto, "</prod>", cTexto1 + "</prod>")
         nPosIni:= Hb_At([<det nItem="] + Left(NumberXml( ::nItem, 0 ), 3) + [">] , ::cXml)
         nPosFim:= Hb_At("</det>", ::cXml, nPosIni) + 6
         ::cXml := Substr(::cXml, 1, nPosIni - 1) + cTexto + Substr(::cXml, nPosFim)
      Endif 
   Endif 

   Release cTexto, cTexto1, nPosIni, nPosFim
Return (Nil)

* ---------------------> Fun��o para remover tag de Detalhe <------------------ *
Static Function fRemoveDet(cTxtXml, nItem)
   Local nPosIni, nPosFim

   nPosIni := Hb_At([<det nItem="] + Left(NumberXml( nItem, 0 ), 3) + [">] , cTxtXml)
   nPosFim := Hb_At("</indTot>", cTxtXml, nPosIni) + 9
   cTxtXml := Substr(cTxtXml, nPosIni, nPosFim)

   Release nPosIni, nPosFim
Return (cTxtXml)

* ----------------> Metodo para gerar a tag de Detalhe Medicam. <------------- *
METHOD fCria_ProdMedicamento() CLASS Malc_GeraXml // Grupo K. Detalhamento Espec�fico de Medicamento e de mat�rias-primas farmac�uticas
   If !Empty(::nVpmc)
      ::cXml+= "<med>"
             ::cXml+= XmlTag( "cProdANVISA"       , Left(::cProdanvisa, 13))                                                     // C�digo de Produto da ANVISA - Utilizar o n�mero do registro ANVISA ou preencher com o literal �ISENTO�, no caso de medicamento isento de registro na ANVISA. (Inclu�do na NT2016.002. Atualizado na NT 2018.005)

             If !Empty(::cXmotivoisencao)
                ::cXml+= XmlTag( "xMotivoIsencao" , Left(::cXmotivoisencao, 255))                                                // Motivo da isen��o da ANVISA - Obs.: Para medicamento isento de registro na ANVISA, informar o n�mero da decis�o que o isenta, como por exemplo o n�mero da Resolu��o da Diretoria Colegiada da ANVISA (RDC). (Criado na NT 2018.005) 
             Endif 

             ::cXml+= XmlTag( "vPMC"              , ::nVpmc)                                                                     // Pre�o m�ximo consumidor
      ::cXml+= "</med>"
   Endif 
Return (Nil)

* ----------------> Metodo para gerar a tag de combust�veis <----------------- *
METHOD fCria_ProdCombustivel() CLASS Malc_GeraXml                                                                                // Marcelo de Paula, Marcelo Brigatti
   Local cGrupoANP:= [1662,2662,5651,5652,5653,5654,5655,5656,5657,5658,5659,5660,5661,5662,5663,5664,5665,5666,5667,6651,6652,6653,6654,6655,6656,6657,6658,6659,6660,6661,6662,6663,6664,6665,6666,6667,7651,7654,7667]

   // N�mero ANP para combust�veis
   If ::cCfOp $ cGrupoANP
      ::cXml+= "<comb>"
             ::cXml+= XmlTag( "cProdANP" , Left(Sonumero(::cCprodanp), 9))                                                       // C�digo de produto da ANP
             ::cXml+= XmlTag( "descANP"  , Left(::cDescanp, 95))                                                                 // Descri��o do produto conforme ANP
             If ::nQtemp > 0
                ::cXml+= XmlTag( "qTemp" , ::nQtemp, 4)                                                                          // Quantidade de combust�vel faturada � temperatura ambiente.
             EndIf   
             ::cXml+= XmlTag( "UFCons"   , Left(::cUfd, 2))

             If ::nQbcprod  > 0
                    ::cXml+= "<CIDE>"
                           ::cXml+= XmlTag( "qBCProd"    , ::nQbcprod, 4)                                                        // Informar a BC da CIDE em quantidade
                           ::cXml+= XmlTag( "vAliqProd"  , ::nValiqprod, 4)                                                      // Informar o valor da al�quota em reais da CIDE
                           ::cXml+= XmlTag( "vCIDE"      , ::nVcide)                                                             // Informar o valor da CIDE
                    ::cXml+= "</CIDE>"
             Endif 
      ::cXml+= "</comb>"
   Endif 
Return (Nil)

* --------------------> Metodo para gerar a tag do ICMS <--------------------- *
METHOD fCria_ProdutoIcms() CLASS Malc_GeraXml
   ::cXml+= "<ICMS>"                                                                                                             // BLOCO N - ICMS NORMAL E ST
          Do Case
             Case ::cCsticms == [000]
                  ::cXml+= "<ICMS00>"
                         ::cXml+= XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"   , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBC" , [3] )                                                                        // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                         ::cXml+= XmlTag( "vBC"   , ::nVbc)
                         ::cXml+= XmlTag( "pICMS" , ::nPicms, 4)
                         ::cXml+= XmlTag( "vICMS" , ::nVlicms)
                   ::cXml+= "</ICMS00>"
             Case ::cCsticms == [010]
                   ::cXml+= "<ICMS10>"
                         ::cXml+= XmlTag( "orig"    , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"     , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBC"   , Iif(!(Hb_Ntos(::nModbc) $ [0_1_2_3]), [0], Left(::nModbc, 1)), 0)          // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                         ::cXml+= XmlTag( "vBC"     , ::nVbc)
                         ::cXml+= XmlTag( "pICMS"   , ::nPicms, 4)
                         ::cXml+= XmlTag( "vICMS"   , ::nVlicms)
                         ::cXml+= XmlTag( "modBCST" , Iif(!(Hb_Ntos(::nModbcst) $ [0_1_2_3_4_5_6]), [3], Left(::nModbcst, 1)), 0) // Modalidade de determina��o da BC do ICMS ST. 0=Pre�o tabelado ou m�ximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor), 6 = Valor da Opera��o (NT 2019.001)
                         ::cXml+= XmlTag( "pMVAST"  , ::nPmvast, 4)
                         ::cXml+= XmlTag( "vBCST"   , ::nVbcst)
                         ::cXml+= XmlTag( "pICMSST" , ::nPicmst, 4)
                         ::cXml+= XmlTag( "vICMSST" , ::nVicmsst)
                   ::cXml+= "</ICMS10>"
             Case ::cCsticms == [020]
                   ::cXml+= "<ICMS20>"
                         ::cXml+= XmlTag( "orig"   , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"    , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBC"  , [3] )                                                                       // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                         ::cXml+= XmlTag( "pRedBC" , ::nPredbc, 4)
                         ::cXml+= XmlTag( "vBC"    , ::nVbc)
                         ::cXml+= XmlTag( "pICMS"  , ::nPicms, 4)
                         ::cXml+= XmlTag( "vICMS"  , ::nVlicms)
                   ::cXml+= "</ICMS20>"
             Case ::cCsticms == [030]
                   ::cXml+= "<ICMS30>"
                         ::cXml+= XmlTag( "orig"     , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"      , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBCST"  , "3" )                                                                     // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                         ::cXml+= XmlTag( "pMVAST"   , ::nPmvast, 4)
                         ::cXml+= XmlTag( "pRedBCST" , ::nPredbcst, 4)
                         ::cXml+= XmlTag( "vBCST"    , ::nVbc)
                         ::cXml+= XmlTag( "pICMSST"  , ::nPicmst, 4)
                         ::cXml+= XmlTag( "vICMSST"  , ::nVlicms)
                   ::cXml+= "</ICMS30>"
             Case ::cCsticms $ [040_041_050_141_241_140_240]
                   ::cXml+= "<ICMS40>"
                         ::cXml+= XmlTag( "orig" , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"  , SubStr(::cCsticms, 2, 2))
                   ::cXml+= "</ICMS40>"
             Case ::cCsticms == [051]
                   ::cXml+= "<ICMS51>"
                         ::cXml+= XmlTag( "orig" , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"  , SubStr(::cCsticms, 2, 2))
                   ::cXml+= "</ICMS51>"
             Case ::cCsticms == [060]
                   ::cXml+= "<ICMS60>"
                         ::cXml+= XmlTag( "orig"           , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"            , "60")
                         ::cXml+= XmlTag( "vBCSTRet"       , 0)
                         ::cXml+= XmlTag( "pST"            , 0, 4)
                         ::cXml+= XmlTag( "vICMSSubstituto", 0)
                         ::cXml+= XmlTag( "vICMSSTRet"     , 0)
                   ::cXml+= "</ICMS60>"
             Case ::cCsticms == [070]
                   ::cXml+= "<ICMS70>"
                         ::cXml+= XmlTag( "orig"    , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"     , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBCST" , "3" )                                                                      // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                         ::cXml+= XmlTag( "pRedBC"  , ::nPredbc, 4)
                         ::cXml+= XmlTag( "vBC"     , ::nVbc)
                         ::cXml+= XmlTag( "pICMS"   , ::nPicms, 4)
                         ::cXml+= XmlTag( "vICMS"   , ::nVlicms)
                         ::cXml+= XmlTag( "modBCST" , "0")
                         ::cXml+= XmlTag( "pMVAST"  , ::nPmvast, 4)
                         ::cXml+= XmlTag( "vBCST"   , ::nVbcst)
                         ::cXml+= XmlTag( "pICMSST" , ::nPicmst, 4)
                         ::cXml+= XmlTag( "vICMSST" , ::nVicmsst)
                         ::cXml+= XmlTag( "pBCOp"   , 1, 4)
                         ::cXml+= XmlTag( "UFST"    , Left(::cUfd, 2))
                   ::cXml+= "</ICMS70>"
             Case ::cCsticms == [090]
                   ::cXml+= "<ICMS90>"
                         ::cXml+= XmlTag( "orig"    , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"     , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBCST" , "3" )                                                                      // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                         ::cXml+= XmlTag( "pRedBC"  , ::nPredbc, 4)
                         ::cXml+= XmlTag( "vBC"     , ::nVbc)
                         ::cXml+= XmlTag( "pICMS"   , ::nPicms, 4)
                         ::cXml+= XmlTag( "vICMS"   , ::nVlicms)
                   ::cXml+= "</ICMS90>"
             Case ::cCsticms == [101]
                   ::cXml+= "<ICMSSN101>"
                         ::cXml+= XmlTag( "orig"        , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CSOSN"       , ::cCsticms)
                         ::cXml+= XmlTag( "pCredSN"     , ::nPcredsn, 4)
                         ::cXml+= XmlTag( "vCredICMSSN" , ::nVcredicmssn, 4)
                   ::cXml+= "</ICMSSN101>"
             Case ::cCsticms $ [102_103_300_400]
                   ::cXml+= "<ICMSSN102>"
                         ::cXml+= XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CSOSN" , ::cCsticms)
                   ::cXml+= "</ICMSSN102>"
             Case ::cCsticms == [201]
                   ::cXml+= "<ICMSSN201>"
                         ::cXml+= XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CSOSN" , ::cCsticms)
                   ::cXml+= "</ICMSSN201>"
             Case ::cCsticms $ [202_203]
                   ::cXml+= "<ICMSSN202>"
                         ::cXml+= XmlTag( "orig"  , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CSOSN" , ::cCsticms)
                   ::cXml+= "</ICMSSN202>"
             Case ::cCsticms == [500]
                   ::cXml+= "<ICMSSN500>"
                         ::cXml+= XmlTag( "orig"           , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CSOSN"          , ::cCsticms)
                         ::cXml+= XmlTag( "vBCSTRet"       , 0)
                         ::cXml+= XmlTag( "pST"            , 0, 4)
                         ::cXml+= XmlTag( "vICMSSubstituto", 0)
                         ::cXml+= XmlTag( "vICMSSTRet"     , 0)
                         ::cXml+= XmlTag( "pRedBCEfet"     , 0, 4)
                         ::cXml+= XmlTag( "vBCEfet"        , 0)
                         ::cXml+= XmlTag( "pICMSEfet"      , 0, 4)
                         ::cXml+= XmlTag( "vICMSEfet"      , 0)
                    ::cXml+= "</ICMSSN500>"
             Case ::cCsticms == [900]
                   ::cXml+= "<ICMSSN900>"
                         ::cXml+= XmlTag( "orig"           , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CSOSN"          , Left(::cCsticms, 3))
                        
                         // Verifica se tem valor do ICMS
                         If ::nVlicms # 0
                            ::cXml+= XmlTag( "modBC"       , Iif(!(Hb_Ntos(::nModbc) $ [0_1_2_3]), [0], Left(::nModbc, 1)), 0)   // Modalidade de determina��o da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Pre�o Tabelado M�x. (valor); 3=Valor da opera��o.
                            ::cXml+= XmlTag( "vBC"         , ::nVbc)
                            ::cXml+= XmlTag( "pICMS"       , ::nPicms, 4)
                            ::cXml+= XmlTag( "vICMS"       , ::nVlicms)
                            ::cXml+= XmlTag( "modBCST"     , Iif(!(::nModbcst $ [0_1_2_3_4_5_6]), [3], Left(::nModbcst, 1)), 0)  // Modalidade de determina��o da BC do ICMS ST. 0=Pre�o tabelado ou m�ximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor), 6 = Valor da Opera��o (NT 2019.001)
                            ::cXml+= XmlTag( "vBCST"       , ::nVbcst)
                            ::cXml+= XmlTag( "pICMSST"     , ::nPicmst, 4)
                            ::cXml+= XmlTag( "vICMSST"     , ::nVicmsst)
                            ::cXml+= XmlTag( "pCredSN"     , ::nPcredsn, 4)
                            ::cXml+= XmlTag( "vCredICMSSN" , ::nVcredicmssn, 4)
                         Endif 
                   ::cXml+= "</ICMSSN900>"
          Endcase
   ::cXml+= "</ICMS>"
Return (Nil)

* --------------------> Metodo para gerar a tag do ICMS NA <------------------ *
METHOD fCria_ProdutoIcms_Na() CLASS Malc_GeraXml  //Grupo NA. ICMS para a UF de destino
   If !Empty(::nVbcufdest)
      ::cXml+= "<ICMSUFDest>"
             ::cXml+= XmlTag( "vBCUFDest"      , ::nVbcufdest)                                                                   // Valor da BC do ICMS na UF de destino
             ::cXml+= XmlTag( "vBCFCPUFDest"   , ::nVbcfcpufdest)                                                                // Valor da Base de C�lculo do FCP na UF de destino. (Inclu�do na NT2016.002)
             ::cXml+= XmlTag( "pFCPUFDest"     , ::nPfcpufdest, 4)                                                               // Percentual adicional inserido na al�quota interna da UF de destino, relativo ao Fundo de Combate � Pobreza (FCP) naquela UF
             ::cXml+= XmlTag( "pICMSUFDest"    , ::nPicmsufdest, 4)                                                              // Al�quota adotada nas opera��es internas na UF de destino para o produto / mercadoria. A al�quota do Fundo de Combate a Pobreza, se existente para o produto / mercadoria, deve ser informada no campo pr�prio (pFCPUFDest) n�o devendo ser somada � essa al�quota interna.
             ::cXml+= XmlTag( "pICMSInter"     , ::nPicmsinter)                                                                  // Al�quota interestadual das UF envolvidas: - 4% al�quota interestadual para produtos importados; - 7% para os Estados de origem do Sul e Sudeste (exceto ES), destinado para os Estados do Norte, Nordeste, Centro- Oeste e Esp�rito Santo; - 12% para os demais casos.
             ::cXml+= XmlTag( "pICMSInterPart" , ::nPicmsinterpart, 4)                                                           // Percentual de ICMS Interestadual para a UF de destino: - 40% em 2016; - 60% em 2017; - 80% em 2018; - 100% a partir de 2019.
             ::cXml+= XmlTag( "vFCPUFDest"     , ::nVfcpufdest)                                                                  // Valor do ICMS relativo ao Fundo de Combate � Pobreza (FCP) da UF de destino. (Atualizado na NT2016.002)
             ::cXml+= XmlTag( "vICMSUFDest"    , ::nVicmsufdest)                                                                 // Valor do ICMS Interestadual para a UF de destino, j� considerando o valor do ICMS relativo ao Fundo de Combate � Pobreza naquela UF.
             ::cXml+= XmlTag( "vICMSUFRemet"   , ::nVicmsufremet)                                                                // Valor do ICMS Interestadual para a UF do remetente. Nota: A partir de 2019, este valor ser� zero.
      ::cXml+= "</ICMSUFDest>"
   Endif 
Return (Nil)

* --------------------> Metodo para gerar a tag do IPI <---------------------- *
METHOD fCria_ProdutoIpi() CLASS Malc_GeraXml
   If ::nVipi > 0 .or. !Empty(::cCstipint)
      ::cXml+= "<IPI>"
             ::cXml+= XmlTag( "cEnq" , Left(::cCEnq, 3))

             If ::cCstipi $ [00_49_50_99]
                ::cXml+= "<IPITrib>"                                                                                             // Grupo do CST 00, 49, 50 e 99
                       ::cXml+= XmlTag( "CST"  , Iif(!(::cCstipi $ [00_49_50_99]), [00], Left(::cCstipi, 2)))                    // C�digo da situa��o tribut�ria do IPI 00=Entrada com recupera��o de cr�dito 49=Outras entradas 50=Sa�da tributada 99=Outras sa�das
                       ::cXml+= XmlTag( "vBC"  , ::nVbcipi)
                       ::cXml+= XmlTag( "pIPI" , ::nPipi, 4)
                       ::cXml+= XmlTag( "vIPI" , ::nVipi)
                ::cXml+= "</IPITrib>"
             Endif 

             If ::cCstipint $ [01_02_03_04_51_52_53_54_55]
                ::cXml+= "<IPINT>"
                       ::cXml+= XmlTag( "CST"  , Iif(!(::cCstipint $ [01_02_03_04_05_51_52_53_54_55]), [01], Left(::cCstipint, 2))) // C�digo da situa��o tribut�ria do IPI 01=Entrada tributada com al�quota zero 02=Entrada isenta 03=Entrada n�o-tributada 04=Entrada imune 05=Entrada com suspens�o 51=Sa�da tributada com al�quota zero 52=Sa�da isenta 53=Sa�da n�o-tributada 54=Sa�da imune 55=Sa�da com suspens�o
                ::cXml+= "</IPINT>"
             Endif 
      ::cXml+= "</IPI>"   
   Endif 
Return (Nil)

* ------------------> Metodo para gerar a tag IS = Imposto Seletivo <--------- *
METHOD fCria_ProdutoIs() CLASS Malc_GeraXml                                                                                      // Reforma tribut�ria
   If !Empty(::cClasstribis)
      ::cXml+= "<IS>"
             ::cXml+= XmlTag( "CSTIS"        , Left(::cClasstribis, 3))                                                          // Utilizar tabela C�DIGO DE CLASSIFICA��O TRIBUT�RIA DO IMPOSTO SELETIVO
             ::cXml+= XmlTag( "cClassTribIS" , Left(::cClasstribis, 6))                                                          // Utilizar tabela C�DIGO DE CLASSIFICA��O TRIBUT�RIA DO IMPOSTO SELETIVO
             ::cXml+= XmlTag( "vBCIS"        , ::nVbcis)                                                                         // Valor da Base de C�lculo do Imposto Seletivo
             ::cXml+= XmlTag( "pIS"          , ::nPisis)                                                                         // Al�quota do Imposto Seletivo
             ::cXml+= XmlTag( "pISEspec"     , ::nPisespec, 4)                                                                   // Al�quota espec�fica por unidade de medida apropriada
             ::cXml+= XmlTag( "uTrib"        , Left(::cUtrib_is, 6))                                                             // Unidade de Medida Tribut�vel
             ::cXml+= XmlTag( "qTrib"        , ::nQtrib_is, 4)                                                                   // Quantidade Tribut�vel
             ::cXml+= XmlTag( "vIS"          , (::nVbcis * ::nQtrib_is) * (::nPisis / 100))                                      // Valor do Imposto Seletivo
      ::cXml+= "</IS>"
   Endif 
Return (Nil)

* ----------------------> Metodo para gerar a tag IBSCBS <-------------------- *
METHOD fCria_ProdutoIbscbs() CLASS Malc_GeraXml  // Reforma tribut�ria
   If !Empty(::cCclasstrib)
      ::cXml+= "<IBSCBS>"
             ::cXml+= XmlTag( "CST", Left(::cCclasstrib, 3))
             ::cXml+= XmlTag( "cClassTrib", Left(::cCclasstrib, 6))
                    ::cXml+= "<gIBSCBS>"
                              If ::nVbcibs == 0
                                  ::nVbcibs:= ::nVprodt + ::nVServs + ::nVFretet + ::nVSeg + ::nVOutrot + ::nVii - ::nDesct - ::nVpist - ::nVCofinst - ::nVicms - ::nVicmsufdest - ::nVfcp - ::nVfcpufdest - Round(::nMonoBas * ::nMonoAliq, 2) - ::nVissqn + ::nVisistot
                              Endif

                              ::cXml+= XmlTag( "vBC" , ::nVbcibs)
                                  ::cXml+= "<gIBSUF>"
                                         ::cXml+= XmlTag( "pIBSUF" , ::nPibsuf, 4)
                                                If ::nPdifgibuf # 0
                                                   ::cXml+= "<gDif>"
                                                          ::cXml+= XmlTag( "pDif" , ::nPdifgibuf, 4)
                                                          ::cXml+= XmlTag( "vDif" , ::nVbcibs * ::nPibsuf * (::nPdifgibuf / 100) )
                                                   ::cXml+= "</gDif>"
                                                Endif

                                                If ::nVdevtribgibuf # 0
                                                   ::cXml+= "<gDevTrib>"
                                                          ::cXml+= XmlTag( "vDevTrib" , ::nVdevtribgibuf)
                                                   ::cXml+= "</gDevTrib>"
                                                Endif

                                                If ::nPredaliqgibuf # 0
                                                   ::cXml+= "<gRed>"
                                                          ::cXml+= XmlTag( "pRedAliq"  , ::nPredaliqgibuf, 4)
                                                          ::cXml+= XmlTag( "pAliqEfet" , ::nPibsuf * (1 - ::nPredaliqgibuf), 4)
                                                   ::cXml+= "</gRed>"
                                                Endif
                                       
                                         ::cXml+= XmlTag( "vIBSUF" , Iif(::nVibsuf == 0, ::nVibsuf:= ::nVbcibs * ::nPibsuf, ::nVibsuf))
                                  ::cXml+= "</gIBSUF>"
                                  ::cXml+= "<gIBSMun>"
                                         ::cXml+= XmlTag( "pIBSMun" , ::nPibsmun, 4)
                                                If ::nPifgibsmun # 0
                                                   ::cXml+= "<gDif>"
                                                          ::cXml+= XmlTag( "pDif"   , ::nPifgibsmun, 4)
                                                          ::cXml+= XmlTag( "vDif"   , ::nVbcibs * (::nPibsmun / 100) * (::nPifgibsmun / 100) ) 
                                                   ::cXml+= "</gDif>"
                                                Endif

                                                If ::nVdevtribgibsmun # 0
                                                   ::cXml+= "<gDevTrib>"
                                                          ::cXml+= XmlTag( "vDevTrib"  , ::nVdevtribgibsmun)
                                                   ::cXml+= "</gDevTrib>"
                                                Endif

                                                If ::nPredaliqibsmun # 0
                                                   ::cXml+= "<gRed>"
                                                          ::cXml+= XmlTag( "pRedAliq"  , ::nPredaliqibsmun, 4)
                                                          ::cXml+= XmlTag( "pAliqEfet" , ::nPibsmun * (1 - ::nPredaliqibsmun), 4)
                                                   ::cXml+= "</gRed>"
                                                Endif

                                         ::cXml+= XmlTag( "vIBSMun" , Iif(::nVibsmun == 0, ::nVibsmun:= ::nVbcibs * ::nPibsmun, ::nVibsmun))
                                  ::cXml+= "</gIBSMun>"
                                  ::cXml+= "<gCBS>"
                                         ::cXml+= XmlTag( "pCBS" , ::nPcbs, 4)
                                                If ::nPpDifgcbs # 0
                                                   ::cXml+= "<gDif>"
                                                          ::cXml+= XmlTag( "pDif"   , ::nPpDifgcbs, 4)
                                                          ::cXml+= XmlTag( "vDif"   , ::nVbcibs * ::nPcbs * (::nPpDifgcbs / 100) )  
                                                   ::cXml+= "</gDif>"
                                                Endif

                                                If ::nVdevtribgcbs # 0
                                                   ::cXml+= "<gDevTrib>"
                                                          ::cXml+= XmlTag( "vDevTrib" , ::nVdevtribgcbs)
                                                   ::cXml+= "</gDevTrib>"
                                                Endif

                                                If ::nPredaliqgcbs # 0
                                                   ::cXml+= "<gRed>"
                                                          ::cXml+= XmlTag( "pRedAliq"  , ::nPredaliqgcbs, 4)
                                                          ::cXml+= XmlTag( "pAliqEfet" , ::nPcbs * (1 - ::nPredaliqgcbs), 4)
                                                   ::cXml+= "</gRed>"
                                                Endif

                                         ::cXml+= XmlTag( "vCBS" , Iif(::nVcbs == 0, ::nVcbs:= ::nVbcibs * ::nPcbs, ::nVcbs))
                                  ::cXml+= "</gCBS>"

                                  If !Empty(::cClasstribreg)
                                     ::cXml+= "<gTribRegular>"
                                            ::cXml+= XmlTag( "CSTReg"             , Left(::cClasstribreg, 3))
                                            ::cXml+= XmlTag( "cClassTribReg"      , Left(::cClasstribreg, 6))
                                            ::cXml+= XmlTag( "pAliqEfetRegIBSUF"  , ::nPaliqefetregibsuf, 4)
                                            ::cXml+= XmlTag( "vTribRegIBSUF"      , ::nVtribregibsuf)
                                            ::cXml+= XmlTag( "pAliqEfetRegIBSMun" , ::nPaliqefetregibsMun, 4)
                                            ::cXml+= XmlTag( "vTribRegIBSMun"     , ::nVtribregibsMun)
                                            ::cXml+= XmlTag( "pAliqEfetRegCBS"    , ::nPaliqefetregcbs, 4)
                                            ::cXml+= XmlTag( "vTribRegCBS"        , ::nVtribregcbs)
                                     ::cXml+= "</gTribRegular>"
                                  Endif

                                  If !Empty(::cCredPresgibs) .and. ::cCredPresgibs $ [1_2_3_4_5]
                                     ::cXml+= "<gIBSCredPres>"
                                            ::cXml+= XmlTag( "cCredPres" , Left(::cCredPresgibs, 2))
                                            ::cXml+= XmlTag( "pCredPres" , ::nPcredpresgibs, 4)
                                            ::cXml+= XmlTag( "vCredPres" , ::nVcredpresgibs)
                                     ::cXml+= "</gIBSCredPres>"
                                  Endif

                                  If !Empty(::cCredPrescbs) .and. ::cCredPrescbs $ [1_2_3_4_5]
                                     ::cXml+= "<gCBSCredPres>"
                                            ::cXml+= XmlTag( "cCredPres" , Left(::cCredPrescbs, 2))
                                            ::cXml+= XmlTag( "pCredPres" , ::nPcredprescbs, 4)
                                            ::cXml+= XmlTag( "vCredPres" , ::nVcredprescbs)
                                     ::cXml+= "</gCBSCredPres>"
                                  Endif
                    ::cXml+= "</gIBSCBS>"
      ::cXml+= "</IBSCBS>"
   Endif 
    
   ::fCria_Gibscbsmono()
Return (Nil)

* -------------------> Metodo para gerar a tag gIBSCBSMono <------------------ *
METHOD fCria_Gibscbsmono() CLASS Malc_GeraXml   // Reforma tribut�ria
   If ::nQbcmono # 0
      ::cXml+= "<gIBSCBSMono>"
             ::cXml+= XmlTag( "qBCMono"         , ::nQbcmono)
             ::cXml+= XmlTag( "adRemIBS"        , ::nAdremibs, 4)
             ::cXml+= XmlTag( "adRemCBS"        , ::nAdremcbs, 4)
             ::cXml+= XmlTag( "vIBSMono"        , ::nVibsmono)
             ::cXml+= XmlTag( "vCBSMono"        , ::nVcbsmono)
             ::cXml+= XmlTag( "qBCMonoReten"    , ::nQbcmonoreten, 0)
             ::cXml+= XmlTag( "adRemIBSReten"   , ::nAdremibsreten, 4)
             ::cXml+= XmlTag( "vIBSMonoReten"   , ::nVibsmonoreten)
             ::cXml+= XmlTag( "adRemCBSReten"   , ::nAdremcbsreten, 4)
             ::cXml+= XmlTag( "vCBSMonoReten"   , ::nVcbsmonoreten)
             ::cXml+= XmlTag( "qBCMonoRet"      , ::nQbcmonoret, 0)
             ::cXml+= XmlTag( "adRemIBSRet"     , ::nAdremibsret, 4)
             ::cXml+= XmlTag( "vIBSMonoRet"     , ::nVibsmonoret)
             ::cXml+= XmlTag( "adRemCBSRet"     , ::nAdremcbsret, 4)
             ::cXml+= XmlTag( "vCBSMonoRet"     , ::nVcbsmonoret)
             ::cXml+= XmlTag( "pDifIBS"         , ::nPdifibs, 4) 
             ::cXml+= XmlTag( "vIBSMonoDif"     , ::nVibsmonodif)
             ::cXml+= XmlTag( "pDifCBS"         , ::nPdifcbs, 4)
             ::cXml+= XmlTag( "vCBSMonoDif"     , ::nVcbsmonodif)
             ::cXml+= XmlTag( "vTotIBSMonoItem" , ::nVtotibsmonoItem)
             ::cXml+= XmlTag( "vTotCBSMonoItem" , ::nVtotcbsmonoItem)
      ::cXml+= "</gIBSCBSMono>"
   Endif 
Return (Nil)

* ----------------> Metodo para gerar as tags do PIS e COFINS <--------------- *
METHOD fCria_ProdutoPisCofins() CLASS Malc_GeraXml   // Marcelo Brigatti
   If !Empty(::cCstPis)
             ::cXml+= "<PIS>"
                   ::cXml+= "<PISAliq>"
                         ::cXml+= XmlTag( "CST"     , Iif(!(::cCstPis $ [01_02]), [01], Left(::cCstPis, 2)))                     // 01=Opera��o Tribut�vel (base de c�lculo = valor da opera��o al�quota normal (cumulativo/n�o cumulativo));  02=Opera��o Tribut�vel (base de c�lculo = valor da opera��o (al�quota diferenciada))
                         ::cXml+= XmlTag( "vBC"     , ::nBcPis )                   
                         ::cXml+= XmlTag( "pPIS"    , ::nAlPis, 4 )                 
                         ::cXml+= XmlTag( "vPIS"    , ::nBcPis * (::nAlPis / 100) ) 
                   ::cXml+= "</PISAliq>"
             ::cXml+= "</PIS>"
             ::cXml+= "<COFINS>"
                   ::cXml+= "<COFINSAliq>"
                         ::cXml+= XmlTag( "CST"     , Iif(!(::cCstCofins $ [01_02]), [01], Left(::cCstCofins, 2)))
                         ::cXml+= XmlTag( "vBC"     , ::nBcCofins )                   
                         ::cXml+= XmlTag( "pCOFINS" , ::nAlCofins, 4 )                
                         ::cXml+= XmlTag( "vCOFINS" , ::nBcCofins * (::nAlCofins / 100) )
                   ::cXml+= "</COFINSAliq>"
             ::cXml+= "</COFINS>"
   ElseIf !Empty(::cCstPisqtd)
             ::cXml+= "<PIS>"
                   ::cXml+= "<PISQtde>"
                         ::cXml+= XmlTag( "CST"       , Iif(!(::cCstPisqtd $ [03]), [03], Left(::cCstPisqtd, 2)))                // Opera��o Tribut�vel (base de c�lculo = quantidade vendida x al�quota por unidade de produto)
                         ::cXml+= XmlTag( "qBCProd"   , ::nQcom )                                                                // Quantidade do produto vendida
                         ::cXml+= XmlTag( "vAliqProd" , ::nAlPis, 4 )                
                         ::cXml+= XmlTag( "vPIS"      , ::nQcom * (::nAlPis / 100) )
                   ::cXml+= "</PISAQtde>"
             ::cXml+= "</PIS>"
             ::cXml+= "<COFINS>"
                   ::cXml+= "<COFINSQtde>"
                         ::cXml+= XmlTag( "CST"       , Iif(!(::cCstCofinsqtd $ [03]), [03], Left(::cCstCofinsqtd, 2)))
                         ::cXml+= XmlTag( "qBCProd"   , ::nQcom )                                                                // Quantidade do produto vendida
                         ::cXml+= XmlTag( "vAliqProd" , ::nAlPis, 4 )                                                                             
                         ::cXml+= XmlTag( "vCOFINS"   , ::nQcom * (::nAlCofins / 100) )
                   ::cXml+= "</COFINSQtde>"
             ::cXml+= "</COFINS>"
   ElseIf !Empty(::cCstPisnt)
             ::cXml+= "<PIS>"
                   ::cXml+= "<PISNT>"
                         ::cXml+= XmlTag( "CST"       , Iif(!(::cCstPisnt $ [04_05_06_07_08_09]), [04], Left(::cCstPisnt, 2)))   // C�digo de Situa��o Tribut�ria do PIS 04=Opera��o Tribut�vel (tributa��o monof�sica (al�quota zero)); 05=Opera��o Tribut�vel (Substitui��o Tribut�ria); 06=Opera��o Tribut�vel (al�quota zero); 07=Opera��o Isenta da Contribui��o; 08=Opera��o Sem Incid�ncia da Contribui��o; 09=Opera��o com Suspens�o da Contribui��o;
                   ::cXml+= "</PISNT>"
             ::cXml+= "</PIS>"
             ::cXml+= "<COFINS>"
                   ::cXml+= "<COFINSNT>"
                         ::cXml+= XmlTag( "CST"       , Iif(!(::cCstCofinsnt $ [04_05_06_07_08_09]), [04], Left(::cCstCofinsnt, 2))) 
                   ::cXml+= "</COFINSNT>"
             ::cXml+= "</COFINS>"
   ElseIf !Empty(::cCstPisoutro)
             ::cXml+= "<PIS>"
                   ::cXml+= "<PISOutr>"
                         ::cXml+= XmlTag( "CST"     , Iif(!(::cCstPisoutro $ [49_50_51_52_53_54_55_56_60_61_62_63_64_65_66_67_70_71_72_73_74_75_98_99]), [49], Left(::cCstPisoutro, 2))) // C�digo de Situa��o Tribut�ria do PIS
                         ::cXml+= XmlTag( "vBC"     , ::nBcPis )                   
                         ::cXml+= XmlTag( "pPIS"    , ::nAlPis, 4 )                 
                         ::cXml+= XmlTag( "vPIS"    , ::nBcPis * (::nAlPis / 100) ) 
                   ::cXml+= "</PISOutr>"
             ::cXml+= "</PIS>"
             ::cXml+= "<COFINS>"
                   ::cXml+= "<COFINSOutr>"
                         ::cXml+= XmlTag( "CST"       , Iif(!(::cCstCofinsoutro $ [49_50_51_52_53_54_55_56_60_61_62_63_64_65_66_67_70_71_72_73_74_75_98_99]), [49], Left(::cCstCofinsoutro, 2))) 
                         ::cXml+= XmlTag( "vBC"       , ::nBcCofins )                   
                         ::cXml+= XmlTag( "pCOFINS"   , ::nAlCofins, 4 )                
                         ::cXml+= XmlTag( "vCOFINS"   , ::nBcCofins * (::nAlCofins / 100) )
                   ::cXml+= "</COFINSOutr>"
             ::cXml+= "</COFINS>"
   Endif  
Return (Nil)

* ---------------> Metodo para gerar a tag de Totais da NFe <----------------- *
METHOD fCria_Totais() CLASS Malc_GeraXml
   ::cXml+= "<total>"
        ::cXml+= "<ICMSTot>"
             ::cXml+= XmlTag( "vBC"          , ::nVbc_t)
             ::cXml+= XmlTag( "vICMS"        , ::nVicms_t)
             ::cXml+= XmlTag( "vICMSDeson"   , ::nVicmsdeson_t)
             ::cXml+= XmlTag( "vFCPUFDest"   , ::nVfcpufdest_t)                                                                    // Complementa o C�lculo com a Diferen�a de ICMS
             ::cXml+= XmlTag( "vICMSUFDest"  , ::nVicmsufdest_t)                                                                   // Complementa o C�lculo com a Diferen�a de ICMS
             ::cXml+= XmlTag( "vICMSUFRemet" , ::nVicmsufremet_t)                                                                  // Complementa o C�lculo com a Diferen�a de ICMS
             ::cXml+= XmlTag( "vFCP"         , ::nVfcp_t)                                                                          // Campo referente a FCP Para vers�o 4.0
             ::cXml+= XmlTag( "vBCST"        , ::nVbcST_t)
             ::cXml+= XmlTag( "vST"          , ::nVst_t)
             ::cXml+= XmlTag( "vFCPST"       , ::nVfcpst_t)                                                                        // Campo referente a FCP Para vers�o 4.0
             ::cXml+= XmlTag( "vFCPSTRet"    , ::nVfcpstret_t)                                                                     // Campo referente a FCP Para vers�o 4.0

             If ::nMonoBas # 0
                ::cXml+= XmlTag( "qBCMonoRet"   , ::nMonoBas)
                ::cXml+= XmlTag( "vICMSMonoRet" , Round(::nMonoBas * ::nMonoAliq, 2))
             Endif 

             ::cXml+= XmlTag( "vProd"        , ::nVprodt)                                                                        // If(::cFinnfe == [1], 0, ::nVprodt))
             ::cXml+= XmlTag( "vFrete"       , ::nVFretet)
             ::cXml+= XmlTag( "vSeg"         , ::nVSeg_t)
             ::cXml+= XmlTag( "vDesc"        , ::nDesct)
             ::cXml+= XmlTag( "vII"          , ::nVii_t)
             ::cXml+= XmlTag( "vIPI"         , ::nVipi_t)
             ::cXml+= XmlTag( "vIPIDevol"    , ::nVipidevol_t)        
             ::cXml+= XmlTag( "vPIS"         , ::nVpis_t)
             ::cXml+= XmlTag( "vCOFINS"      , ::nVCofins_t)
             ::cXml+= XmlTag( "vOutro"       , ::nVOutrot)
         
             If ::nVnf == 0
                ::cXml+= XmlTag( "vNF"       , ::nVprodt - ::nDesct - ::nVicmsdeson_t + ::nVst_t + ::nVfcpst_t + ::nVFretet + ::nVSeg_t + ::nVOutrot + ::nVii_t + ::nVipi_t + ::nVipidevol_t)

                If ::cTpOp == [2]  // Exce��o 1: Faturamento direto de ve�culos novos: Se informada opera��o de Faturamento Direto para ve�culos novos (tpOp = 2, id:J02): 
                   ::cXml+= XmlTag( "vNF"    , ::nVprodt - ::nDesct - ::nVicmsdeson_t + ::nVFretet + ::nVSeg_t + ::nVOutrot + ::nVii_t + ::nVipi_t)
                Endif
             Else
               ::cXml+= XmlTag( "vNF"        , ::nVnf)
             Endif

             ::cXml+= XmlTag( "vTotTrib"     , ::nVtottribt)

/* ::nVnf:= 
  (+) vProd (id:W07) 
  (-) vDesc (id:W10) 
  (-) vICMSDeson (id:W04a) 
  (+) vST (id:W06) 
  (+) vFCPST (id:W06a) 
  (+) vFrete (id:W08) 
  (+) vSeg (id:W09) 
  (+) vOutro (id:W15) 
  (+) vII (id:W11) 
  (+) vIPI (id:W12) 
  (+) vIPIDevol (id: W12a) 
  (+) vServ (id:W18) (*3) (NT 2011/005) n�o criamos este grupo
*/
        ::cXml+= "</ICMSTot>"
   ::cXml+= "</total>"

   ::fCria_Istot() 
Return (Nil)

* --------------> Metodo para gerar a tag de Total IS da NFe <---------------- *
METHOD fCria_Istot() CLASS Malc_GeraXml
   If ::nVisistot # 0

      If "</total>" $ ::cXml
         ::cXml:= StrTran(::cXml, "</total>", "")  
      Endif  

      ::cXml+= "<ISTot>"
             ::cXml+= XmlTag( "vIS" , ::nVisistot)
      ::cXml+= "</ISTot>"
      ::cXml+= "<IBSCBSTot>"
             ::cXml+= XmlTag( "vBCIBSCBS" , ::nVbcibscbs)
             ::cXml+= "<gIBS>"
                    ::cXml+= "<gIBSUF>"
                           ::cXml+= XmlTag( "vDif"     , ::nVdifgibsuf)
                           ::cXml+= XmlTag( "vDevTrib" , ::nVdevtribgibsuf)
                           ::cXml+= XmlTag( "vIBSUF"   , ::nVibsufgibsuf)
                    ::cXml+= "</gIBSUF>"
                    ::cXml+= "<gIBSMun>"
                           ::cXml+= XmlTag( "vDif"     , ::nVdDifgibsmun)
                           ::cXml+= XmlTag( "vDevTrib" , ::nVdevtribgibsmun)
                           ::cXml+= XmlTag( "vIBSMun"  , ::nVibsmungibsmun)
                    ::cXml+= "</gIBSMun>"
                    ::cXml+= XmlTag( "vIBS"             , ::nVibsgibs)
                    ::cXml+= XmlTag( "vCredPres"        , ::nVcredpresgibs)
                    ::cXml+= XmlTag( "vCredPresCondSus" , ::nVcredprescondsusgibs)
             ::cXml+= "</gIBS>"
             ::cXml+= "<gCBS>"
                    ::cXml+= XmlTag( "vDif"             , ::nVdifgcbs)
                    ::cXml+= XmlTag( "vDevTrib"         , ::nVdevtribgcbs)
                    ::cXml+= XmlTag( "vCBS"             , ::nVcbsgcbs)
                    ::cXml+= XmlTag( "vCredPres"        , ::nVcredpresgcbs)
                    ::cXml+= XmlTag( "vCredPresCondSus" , ::nVcredprescondsusgcbs)
             ::cXml+= "</gCBS>"
      ::cXml+= "</IBSCBSTot>"
 
      ::cXml+= "</total>"
   Endif 

   ::fCria_Gibscbsmono()
Return (Nil)

* ---------------> Metodo para gerar a tag do Transportador <----------------- *
METHOD fCria_Transportadora() CLASS Malc_GeraXml
   If ::cModelo # [65]
      ::cXml+= "<transp>"
             ::cXml+= XmlTag( "modFrete" , Iif(!(::cModFrete $ [0_1_2_3_4_9]), [0], Left(::cModFrete, 1)))                       // Modalidade do frete 0=Contrata��o do Frete por conta do Remetente (CIF); 1=Contrata��o do Frete por conta do Destinat�rio (FOB); 2=Contrata��o do Frete por conta de Terceiros; 3=Transporte Pr�prio por conta do Remetente; 4=Transporte Pr�prio por conta do Destinat�rio;9=Sem Ocorr�ncia de Transporte. (Atualizado na NT2016.002)

             If ::cModFrete # [9]
                ::cXml+= "<transporta>"
                       If !Empty(::cXnomet)
                          If !Empty(::cCnpjt) .and. Len(SoNumeroCnpj(::cCnpjt)) < 14                                             // Pessoa F�sica - Cpf
                             ::cXml+= XmlTag( "CPF"  , Left(SoNumeroCnpj(::cCnpjt), 11))
       		          Elseif !Empty(::cCnpjt)                                                                                    // Pessoa Juridica - Cnpj
                             ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpjt), 14))
                          Endif 

                          ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomet), 60))

                          If !Empty(::cIet)
                             ::cXml+= XmlTag( "IE" , Left(SoNumero(::cIet), 14))
                          Endif 

                          If !Empty(::cXEndert)
                             ::cXml+= XmlTag( "xEnder" , Left(fRetiraAcento(::cXEndert), 60))
                          Endif 

                          If !Empty(::cXmunt)
                             ::cXml+= XmlTag( "xMun" , Left(fRetiraAcento(::cXmunt), 60))
                          Endif 

                          If !Empty(::cUft)
                             ::cXml+= XmlTag( "UF" , Left(fRetiraAcento(::cUft), 2))
                          Endif 
                       Else   
                          ::cXml+= XmlTag( "xNome" , [o Proprio])
                       Endif 
                ::cXml+= "</transporta>"

                If !Empty(fRetiraSinal(::cPlaca))
                   ::cXml+= "<veicTransp>"
                          ::cXml+= XmlTag( "placa" , Left(fRetiraSinal(::cPlaca), 7))
                          ::cXml+= XmlTag( "UF"    , Left(fRetiraAcento(::cUfplacat), 2))

                          If !Empty(::cRntc)
                             ::cXml+= XmlTag( "RNTC" , Left(fRetiraAcento(::cRntc), 20))
                          Endif 
                   ::cXml+= "</veicTransp>"
                Endif 
             Endif    

             // Informa��es de Volumes
             If !Empty(::nQvol) .or. !Empty(::cEsp) .or. !Empty(::cNvol) .or. !Empty(::nPesol) .or. !Empty(::nPesob)
                ::cXml+= "<vol>"
                       If !Empty(::nQvol)
                          ::cXml+= XmlTag( "qVol" , ::nQvol, 0)
                       Endif 
               
                       If !Empty(::cEsp)
                          ::cXml+= XmlTag( "esp" , Left(fRetiraAcento(::cEsp), 60))
                       Endif 

                       If !Empty(::cMarca)
                          ::cXml+= XmlTag( "marca" , Left(fRetiraAcento(::cMarca), 60))
                       Endif 

                       If !Empty(::cNvol)
                          ::cXml+= XmlTag( "nVol" , Left(fRetiraAcento(::cNvol), 60))
                       Endif 

                       If !Empty(::nPesol)
                          ::cXml+= XmlTag( "pesoL" , ::nPesol, 3)
                       Endif 

                       If !Empty(::nPesob)
                          ::cXml+= XmlTag( "pesoB" , ::nPesob, 3)
                       Endif  
                ::cXml+= "</vol>"
             Endif 
      ::cXml+= "</transp>"
   Else
      ::cXml+= "<transp>"
             ::cXml+= XmlTag( "modFrete" , [9])
      ::cXml+= "</transp>"
   Endif 
Return (Nil)

* ------------------> Metodo para gerar a tag de Cobran�a <------------------- *
METHOD fCria_Cobranca() CLASS Malc_GeraXml  // Grupo Y. Dados da Cobran�a
   If !Empty(::cNfat)
      If !("<cobr>") $ ::cXml
         ::cXml+= "<cobr>" 
      Endif 
         If !("<fat>") $ ::cXml
            ::cXml+= "<fat>"
                   ::cXml+= XmlTag( "nFat"     , Left(::cNfat, 60))                                                              // N�mero da Fatura
                   ::cXml+= XmlTag( "vOrig"    , ::nVorigp)                                                                      // Valor Original da Fatura
         
                   If !Empty(::nVdescp)
                      ::cXml+= XmlTag( "vDesc" , ::nVdescp)                                                                      // Valor do desconto
                   Endif 

                   ::cXml+= XmlTag( "vLiq"     , ::nVliqup)                                                                      // Valor L�quido da Fatura
            ::cXml+= "</fat>"
         Endif 
         If "</fat></cobr><dup>" $ ::cXml
            ::cXml:= StrTran(::cXml, "</fat></cobr><dup>", "</fat><dup>")
         EndIf   

         If !Empty(::nVdup)
             ::cXml+= "<dup>"
                    ::cXml+= XmlTag( "nDup"  , Left(::cNDup, 60))                                                                // Obrigat�ria informa��o do n�mero de parcelas com 3 algarismos, sequenciais e consecutivos. Ex.: �001�,�002�,�003�,... Observa��o: este padr�o de preenchimento ser� Obrigat�rio somente a partir de 03/09/2018
                    ::cXml+= XmlTag( "dVenc" , DateXml(::dDvencp))                                                               // Formato: �AAAA-MM-DD�. Obrigat�ria a informa��o da data de vencimento na ordem crescente das datas. Ex.: �2018-06-01�,�2018-07-01�, �2018-08-01�,...
                    ::cXml+= XmlTag( "vDup"  , ::nVdup)                                                                          // Valor da Parcela
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
METHOD fCria_Pagamento() CLASS Malc_GeraXml // Grupo YA. Informa��es de Pagamento
   If !("<pag>") $ ::cXml
      ::cXml+= "<pag>" 
   Endif  

   ::cXml+= "<detPag>" 
          If !(::cTpag $ [90_99])
             ::cXml+= XmlTag( "indPag" , Iif(!(::cIndPag $ [0_1]), [0], Left(::cIndPag, 1)))                                     // Indica��o da Forma de Pagamento 0= Pagamento � Vista 1= Pagamento � Prazo (Inclu�do na NT2016.002)
          Endif     

          ::cXml+= XmlTag( "tPag"      , Iif(!(::cTpag $ [01_02_03_04_05_10_11_12_13_15_16_17_18_19_90_99]), [01], Left(::cTpag, 2)))  // Meio de pagamento 01=Dinheiro 02=Cheque 03=Cart�o de Cr�dito 04=Cart�o de D�bito 05=Cr�dito Loja 10=Vale Alimenta��o 11=Vale Refei��o 12=Vale Presente 13=Vale Combust�vel 15=Boleto Banc�rio 16=Dep�sito Banc�rio 17=Pagamento Instant�neo (PIX) 18=Transfer�ncia banc�ria, Carteira Digital 19=Programa de fidelidade, Cashback, Cr�dito Virtual 90= Sem pagamento 99=Outros (Atualizado na NT2016.002, NT2020.006)

          If ::cTpag == [99]
             ::cXml+= XmlTag( "xPag" , Left(::cXpag, 60))                                                                        // Descri��o do meio de pagamento. Preencher informando o meio de pagamento utilizado quando o c�digo do meio de pagamento for informado como 99-outros.
          Endif  
  
          If ::cTpag # [90]
             ::cXml+= XmlTag( "vPag" , ::nVpag)
          Else
             ::cXml+= XmlTag( "vPag" , 0)                                                                                        // Valor do Pagamento
          Endif  

          If ::nTpintegra # 0 // n�o repete 
             ::cXml+= "<card>"
                    ::cXml+= XmlTag( "tpIntegra" , Iif(!(Hb_Ntos(::nTpintegra) $ [1_2]), [1], Hb_Ntos(::nTpintegra, 1)))         // 1=Pagamento integrado com o sistema de automa��o da empresa (Ex.: equipamento TEF, Com�rcio Eletr�nico) | 2= Pagamento n�o integrado com o sistema de automa��o da empresa 

                    If !Empty(::cCnpjpag)
                       ::cXml+= XmlTag( "CNPJ"   , Left(SoNumeroCnpj(::cCnpjpag), 14))                                           // Informar o CNPJ da institui��o de pagamento, adquirente ou subadquirente. Caso o pagamento seja processado pelo intermediador da transa��o, informar o CNPJ deste (Atualizado na NT 2020.006                                                       // CNPJ do Emitente
                    Endif  
  
                    If !Empty(::cTband)  
                       ::cXml+= XmlTag( "tBand"  , Iif(!(::cTband $ [01_02_03_04_05_06_07_08_09_99]), [0], Left(::cTband, 2)))   // Bandeira da operadora de cart�o de cr�dito e/ou d�bito 01=Visa 02=Mastercard 03=American Express 04=Sorocred 05=Diners Club 06=Elo 07=Hipercard 08=Aura 09=Cabal 99=Outros (Atualizado na NT2016.002
                    Endif  

                    If !Empty(::cAut)
                       ::cXml+= XmlTag( "cAut"   , Left(::cAut, 20))                                                             // Identifica o n�mero da autoriza��o da transa��o da opera��o com cart�o de cr�dito e/ou d�bito
                    Endif  
             ::cXml+= "</card>"
          Endif   
   ::cXml+= "</detPag>" 

   If !Empty(::nVtroco) // n�o repete
      ::cXml+= XmlTag( "vTroco" , ::nVtroco)                                                                                     // Valor do troco (Inclu�do na NT2016.002
   Endif  

   If !("</vPag></detPag></pag><detPag>") $ ::cXml .Or. !("</pag>") $ ::cXml
      ::cXml+= "</pag>"
   Else
      ::cXml:= StrTran(::cXml, "</detPag></pag>", "</detPag>")  
   Endif  

   If !("</pag>") $ ::cXml
      ::cXml+= "</pag>" 
   Endif  
Return (Nil)

* ------------> Metodo para gerar a tag de Informa��es Adicionais <----------- *
METHOD fCria_Informacoes() CLASS Malc_GeraXml
   ::cXml+= "<infAdic>"
          If ::lComplementar                                                                                                     // Informa��es DIFAL
             If ::nVIcmsSufDest > 0
                ::cInfFisc+= "DIFAL para UF destino R$ " + NumberXml(::nVIcmsSufDest, 2) + hb_OsNewLine()
             Endif 

             If ::nVIcmsSufRemet > 0
                ::cInfFisc+= "DIFAL para UF Origem R$ " + NumberXml(::nVIcmsSufRemet, 2) + hb_OsNewLine()
             Endif    

             If !Empty(::nVpis)                                                                                                  // Destaque valor do PIS/COFINS
                ::cInfFisc+= "Valor de PIS para movimento R$ " + NumberXml(::nVpis, 2) + hb_OsNewLine()
                ::cInfFisc+= "Valor de COFINS para movimento R$ " + NumberXml(::nVcofins, 2) + hb_OsNewLine()
             Endif 
             If ::cUfd # [EX] .and. !Empty(::cCodDest)
 		::cInfFisc+= "C�d:" + ::cCodDest + hb_OsNewLine()
             Endif 
          Endif 

          If !Empty(AllTrim(::cInfFisc))
             ::cXml+= XmlTag( "infAdFisco" , Left(fRetiraAcento(StrTran(::cInfFisc, hb_OsNewLine(), "; ")), 2000))
          Endif 

          If !Empty(AllTrim(::cInfcpl))
             ::cXml+= XmlTag( "infCpl" , Left(CharRem("���-:\(){}[]`��'", fRetiraAcento(StrTran(::cInfcpl, hb_OsNewLine(), '; '))), 5000))
          *  ::cXml+= XmlTag( "infCpl" , Left(fRetiraAcento(StrTran(::cInfcpl, hb_OsNewLine(), '; ')), 5000))
          Endif 
   ::cXml+= "</infAdic>"
Return (Nil)

* ----------> Metodo para gerar a tag de Declara��o de Importa��o <----------- *
METHOD fCria_ProdImporta() CLASS Malc_GeraXml                                                                                    // Colabora��o Rubens Aluotto, Marcelo Brigatti
   If Substr(Alltrim(::cCfop), 1, 1) == [3]
      ::cXml+= "<DI>"
             ::cXml+= XmlTag( "nDI" , Left(::cNdi, 12))                                                                          // n�mero do docto de importa��o DI/DSI/DA - 1-10 C  
             ::cXml+= XmlTag( "dDI" , DateXml(::dDdi))                                                                           // Data do documento de importa��o - AAAA-MM-DD
             ::cXml+= XmlTag( "xLocDesemb" , Left(fRetiraAcento(::cXlocdesemb), 60))                                             // Local do Desembarque da importa��o  
             ::cXml+= XmlTag( "UFDesemb" , Left(::cUfdesemb, 2))                                                                 // sigla da UF onde ocorreu o desembara�o aduaneiro - 2 C 
             ::cXml+= XmlTag( "dDesemb" , DateXml(::dDdesemb))                                                                   // Data do desembara�o aduaneiro - AAAA-MM-DD
             ::cXml+= XmlTag( "tpViaTransp" , Iif(!(Hb_Ntos(::nTpviatransp) $ [1_2_3_4_5_6_7]), [1], Hb_Ntos(::nTpviatransp)))   // Via de transporte internacional informada na Declara��o de Importa��o (DI)
                                                                                                                                 // 1 - mar�tima, 2 - fluvial, 3 - Lacustre, 4 - a�rea, 5 - postal, 6 - ferrovia, 7 - rodovia
             If ::nTpviatransp == 1
                ::cXml+= XmlTag( "vAFRMM" , ::nVafrmm)                                                                           //  valor somente informar no caso do tpViaTransp == 1 ( 15,2 n )
             Endif 

             ::cXml+= XmlTag( "tpIntermedio" , Iif(!(Hb_Ntos(::nTpintermedio) $ [1_2_3]), [1], Hb_Ntos(::nTpintermedio)))        // Forma de importa��o quanto a intermedia��o. 1 - importa��o por conta pr�pria, 2 - importa��o por conta e ordem, 3 - importa��o por encomenda
             If !(Empty(::cCnpja)) 
                ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpja), 14))                                                      // cnpj do adquirinte ou encomendante  </CNPJ>
             Endif 
             If ::nTpintermedio # 1 .and. ::cUfterceiro # [EX]
                ::cXml+= XmlTag( "UFTerceiro" , Left(::cUfterceiro, 2))                                                          // Obrigat�ria a informa��o no caso de importa��o por conta e ordem ou por encomenda. N�o aceita o valor "EX".
             Endif 
 
             ::cXml+= XmlTag( "cExportador" , Left(fRetiraAcento(::cCexportador), 60))                                           // c�digo do exportador 1-60 c  

             // For i:= 1 to 100
             If !Empty(::nNadicao)
                ::cXml+= "<adi>"    // BLOCO I
                       ::cXml+= XmlTag( "nAdicao" , ::nNadicao, 0)                                                               // n�mero da adicao 1-3
                       ::cXml+= XmlTag( "nSeqAdic" , ::nNseqadic, 0)                                                             // n�mero sequencial do �tem dentro da adi��o 1-3
                       ::cXml+= XmlTag( "cFabricante" , Left(::cCfabricante, 60))                                                // C�digo do fabricante estrangeiro - 1-60 c
                       If ::nVdescdi > 0
                          ::cXml+= XmlTag( "vDescDI" , ::nVdescdi)                                                               // Valor do desconto do �tem da DI - adi��o n 15,2 ( se houver )
                       Endif    
                       If !(Empty(::cNdraw)) 
                          ::cXml+= XmlTag( "nDraw" , Left(SoNumero(::cNdraw), 11))                                               // O n�mero do Ato Concess�rio de Suspens�o deve ser preenchido com 11 d�gitos (AAAANNNNNND) e o n�mero do Ato Concess�rio de Drawback Isen��o deve ser preenchido com 9 d�gitos (AANNNNNND). (Observa��o inclu�da na NT 2013/005 v. 1.10)
                       Endif    
                ::cXml+= "</adi>"
             Endif 
             // Next
       ::cXml+= "</DI>"

       // For i:= 1 to 500
       // Grupo I03. Produtos e Servi�os / Grupo de Exporta��o
       If !Empty(::cNdraw)
          ::cXml+= "<detExport>"                                                                                                 // Grupo de informa��es de exporta��o para o item
                 ::cXml+= XmlTag( "nDraw" , Left(SoNumero(::cNdraw), 11))                                                        // O n�mero do Ato Concess�rio de Suspens�o deve ser preenchido com 11 d�gitos (AAAANNNNNND) e o n�mero do Ato Concess�rio de Drawback Isen��o deve ser preenchido com 9 d�gitos (AANNNNNND). (Observa��o inclu�da na NT 2013/005 v. 1.10)
          ::cXml+= "</detExport>"    

          ::cXml+= "<exportInd>"                                                                                                 // Grupo sobre exporta��o indireta
            ::cXml+= XmlTag( "nRE"     , Left(Sonumero(::nNre), 12), 0)                                                          // N�mero do Registro de Exporta��o
            ::cXml+= XmlTag( "chNFe"   , Left(::cChnfe, 44))                                                                     // Chave de Acesso da NF-e recebida para exporta��o NF-e recebida com fim espec�fico de exporta��o. No caso de opera��o com CFOP 3.503, informar a chave de acesso da NF-e que efetivou a exporta��o 
            ::cXml+= XmlTag( "qExport" , ::nQexport, 4)                                                                          // Quantidade do item realmente exportado A unidade de medida desta quantidade � a unidade de comercializa��o deste item. No caso de opera��o com CFOP 3.503, informar a quantidade de mercadoria devolvida
          ::cXml+= "</exportInd>"
       Endif 
       // Next
   Endif 
Return (Nil)

* -----------------> Metodo para gerar a tag de Exporta��o <------------------ *
METHOD fCria_ProdExporta() CLASS Malc_GeraXml                                                                                    // Colabora��o Rubens Aluotto - 16/06/2025
   If !Empty(::cUfSaidapais) .and. Substr(SoNumero(::cCfOp), 1, 1) == [7]
      ::cXml+= "<exporta>"
             ::cXml+= XmlTag( "UFSaidaPais" , Left(::cUfSaidapais, 2))
             ::cXml+= XmlTag( "xLocExporta" , Left(::cXlocexporta, 60))
             ::cXml+= XmlTag( "xLocDespacho", Left(::cXlocdespacho, 60))
      ::cXml+= "</exporta>"
   Endif 
Return (Nil)

* ------------> Metodo para gerar a tag do Respons�vel T�cnico <-------------- *
METHOD fCria_Responsavel() CLASS Malc_GeraXml
   If !Empty(::cRespNome) .and. !Empty(::cRespcnpj) .and. !Empty(::cRespemail)
      ::cXml+= "<infRespTec>" 
             ::cXml+= XmlTag( "CNPJ"     , Left(SoNumeroCnpj(::cRespcnpj), 14))                                                  // CNPJ do Respons�vel T�cnico
             ::cXml+= XmlTag( "xContato" , Left(fRetiraAcento(::cRespNome), 60))                                                 // Contato do Respons�vel T�cnico
             ::cXml+= XmlTag( "email"    , Left(fRetiraAcento(::cRespemail), 60))                                                // E-mail do Respons�vel T�cnico
             ::cXml+= XmlTag( "fone"     , Left(fRetiraSinal(::cRespfone), 14))                                                  // Telefone do Respons�vel T�cnico
      ::cXml+= "</infRespTec>" 
   Endif 
Return (Nil)

* -----------> Metodo para gerar a tag do Imposto de Importa��o <------------- *
METHOD fCria_ProdutoII() CLASS Malc_GeraXml  // Marcelo Brigatti
   If Substr(Alltrim(::cCfOp), 1, 1) == [3]
      ::cXml+= "<II>"    // BLOCO P
            ::cXml+= XmlTag( "vBC"      , ::nVbci )
            ::cXml+= XmlTag( "vDespAdu" , ::nVdespadu )
            ::cXml+= XmlTag( "vII"      , ::nVii )
            ::cXml+= XmlTag( "vIOF"     , ::nViof )
      ::cXml+= "</II>"
   Endif 
Return (Nil)

* -----------------------> Metodo para fechar o XML <------------------------- *
METHOD fCria_Fechamento() CLASS Malc_GeraXml
   ::cXml+= "</infNFe>"
   ::cXml+= "</NFe>"
Return (Nil)

* -----------------------> Metodo para Ler Certificado .PFX <----------------- *
METHOD fCertificadopfx(cCertificadoArquivo, cCertificadoSenha) CLASS Malc_GeraXml
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

* ----------> Fun��o para Retirar Caracteres/Sinais de uma String <----------- *
Static Function fRetiraSinal(cStr, cEliminar)
   hb_Default(@cEliminar, "��� /;-:,\.(){}[]`��' ")
Return (cStr:= CharRem(cEliminar, cStr))

* ------------------> Retira Acentos e Letras de uma String <----------------- *
Static Function fRetiraAcento(cStr)
   Local aLetraCAc:= {[�],[�],[�],[�],[�],[�],[�],[�],[�],[&],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�],[�] ,[�] ,[�],[�],[�],[�],[�],[�],[�],[� ] ,[�],[�],[�],[�],[�],[�],[�],[�],[A�],[A�],[Ai],[A�],[Ao.],[�],[�] }
   Local aLetraSAc:= {[A],[A],[A],[A],[A],[E],[E],[E],[E],[E],[I],[I],[I],[I],[O],[O],[O],[O],[O],[U],[U],[U],[U],[C],[N],[Y],[a],[a],[a],[a],[a],[e],[e],[e],[a],[e],[i],[i],[i],[i],[o],[o],[o],[o],[o],[u],[u],[u],[u],[c],[n],[y],[y],[o.],[a.],[c],[a],[i],[u],[a],[a],[a],[E ],[a],[�],[e],[e],[o],[o],[a],[],[o],[c],[a],[e],[u],[],[]}, i
   hb_Default(@cStr, [])

   For i:= 1 To Len(aLetraCAc)
       cStr:= StrTran(cStr, aLetraCAc[i], aLetraSAc[i])
   Next
   Release aLetraCAc, aLetraSAc, i
Return (cStr)

* ------> Altera��o da fun��o original da sefazclass - ze_xmlfunc.prg <------- *
#ifndef DOW_DOMINGO
#define DOW_DOMINGO 1
#Endif 

* ---------------> Altera��o da fun��o original da sefazclass <---------------- *
Static Function XmlTag( cTag, xValue, nDecimals, lConvert )                                                                      // altera��o da fun��o original da sefazclass - ze_xmlfunc.prg
   Local cXml

   hb_Default( @nDecimals, 2 )
   hb_Default( @lConvert, .T. )

   IF lConvert
      IF ValType( xValue ) == "D"
         xValue := DateXml( xValue )
      ELSEIF ValType( xValue ) == "N"
         xValue := NumberXml( xValue, nDecimals )
      ELSE
         xValue := StringXML( xValue )
      Endif 
   Endif 
   IF Len( xValue ) == 0
      cXml := [<]+ cTag + [/>]
   ELSE
      cXml := [<] + cTag + [>] + xValue + [</] + cTag + [>]
   Endif 
Return cXml

* ----------------------> Fun��o para transformar datas <--------------------- *
Static Function DateXml( dDate )
Return Transform( Dtos( dDate ), "@R 9999-99-99" )

* ---------------------> Fun��o para transformar n�meros <-------------------- *
Static Function NumberXml( nValue, nDecimals )                                                                                   // altera��o da fun��o original da sefazclass - ze_xmlfunc.prg
   hb_Default( @nDecimals, 0 )
 
   IF nValue < 0                                                                                                                 // altera��o
      nValue:= 0
   Endif 
Return Ltrim( Str( nValue, 16, nDecimals ) )

* ----------------> Fun��o para retirar caracteres especiais <---------------- *
Static Function StringXML( cTexto )
   cTexto := AllTrim( cTexto )
   DO WHILE Space(2) $ cTexto
      cTexto := StrTran( cTexto, Space(2), Space(1) )
   ENDDO
   cTexto := StrTran( cTexto, "&", "E" ) // "&amp;" )
   cTexto := StrTran( cTexto, ["], "&quot;" )
   cTexto := StrTran( cTexto, "'", "&#39;" )
   cTexto := StrTran( cTexto, "<", "&lt;" )
   cTexto := StrTran( cTexto, ">", "&gt;" )
   cTexto := StrTran( cTexto, "�", "&#176;" )
   cTexto := StrTran( cTexto, "�", "&#170;" )

Return cTexto

* ----------------------> Fun��o para transformar datas <--------------------- *
Static Function DateTimeXml( dDate, cTime, cUF, lUTC, cUserTimeZone )
   Local cText, lHorarioVerao

   hb_Default( @dDate, Date() )
   hb_Default( @cTime, Time() )
   hb_Default( @cUF, "SP" )
   hb_Default( @lUTC, .T. )

   lHorarioVerao := ( dDate >= HorarioVeraoInicio( Year( dDate ) ) .OR. dDate <= HorarioVeraoTermino( Year( dDate ) - 1 ) )
   cText := Transform( Dtos( dDate ), "@R 9999-99-99" ) + "T" + cTime
   DO CASE
   CASE ! Empty( cUserTimeZone )                               ; cText += cUserTimeZone
   CASE ! lUTC ; cText += "" // no UTC
   CASE cUF $ "AC"                                             ; cText += "-05:00"
   CASE cUF $ "MT,MS" .AND. lHorarioVerao                      ; cText += "-03:00"
   CASE cUF $ "DF,ES,GO,MG,PR,RJ,RS,SC" .AND. lHorarioVerao    ; cText += "-02:00"
   // SP n�o tem mais hor�rio de ver�o
   CASE cUF $ "AM,MT,MS,RO,RR"                                 ; cText += "-04:00"
   OTHERWISE                                                   ; cText += "-03:00"                                               // demais casos
   ENDCASE

Return cText

* ----------------> Fun��o para c�lculo do Domingo de P�scoa <---------------- *
Static Function DomingoDePascoa( nAno )
   Local nA, nB, nC, nD, nE, nF, nG, nH, nI, nK, nL, nM, nMes, nDia

   nA   := nAno % 19
   nB   := Int( nAno / 100 )
   nC   := nAno % 100
   nD   := Int( nB / 4 )
   nE   := nB % 4
   nF   := Int( ( nB + 8 ) / 25 )
   nG   := Int( ( nB - nF + 1 ) / 3 )
   nH   := ( 19 * nA + nB - nD - nG + 15 ) % 30
   nI   := Int( nC / 4 )
   nK   := nC % 4
   nL   := ( 32 + 2 * nE + 2 * nI - nH - nK ) % 7
   nM   := Int( ( nA + 11 * nH + 22 * nL ) / 451 )
   nMes := Int( ( nH + nL - 7 * nM + 114 ) / 31 )
   nDia := ( ( nH + nL - 7 * nM + 114 ) % 31 ) + 1

Return Stod( StrZero( nAno, 4 ) + StrZero( nMes, 2 ) + StrZero( nDia, 2 ) )

* ----------------> Fun��o para c�lculo do Ter�a de Carnaval <---------------- *
Static Function TercaDeCarnaval( nAno )
Return DomingoDePascoa( nAno ) - 47

* ------------> Fun��o para c�lculo do Hor�rio de Ver�o in�cio <-------------- *
Static Function HorarioVeraoInicio( nAno )
   Local dPrimeiroDeOutubro, dPrimeiroDomingoDeOutubro, dTerceiroDomingoDeOutubro

   IF nAno == 2018
      dTerceiroDomingodeOutubro := Stod( "20181104" )
   ELSE
      dPrimeiroDeOutubro := Stod( StrZero( nAno, 4 ) + "1001" )
      dPrimeiroDomingoDeOutubro := dPrimeiroDeOutubro + iif( Dow( dPrimeiroDeOutubro ) == DOW_DOMINGO, 0, ( 7 - Dow( dPrimeiroDeOutubro ) + 1 ) )
      dTerceiroDomingoDeOutubro := dPrimeiroDomingoDeOutubro + 14
   Endif 

Return dTerceiroDomingoDeOutubro

* ------------> Fun��o para c�lculo do Hor�rio de Ver�o t�rmino <------------- *
Static Function HorarioVeraoTermino( nAno )
   Local dPrimeiroDeFevereiro, dPrimeiroDomingoDeFevereiro, dTerceiroDomingoDeFevereiro

   dPrimeiroDeFevereiro := Stod( StrZero( nAno + 1, 4 ) + "0201" )
   dPrimeiroDomingoDeFevereiro := dPrimeiroDeFevereiro + iif( Dow( dPrimeiroDeFevereiro ) == DOW_DOMINGO, 0, ( 7 - Dow( dPrimeiroDeFevereiro ) + 1 ) )
   dTerceiroDomingoDeFevereiro := dPrimeiroDomingoDeFevereiro + 14
   IF dTerceiroDomingoDeFevereiro == TercaDeCarnaval( nAno + 1 ) - 2                                                             // /* nao pode ser domingo de carnaval */
      dTerceiroDomingoDeFevereiro += 7
   Endif 

Return dTerceiroDomingoDeFevereiro
* ---> Fim da Altera��o da fun��o original da sefazclass - ze_xmlfunc.prg <--- *

* -----> Altera��o da fun��o original da sefazclass - ze_xmldigitoc.prg <----- *
* --------------> Fun��o para c�lculo do d�gito do m�dulo 11 <---------------- *
Static Function CalculaDigito( cNumero, cModulo )
   Local nFator, nPos, nSoma, nResto, nModulo, cCalculo

   hb_Default( @cModulo, "11" )
   IF Empty( cNumero )
      Return ""
   Endif 
   cCalculo := AllTrim( cNumero )
   nModulo  := Val( cModulo )
   nFator   := 2
   nSoma    := 0
   IF nModulo == 10
      FOR nPos = Len( cCalculo ) To 1 Step -1
         nSoma += Val( Substr( cCalculo, nPos, 1 ) ) * nFator
         nFator += 1
      NEXT
   ELSE
      FOR nPos = Len( cCalculo ) To 1 Step -1
         nSoma += ( Asc( Substr( cCalculo, nPos, 1 ) ) - 48 ) * nFator
         IF nFator == 9
            nFator := 2
         ELSE
            nFator += 1
         Endif 
      NEXT
   Endif 
   nResto := 11 - Mod( nSoma, 11 )
   IF nResto > 9
      nResto := 0
   Endif 
   cCalculo := Str( nResto, 1 )

Return cCalculo
* --> Fim da Altera��o da fun��o original da sefazclass - ze_xmldigitoc.prg <- *

* ------> Altera��o da fun��o original da sefazclass - ze_miscfunc.prg  <----- *
* -------------> Fun��o para verificar de o caracter � n�mero <--------------- *
Static Function SoNumero( cTxt )
   Local cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF cChar $ "0123456789"
         cSoNumeros += cChar
      Endif 
   NEXT
Return cSoNumeros

* -----------> Fun��o para verificar de o caracter � n�mero no CNPJ <--------- *
Static Function SoNumeroCnpj( cTxt )
   Local cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF ( cChar >= "0" .AND. cChar <= "9" ) .OR. ( cChar >= "A" .AND. cChar <= "Z" )
         cSoNumeros += cChar
      Endif 
   NEXT

Return cSoNumeros
* ---> Fim da Altera��o da fun��o original da sefazclass - ze_miscfunc.prg <-- ** ---> Fim da Altera��o da fun��o original da sefazclass - ze_miscfunc.prg <-- *
