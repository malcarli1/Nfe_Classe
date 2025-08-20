/*****************************************************************************
 * SISTEMA  : TCONTROL                                                       *
 * PROGRAMA : NFE_CLASSE.PRG   		                                     *
 * OBJETIVO : CLASSE PARA GERAÇÃO DE XML DE DFE'S - NFE(55) E NFCE(65)       *
 * AUTOR    : Marcelo Antonio Lázzaro Carli                                  *
 * ALTERADO : Rubens Aluotto                                                 *
 *          : Marcelo de Paula                                               *
 *          : Marcelo Brigatti                                               *
 * DATA     : 10.06.2025                                                     *
 * ULT. ALT.: 18.08.2025                                                     *
 *****************************************************************************/
#include <hbclass.ch>

CLASS Malc_GeraXml
   // Configurações iniciais básicas
   VAR cXml                  INIT []
   VAR cUf                   INIT [35]                                         // Grupo B // SP = 35
   VAR cNf                   INIT []                                           // Grupo B
   VAR cCnpj                 INIT []                                           // Cnpj/Cpf Emitente
   VAR cAmbiente             INIT [2]                                          // Ambiente de Homologação 
   VAR cSerie                INIT [1]
   VAR cModelo               INIT [55]                                         // 55 Nfe ou 65 nfce
   VAR cNrdoc                INIT []
   VAR cVersao               INIT [4.00]                                       // Grupo A
   VAR cId                   INIT []                                           // Grupo A
   VAR cCertNomecer          INIT []                                           // Nome do certificado retornado
   VAR cCertEmissor          INIT []                                           // Nome do Emissor do certificado retornado
   VAR dCertDataini          INIT CToD( [] )                                   // Data Inicial de Validade do certificado retornado
   VAR dCertDatafim          INIT CToD( [] )                                   // Data Final de Validade do certificado retornado
   VAR cCertImprDig          INIT []                                           // Impressão Digital do certificado retornado
   VAR cCertSerial           INIT []                                           // Número Serial do certificado retornado
   VAR nCertVersao           INIT 0                                            // Versão do certificado retornado
   VAR lCertInstall          INIT .F.                                          // Verifica se o Certificado está Instalado no Repositório do Windows
   VAR lCertVencido          INIT .F.                                          // Verifica se o Certificado está Vencido

   // Tag ide - Grupo B
   VAR cNatop                INIT []
   VAR cMunfg                INIT []
   VAR dDataE                INIT Date()
   VAR cTimeE                INIT Time()
   VAR dDataS                INIT Date()
   VAR cTimeS                INIT Time()
   VAR cTpnf                 INIT [1]                                          // 0 - entrada, 1 - saída
   VAR cIdest                INIT [1]                                          // 1 - Interna, 2 - Interestadual, 3 - Exterior
   VAR cTpImp                INIT [1]                                          // Tipo de Impressão    1 - Retrato / 2 - Paisagem
   VAR cTpEmis               INIT [1]                                          // Tipo de Emissão      1 - Normal  / 2 - Contingência FS-IA / 3 - (DESATIVADO) / 4 - Contingência EPEC / 5 - Contingência FS-DA / 6 - Contingência SVC-AN / 7 - Contingência SVC-RS / 9 - Contingência off-line da NFC-e 
   VAR cFinnfe               INIT [1]                                          // 1 = NF-e normal; 2 = NF-e complementar; 3 = NF-e de ajuste; 4 = Devolução de mercadoria.
   VAR cIndfinal             INIT [1]                                          // Indica operação com consumidor final (0 - Não ; 1 - Consumidor Final)
   VAR cIndpres              INIT [1]                                          // Indicador de Presença do comprador no estabelecimento comercial no momento da operação.
   VAR cIndintermed          INIT [0]
   VAR cProcemi              INIT [0]                                          // 0 - emissão de NF-e com aplicativo do contribuinte
   VAR cVerproc              INIT [4.00_B30]
   VAR dDhCont               INIT []                                           // Data-hora contingência       FSDA - tpEmis = 5
   VAR cxJust                INIT []                                           // Justificativa contingência   FSDA - tpEmis = 5
   VAR cRefnfe               INIT []                                           // Grupo BA
   VAR cCepe                 INIT []  
   VAR cTpnfdebito           INIT []                                           // Reforma tributária
   VAR cTpnfcredito          INIT []                                           // Reforma tributária
   VAR cTpentegov            INIT []                                           // Reforma tributária
   VAR nPredutor             INIT 0                                            // Reforma tributária 
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

   // Tag prod - Grupo I - Produtos e Serviços da NFe
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

   // TAG DI - Grupo I01 - Configuracoes para IMPORTACAO CFOP com início "3"   // Colaboração Rubens Aluotto - 16/06/2025
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

   // TAG adi - Grupo I01 - Grupo de Adições (SubGrupo da TAG DI) 
   VAR nNadicao              INIT 0                                           // Número da Adição 
   VAR nNseqadic             INIT 0                                           // Número sequencial do ítem dentro da Adição
   VAR cCfabricante          INIT []                                          // Código do fabricante estrangeiro, usado nos sistemas internos de informação do emitente da NF-e 
   VAR nVdescdi              INIT 0                                           // Valor do desconto do item da DI – Adição
   VAR cNdraw                INIT []                                          // Número do ato concessório de Drawback (O número do Ato Concessório de Suspensão deve ser preenchido com 11 dígitos (AAAANNNNNND)
   VAR nNre                  INIT 0                                           // Número do Registro de Exportação
   VAR cChnfe                INIT []                                          // Chave de Acesso da NF-e recebida para exportação NF-e recebida com fim específico de exportação. No caso de operação com CFOP 3.503, informar a chave de acesso da NF-e que efetivou a exportação 
   VAR nQexport              INIT 0                                           // Quantidade do item realmente exportado A unidade de medida desta quantidade é a unidade de comercialização deste item. No caso de operação com CFOP 3.503, informar a quantidade de mercadoria devolvida

   // Grupo JA. Detalhamento Específico de Veículos novos
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

   // Tag med - Grupo K. Detalhamento Específico de Medicamento e de matérias-primas farmacêuticas
   VAR cProdanvisa           INIT []
   VAR cXmotivoisencao       INIT []
   VAR nVpmc                 INIT 0

   // Tag arma - Grupo L. Detalhamento Específico de Armamentos
   VAR cTparma               INIT []
   VAR cNserie_a             INIT []
   VAR cNcano                INIT []
   VAR cDescr_a              INIT []

   // Tag comb - Grupo LA - Combustíveis
   VAR cCprodanp             INIT []                                           // Código de produto da ANP
   VAR cDescanp              INIT []                                           // Descrição do produto conforme ANP
   VAR nQtemp                INIT 0                                            // Quantidade de combustível faturada à temperatura ambiente.
   VAR nQbcprod              INIT 0                                            // Informar a BC da CIDE em quantidade
   VAR nValiqprod            INIT 0                                            // Informar o valor da alíquota em reais da CIDE
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

   // Imposto de Importação 
   // TAG II - Grupo P - Grupo Imposto de Importação                           // (Informar apenas quando o item for sujeito ao II) 
   VAR nVbci                 INIT 0                                            // Valor BC do Imposto de Importação
   VAR nVdespadu             INIT 0                                            // Valor despesas aduaneiras
   VAR nVii                  INIT 0                                            // Valor Imposto de Importação
   VAR nViof                 INIT 0                                            // Valor Imposto sobre Operações Financeiras 

   // Tag Pis/Cofins - Grupo Q e S
   VAR cCstPis               INIT []                                           // (01, 02) CSTs do PIS são mutuamente exclusivas só pode existir um tipo
   VAR cCstPisqtd            INIT []                                           // (03)
   VAR cCstPisnt             INIT []                                           // (04, 05, 06, 07, 08, 09)
   VAR cCstPisoutro          INIT []                                           // (49, 50, 51, 52, 53, 54, 55, 56, 60, 61, 62, 63, 64, 65, 66, 67, 70, 71, 72, 73, 74, 75, 98, 99)
   VAR cCstCofins            INIT []                                           // (01, 02) CSTs do Cofins são mutuamente exclusivas só pode existir um tipo                 
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
   VAR lVtottrib             INIT .T.                                          // Variável para permitir ou não informar os valores dos tributos na informação adicional dos itens 

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

   // Tag Pag - Grupo YA. Informações de Pagamento
   VAR cIndPag               INIT [0]
   VAR cTpag                 INIT []
   VAR cXpag                 INIT []
   VAR nVpag                 INIT 0
   VAR nVtroco               INIT 0
   VAR nTpintegra            INIT 0                                            // 1=Pagamento integrado com o sistema de automação da empresa (Ex.: equipamento TEF, Comércio Eletrônico) | 2= Pagamento não integrado com o sistema de automação da empresa 
   VAR cCnpjpag              INIT []
   VAR cTband                INIT []
   VAR cAut                  INIT []

   // Tag infAdic - Grupo Z - informações Fisco / Complementar
   VAR lComplementar         INIT .F.
   VAR nVIcmsSufDest         INIT 0
   VAR nVIcmsSufRemet        INIT 0
   VAR nVpis                 INIT 0
   VAR nVcofins              INIT 0
   VAR cCodDest              INIT []
   VAR cInfcpl               INIT []                                           // Grupo Z - infCpl
   VAR cInfFisc              INIT []                                           // Grupo Z - infAdFisco

   // TAG exporta - Grupo ZA - Configuracoes para EXPORTACAO CFOP com início "7" // Colaboração Rubens Aluotto - 16/06/2025
   VAR cUfSaidapais          INIT []
   VAR cXlocexporta          INIT []
   VAR cXlocdespacho         INIT []

   // Tag infRespTec - Grupo ZD - responsável técnico
   VAR cRespcnpj             INIT []
   VAR cRespNome             INIT []
   VAR cRespemail            INIT []
   VAR cRespfone             INIT []

   // TAG is - Reforma tributária
   VAR cClasstribiS          INIT []
   VAR nVbcis                INIT 0
   VAR nPisis                INIT 0
   VAR nPisespec             INIT 0
   VAR cUtrib_is             INIT []
   VAR nQtrib_is             INIT 0

   // TAG Ibscbs - Reforma tributária
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

   // Tag ISTot - Reforma tributária
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

   // Tag gIBSCBSMono  - Reforma tributária
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
   METHOD fCria_Compragov()                                                    // Reforma tributária
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
   METHOD fCria_ProdutoIs()                                                    // Reforma tributária
   METHOD fCria_ProdutoIbscbs()                                                // Reforma tributária
   METHOD fCria_Totais()
   METHOD fCria_Istot()                                                        // Reforma tributária
   METHOD fCria_Gibscbsmono()                                                  // Reforma tributária
   METHOD fCria_Transportadora() 
   METHOD fCria_Cobranca()
   METHOD fCria_Pagamento()
   METHOD fCria_Informacoes() 
   METHOD fCria_Responsavel()
   METHOD fCria_Fechamento()

   METHOD fCertificadopfx(cCertificadoArquivo, cCertificadoSenha)
ENDCLASS

* ---------------> Metodo para inicializar a criação do XML <----------------- *
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

* ------------> Metodo para gerar a tag de identificação da NFe <------------- *
METHOD fCria_Ide() CLASS Malc_GeraXml
   ::cXml+= "<ide>"                                                                                                              // Início da TAG (ide)
          ::cXml+= XmlTag( "cUF"    , Left(::cUf, 2))                                                                            // UF do Emitente no caso SP = 35
          ::cXml+= XmlTag( "cNF"    , Padl(Alltrim(::cNrdoc), 8, [0]))                                                           // Controle da Nota ou número do pedido
          ::cXml+= XmlTag( "natOp"  , Left(fRetiraAcento(::cNatop), 60))                                                         // Natureza da Operação
          ::cXml+= XmlTag( "mod"    , Iif(!(::cModelo $ [55_65]), [55], Left(::cModelo, 2)))                                     // Modelo do Documento 55 - Nfe ou 65 Nfce
          ::cXml+= XmlTag( "serie"  , Iif(Empty(::cSerie), [1], Left(::cSerie, 3)))                                              // Série 
          ::cXml+= XmlTag( "nNF"    , Left(::cNf, 9))                                                                            // Número da Nota Fiscal
          ::cXml+= XmlTag( "dhEmi"  , DateTimeXml(::dDataE, ::cTimeE))                                                           // Data Emissão Formato yyyy-mm-dd

          If !Empty(::dDataS)
             If ::cModelo # [65]
                ::cXml+= XmlTag( "dhSaiEnt" , DateTimeXml(::dDataS, ::cTimeS))                                                   // Data da Saída da mercadoria
             Endif 
          Endif  
 
          ::cXml+= XmlTag( "tpNF"     , Iif(!(::cTpnf $ [0_1]), [0], Left(::cTpnf, 1)))                                          // Tipo de Emissão da NF  0 - Entrada, 1 - Saída, 2 - Saída-Devolução, 3 - Saída-Garantia
          ::cXml+= XmlTag( "idDest"   , Iif(!(::cIdest $ [1_2_3]), [1], Left(::cIdest, 1)))                                      // Identificador de Local de destino da operação (1 - Interna, 2 - Interestadual, 3 - Exterior)
          ::cXml+= XmlTag( "cMunFG"   , Left(::cMunfg, 7))                                                                       // IBGE do Emitente

          If ::cIndpres == [5]                                                                                                   
             ::cXml+= XmlTag( "cMunFGIBS", Left(::cMunfg, 7))                                                                    // Informar o município de ocorrência do fato gerador do fato gerador do IBS / CBS. Campo preenchido somente quando “indPres = 5 (Operação presencial, fora do estabelecimento)”, e não tiver endereço do destinatário (Grupo: E05) ou Local de entrega (Grupo: G01).
          Endif 

          If ::cModelo == [65]
             ::cXml+= XmlTag( "tpImp" , Iif(!(::cTpimp $ [4_5]), [4], Left(::cTpimp, 1))) 
          Elseif ::cModelo == [55]
             ::cXml+= XmlTag( "tpImp" , Iif(!(::cTpimp $ [0_1_2_3]), [1], Left(::cTpimp, 1)))                                    // Tipo de Impressão 0 - Sem geração de DANFE; 1 - DANFE normal, Retrato; 2 - DANFE normal, Paisagem; 3 - DANFE Simplificado; 4 - DANFE NFC-e; 5 - DANFE NFC-e em mensagem eletrônica
          Endif 

          ::cXml+= XmlTag( "tpEmis"   , Iif(!(::cTpemis $ [1_2_3_4_5_6_7_9]), [1], Left(::cTpemis, 1)))                          // 1=Emissão normal (não em contingência); 2=Contingência FS-IA, com impressão do DANFE em Formulário de Segurança - Impressor Autônomo; 3=Contingência SCAN (Sistema de Contingência do Ambiente Nacional); *Desativado * NT 2015/002 4=Contingência EPEC (Evento Prévio da Emissão em Contingência); 5=Contingência FS-DA, com impressão do DANFE em Formulário de Segurança - Documento Auxiliar; 6=Contingência SVC-AN (SEFAZ Virtual de Contingência do AN); 7=Contingência SVC-RS (SEFAZ Virtual de Contingência do RS); 9=Contingência off-line da NFC-e;
          ::cXml+= XmlTag( "cDV"      , Right(::cId, 1))                                                                         // Dígito da Chave de Acesso
          ::cXml+= XmlTag( "tpAmb"    , Iif(Empty(::cAmbiente), [2], Left(::cAmbiente, 1)))                                      // Identificação do Ambiente  1 - Produção,  2 - Homologação

          If ::cModelo == [65]
             ::cXml+= XmlTag( "finNFe", [1])                                                                                     // 1 - NF-e normal; 2 - NF-e complementar; 3 - NF-e de ajuste; 4 - Devolução de mercadoria; 5 - Nota de crédito; 6 - Nota de débito
          Elseif ::cModelo == [55]
             ::cXml+= XmlTag( "finNFe", Iif(!(::cFinnfe $ [1_2_3_4_5_6]), [1], Left(::cFinnfe, 1)))                              // 1 - NF-e normal; 2 - NF-e complementar; 3 - NF-e de ajuste; 4 - Devolução de mercadoria; 5 - Nota de crédito; 6 - Nota de débito
          Endif 

          If ::cFinnfe == [6]                                                                                                    // Nota de Débito
             ::cXml+= XmlTag( "tpNFDebito"  , Iif(!(::tpNFDebito $ [01_02_03_04_05_06_07]), [01], Left(::tpNFDebito, 2)))        // 01=Transferência de créditos para Cooperativas; 02=Anulação de Crédito por Saídas Imunes/Isentas; 03=Débitos de notas fiscais não processadas na apuração; 04=Multa e juros; 05=Transferência de crédito de sucessão; 06=Pagamento antecipado; 07=Perda em estoque                                                      
          Elseif ::cFinnfe == [5]                                                                                                // Nota de Crédito
             ::cXml+= XmlTag( "tpNFCredito" , Iif(!(::tpNFCredito $ [01_02_03]), [01], Left(::tpNFCredito, 2)))                  // 01 = Multa e juros; 02 = Apropriação de crédito presumido de IBS sobre o saldo devedor na ZFM (art. 450, § 1º, LC 214/25); 03 = Retorno 
          Endif 

          If ::cAmbiente == [2] .or. ::cModelo == [65]
             ::cXml+= XmlTag( "indFinal" , [1])                                                                                  // Indica operação com consumidor final (0 - Não ; 1 - Consumidor Final)
          Else
             ::cXml+= XmlTag( "indFinal" , Iif(!(::cIndfinal $ [0_1]), [0], Left(::cIndfinal, 1)))                               // Indica operação com consumidor final (0 - Não ; 1 - Consumidor Final)
          Endif 

          ::cXml+= XmlTag( "indPres"  , Iif(!(::cIndpres $ [0_1_2_3_4_5_9]), [0], Left(::cIndpres, 1)))                          // Indicador de Presença do comprador no estabelecimento comercial no momento da operação.
                                                                                                                                 // 1 - Operação presencial;
                                                                                                                                 // 2 - Não presencial, internet;
                                                                                                                                 // 3 - Não presencial, tele-atendimento;
                                                                                                                                 // 4 - NFC-e entrega em domicílio;
                                                                                                                                 // 5 - Operação presencial, fora do estabelecimento; (incluído NT2016.002)
                                                                                                                                 // 9 - Não presencial, outros.
          If !(::cIndpres $ [0_1_5])                                                                                             // Se Informado indicativo de presença, tag: indPres, DIFERENTE de 2, 3, 4 ou 9 – Proibido o preenchimento do campo Indicativo do Intermediador (tag: indIntermed)
             ::cXml+= XmlTag( "indIntermed" , Iif(!(::cIndintermed $ [0_1]), [0], Left(::cIndintermed, 1)))                      // Indicador de intermediador/marketplace, 0 - Operação sem intermediador (em site ou plataforma própria), 1 - Operação em site ou plataforma de terceiros (intermediadores/marketplace)
          Endif 

          ::cXml+= XmlTag( "procEmi"  , Iif(!(::cProcemi $ [0_1_2_3]), [1], Left(::cProcemi, 1)))                                // 0 - emissão de NF-e com aplicativo do contribuinte;
                                                                                                                                 // 1 - emissão de NF-e avulsa pelo Fisco;
                                                                                                                                 // 2 - emissão de NF-e avulsa, pelo contribuinte com seu certificado digital, através do site do Fisco;
                                                                                                                                 // 3 - emissão NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.
          ::cXml+= XmlTag( "verProc"  , Left(::cVerproc, 20))                                                                    // Informar a versão do aplicativo emissor de NF-e.

          If ::cTpemis # [1]                                                                                                     // 1 - Emissão normal (não em contingência
             ::cXml+= XmlTag( "dhCont" , DateTimeXml(::dDhcont, ::cTimeE))                                                       // Data-hora contingência       FSDA - tpEmis = 5
             ::cXml+= XmlTag( "xJust"  , Left(::cXjust, 256))                                                                    // Justificativa contingência   FSDA - tpEmis = 5
          Endif 

          ::fCria_Compragov()
   ::cXml+= "</ide>"
Return (Nil)

* -----------------> Metodo para gerar as referências da NF <----------------- *
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
             ::cXml+= XmlTag( "tpEnteGov" , Iif(!(::cTpentegov $ [1_2_3_4]), [1], Left(::cTpentegov, 1)))                        // 1=União 2=Estado 3=Distrito Federal 4=Município
             ::cXml+= XmlTag( "pRedutor"  , ::nPredutor, 4)                            
             ::cXml+= XmlTag( "tpOperGov" , Iif(!(::cTpOperGov $ [1_2]), [1], Left(::cTpOperGov, 1)))                            // 1=Fornecimento 2=Recebimento do pagamento, conforme fato gerador do IBS/CBS definido no Art. 10 § 2º
      ::cXml+= "</gCompraGov>"
   Endif                                                                             
Return (Nil)

* -----------------> Metodo para gerar a tag do emitente <-------------------- *
METHOD fCria_Emitente() CLASS Malc_GeraXml
   ::cXml+= "<emit>"                                                                                                             // Início da TAG (emit)
          ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpj), 14))                                                             // CNPJ do Emitente
          ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomee), 60))                                                         // Razão Social emitente

          If !Empty(::cXfant)
             ::cXml+= XmlTag( "xFant" , Left(fRetiraAcento(::cXfant), 60))                                                       // Nome Fantasia Emitente
          Endif 

          ::cXml+= "<enderEmit>"
                 ::cXml+= XmlTag( "xLgr"    , Left(fRetiraAcento(::cXlgre), 60))                                                 // Endereço Emitente
                 ::cXml+= XmlTag( "nro"     , Left(::cNroe, 60))                                                                 // Número do Endereço do Emitente

                 If !Empty(::cXcple)
                    ::cXml+= XmlTag( "xCpl" , Left(fRetiraAcento(::cXcple), 60))
                 Endif 

                 ::cXml+= XmlTag( "xBairro" , Left(fRetiraAcento(::cXBairroe), 60))                                              // Bairro do Emitente
                 ::cXml+= XmlTag( "cMun"    , Left(SoNumero(::cMunfg), 7))                                                       // Código IBGE do emitente
                 ::cXml+= XmlTag( "xMun"    , Left(fRetiraAcento(::cXmune), 60))                                                 // Cidade do Emitente
      	         ::cXml+= XmlTag( "UF"      , Left(::cUfE, 2))                                                                   // UF do Emitente
     	         ::cXml+= XmlTag( "CEP"     , Left(SoNumero(::cCepe), 8))                                                        // CEP do Emitente
    	         ::cXml+= XmlTag( "cPais"   , Left(::cPais, 4))                                                                  // Código do País emitente
    	         ::cXml+= XmlTag( "xPais"   , Left(fRetiraAcento(::cXpaise), 60))                                                // País Emitente da NF

                 If !Empty(SoNumero(::cFonee))
	                ::cXml+= XmlTag( "fone"    , Left(SoNumero(::cFonee), 14))                                                   // Telefone do Emitente
                 Endif 
          ::cXml+= "</enderEmit>"
          
          ::cXml+= XmlTag( "IE" , Left(SoNumero(::cIee), 14))                                                                    // Inscrição Estadual do Emitente

          If !Empty(::cIme)                                                                                                      // Não obrigatório
             ::cXml+= XmlTag( "IM" , Left(SoNumero(::cIme), 15))                                                                 // Inscrição Municipal do Emitente
          Endif 

          If !Empty(::cCnaee)                                                                                                    // Não obrigatório
             ::cXml+= XmlTag( "CNAE" , Left(SoNumero(::cCnaee), 7))                                                              // CNAE do Emitente
          Endif 

          ::cXml+= XmlTag( "CRT" , Iif(Val(::cCrt) <= 1 .or. !(::cCrt $ [1_2_3]), [1], ::cCrt))                                  // Códigos de Detalhamento do Regime e da Situação TABELA A – Código de Regime Tributário – CRT
                                                                                                                                 // 1 – Simples Nacional
                                                                                                                                 // 2 – Simples Nacional – excesso de sublimite da receita bruta
                                                                                                                                 // 3 – Regime Normal NOTAS EXPLICATIVAS
   ::cXml+= "</emit>"                                                                                                            // Final da TAG Emitente
Return (Nil)

* -----------------> Metodo para gerar a tag do destinatário <---------------- *
METHOD fCria_Destinatario() CLASS Malc_GeraXml
   If !Empty(::cCnpjd)
      ::cXml+= "<dest>"
             If !Empty(::cCnpjd)
                If Len(SoNumeroCnpj(::cCnpjd)) < 14                                                                              // Pessoa Física - Cpf
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

             If ::cAmbiente == [2]                                                                                               // Homologação
                ::cXml+= XmlTag( "xNome" , [NF-E EMITIDA EM AMBIENTE DE HOMOLOGACAO - SEM VALOR FISCAL])
             Else                                                                                                                // Produção
                ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomed), 60))
             Endif    

             // Grupo Obrigatório para a NF-e (modelo 55).
             ::cXml+= "<enderDest>"    
                    ::cXml+= XmlTag( "xLgr"     , Left(fRetiraAcento(::cXlgrd), 60))
                    ::cXml+= XmlTag( "nro"      , Left(::cNrod, 60))

                    If !Empty(::cXcpld)
                       ::cXml+= XmlTag( "xCpl"  , Left(::cXcpld, 60))
                    Endif 

                    ::cXml+= XmlTag( "xBairro"  , Left(fRetiraAcento(::cXBairrod), 60))

                    If ::cUfd == [EX]                                                                                            // Importação/Exportação
                       ::cXml+= XmlTag( "cMun"  , [9999999])
                       ::cXml+= XmlTag( "xMun"  , [EXTERIOR])
                       ::cXml+= XmlTag( "UF"    , [EX])
                    Else                                                                                                         // Comércio Interno
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

   	     ::cXml+= XmlTag( "indIEDest" , If(::cModelo == [65] .or. ::cUfd == [EX], "9", Left(::cIndiedest, 1)))                   //   1 = Contribuinte ICMS (informar a IE do destinatário);

             If !Empty(::cIed) .and. !(::cUfd == [EX]) .and. !(::cModelo == [65]) .and. ::cIndiedest == [1]                      //   9 = Não Contribuinte, que pode ou não possuir Inscrição Estadual no Cadastro de Contribuintes do ICMS.
                ::cXml+= XmlTag( "IE" , Left(SoNumero(::cIed), 14))                                                              //   Nota 1: No caso de NFC-e informar indIEDest=9 e não informar a tag IE do destinatário; 
             Endif                                                                                                               //   Nota 2: No caso de operação com o Exterior informar indIEDest=9 e não informar a tag IE do destinatário;
                                                                                                                                 //   Nota 3: No caso de Contribuinte Isento de Inscrição (indIEDest=2), não informar a tag IE do destinatário.
             If !Empty(::cEmaild)
                ::cXml+= XmlTag( "email" , Left(::cEmaild, 60))
             Endif    
      ::cXml+= "</dest>"
   Endif

   ::fCria_Retirada() 
   ::fCria_Entrega()
Return (Nil)

* ----------> Metodo para gerar a tag do // Contador Responsável <------------ *
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

* ----------> Metodo para gerar a tag do endereço de retirada <--------------- *
METHOD fCria_Retirada() CLASS Malc_GeraXml                                                                                       // Marcelo Brigatti
   If Alltrim(::cXlgrd) # Alltrim(::cXlgrr)  // Informar somente se diferente do endereço do remetente.                          // If !Empty(SoNumeroCnpj(::cCnpjr))  // Informar somente se diferente do endereço do remetente.                                  
      ::cXml+= "<retirada>"
             If Len(SoNumeroCnpj(::cCnpjr)) < 14                                                                                 // Pessoa Física - Cpf
                ::cXml+= XmlTag( "CPF"  , Left(SoNumeroCnpj(::cCnpjr), 11))
             Else                                                                                                                // Pessoa Juridica
                ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpjr), 14))
             Endif 

             ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomer), 60))                                                      // Razão Social retirada

             If !Empty(::cXfantr)
                ::cXml+= XmlTag( "xFant" , Left(fRetiraAcento(::cXfantr), 60))                                                   // Nome Fantasia retirada
             Endif 

             ::cXml+= XmlTag( "xLgr"    , Left(fRetiraAcento(::cXlgrr), 60))                                                     // Endereço retirada
             ::cXml+= XmlTag( "nro"     , Left(::cNror, 60))                                                                     // Número do Endereço do retirada

             If !Empty(::cXcplr)
                ::cXml+= XmlTag( "xCpl" , Left(fRetiraAcento(::cXcplr), 60))
             Endif 

             ::cXml+= XmlTag( "xBairro" , Left(fRetiraAcento(::cXBairror), 60))                                                  // Bairro do retirada
             ::cXml+= XmlTag( "cMun"    , Left(SoNumero(::cMunfg), 7))                                                           // Código IBGE do retirada
             ::cXml+= XmlTag( "xMun"    , Left(fRetiraAcento(::cXmunr), 60))                                                     // Cidade do retirada
             ::cXml+= XmlTag( "UF"      , Left(::cUfE, 2))                                                                       // UF do retirada
	         ::cXml+= XmlTag( "CEP"     , Left(SoNumero(::cCepr), 8))                                                            // CEP do retirada
	         ::cXml+= XmlTag( "cPais"   , Left(::cPaisr, 4))                                                                     // Código do País retirada
	         ::cXml+= XmlTag( "xPais"   , Left(fRetiraAcento(::cXpaisr), 60))                                                    // País retirada da NF

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
                 
* -----------> Metodo para gerar a tag do endereço de entrega <--------------- *
METHOD fCria_Entrega() CLASS Malc_GeraXml                                                                                        // Marcelo Brigatti
   If Alltrim(::cXlgrd) # Alltrim(::cXlgrg)  // Informar somente se diferente do endereço destinatário.                          // If !Empty(SoNumeroCnpj(::cCnpjg))  // Informar somente se diferente do endereço destinatário.                                 // If Alltrim(::cXlgrd) # Alltrim(::cXlgrg)  // Informar somente se diferente do endereço destinatário.
      ::cXml+= "<entrega>"
             If Len(SoNumeroCnpj(::cCnpjg)) < 14                                                                                 // Pessoa Física - Cpf
                ::cXml+= XmlTag( "CPF"  , Left(SoNumeroCnpj(::cCnpjg), 11))
             Else                                                                                                                // Pessoa Juridica
                ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpjg), 14))
             Endif 

             ::cXml+= XmlTag( "xNome" , Left(fRetiraAcento(::cXnomeg), 60))                                                      // Razão Social entrega

             If !Empty(::cXfantg)
                ::cXml+= XmlTag( "xFant" , Left(fRetiraAcento(::cXfantg), 60))                                                   // Nome Fantasia entrega
             Endif 

             ::cXml+= XmlTag( "xLgr"    , Left(fRetiraAcento(::cXlgrg), 60))                                                     // Endereço entrega
             ::cXml+= XmlTag( "nro"     , Left(::cNrog, 60))                                                                     // Número do Endereço do entrega

             If !Empty(::cXcplg)
                ::cXml+= XmlTag( "xCpl" , Left(fRetiraAcento(::cXcplg), 60))
             Endif 

             ::cXml+= XmlTag( "xBairro" , Left(fRetiraAcento(::cXBairrog), 60))                                                  // Bairro do entrega
             ::cXml+= XmlTag( "cMun"    , Left(SoNumero(::cMunfg), 7))                                                           // Código IBGE do entrega
             ::cXml+= XmlTag( "xMun"    , Left(fRetiraAcento(::cXmung), 60))                                                     // Cidade do entrega
	         ::cXml+= XmlTag( "UF"      , Left(::cUfg, 2))                                                                       // UF do entrega
    	     ::cXml+= XmlTag( "CEP"     , Left(SoNumero(::cCepg), 8))                                                            // CEP do entrega
	         ::cXml+= XmlTag( "cPais"   , Left(::cPaisg, 4))                                                                     // Código do País entrega
	         ::cXml+= XmlTag( "xPais"   , Left(fRetiraAcento(::cXpaisg), 60))                                                    // País entrega da NF

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

                 ::cXml+= XmlTag( "NCM"      , Iif(Empty(::cNcm), [00], Left(::cNcm, 8)))                                        // Obrigatória informação do NCM completo (8 dígitos). Nota: Em caso de item de serviço ou item que não tenham produto (ex. transferência de crédito, crédito do ativo imobilizado, etc.), informar o valor 00 (dois zeros). (NT 2014/004)

        	 If Len(::cNcm) > 8
        	    ::cXml+= XmlTag( "EXTIPI" , [0] + Right(::cNcm, 2))                                                              // Excessão de IPI 
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
 
                 ::cXml+= XmlTag( "indTot", Iif(!(::cIndtot $ [0_1]), [0], Left(::cIndtot, 1)))                                  // Indica se valor do Item (vProd) entra no valor total da NF-e (vProd). 0=Valor do item (vProd) não compõe o valor total da NF-e 1=Valor do item (vProd) compõe o valor total da NF-e (vProd) (v2.0)

                 If !Empty(::cXped)                                                                                              // Marcelo Brigatti 
                    ::cXml+= XmlTag( "xPed"      , Left(::cXped, 15))                                                            // número do pedido de compra
                    ::cXml+= XmlTag( "nItemPed"  , SoNumero(::nNitemped), 6)                                                     // número do ítem do pedido de compra 
                 Endif   

                 If !Empty(::cNfci)                
                    ::cXml+= XmlTag( "nFCI"      , Left(::cNfci, 36))                                                            // Informação relacionada com a Resolução 13/2012 do Senado Federal. Formato: Algarismos, letras maiúsculas de "A" a "F" e o caractere hífen. Exemplo: B01F70AF-10BF-4B1F-848C-65FF57F616FE
                 Endif   

                 ::fCria_ProdCombustivel()                                                                                       // somente 1 vez correto aqui 1-1
                 ::fCria_ProdVeiculo()                                                                                           // somente 1 vez correto aqui 1-1
                 ::fCria_ProdMedicamento()                                                                                       // somente 1 vez correto aqui 1-1

                 // está errado aqui feito somente para testar xml ou se tiver uma só produto de importação
                 If Len(AllTrim(::cNdi)) > 0
                    ::fCria_ProdImporta()
                 Endif 
          ::cXml+= "</prod>"
           
          ::cXml+= "<imposto>"                                                                                                   // BLOCO M - IMPOSTOS
                 If ::nVtottrib > 0 .and. SubStr(::cCfOp, 2, 3) # [010]                                                          // lei transparência
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
             If ::lVtottrib == .T. .And. ::nVtottrib # 0                                                                         // lei transparência informações adicionais do produtos
                ::cXml+= XmlTag( "infAdProd", Left(Iif(::nVtottrib > 0, [Valor aproximado dos tributos federais, estaduais e municipais: R$ ] + NumberXml(::nVtottrib, 2) + [ Fonte IBPT. ], []) + ::cInfadprod , 500))
             Endif 
          Endif                   
   ::cXml+= "</det>"
Return (Nil)

* ----------------> Metodo para gerar a tag de veicProd <----------------- *
METHOD fCria_ProdVeiculo() CLASS Malc_GeraXml  // Grupo JA. Detalhamento Específico de Veículos novos                                                                               
   If !Empty(::cChassi)
      ::cXml+= "<veicProd>"
             ::cXml+= XmlTag( "tpOp"         , Iif(!(::cTpOp $ [0_1_2_3]), [0], Left(::cTpOp, 1)))                                                              // 1=Venda concessionária, 2=Faturamento direto para consumidor final 3=Venda direta para grandes consumidores (frotista, governo, ...) 0=Outros
             ::cXml+= XmlTag( "chassi"       , Left(Sonumero(::cChassi), 17))                                                                                   // Chassi do veículo - VIN (código-identificação-veículo)
             ::cXml+= XmlTag( "cCor"         , Left(::cCor, 4))                                                                                                 // Cor - Código de cada montadora
             ::cXml+= XmlTag( "xCor"         , Left(::cXcor, 40))                                                                                               // Descrição da Cor 
             ::cXml+= XmlTag( "pot"          , Left(::cPot, 4))                                                                                                 // Potência Motor (CV)             
             ::cXml+= XmlTag( "cilin"        , Left(::cCilin, 9))                                                                                               // Potência máxima do motor do veículo em cavalo vapor (CV). (potência-veículo)
             ::cXml+= XmlTag( "pesoL"        , ::nPesolvei, 4)                                                                                                  // Em toneladas - 4 casas decimais                                                     
             ::cXml+= XmlTag( "pesoB"        , ::nPesobvei, 4)                                                                                                  // Peso Bruto Total - em tonelada - 4 casas decimais
             ::cXml+= XmlTag( "nSerie"       , Left(::cNserie, 9))                                                                                              // Serial (série)
             ::cXml+= XmlTag( "tpComb"       , Iif(!(::cTpcomb $ [01_02_03_04_05_06_07_08_09_10_11_12_13_14_15_16_17_18]), [01], Left(::cTpcomb, 2)))           // Utilizar Tabela RENAVAM (v2.0) 01 - Álcool, 02 - Gasolina, 03 - Diesel, 04 - Gasogênio, 05 - Gás Metano, 06 - Elétrico/Fonte Interna, 07 - Elétrico/Fonte Externa, 08 - Gasolina/Gás Natural Combustível, 09 - Álcool/Gás Natural Combustível, 10 - Diesel/Gás Natural Combustível, 11 - Vide/Campo/Observação, 12 - Álcool/Gás Natural Veicular, 13 - Gasolina/Gás Natural Veicular, 14 - Diesel/Gás Natural Veicular, 15 - Gás Natural Veicular, 16 - Álcool/Gasolina, 17 - Gasolina/Álcool/Gás Natural Veicular, 18 - Gasolina/elétrico                                                    
             ::cXml+= XmlTag( "nMotor"       , Left(::cNmotor, 21))                                                                                             // Número de Motor
             ::cXml+= XmlTag( "CMT"          , ::nCmt, 4)                                                                                                       // CMT - Capacidade Máxima de Tração - em Toneladas 4 casas decimais (v2.0)
             ::cXml+= XmlTag( "dist"         , Left(::cDist, 4))                                                                                                // Distância entre eixos
             ::cXml+= XmlTag( "anoMod"       , Left(::cAnomod, 4))                                                                                              // Ano Modelo de Fabricação
             ::cXml+= XmlTag( "anoFab"       , Left(::cAnofab, 4))                                                                                              // Ano de Fabricação
             ::cXml+= XmlTag( "tpVeic"       , Iif(!(::cTpveic $ [02_03_04_05_06_07_08_10_11_13_14_17_18_19_20_21_22_23_24_25_26]), [02], Left(::cTpveic, 2)))  // Utilizar Tabela RENAVAM, conforme exemplos abaixo: 02=CICLOMOTO; 03=MOTONETA; 04=MOTOCICLO; 05=TRICICLO; 06=AUTOMÓVEL; 07=MICRO-ÔNIBUS; 08=ÔNIBUS; 10=REBOQUE; 11=SEMIRREBOQUE; 13=CAMIONETA; 14=CAMINHÃO; 17=CAMINHÃO TRATOR; 18=TRATOR RODAS; 19=TRATOR ESTEIRAS; 20=TRATOR MISTO; 21=QUADRICICLO; 22=ESP / ÔNIBUS; 23=CAMINHONETE; 24=CARGA/CAM; 25=UTILITÁRIO; 26=MOTOR-CASA
             ::cXml+= XmlTag( "espVeic"      , Iif(!(::cEspveic $ [1_2_3_4_5_6]), [1], Left(::cEspveic, 1)))                                                    // Utilizar Tabela RENAVAM 1=PASSAGEIRO; 2=CARGA; 3=MISTO;4=CORRIDA; 5=TRAÇÃO; 6=ESPECIAL;
             ::cXml+= XmlTag( "VIN"          , Iif(!(::cVin $ [N_R]), [N], Left(::cVin, 1)))                                                                    // Condição do VIN Informa-se o veículo tem VIN (chassi) remarcado. R=Remarcado; N=Normal
             ::cXml+= XmlTag( "condVeic"     , Iif(!(::cCondveic $ [1_2_3]), [1], Left(::cCondveic, 1)))                                                        // Condição do Veículo 1=Acabado; 2=Inacabado; 3=Semiacabado
             ::cXml+= XmlTag( "cMod"         , Left(::cCmod, 6))                                                                                                // Código Marca Modelo                                                  
             ::cXml+= XmlTag( "cCorDENATRAN" , Iif(!(::cCordenatran $ [01_02_03_04_05_06_07_08_09_10_11_13_14_15_16]), [01], Left(::cCorDENATRAN, 2)))          // Segundo as regras de pré-cadastro do DENATRAN (v2.0) 01=AMARELO, 02=AZUL, 03=BEGE,04=BRANCA, 05=CINZA, 06=-DOURADA,07=GRENÁ, 08=LARANJA, 09=MARROM,10=PRATA, 11=PRETA, 12=ROSA, 13=ROXA,14=VERDE, 15=VERMELHA, 16=FANTASIA
             ::cXml+= XmlTag( "lota"         , Left(::cLota, 3))                                                                                                // Quantidade máxima permitida de passageiros sentados, inclusive o motorista. (v2.0)
             ::cXml+= XmlTag( "tpRest"       , Iif(!(::cTprest $ [0_1_2_3_4_9]), [0], Left(::cTprest, 1)))                                                      // Restrição 0=Não há; 1=Alienação Fiduciária; 2=Arrendamento Mercantil; 3=Reserva de Domínio; 4=Penhor de Veículos; 9=Outras. (v2.0)
      ::cXml+= "</veicProd>"
   Endif 
Return (Nil)

* ----------------> Metodo para gerar a Tag arma <---------------------------- *
METHOD fCria_ProdArmamento() CLASS Malc_GeraXml  // Tag arma - Grupo L. Detalhamento Específico de Armamentos
   Local cTexto:= cTexto1:= [], nPosIni, nPosFim

   If !Empty(::cNserie_a)
      If [<det nItem="] + Left(NumberXml( ::nItem, 0 ), 3) + [">] $ ::cXml
         cTexto:= fRemoveDet(::cXml, ::nItem)

         cTexto1+= "<arma>"
                cTexto1+= XmlTag( "tpArma" , Iif(!(::cTparma $ [0_1]), [0], Left(::cTparma, 1)))                                 // Indicador do tipo de arma de fogo 0=Uso permitido; 1=Uso restrito
                cTexto1+= XmlTag( "nSerie" , Left(::cNserie_a, 15))                                                              // Número de série da arma
                cTexto1+= XmlTag( "nCano"  , Left(::cNcano, 15))                                                                 // Número de série do cano
                cTexto1+= XmlTag( "descr"  , Left(fRetiraAcento(::cDescr_a), 256))                                               // Descrição completa da arma, compreendendo: calibre, marca, capacidade, tipo de funcionamento, comprimento e demais elementos que permitam a sua perfeita identificação.
         cTexto1+= "</arma>"

         cTexto := StrTran(cTexto, "</prod>", cTexto1 + "</prod>")
         nPosIni:= Hb_At([<det nItem="] + Left(NumberXml( ::nItem, 0 ), 3) + [">] , ::cXml)
         nPosFim:= Hb_At("</det>", ::cXml, nPosIni) + 6
         ::cXml := Substr(::cXml, 1, nPosIni - 1) + cTexto + Substr(::cXml, nPosFim)
      Endif 
   Endif 

   Release cTexto, cTexto1, nPosIni, nPosFim
Return (Nil)

* ---------------------> Função para remover tag de Detalhe <------------------ *
Static Function fRemoveDet(cTxtXml, nItem)
   Local nPosIni, nPosFim

   nPosIni := Hb_At([<det nItem="] + Left(NumberXml( nItem, 0 ), 3) + [">] , cTxtXml)
   nPosFim := Hb_At("</indTot>", cTxtXml, nPosIni) + 9
   cTxtXml := Substr(cTxtXml, nPosIni, nPosFim)

   Release nPosIni, nPosFim
Return (cTxtXml)

* ----------------> Metodo para gerar a tag de Detalhe Medicam. <------------- *
METHOD fCria_ProdMedicamento() CLASS Malc_GeraXml // Grupo K. Detalhamento Específico de Medicamento e de matérias-primas farmacêuticas
   If !Empty(::nVpmc)
      ::cXml+= "<med>"
             ::cXml+= XmlTag( "cProdANVISA"       , Left(::cProdanvisa, 13))                                                     // Código de Produto da ANVISA - Utilizar o número do registro ANVISA ou preencher com o literal “ISENTO”, no caso de medicamento isento de registro na ANVISA. (Incluído na NT2016.002. Atualizado na NT 2018.005)

             If !Empty(::cXmotivoisencao)
                ::cXml+= XmlTag( "xMotivoIsencao" , Left(::cXmotivoisencao, 255))                                                // Motivo da isenção da ANVISA - Obs.: Para medicamento isento de registro na ANVISA, informar o número da decisão que o isenta, como por exemplo o número da Resolução da Diretoria Colegiada da ANVISA (RDC). (Criado na NT 2018.005) 
             Endif 

             ::cXml+= XmlTag( "vPMC"              , ::nVpmc)                                                                     // Preço máximo consumidor
      ::cXml+= "</med>"
   Endif 
Return (Nil)

* ----------------> Metodo para gerar a tag de combustíveis <----------------- *
METHOD fCria_ProdCombustivel() CLASS Malc_GeraXml                                                                                // Marcelo de Paula, Marcelo Brigatti
   Local cGrupoANP:= [1662,2662,5651,5652,5653,5654,5655,5656,5657,5658,5659,5660,5661,5662,5663,5664,5665,5666,5667,6651,6652,6653,6654,6655,6656,6657,6658,6659,6660,6661,6662,6663,6664,6665,6666,6667,7651,7654,7667]

   // Número ANP para combustíveis
   If ::cCfOp $ cGrupoANP
      ::cXml+= "<comb>"
             ::cXml+= XmlTag( "cProdANP" , Left(Sonumero(::cCprodanp), 9))                                                       // Código de produto da ANP
             ::cXml+= XmlTag( "descANP"  , Left(::cDescanp, 95))                                                                 // Descrição do produto conforme ANP
             If ::nQtemp > 0
                ::cXml+= XmlTag( "qTemp" , ::nQtemp, 4)                                                                          // Quantidade de combustível faturada à temperatura ambiente.
             EndIf   
             ::cXml+= XmlTag( "UFCons"   , Left(::cUfd, 2))

             If ::nQbcprod  > 0
                    ::cXml+= "<CIDE>"
                           ::cXml+= XmlTag( "qBCProd"    , ::nQbcprod, 4)                                                        // Informar a BC da CIDE em quantidade
                           ::cXml+= XmlTag( "vAliqProd"  , ::nValiqprod, 4)                                                      // Informar o valor da alíquota em reais da CIDE
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
                         ::cXml+= XmlTag( "modBC" , [3] )                                                                        // Modalidade de determinação da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Preço Tabelado Máx. (valor); 3=Valor da operação.
                         ::cXml+= XmlTag( "vBC"   , ::nVbc)
                         ::cXml+= XmlTag( "pICMS" , ::nPicms, 4)
                         ::cXml+= XmlTag( "vICMS" , ::nVlicms)
                   ::cXml+= "</ICMS00>"
             Case ::cCsticms == [010]
                   ::cXml+= "<ICMS10>"
                         ::cXml+= XmlTag( "orig"    , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"     , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBC"   , Iif(!(Hb_Ntos(::nModbc) $ [0_1_2_3]), [0], Left(::nModbc, 1)), 0)          // Modalidade de determinação da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Preço Tabelado Máx. (valor); 3=Valor da operação.
                         ::cXml+= XmlTag( "vBC"     , ::nVbc)
                         ::cXml+= XmlTag( "pICMS"   , ::nPicms, 4)
                         ::cXml+= XmlTag( "vICMS"   , ::nVlicms)
                         ::cXml+= XmlTag( "modBCST" , Iif(!(Hb_Ntos(::nModbcst) $ [0_1_2_3_4_5_6]), [3], Left(::nModbcst, 1)), 0) // Modalidade de determinação da BC do ICMS ST. 0=Preço tabelado ou máximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor), 6 = Valor da Operação (NT 2019.001)
                         ::cXml+= XmlTag( "pMVAST"  , ::nPmvast, 4)
                         ::cXml+= XmlTag( "vBCST"   , ::nVbcst)
                         ::cXml+= XmlTag( "pICMSST" , ::nPicmst, 4)
                         ::cXml+= XmlTag( "vICMSST" , ::nVicmsst)
                   ::cXml+= "</ICMS10>"
             Case ::cCsticms == [020]
                   ::cXml+= "<ICMS20>"
                         ::cXml+= XmlTag( "orig"   , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"    , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBC"  , [3] )                                                                       // Modalidade de determinação da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Preço Tabelado Máx. (valor); 3=Valor da operação.
                         ::cXml+= XmlTag( "pRedBC" , ::nPredbc, 4)
                         ::cXml+= XmlTag( "vBC"    , ::nVbc)
                         ::cXml+= XmlTag( "pICMS"  , ::nPicms, 4)
                         ::cXml+= XmlTag( "vICMS"  , ::nVlicms)
                   ::cXml+= "</ICMS20>"
             Case ::cCsticms == [030]
                   ::cXml+= "<ICMS30>"
                         ::cXml+= XmlTag( "orig"     , Iif(!(::cOrig $ [0_1_2_3_4_5_6_7_8]), [0], Left(::cOrig, 1)))
                         ::cXml+= XmlTag( "CST"      , SubStr(::cCsticms, 2, 2))
                         ::cXml+= XmlTag( "modBCST"  , "3" )                                                                     // Modalidade de determinação da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Preço Tabelado Máx. (valor); 3=Valor da operação.
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
                         ::cXml+= XmlTag( "modBCST" , "3" )                                                                      // Modalidade de determinação da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Preço Tabelado Máx. (valor); 3=Valor da operação.
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
                         ::cXml+= XmlTag( "modBCST" , "3" )                                                                      // Modalidade de determinação da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Preço Tabelado Máx. (valor); 3=Valor da operação.
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
                            ::cXml+= XmlTag( "modBC"       , Iif(!(Hb_Ntos(::nModbc) $ [0_1_2_3]), [0], Left(::nModbc, 1)), 0)   // Modalidade de determinação da BC do ICMS. 0=Margem Valor Agregado (%); 1=Pauta (Valor);2=Preço Tabelado Máx. (valor); 3=Valor da operação.
                            ::cXml+= XmlTag( "vBC"         , ::nVbc)
                            ::cXml+= XmlTag( "pICMS"       , ::nPicms, 4)
                            ::cXml+= XmlTag( "vICMS"       , ::nVlicms)
                            ::cXml+= XmlTag( "modBCST"     , Iif(!(::nModbcst $ [0_1_2_3_4_5_6]), [3], Left(::nModbcst, 1)), 0)  // Modalidade de determinação da BC do ICMS ST. 0=Preço tabelado ou máximo sugerido, 1=Lista Negativa (valor), 2=Lista Positiva (valor);3=Lista Neutra (valor), 4=Margem Valor Agregado (%), 5=Pauta (valor), 6 = Valor da Operação (NT 2019.001)
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
             ::cXml+= XmlTag( "vBCFCPUFDest"   , ::nVbcfcpufdest)                                                                // Valor da Base de Cálculo do FCP na UF de destino. (Incluído na NT2016.002)
             ::cXml+= XmlTag( "pFCPUFDest"     , ::nPfcpufdest, 4)                                                               // Percentual adicional inserido na alíquota interna da UF de destino, relativo ao Fundo de Combate à Pobreza (FCP) naquela UF
             ::cXml+= XmlTag( "pICMSUFDest"    , ::nPicmsufdest, 4)                                                              // Alíquota adotada nas operações internas na UF de destino para o produto / mercadoria. A alíquota do Fundo de Combate a Pobreza, se existente para o produto / mercadoria, deve ser informada no campo próprio (pFCPUFDest) não devendo ser somada à essa alíquota interna.
             ::cXml+= XmlTag( "pICMSInter"     , ::nPicmsinter)                                                                  // Alíquota interestadual das UF envolvidas: - 4% alíquota interestadual para produtos importados; - 7% para os Estados de origem do Sul e Sudeste (exceto ES), destinado para os Estados do Norte, Nordeste, Centro- Oeste e Espírito Santo; - 12% para os demais casos.
             ::cXml+= XmlTag( "pICMSInterPart" , ::nPicmsinterpart, 4)                                                           // Percentual de ICMS Interestadual para a UF de destino: - 40% em 2016; - 60% em 2017; - 80% em 2018; - 100% a partir de 2019.
             ::cXml+= XmlTag( "vFCPUFDest"     , ::nVfcpufdest)                                                                  // Valor do ICMS relativo ao Fundo de Combate à Pobreza (FCP) da UF de destino. (Atualizado na NT2016.002)
             ::cXml+= XmlTag( "vICMSUFDest"    , ::nVicmsufdest)                                                                 // Valor do ICMS Interestadual para a UF de destino, já considerando o valor do ICMS relativo ao Fundo de Combate à Pobreza naquela UF.
             ::cXml+= XmlTag( "vICMSUFRemet"   , ::nVicmsufremet)                                                                // Valor do ICMS Interestadual para a UF do remetente. Nota: A partir de 2019, este valor será zero.
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
                       ::cXml+= XmlTag( "CST"  , Iif(!(::cCstipi $ [00_49_50_99]), [00], Left(::cCstipi, 2)))                    // Código da situação tributária do IPI 00=Entrada com recuperação de crédito 49=Outras entradas 50=Saída tributada 99=Outras saídas
                       ::cXml+= XmlTag( "vBC"  , ::nVbcipi)
                       ::cXml+= XmlTag( "pIPI" , ::nPipi, 4)
                       ::cXml+= XmlTag( "vIPI" , ::nVipi)
                ::cXml+= "</IPITrib>"
             Endif 

             If ::cCstipint $ [01_02_03_04_51_52_53_54_55]
                ::cXml+= "<IPINT>"
                       ::cXml+= XmlTag( "CST"  , Iif(!(::cCstipint $ [01_02_03_04_05_51_52_53_54_55]), [01], Left(::cCstipint, 2))) // Código da situação tributária do IPI 01=Entrada tributada com alíquota zero 02=Entrada isenta 03=Entrada não-tributada 04=Entrada imune 05=Entrada com suspensão 51=Saída tributada com alíquota zero 52=Saída isenta 53=Saída não-tributada 54=Saída imune 55=Saída com suspensão
                ::cXml+= "</IPINT>"
             Endif 
      ::cXml+= "</IPI>"   
   Endif 
Return (Nil)

* ------------------> Metodo para gerar a tag IS = Imposto Seletivo <--------- *
METHOD fCria_ProdutoIs() CLASS Malc_GeraXml                                                                                      // Reforma tributária
   If !Empty(::cClasstribis)
      ::cXml+= "<IS>"
             ::cXml+= XmlTag( "CSTIS"        , Left(::cClasstribis, 3))                                                          // Utilizar tabela CÓDIGO DE CLASSIFICAÇÃO TRIBUTÁRIA DO IMPOSTO SELETIVO
             ::cXml+= XmlTag( "cClassTribIS" , Left(::cClasstribis, 6))                                                          // Utilizar tabela CÓDIGO DE CLASSIFICAÇÃO TRIBUTÁRIA DO IMPOSTO SELETIVO
             ::cXml+= XmlTag( "vBCIS"        , ::nVbcis)                                                                         // Valor da Base de Cálculo do Imposto Seletivo
             ::cXml+= XmlTag( "pIS"          , ::nPisis)                                                                         // Alíquota do Imposto Seletivo
             ::cXml+= XmlTag( "pISEspec"     , ::nPisespec, 4)                                                                   // Alíquota específica por unidade de medida apropriada
             ::cXml+= XmlTag( "uTrib"        , Left(::cUtrib_is, 6))                                                             // Unidade de Medida Tributável
             ::cXml+= XmlTag( "qTrib"        , ::nQtrib_is, 4)                                                                   // Quantidade Tributável
             ::cXml+= XmlTag( "vIS"          , (::nVbcis * ::nQtrib_is) * (::nPisis / 100))                                      // Valor do Imposto Seletivo
      ::cXml+= "</IS>"
   Endif 
Return (Nil)

* ----------------------> Metodo para gerar a tag IBSCBS <-------------------- *
METHOD fCria_ProdutoIbscbs() CLASS Malc_GeraXml  // Reforma tributária
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
METHOD fCria_Gibscbsmono() CLASS Malc_GeraXml   // Reforma tributária
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
                         ::cXml+= XmlTag( "CST"     , Iif(!(::cCstPis $ [01_02]), [01], Left(::cCstPis, 2)))                     // 01=Operação Tributável (base de cálculo = valor da operação alíquota normal (cumulativo/não cumulativo));  02=Operação Tributável (base de cálculo = valor da operação (alíquota diferenciada))
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
                         ::cXml+= XmlTag( "CST"       , Iif(!(::cCstPisqtd $ [03]), [03], Left(::cCstPisqtd, 2)))                // Operação Tributável (base de cálculo = quantidade vendida x alíquota por unidade de produto)
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
                         ::cXml+= XmlTag( "CST"       , Iif(!(::cCstPisnt $ [04_05_06_07_08_09]), [04], Left(::cCstPisnt, 2)))   // Código de Situação Tributária do PIS 04=Operação Tributável (tributação monofásica (alíquota zero)); 05=Operação Tributável (Substituição Tributária); 06=Operação Tributável (alíquota zero); 07=Operação Isenta da Contribuição; 08=Operação Sem Incidência da Contribuição; 09=Operação com Suspensão da Contribuição;
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
                         ::cXml+= XmlTag( "CST"     , Iif(!(::cCstPisoutro $ [49_50_51_52_53_54_55_56_60_61_62_63_64_65_66_67_70_71_72_73_74_75_98_99]), [49], Left(::cCstPisoutro, 2))) // Código de Situação Tributária do PIS
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
             ::cXml+= XmlTag( "vFCPUFDest"   , ::nVfcpufdest_t)                                                                    // Complementa o Cálculo com a Diferença de ICMS
             ::cXml+= XmlTag( "vICMSUFDest"  , ::nVicmsufdest_t)                                                                   // Complementa o Cálculo com a Diferença de ICMS
             ::cXml+= XmlTag( "vICMSUFRemet" , ::nVicmsufremet_t)                                                                  // Complementa o Cálculo com a Diferença de ICMS
             ::cXml+= XmlTag( "vFCP"         , ::nVfcp_t)                                                                          // Campo referente a FCP Para versão 4.0
             ::cXml+= XmlTag( "vBCST"        , ::nVbcST_t)
             ::cXml+= XmlTag( "vST"          , ::nVst_t)
             ::cXml+= XmlTag( "vFCPST"       , ::nVfcpst_t)                                                                        // Campo referente a FCP Para versão 4.0
             ::cXml+= XmlTag( "vFCPSTRet"    , ::nVfcpstret_t)                                                                     // Campo referente a FCP Para versão 4.0

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

                If ::cTpOp == [2]  // Exceção 1: Faturamento direto de veículos novos: Se informada operação de Faturamento Direto para veículos novos (tpOp = 2, id:J02): 
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
  (+) vServ (id:W18) (*3) (NT 2011/005) não criamos este grupo
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
             ::cXml+= XmlTag( "modFrete" , Iif(!(::cModFrete $ [0_1_2_3_4_9]), [0], Left(::cModFrete, 1)))                       // Modalidade do frete 0=Contratação do Frete por conta do Remetente (CIF); 1=Contratação do Frete por conta do Destinatário (FOB); 2=Contratação do Frete por conta de Terceiros; 3=Transporte Próprio por conta do Remetente; 4=Transporte Próprio por conta do Destinatário;9=Sem Ocorrência de Transporte. (Atualizado na NT2016.002)

             If ::cModFrete # [9]
                ::cXml+= "<transporta>"
                       If !Empty(::cXnomet)
                          If !Empty(::cCnpjt) .and. Len(SoNumeroCnpj(::cCnpjt)) < 14                                             // Pessoa Física - Cpf
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

             // Informações de Volumes
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

* ------------------> Metodo para gerar a tag de Cobrança <------------------- *
METHOD fCria_Cobranca() CLASS Malc_GeraXml  // Grupo Y. Dados da Cobrança
   If !Empty(::cNfat)
      If !("<cobr>") $ ::cXml
         ::cXml+= "<cobr>" 
      Endif 
         If !("<fat>") $ ::cXml
            ::cXml+= "<fat>"
                   ::cXml+= XmlTag( "nFat"     , Left(::cNfat, 60))                                                              // Número da Fatura
                   ::cXml+= XmlTag( "vOrig"    , ::nVorigp)                                                                      // Valor Original da Fatura
         
                   If !Empty(::nVdescp)
                      ::cXml+= XmlTag( "vDesc" , ::nVdescp)                                                                      // Valor do desconto
                   Endif 

                   ::cXml+= XmlTag( "vLiq"     , ::nVliqup)                                                                      // Valor Líquido da Fatura
            ::cXml+= "</fat>"
         Endif 
         If "</fat></cobr><dup>" $ ::cXml
            ::cXml:= StrTran(::cXml, "</fat></cobr><dup>", "</fat><dup>")
         EndIf   

         If !Empty(::nVdup)
             ::cXml+= "<dup>"
                    ::cXml+= XmlTag( "nDup"  , Left(::cNDup, 60))                                                                // Obrigatória informação do número de parcelas com 3 algarismos, sequenciais e consecutivos. Ex.: “001”,”002”,”003”,... Observação: este padrão de preenchimento será Obrigatório somente a partir de 03/09/2018
                    ::cXml+= XmlTag( "dVenc" , DateXml(::dDvencp))                                                               // Formato: “AAAA-MM-DD”. Obrigatória a informação da data de vencimento na ordem crescente das datas. Ex.: “2018-06-01”,”2018-07-01”, “2018-08-01”,...
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
METHOD fCria_Pagamento() CLASS Malc_GeraXml // Grupo YA. Informações de Pagamento
   If !("<pag>") $ ::cXml
      ::cXml+= "<pag>" 
   Endif  

   ::cXml+= "<detPag>" 
          If !(::cTpag $ [90_99])
             ::cXml+= XmlTag( "indPag" , Iif(!(::cIndPag $ [0_1]), [0], Left(::cIndPag, 1)))                                     // Indicação da Forma de Pagamento 0= Pagamento à Vista 1= Pagamento à Prazo (Incluído na NT2016.002)
          Endif     

          ::cXml+= XmlTag( "tPag"      , Iif(!(::cTpag $ [01_02_03_04_05_10_11_12_13_15_16_17_18_19_90_99]), [01], Left(::cTpag, 2)))  // Meio de pagamento 01=Dinheiro 02=Cheque 03=Cartão de Crédito 04=Cartão de Débito 05=Crédito Loja 10=Vale Alimentação 11=Vale Refeição 12=Vale Presente 13=Vale Combustível 15=Boleto Bancário 16=Depósito Bancário 17=Pagamento Instantâneo (PIX) 18=Transferência bancária, Carteira Digital 19=Programa de fidelidade, Cashback, Crédito Virtual 90= Sem pagamento 99=Outros (Atualizado na NT2016.002, NT2020.006)

          If ::cTpag == [99]
             ::cXml+= XmlTag( "xPag" , Left(::cXpag, 60))                                                                        // Descrição do meio de pagamento. Preencher informando o meio de pagamento utilizado quando o código do meio de pagamento for informado como 99-outros.
          Endif  
  
          If ::cTpag # [90]
             ::cXml+= XmlTag( "vPag" , ::nVpag)
          Else
             ::cXml+= XmlTag( "vPag" , 0)                                                                                        // Valor do Pagamento
          Endif  

          If ::nTpintegra # 0 // não repete 
             ::cXml+= "<card>"
                    ::cXml+= XmlTag( "tpIntegra" , Iif(!(Hb_Ntos(::nTpintegra) $ [1_2]), [1], Hb_Ntos(::nTpintegra, 1)))         // 1=Pagamento integrado com o sistema de automação da empresa (Ex.: equipamento TEF, Comércio Eletrônico) | 2= Pagamento não integrado com o sistema de automação da empresa 

                    If !Empty(::cCnpjpag)
                       ::cXml+= XmlTag( "CNPJ"   , Left(SoNumeroCnpj(::cCnpjpag), 14))                                           // Informar o CNPJ da instituição de pagamento, adquirente ou subadquirente. Caso o pagamento seja processado pelo intermediador da transação, informar o CNPJ deste (Atualizado na NT 2020.006                                                       // CNPJ do Emitente
                    Endif  
  
                    If !Empty(::cTband)  
                       ::cXml+= XmlTag( "tBand"  , Iif(!(::cTband $ [01_02_03_04_05_06_07_08_09_99]), [0], Left(::cTband, 2)))   // Bandeira da operadora de cartão de crédito e/ou débito 01=Visa 02=Mastercard 03=American Express 04=Sorocred 05=Diners Club 06=Elo 07=Hipercard 08=Aura 09=Cabal 99=Outros (Atualizado na NT2016.002
                    Endif  

                    If !Empty(::cAut)
                       ::cXml+= XmlTag( "cAut"   , Left(::cAut, 20))                                                             // Identifica o número da autorização da transação da operação com cartão de crédito e/ou débito
                    Endif  
             ::cXml+= "</card>"
          Endif   
   ::cXml+= "</detPag>" 

   If !Empty(::nVtroco) // não repete
      ::cXml+= XmlTag( "vTroco" , ::nVtroco)                                                                                     // Valor do troco (Incluído na NT2016.002
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

* ------------> Metodo para gerar a tag de Informações Adicionais <----------- *
METHOD fCria_Informacoes() CLASS Malc_GeraXml
   ::cXml+= "<infAdic>"
          If ::lComplementar                                                                                                     // Informações DIFAL
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
 		::cInfFisc+= "Cód:" + ::cCodDest + hb_OsNewLine()
             Endif 
          Endif 

          If !Empty(AllTrim(::cInfFisc))
             ::cXml+= XmlTag( "infAdFisco" , Left(fRetiraAcento(StrTran(::cInfFisc, hb_OsNewLine(), "; ")), 2000))
          Endif 

          If !Empty(AllTrim(::cInfcpl))
             ::cXml+= XmlTag( "infCpl" , Left(CharRem("°ºª-:\(){}[]`´’'", fRetiraAcento(StrTran(::cInfcpl, hb_OsNewLine(), '; '))), 5000))
          *  ::cXml+= XmlTag( "infCpl" , Left(fRetiraAcento(StrTran(::cInfcpl, hb_OsNewLine(), '; ')), 5000))
          Endif 
   ::cXml+= "</infAdic>"
Return (Nil)

* ----------> Metodo para gerar a tag de Declaração de Importação <----------- *
METHOD fCria_ProdImporta() CLASS Malc_GeraXml                                                                                    // Colaboração Rubens Aluotto, Marcelo Brigatti
   If Substr(Alltrim(::cCfop), 1, 1) == [3]
      ::cXml+= "<DI>"
             ::cXml+= XmlTag( "nDI" , Left(::cNdi, 12))                                                                          // número do docto de importação DI/DSI/DA - 1-10 C  
             ::cXml+= XmlTag( "dDI" , DateXml(::dDdi))                                                                           // Data do documento de importação - AAAA-MM-DD
             ::cXml+= XmlTag( "xLocDesemb" , Left(fRetiraAcento(::cXlocdesemb), 60))                                             // Local do Desembarque da importação  
             ::cXml+= XmlTag( "UFDesemb" , Left(::cUfdesemb, 2))                                                                 // sigla da UF onde ocorreu o desembaraço aduaneiro - 2 C 
             ::cXml+= XmlTag( "dDesemb" , DateXml(::dDdesemb))                                                                   // Data do desembaraço aduaneiro - AAAA-MM-DD
             ::cXml+= XmlTag( "tpViaTransp" , Iif(!(Hb_Ntos(::nTpviatransp) $ [1_2_3_4_5_6_7]), [1], Hb_Ntos(::nTpviatransp)))   // Via de transporte internacional informada na Declaração de Importação (DI)
                                                                                                                                 // 1 - marítima, 2 - fluvial, 3 - Lacustre, 4 - aérea, 5 - postal, 6 - ferrovia, 7 - rodovia
             If ::nTpviatransp == 1
                ::cXml+= XmlTag( "vAFRMM" , ::nVafrmm)                                                                           //  valor somente informar no caso do tpViaTransp == 1 ( 15,2 n )
             Endif 

             ::cXml+= XmlTag( "tpIntermedio" , Iif(!(Hb_Ntos(::nTpintermedio) $ [1_2_3]), [1], Hb_Ntos(::nTpintermedio)))        // Forma de importação quanto a intermediação. 1 - importação por conta própria, 2 - importação por conta e ordem, 3 - importação por encomenda
             If !(Empty(::cCnpja)) 
                ::cXml+= XmlTag( "CNPJ" , Left(SoNumeroCnpj(::cCnpja), 14))                                                      // cnpj do adquirinte ou encomendante  </CNPJ>
             Endif 
             If ::nTpintermedio # 1 .and. ::cUfterceiro # [EX]
                ::cXml+= XmlTag( "UFTerceiro" , Left(::cUfterceiro, 2))                                                          // Obrigatória a informação no caso de importação por conta e ordem ou por encomenda. Não aceita o valor "EX".
             Endif 
 
             ::cXml+= XmlTag( "cExportador" , Left(fRetiraAcento(::cCexportador), 60))                                           // código do exportador 1-60 c  

             // For i:= 1 to 100
             If !Empty(::nNadicao)
                ::cXml+= "<adi>"    // BLOCO I
                       ::cXml+= XmlTag( "nAdicao" , ::nNadicao, 0)                                                               // número da adicao 1-3
                       ::cXml+= XmlTag( "nSeqAdic" , ::nNseqadic, 0)                                                             // número sequencial do ítem dentro da adição 1-3
                       ::cXml+= XmlTag( "cFabricante" , Left(::cCfabricante, 60))                                                // Código do fabricante estrangeiro - 1-60 c
                       If ::nVdescdi > 0
                          ::cXml+= XmlTag( "vDescDI" , ::nVdescdi)                                                               // Valor do desconto do ítem da DI - adição n 15,2 ( se houver )
                       Endif    
                       If !(Empty(::cNdraw)) 
                          ::cXml+= XmlTag( "nDraw" , Left(SoNumero(::cNdraw), 11))                                               // O número do Ato Concessório de Suspensão deve ser preenchido com 11 dígitos (AAAANNNNNND) e o número do Ato Concessório de Drawback Isenção deve ser preenchido com 9 dígitos (AANNNNNND). (Observação incluída na NT 2013/005 v. 1.10)
                       Endif    
                ::cXml+= "</adi>"
             Endif 
             // Next
       ::cXml+= "</DI>"

       // For i:= 1 to 500
       // Grupo I03. Produtos e Serviços / Grupo de Exportação
       If !Empty(::cNdraw)
          ::cXml+= "<detExport>"                                                                                                 // Grupo de informações de exportação para o item
                 ::cXml+= XmlTag( "nDraw" , Left(SoNumero(::cNdraw), 11))                                                        // O número do Ato Concessório de Suspensão deve ser preenchido com 11 dígitos (AAAANNNNNND) e o número do Ato Concessório de Drawback Isenção deve ser preenchido com 9 dígitos (AANNNNNND). (Observação incluída na NT 2013/005 v. 1.10)
          ::cXml+= "</detExport>"    

          ::cXml+= "<exportInd>"                                                                                                 // Grupo sobre exportação indireta
            ::cXml+= XmlTag( "nRE"     , Left(Sonumero(::nNre), 12), 0)                                                          // Número do Registro de Exportação
            ::cXml+= XmlTag( "chNFe"   , Left(::cChnfe, 44))                                                                     // Chave de Acesso da NF-e recebida para exportação NF-e recebida com fim específico de exportação. No caso de operação com CFOP 3.503, informar a chave de acesso da NF-e que efetivou a exportação 
            ::cXml+= XmlTag( "qExport" , ::nQexport, 4)                                                                          // Quantidade do item realmente exportado A unidade de medida desta quantidade é a unidade de comercialização deste item. No caso de operação com CFOP 3.503, informar a quantidade de mercadoria devolvida
          ::cXml+= "</exportInd>"
       Endif 
       // Next
   Endif 
Return (Nil)

* -----------------> Metodo para gerar a tag de Exportação <------------------ *
METHOD fCria_ProdExporta() CLASS Malc_GeraXml                                                                                    // Colaboração Rubens Aluotto - 16/06/2025
   If !Empty(::cUfSaidapais) .and. Substr(SoNumero(::cCfOp), 1, 1) == [7]
      ::cXml+= "<exporta>"
             ::cXml+= XmlTag( "UFSaidaPais" , Left(::cUfSaidapais, 2))
             ::cXml+= XmlTag( "xLocExporta" , Left(::cXlocexporta, 60))
             ::cXml+= XmlTag( "xLocDespacho", Left(::cXlocdespacho, 60))
      ::cXml+= "</exporta>"
   Endif 
Return (Nil)

* ------------> Metodo para gerar a tag do Responsável Técnico <-------------- *
METHOD fCria_Responsavel() CLASS Malc_GeraXml
   If !Empty(::cRespNome) .and. !Empty(::cRespcnpj) .and. !Empty(::cRespemail)
      ::cXml+= "<infRespTec>" 
             ::cXml+= XmlTag( "CNPJ"     , Left(SoNumeroCnpj(::cRespcnpj), 14))                                                  // CNPJ do Responsável Técnico
             ::cXml+= XmlTag( "xContato" , Left(fRetiraAcento(::cRespNome), 60))                                                 // Contato do Responsável Técnico
             ::cXml+= XmlTag( "email"    , Left(fRetiraAcento(::cRespemail), 60))                                                // E-mail do Responsável Técnico
             ::cXml+= XmlTag( "fone"     , Left(fRetiraSinal(::cRespfone), 14))                                                  // Telefone do Responsável Técnico
      ::cXml+= "</infRespTec>" 
   Endif 
Return (Nil)

* -----------> Metodo para gerar a tag do Imposto de Importação <------------- *
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

* ----------> Função para Retirar Caracteres/Sinais de uma String <----------- *
Static Function fRetiraSinal(cStr, cEliminar)
   hb_Default(@cEliminar, "°ºª /;-:,\.(){}[]`´’' ")
Return (cStr:= CharRem(cEliminar, cStr))

* ------------------> Retira Acentos e Letras de uma String <----------------- *
Static Function fRetiraAcento(cStr)
   Local aLetraCAc:= {[Á],[À],[Ä],[Ã],[Â],[É],[È],[Ë],[Ê],[&],[Í],[Ì],[Ï],[Î],[Ó],[Ò],[Ö],[Õ],[Ô],[Ú],[Ù],[Ü],[Û],[Ç],[Ñ],[Ý],[á],[à],[ä],[ã],[â],[é],[è],[ë],[ƒ],[ê],[í],[ì],[ï],[î],[ó],[ò],[ö],[õ],[ô],[ú],[ù],[ü],[û],[ç],[ñ],[ý],[ÿ],[º] ,[ª] ,[‡],[Æ],[¡],[£],[ÿ],[ ],[á],[ ] ,[ ],[ ],[‚],[ˆ],[“],[¢],[…],[°],[A³],[A§],[Ai],[A©],[Ao.],[’],[´] }
   Local aLetraSAc:= {[A],[A],[A],[A],[A],[E],[E],[E],[E],[E],[I],[I],[I],[I],[O],[O],[O],[O],[O],[U],[U],[U],[U],[C],[N],[Y],[a],[a],[a],[a],[a],[e],[e],[e],[a],[e],[i],[i],[i],[i],[o],[o],[o],[o],[o],[u],[u],[u],[u],[c],[n],[y],[y],[o.],[a.],[c],[a],[i],[u],[a],[a],[a],[E ],[a],[ ],[e],[e],[o],[o],[a],[],[o],[c],[a],[e],[u],[],[]}, i
   hb_Default(@cStr, [])

   For i:= 1 To Len(aLetraCAc)
       cStr:= StrTran(cStr, aLetraCAc[i], aLetraSAc[i])
   Next
   Release aLetraCAc, aLetraSAc, i
Return (cStr)

* ------> Alteração da função original da sefazclass - ze_xmlfunc.prg <------- *
#ifndef DOW_DOMINGO
#define DOW_DOMINGO 1
#Endif 

* ---------------> Alteração da função original da sefazclass <---------------- *
Static Function XmlTag( cTag, xValue, nDecimals, lConvert )                                                                      // alteração da função original da sefazclass - ze_xmlfunc.prg
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

* ----------------------> Função para transformar datas <--------------------- *
Static Function DateXml( dDate )
Return Transform( Dtos( dDate ), "@R 9999-99-99" )

* ---------------------> Função para transformar números <-------------------- *
Static Function NumberXml( nValue, nDecimals )                                                                                   // alteração da função original da sefazclass - ze_xmlfunc.prg
   hb_Default( @nDecimals, 0 )
 
   IF nValue < 0                                                                                                                 // alteração
      nValue:= 0
   Endif 
Return Ltrim( Str( nValue, 16, nDecimals ) )

* ----------------> Função para retirar caracteres especiais <---------------- *
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
   cTexto := StrTran( cTexto, "º", "&#176;" )
   cTexto := StrTran( cTexto, "ª", "&#170;" )

Return cTexto

* ----------------------> Função para transformar datas <--------------------- *
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
   // SP não tem mais horário de verão
   CASE cUF $ "AM,MT,MS,RO,RR"                                 ; cText += "-04:00"
   OTHERWISE                                                   ; cText += "-03:00"                                               // demais casos
   ENDCASE

Return cText

* ----------------> Função para cálculo do Domingo de Páscoa <---------------- *
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

* ----------------> Função para cálculo do Terça de Carnaval <---------------- *
Static Function TercaDeCarnaval( nAno )
Return DomingoDePascoa( nAno ) - 47

* ------------> Função para cálculo do Horário de Verão início <-------------- *
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

* ------------> Função para cálculo do Horário de Verão término <------------- *
Static Function HorarioVeraoTermino( nAno )
   Local dPrimeiroDeFevereiro, dPrimeiroDomingoDeFevereiro, dTerceiroDomingoDeFevereiro

   dPrimeiroDeFevereiro := Stod( StrZero( nAno + 1, 4 ) + "0201" )
   dPrimeiroDomingoDeFevereiro := dPrimeiroDeFevereiro + iif( Dow( dPrimeiroDeFevereiro ) == DOW_DOMINGO, 0, ( 7 - Dow( dPrimeiroDeFevereiro ) + 1 ) )
   dTerceiroDomingoDeFevereiro := dPrimeiroDomingoDeFevereiro + 14
   IF dTerceiroDomingoDeFevereiro == TercaDeCarnaval( nAno + 1 ) - 2                                                             // /* nao pode ser domingo de carnaval */
      dTerceiroDomingoDeFevereiro += 7
   Endif 

Return dTerceiroDomingoDeFevereiro
* ---> Fim da Alteração da função original da sefazclass - ze_xmlfunc.prg <--- *

* -----> Alteração da função original da sefazclass - ze_xmldigitoc.prg <----- *
* --------------> Função para cálculo do dígito do módulo 11 <---------------- *
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
* --> Fim da Alteração da função original da sefazclass - ze_xmldigitoc.prg <- *

* ------> Alteração da função original da sefazclass - ze_miscfunc.prg  <----- *
* -------------> Função para verificar de o caracter é número <--------------- *
Static Function SoNumero( cTxt )
   Local cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF cChar $ "0123456789"
         cSoNumeros += cChar
      Endif 
   NEXT
Return cSoNumeros

* -----------> Função para verificar de o caracter é número no CNPJ <--------- *
Static Function SoNumeroCnpj( cTxt )
   Local cSoNumeros := "", cChar

   FOR EACH cChar IN cTxt
      IF ( cChar >= "0" .AND. cChar <= "9" ) .OR. ( cChar >= "A" .AND. cChar <= "Z" )
         cSoNumeros += cChar
      Endif 
   NEXT

Return cSoNumeros
* ---> Fim da Alteração da função original da sefazclass - ze_miscfunc.prg <-- ** ---> Fim da Alteração da função original da sefazclass - ze_miscfunc.prg <-- *
