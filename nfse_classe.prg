/*****************************************************************************
 * SISTEMA  : GERAL                                                          *
 * PROGRAMA : NFSE_CLASSE.PRG                                                *
 * OBJETIVO : CLASSE PARA GERAÇÃO DE XML DE NFSe's                           *
 * AUTOR    : Marcelo Brigatti                                               *
 * ALTERADO : Franklin Brasil                                                *
 * ALTERADO : Marcelo Antonio Lázzaro Carli                                  *
 * PREFEITURAS IMPLEMENTADAS: São Paulo e Cotia/SP                           *
 * DATA     : 14.07.2025                                                     *
 * ULT. ALT.: 03.06.2026                                                     *
 *****************************************************************************/
#include <hbclass.ch>
**#include <minigui.ch>  /// usei por causa do MsgInfo mas podemos tirar                            
/*
https://www.nfse.gov.br/ConsultaPublica/NFSe/Impressao?chave=MDhXVVA0Yy
https://www.nfse.gov.br/ConsultaPublica/Download/DANFSe?chave=MDhXVVA0Y
https://www.nfse.gov.br/ConsultaPublica?tpc=1&chave=4104303122535444800
*/




******************************************************************************
*** OBS: Precisa linkar na compilação C:\Borland\bcc58\Lib\PSDK\crypt32.lib;C:\Borland\bcc58\Lib\PSDK\advapi32.lib;C:\Borland\bcc58\Lib\PSDK\cryptui
******************************************************************************

#define WS_CANCELAMENTONFE           1
#define WS_ENVIOLOTERPS              2
#define WS_ENVIORPS                  3
#define WS_CONSULTARPS               4
#define WS_TESTEENVIOLOTERPS         5

CLASS MM_GeraXmlNFSe
   // Configurações iniciais básicas
   VAR cXml                         AS Character INIT []
   VAR cAmbiente                    AS Character INIT [1]                                      // 1 Produção 2 - Homologação sp, foz não tem mais o ambiente de homologação
   VAR nTempoEspera                 AS Num       INIT .7                                       // intervalo entre envia lote e consulta recibo
   VAR nWsServico                   AS Int       INIT 5                                        // Serviço de Envio de Rps
   VAR cPasta                       AS Character INIT GetCurrentFolder() + [\Nfse]             // Pasta padrão para geração  // Pasta do Arquivo de Log de retornos: MM_NFSeClasse.log
   VAR cCertificado                 AS Character INIT [NENHUM]                                 // Nome do certificado (Somente o Nome)
   VAR cCertNomecer                 AS Character INIT []                                       // Nome do certificado retornado (Nome completo CN=Nome do certificado, .....)
   VAR cCertEmissor                 AS Character INIT []                                       // Nome do Emissor do certificado retornado
   VAR dCertDataini                              INIT Ctod([])                                 // Data Inicial de Validade do certificado retornado
   VAR dCertDatafim                              INIT Ctod([])                                 // Data Final de Validade do certificado retornado
   VAR cCertImprDig                 AS Character INIT []                                       // Impressão Digital do certificado retornado
   VAR cCertSerial                  AS Character INIT []                                       // Número Serial do certificado retornado
   VAR nCertVersao                  AS Num       INIT 0                                        // Versão do certificado retornado
   VAR lCertInstall                 AS Logical   INIT .F.                                      // Verifica se o Certificado está Instalado no Repositório do Windows
   VAR lCertVencido                 AS Logical   INIT .F.                                      // Verifica se o Certificado está Vencido
   VAR cPassword                    AS Character INIT []                                       // Senha de arquivo PFX ou Senha de acesso ao WS
   VAR cToken                       AS Character INIT []                                       // Token necessário para Header Authorization

   VAR oCertificado                                                                            // Objeto do certificado capturado
   VAR cUrlWS                       AS Character INIT []                                       // URL do Web Service SVAN
   VAR cChaveDce                    AS Character INIT []                                       // Armazenará a chave gerada automaticamente

   // XMLs de cada etapa 
   VAR cXmlDocumento                AS Character INIT []                                       // O documento oficial, com ou sem assinatura, depende do documento
   VAR cXmlEnvio                    AS Character INIT []                                       // usado pra criar/complementar XML do documento
   VAR cXmlSoap                     AS Character INIT []                                       // XML completo enviado pra Sefaz, incluindo informações do envelope
   VAR cXmlRetorno                  AS Character INIT [Erro Desconhecido]                      // Retorno do webservice e/ou rotina
   VAR cXmlProtocolo                AS Character INIT []                                       // XML protocolo (obtido no consulta recibo e/ou envio de outros docs)
   VAR cXmlAutorizado               AS Character INIT []                                       // XML autorizado, caso tudo ocorra sem problemas
   VAR cStatus                      AS Character INIT Space(3)                                 // Status obtido da resposta final da Fazenda
   VAR cXmlUtf8                     AS Character INIT [<?xml version="1.0" encoding="UTF-8"?>]
   
   // uso interno                                                         
   VAR cSoapService                 AS Character INIT []                                       // webservice Serviço
   VAR cSoapAction                  AS Character INIT []                                       // webservice Action
   VAR cSoapURL                     AS Character INIT []                                       // webservice Endereço
   VAR nSoapTimeOut                 AS Int       INIT 15000                                    // Limite de espera por resposta em segundos * 1000
   VAR cProxyUrl                    AS Character INIT []
   VAR cProxyUser                   AS Character INIT []
   VAR cProxyPassword               AS Character INIT []
   VAR lEnvioZip                    AS Logical   INIT .F.                                      // Envio de zip
   VAR lComUri                      AS Logical   INIT .F.                                      // Não tem tag cUri

   // Grupo Cabeçalho - TAG raiz do cabeçalho da mensagem
   VAR nCodigoMunicipio             AS Int       INIT 0                                        // Código do Municipio
   VAR ngVersaoSchema               AS Num       INIT 1                                        // Versão do leiaute. O conteúdo deste campo indica a versão do leiaute XML da estrutura XML informada na área de dados da mensagem.

   // Grupo tcLoteRps
   VAR ngQuantidadeRps              AS Num       INIT 0                                        // QuantidadeRps-TsQuantidadeRps (ocor 1-1, Numérico máx 4)  
   VAR nValorTotalServicos          AS Num       INIT 0                                        // Total de Serviços do Lote
   VAR nValorTotalDeducoes          AS Num       INIT 0                                        // Total de Deduções do Lote

   // Grupo tcIdentificacaoRps
   VAR ngNumeroRps                  AS Int       INIT 0                                        // Número do RPS máx 15 
   VAR cgSerieRps                   AS Character INIT [1]                                      // Número de série do RPS máx 5 
   VAR ngTipoRps                    AS Int       INIT 1                                        // Código de tipo de RPS - 1 - RPS | 2 – Nota Fiscal Conjugada (Mista) | 3 – Cupom 
   
   // Grupo TcInfRps
   VAR dgDataEmissao                AS Date      INIT Ctod([])                                 // Data da emissão da NFSe
   VAR ngNaturezaOperacao           AS Int       INIT 1                                        // 1 – Tributação no município | 2 - Tributação fora do município | 3 - Isenção | 4 - Imune | 5 –Exigibilidade suspensa por decisão judicial | 6 – Exigibilidade suspensa por procedimento administrativo 
   VAR ngRegimeEspecialTributacao   AS Int       INIT 6                                        // 1 – Microempresa municipal | 2 - Estimativa | 3 – Sociedade de profissionais | 4 – Cooperativa | 5 - Microempresário Individual (MEI) | 6 - Microempresário e Empresa de Pequeno Porte ME EPP)
   VAR ngOptanteSimplesNacional     AS Int       INIT 0                                        // 1 - Sim | 2 - Não
   VAR ngIncentivadorCultural       AS Int       INIT 0                                        // 1 - Sim | 2 - Não  
   VAR ngStatus                     AS Int       INIT 0                                        // 1 – Normal | 2 – Cancelado
   VAR cNumNfse                     AS Character INIT []                                       // Número da Nota, retornado na emissão
   VAR cSituacao                    AS Character INIT []                                       // Situação da nota fiscal eletrônica  
   VAR cgSerieNfe                   AS Character INIT [1]                                      // Número de série da Nfe máx 5 
   VAR cAutenticidade               AS Character INIT []                                       // (HASH) Autenticidade presente na Nota fiscal eletrônica
   VAR cMotivo                      AS Character INIT []                                       // Motivo de Cancelamento 
   VAR cgInfAdic                    AS Character INIT []
   
   // Grupo TcDadosServico
   VAR ngValorServico               AS Num       INIT 0                                     
   VAR ngAliquotaServico            AS Num       INIT 0                                     
   VAR ngIssRetido                  AS Int       INIT 2                                        // 1 - Sim | 2 - Não
   VAR cgItemListaServico           AS Character INIT []                                       // 1401 - Código do serviço
   VAR cgCodigoCnae                 AS Character INIT []                                       // 4520001 - Código do CNAE
   VAR cgCodigoTributacaoMunicipio  AS Character INIT []                                       // 452000100 - Código de Tributação no Município
   VAR cgDiscriminacao              AS Character INIT []
   VAR cgObservacao                 AS Character INIT []
   VAR cgCodigoMunicipioIbge        AS Character INIT [] 
   VAR ngQuantidadeServicos         AS Num       INIT 0
   VAR cClassTribIBSCBS             AS Character INIT [000001]                                 // Classtrib da RTC
   
   // Grupo tcDadosPrestador
   VAR cgCnpjp                      AS Character INIT []                                       // Cnpj prestador  
   VAR cgInscricaoMunicipalp        AS Character INIT []                                       // InscricaoMunicipal prestador
   VAR cgRazaoSocialp               AS Character INIT []
   VAR cgEnderecop                  AS Character INIT []
   VAR cgNumerop                    AS Character INIT []
   VAR cgComplementoEnderecop       AS Character INIT []
   VAR cgBairrop                    AS Character INIT []
   VAR cgCodigoMunicipiop           AS Character INIT []
   VAR cgUfp                        AS Character INIT []
   VAR cgCepp                       AS Character INIT []
   VAR cgTelefonep                  AS Character INIT []
   VAR cgEmailp                     AS Character INIT []
   VAR cIep                         AS Character INIT []
   VAR cCrt                         AS Character INIT []
   
   // Grupo tcDadosTomador
   VAR cgCnpjt                      AS Character INIT []                                       // Cnpj tomador
   VAR cgInscricaoMunicipalt        AS Character INIT []                                       // InscricaoMunicipal tomador
   VAR cgRazaoSocialt               AS Character INIT []
   VAR cgFantasiat                  AS Character INIT []
   VAR cgTipoLogradourot            AS Character INIT []
   VAR cgEnderecot                  AS Character INIT []
   VAR cgNumerot                    AS Character INIT []
   VAR cgComplementoEnderecot       AS Character INIT []
   VAR cgBairrot                    AS Character INIT []
   VAR cgCodigoMunicipiot           AS Character INIT []
   VAR cgMunicipiot                 AS Character INIT []
   VAR cgUft                        AS Character INIT []
   VAR cgCept                       AS Character INIT []
   VAR cgTelefonet                  AS Character INIT []
   VAR cgEmailt                     AS Character INIT []
   VAR cgIet                        AS Character INIT []
      
   // Método para gerar o XML da NFSe   
   METHOD New()         CONSTRUCTOR
   METHOD ExecutaNfse() CONSTRUCTOR                                                            // Executa métodos da NFse (Lote RPS, Consulta, Cancelamento)

   // Métodos para setar, assinar e enviar o XML
   METHOD Setup()
   METHOD XmlSoapEnvelopeNfse()
   METHOD XmlSoapPostNfse()
   METHOD MicrosoftXmlSoapPostNfse()
   METHOD AssinaXml()
   METHOD Gera_Chave_SHA1() 
   METHOD MontaStringAssinaturaRpsSpV1e2()
   METHOD fCertificadoNative()
   METHOD fCertificadoPfx()

   // Métodos para consumir os WebServices da NFSe
   METHOD fCria_Xml_Para_Rps()                                                                 // fEnvia_Nfse() -> renomeado para fCria_Xml_Para_Rps()
   METHOD fConsulta_Retorno_Rps_Enviado()                                                      // Consulta (exibe, grava) os retornos de: fCria_Xml_Para_Rps() 
   METHOD fConsulta_Nfse()
   METHOD fCancela_Nfse()

   // Métodos auxiliares
   METHOD fRetiraAcento()                                                                      // cString 
   METHOD XmlTag()                                                                             // cTag, xValue, nDecimals, lConvert
   METHOD DateXml()                                                                            // dDate
   METHOD StringXML()                                                                          // cString
   METHOD SoNumeros()                                                                          // cString
   METHOD SoNumeroCnpj()                                                                       // cString
   METHOD XmlToString()                                                                        // cString
   METHOD XmlTransf()                                                                          // cString
   METHOD XmlNode()                                                                            // cXml, cNode, lComTag
   METHOD CorrigeUTF8Manual()                                                                  // cString

   // Método para gravar Log dos eventos
   METHOD fGravaLog()                                                                          // cMensagem, cComando, cResultado, cRetorno

   // Métodos Operacionais
   METHOD SelecionarCertificado()
   METHOD GerarChaveDce( cUf, cAaMm, cCnpj, cSerie, cNumero )
   METHOD GerarXmlEnvioDce( cUf, cAaMm, cCnpjEmit, cCnpjDest, nValorTotal, cSerie, cNumero, cDescProd, cCnpjTransp, cXNomeTransp )
   METHOD GerarXmlConsultaDce( cChaveAcesso )
   METHOD AssinarXmlDce( cXmlBruto )
   METHOD EnviarDce( cXmlAssinado )
   METHOD ConsultarDce( cChaveAcesso )
   METHOD TransmitirSvan( cSoapEnvelope )
ENDCLASS

* ---------------> Método para inicializar a criação da Classe <-------------- *
METHOD New()
   ::cXml:= []
Return Self

* -----------------> Método para selecionar as URLs da NFSe <----------------- *
METHOD Setup()
   Local aSoapList

   If !Hb_FileExists(::cPasta + [\*.*])
      Hb_dirBuild(::cPasta)
   Endif

   If !Hb_FileExists(::cPasta + [\MM_NFSeClasse.log])
      Hb_MemoWrit(::cPasta + [\MM_NFSeClasse.log], [])
   Endif

   If ::nCodigoMunicipio == 3513009        // Cotia SP
      ::ngVersaoSchema:= 2.00
      If ::cAmbiente == [1]                // Produção
         aSoapList:= { { WS_CANCELAMENTONFE  , [CancelamentoNFe]  , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/v2/cancela]       , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/v2/cancela] }, ;
                       { WS_ENVIOLOTERPS     , [EnvioLoteRPS]     , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/v2/emissao]       , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/v2/emissao] }, ;
                       { WS_ENVIORPS         , [EnvioRPS]         , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/v2/emissao]       , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/v2/emissao] }, ; 
                       { WS_CONSULTARPS      , [ConsultaNFe]      , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/consulta]         , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/consulta]   }}
      ElseIf ::cAmbiente == [2]            // Homologação
         aSoapList:= { {}, ;
                       { WS_ENVIOLOTERPS   , [EnvioLoteRPS]   , [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/v2/emissao/simula], [https://webservice.giap.com.br/WSNfsesCotia/nfseresources/ws/v2/emissao/simula] } }
      Endif
   ElseIf ::nCodigoMunicipio == 3550308    // SP capital
      ::ngVersaoSchema:= 1                
      aSoapList:= { { WS_CANCELAMENTONFE  , [CancelamentoNFe]  , [http://www.prefeitura.sp.gov.br/nfe/ws/cancelamentoNFe], [https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx] }, ;
                    { WS_ENVIOLOTERPS     , [EnvioLoteRPS]     , [http://www.prefeitura.sp.gov.br/nfe/ws/envioLoteRPS]   , [https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx] }, ;
                    { WS_ENVIORPS         , [EnvioRPS]         , [http://www.prefeitura.sp.gov.br/nfe/ws/envioRPS]       , [https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx] }, ; 
                    { WS_CONSULTARPS      , [ConsultaNFe]      , [http://www.prefeitura.sp.gov.br/nfe/ws/consultaNFe]    , [https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx] }, ;
                    { WS_TESTEENVIOLOTERPS, [TesteEnvioLoteRPS], [http://www.prefeitura.sp.gov.br/nfe/ws/testeenvio]     , [https://nfe.prefeitura.sp.gov.br/ws/lotenfe.asmx] } }
   ElseIf ::nCodigoMunicipio == 3529005    // Marília SP
      aSoapList := { { WS_CANCELAMENTONFE   , [CancelarNota]       , [urn:sigiss_ws#CancelarNota]       , [https://marilia.sigiss.com.br:443/marilia/ws/sigiss_ws.php] }, ;
                     { WS_ENVIOLOTERPS      , [GerarNota]          , [urn:sigiss_ws#GerarNota]          , [https://marilia.sigiss.com.br:443/marilia/ws/sigiss_ws.php] }, ;
                     { WS_ENVIORPS          , [GerarNota]          , [urn:sigiss_ws#GerarNota]          , [https://marilia.sigiss.com.br:443/marilia/ws/sigiss_ws.php] }, ;
                     { WS_CONSULTARPS       , [ConsultarNotaValida], [urn:sigiss_ws#ConsultarNotaValida], [https://marilia.sigiss.com.br:443/marilia/ws/sigiss_ws.php] }, ;
                     { WS_TESTEENVIOLOTERPS , [gerateste]          , [urn:sigiss_ws#gerateste]          , [https://marilia.sigiss.com.br:443/marilia/ws/sigiss_ws.php] } }
   Endif

   ::cSoapService:= aSoapList[ ::nWsServico, 2 ]
   ::cSoapAction := aSoapList[ ::nWsServico, 3 ]
   ::cSoapURL    := aSoapList[ ::nWsServico, 4 ]
Return (Nil)

* ---------------> Método para gerar o XML da NFSe e enviar <----------------- *
METHOD ExecutaNfse(cXml, nWsServico)
   ::nWsServico:= nWsServico         // Inicializar o tipo de serviço (enviar, consultar, cancelar)
   ::Setup()                         // Buscar os WebServices do Ambiente (Produção/homologação) informados
   ::AssinaXml(cXml)                 // Retorna Xml assinado para envio (cXml passa a ser cXmlDocumento) 
   ::cXmlEnvio:= ::cXmlDocumento
   ::XmlSoapPostNfse()
Return (::cXmlRetorno)

* ------------------> Método para gravar o Log de retorno <------------------- *
METHOD fGravaLog(cMensagem, cComando, cResultado, cRetorno)
   Local cDataHora:= Dtoc(Date()) + [ - ] + Time()

   cLog:= Hb_Memoread(::cPasta + [\MM_NFSeClasse.log]) + Hb_Eol()
   cLog += [|##| Retorno: ] + cDataHora + Hb_Eol()
   cLog += [Enviado: ] + cComando + [ Retorno: ] + cResultado + Hb_Eol()
   cLog += [Mensagem: ] + Hb_Eol()
   cLog += cMensagem + Hb_Eol()
   cLog += cRetorno + Hb_Eol()
   cLog += [|##| Retorno Fim ] + cDataHora + Hb_Eol()
   Hb_MemoWrit(::cPasta + [\MM_NFSeClasse.log], cLog)
Return (Nil)

* --------------------> Método para enviar o XML da NFSe <-------------------- *
METHOD XmlSoapPostNfse()
   Do Case
      Case Empty(::cSoapURL)
           ::cXmlRetorno:= [Erro SOAP: Não há endereço de webservice]
           Return (Nil)
      Case Empty(::cSoapService)
           ::cXmlRetorno:= [Erro SOAP: Não há nome do serviço]
           Return (Nil)
      Case Empty(::cSoapAction)
           ::cXmlRetorno:= [Erro SOAP: Não há endereço de SOAP Action]
           Return (Nil)
   Endcase

   ::XmlSoapEnvelopeNfse()
   ::MicrosoftXmlSoapPostNfse()

   If Upper(Left(::cXmlRetorno, 4)) == [ERRO]
      ::cXmlRetorno:= [<xml>*ERRO* Erro ao criar XML Soap Envelope ] + ::cSoapURL + [</xml>]
      ::fGravaLog([Erro ao criar XML Soap Envelope ] + ::cSoapURL, [MicrosoftXmlSoapPostNfse], [ERRO], ::cXmlRetorno)
      Return (Nil)
   Endif
Return (Nil)

* ------------------> Método para envelopar o XML da NFSe <------------------- *
METHOD XmlSoapEnvelopeNfse()
   ::cXmlsoap:= ::cXmlUtf8  
 
   If ::nCodigoMunicipio == 3513009            // cotia SP 
      ::cXmlSoap+= ::cXmlEnvio 
      // Se quiser ver o XML envelopado
      * Hb_MemoWrit(::cPasta + [\Nfse_] + ::cSoapService + [_] + ::cAutenticidade + [_] + Hb_Ntos(::nCodigoMunicipio) + [_Envelope.xml], ::cXmlSoap)
   ElseIf ::nCodigoMunicipio == 3550308        // SP capital
      ::cXmlsoap+= [<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">]
      ::cXmlSoap+=   [<soap12:Body>]
      ::cXmlSoap+=     [<] + ::cSoapService + [Request xmlns="http://www.prefeitura.sp.gov.br/nfe">]
      ::cXmlSoap+=           ::XmlTag([VersaoSchema] , Hb_Ntos(::ngVersaoSchema)) 
      ::cXmlSoap+=           ::XmlTag([MensagemXML]  , ::cXmlEnvio) 
      ::cXmlSoap+=     [</] + ::cSoapService + [Request>]
      ::cXmlSoap+=   [</soap12:Body>]
      ::cXmlSoap+= [</soap12:Envelope>]

      // Se quiser ver o XML envelopado
      * Hb_MemoWrit(::cPasta + [\Nfse_] + ::cSoapService + [_] + StrZero(Val(::cNumNfse), 12) + [_] + Hb_Ntos(::nCodigoMunicipio) + [_Envelope.xml], ::cXmlSoap)
   ElseIf ::nCodigoMunicipio == 3529005          // Marília SP
      ::cXmlsoap+= [<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ]
      ::cXmlsoap+=    [xmlns:urn="urn:sigiss_ws">]
      ::cXmlsoap+=       [<soapenv:Header/>]
      ::cXmlsoap+=       [<soapenv:Body>]
      ::cXmlsoap+=          [<urn:] + ::cSoapService + [>]
      ::cXmlSoap+=              ::cXmlEnvio
      ::cXmlsoap+=          [</urn:] + ::cSoapService + [>]
      ::cXmlsoap+=       [</soapenv:Body>]
      ::cXmlsoap+= [</soapenv:Envelope>]
      // Se quiser ver o XML envelopado
      * Hb_MemoWrit(::cPasta + [\Nfse_] + ::cSoapService + [_] + StrZero(Val(::cNumNfse), 12) + [_] + Hb_Ntos(::nCodigoMunicipio) + [_Envelope.xml], ::cXmlSoap)
   Endif

   ::fGravaLog([XML do Envelope], [XmlSoapEnvelopeNfse], [Sucesso], ::cXmlSoap)
Return (Nil)

METHOD MicrosoftXmlSoapPostNfse()
   Local oServer, nCont, cRetorno, lOk:= .F., cBlocoValido

   BEGIN SEQUENCE WITH __BreakBlock()
      oServer:= Win_OleCreateObject([MSXML2.ServerXMLHTTP.6.0])
      lOk:= .T.
   ENDSEQUENCE

   If !lOk
      ::cXmlRetorno:= [<xml>*ERRO* Erro: No uso do objeto MSXML2.ServerXmlHTTP.6.0</xml>]
      ::fGravaLog([Erro: No uso do objeto MSXML2.ServerXmlHTTP.6.0], [MicrosoftXmlSoapPostNfse], [ERRO], ::cXmlRetorno)
      Return (Nil)
   Endif

   If ::cCertificado # Nil .and. ::cCertificado # [NENHUM]
      oServer:setOption(3, [CURRENT_USER\MY\] + ::cCertificado)
   Endif

   oServer:SetTimeOuts(::nSoapTimeOut, ::nSoapTimeOut, ::nSoapTimeOut, ::nSoapTimeOut)
   lOk:= .F.

   BEGIN SEQUENCE WITH __BreakBlock()
      oServer:Open([POST], ::cSoapURL, .F.)
      lOk:= .T.
   ENDSEQUENCE

   If !lOk
      ::cXmlRetorno:= [<xml>*ERRO* Erro: No Open() do endereço ] + ::cSoapURL + [</xml>]
      ::fGravaLog([Erro: No Open() do endereço ] + ::cSoapURL, [MicrosoftXmlSoapPostNfse], [ERRO], ::cXmlRetorno)
      Return (Nil)
   Endif

   If !Empty(::cProxyUrl)
      oServer:SetProxy(2, ::cProxyUrl)
      If !Empty(::ProxyUser) .or. !Empty(::cProxyPassword)
         oServer:SetProxyCredentials(::ProxyUser, ::ProxyPassword)
      Endif
   Endif

   If ::cSoapAction # Nil .and. !Empty(::cSoapAction)
      oServer:SetRequestHeader([SOAPAction], ::cSoapAction)
   Endif

   If ::lEnvioZip
      oServer:SetRequestHeader([Accept-Encoding], [gzip,deflate])
      oServer:SetRequestHeader([Content-Encoding], [gzip])
   Endif

   If ::nCodigoMunicipio == 3513009           // Cotia SP
       oServer:SetRequestHeader([Content-Type], [application/xml])
       oServer:SetRequestHeader([Authorization] , ::cgInscricaoMunicipalp + [-] + ::cToken) // im + token
   ElseIf ::nCodigoMunicipio == 3550308       // SP capital
       oServer:SetRequestHeader([Content-Type], [application/soap+xml; charset=utf-8])
   Elseif ::nCodigoMunicipio == 3529005       // Marília SP
       oServer:SetRequestHeader([Content-Type], [text/xml; charset=utf-8])
   Endif

   oServer:SetRequestHeader([content-Length], Ltrim(Str(Len(::cXmlSoap))))
   lOk:= .F.

   BEGIN SEQUENCE WITH __BreakBlock()
      oServer:Send(::cXmlSoap)
      lOk:= .T.
   ENDSEQUENCE

   If !lOk
      ::cXmlRetorno:= [<xml>*ERRO* Erro: Send falhou ] + ::cSoapURL + [</xml>]
      ::fGravaLog([Erro: Send falhou ] + ::cSoapURL, [MicrosoftXmlSoapPostNfse], [ERRO], ::cXmlRetorno)
      Return (Nil)
   Endif

*  cRetorno:= oServer:ResponseXML:XML
   cRetorno:= oServer:ResponseBody // sempre usar para UTF-8

   If Empty(cRetorno)
      cRetorno:= oServer:ResponseBody
      If Empty(cRetorno)
         cRetorno:= oServer:ResponseText  /// aqui que deu certo
      Endif
   Endif

   If ValType(cRetorno) == [C]
      ::cXmlRetorno:= cRetorno
   Elseif cRetorno == Nil
      ::cXmlRetorno:= [Sem retorno do webservice]
      ::fGravaLog([Sem retorno do webservice], [MicrosoftXmlSoapPostNfse], [ERRO], ::cXmlRetorno)
   Elseif ValType(cRetorno) == [A] // xharbour e harbour antigo???
      ::cXmlRetorno:= []
      For nCont:= 1 TO Len(cRetorno)
         ::cXmlRetorno+= Chr(cRetorno[ nCont ])
      Next
   Endif

   If [not have permission to view] $ ::cXmlRetorno
      ::cStatus    := [999]
      ::cMotivo    := [problemas com Sefaz e/ou certificado]
      ::cXmlRetorno:= [<xml>*ERRO* Erro: Sefaz e/ou certificado</xml>]
      ::fGravaLog([Erro: Sefaz e/ou certificado], [MicrosoftXmlSoapPostNfse], [ERRO], ::cXmlRetorno)
   Else
      If ::nCodigoMunicipio # 3513009 .and. ::nCodigoMunicipio # 3529005           // Cotia e Marília SP
         lOk:= .F.
         For EACH cBlocoValido IN { [soap:Body], [soapenv:Body], [env:Body], [S:Body], [soap12:Body]}
             If !Empty(::XmlNode(::cXmlRetorno, cBlocoValido))
                ::cXmlRetorno:= ::XmlNode(::cXmlRetorno, cBlocoValido)
                lOk:= .T.
                ::fGravaLog([Envio do XML ao WebService], [MicrosoftXmlSoapPostNfse], [SUCESSO], ::cXmlRetorno)
                Exit
             Endif
         Next
      
         If !lOk
            ::cXmlRetorno:= [<xml>*ERRO* Erro de retorno ] + ProcName(2) + [ body não identificado ] + ::cXmlRetorno + [</xml>]
            ::fGravaLog([Erro de retorno ] + ProcName(2) + [ body não identificado], [MicrosoftXmlSoapPostNfse], [ERRO], ::cXmlRetorno)
         Endif
      Endif
   Endif
Return (Nil) 

* --------------------> Método para assinar o XML da NFSe <------------------- *
METHOD AssinaXml(cXml)
   ::cXmlDocumento := cXml
   ::cXmlRetorno   := CapicomAssinaXml(@::cXmlDocumento, ::cCertificado, , ::cPassword, ::lComUri)

   If ::cXmlRetorno # [Ok]
      ::cStatus    := [999]
      ::cMotivo    := ::cXmlRetorno
      ::cXmlRetorno:= [<erro text="] + [*erro* ] + ::cXmlRetorno + ["</erro>]
      ::fGravaLog([Erro ao assinar o XML], [Capicom Assinar], [ERRO], ::cXmlRetorno)
   Else
      ::fGravaLog([XML assinado !!!], [Capicom Assinar], [SUCESSO], ::cXmlDocumento)
      Hb_MemoWrit(::cPasta + [\Nfse_] + StrZero(Val(::cNumNfse), 12) + [_Assinado.xml],  ::cXmlDocumento)
   Endif
Return ::cXmlRetorno 

* -----------------> Método para gerar chave criptográfica <------------------ *
METHOD Gera_Chave_SHA1(cString)
   Local cRet:= [], cSerial:= Upper(AllTrim(::cCertSerial))

   If Empty(cSerial)
      cRet:= [ERRO_ASSINATURA_RPS: Serial do certificado nao informado.]
      ::fGravaLog([Erro ao assinar RPS SP], [Gera_Chave_SHA1], [ERRO], cRet)
      Return (cRet)
   Endif

   cRet:= AssinarRpsSpNative(cSerial, cString)

   If Left(cRet, 5) == [ERRO_]
      ::fGravaLog([Erro ao assinar RPS SP], [Gera_Chave_SHA1], [ERRO], cRet)
   Endif
Return (cRet)

* -------> Monta a string da tag Assinatura do RPS SP - XSD versao 1 e 2 <-------- *
METHOD MontaStringAssinaturaRpsSpV1e2()
   Local cDocTomador:= AllTrim(::SoNumeroCnpj(::cgCnpjt)), cTipoCnpjCpf:= []

   Do Case
      Case Empty(cDocTomador)
         cTipoCnpjCpf:= [3]
         cDocTomador := Replicate([0], 14)
      Case Len(cDocTomador) <= 11
         cTipoCnpjCpf:= [1]
         cDocTomador := PadL(cDocTomador, 14, [0])
      Otherwise
         cTipoCnpjCpf:= [2]
         cDocTomador := PadL(cDocTomador, 14, [0])
   Endcase

Return PadL(AllTrim(::SoNumeros(::cgInscricaoMunicipalp)), If(::ngVersaoSchema == 1, 8, 12), [0]) + ;
       PadR(Left(AllTrim(::cgSerieRPS), 5), 5) + ;
       StrZero(::ngNumeroRps, 12) + ;
       Dtos(::dgDataEmissao) + ;
       [T] + ;
       [N] + ;
       If(::ngIssRetido == 1, [S], [N]) + ;
       StrZero(Round(::ngValorServico * 100, 0), 15) + ;
       StrZero(Round(::nValorTotalDeducoes * 100, 0), 15) + ;
       PadL(Left(AllTrim(::SoNumeros(::cgItemListaServico)), 5), 5, [0]) + ;
       cTipoCnpjCpf + ;
       cDocTomador

* ----------------> Método para Enviar o lote de RPS da NFSe <---------------- *
METHOD fCria_Xml_Para_Rps()
   Local cTipoCnpjCpf:= cLink:= cNfse:= cCodigo:= []

   If ::nCodigoMunicipio == 3513009         // Cotia SP
      ::cXml:= [<?xml version="1.0" encoding="utf-8" standalone="yes"?>]
      ::cXml+= [<nfe>]
      ::cXml+=    [<notaFiscal>]
      ::cXml+=       [<dadosPrestador>]
      ::cXml+=          ::XmlTag([dataEmissao]          , Dtoc(::dgDataEmissao)) 
      ::cXml+=          ::XmlTag([im]                   , Left(::SoNumeros(::cgInscricaoMunicipalp), 16)) 
      ::cXml+=          ::XmlTag([numeroRps]            , Left(Hb_Ntos(::ngNumeroRps), 16))
      ::cXml+=       [</dadosPrestador>]
      ::cXml+=       [<dadosServico>]

      If !Empty(::cgBairrot)
         ::cXml+=       ::XmlTag([bairro]               , Left(::fRetiraAcento(::cgBairrot), 100))
      Endif

      If !Empty(::cgCept)
         ::cXml+=       ::XmlTag([cep]                  , Left(::cgCept, 9))
      Endif

      ::cXml+=          ::XmlTag([cidade]               , Left(::fRetiraAcento(::cgMunicipiot), 255))

      If !Empty(::cgComplementoEnderecot)
         ::cXml+=       ::XmlTag([complemento]          , Left(::fRetiraAcento(::cgComplementoEnderecot), 100))
      Endif

      If !Empty(::cgEnderecot)
         ::cXml+=       ::XmlTag([logradouro]           , Left(::fRetiraAcento(::cgEnderecot), 255))
      Endif

      If !Empty(::cgNumerot)
         ::cXml+=       ::XmlTag([numero]               , Left(::cgNumerot, 50))
      Endif

      ::cXml+=          ::XmlTag([pais]                 , Left([BRASIL], 200))
      ::cXml+=          ::XmlTag([uf]                   , Left(Upper(::cgUft), 2))
      ::cXml+=       [</dadosServico>]
      ::cXml+=       [<dadosTomador>]
      ::cXml+=          ::XmlTag([bairro]               , Left(::fRetiraAcento(::cgBairrot), 100))
      ::cXml+=          ::XmlTag([cep]                  , Left(::cgCept, 9))
      ::cXml+=          ::XmlTag([cidade]               , Left(::fRetiraAcento(::cgMunicipiot), 255))

      If !Empty(::cgComplementoEnderecot)
         ::cXml+=       ::XmlTag([complemento]          , Left(::fRetiraAcento(::cgComplementoEnderecot), 100))
      Endif

      ::cXml+=          ::XmlTag([documento]            , Left(::SoNumeroCnpj(::cgCnpjt), 14))

      If !Empty(::cgEmailt)
         ::cXml+=       ::XmlTag([email]                , Left(::cgEmailt, 255))
      Endif

      If !Empty(::cgIet)
         ::cXml+=       ::XmlTag([ie]                   , Left(::SoNumeros(::cgIet), 30))
      Endif
  
      ::cXml+=          ::XmlTag([logradouro]           , Left(::fRetiraAcento(::cgEnderecot), 255))
      ::cXml+=          ::XmlTag([nomeTomador]          , Left(::fRetiraAcento(::cgRazaoSocialt), 255)) 
      ::cXml+=          ::XmlTag([numero]               , Left(::cgNumerot, 50))
      ::cXml+=          ::XmlTag([tipoDoc]              , If(Len(::SoNumeroCnpj(::cgCnpjt)) < 14, [F], [J]))
      ::cXml+=          ::XmlTag([uf]                   , Left(Upper(::cgUft), 2))
      ::cXml+=       [</dadosTomador>]
      ::cXml+=       [<detalheServico>]
      ::cXml+=          ::XmlTag([cofins]               , Left([0], 16))
      ::cXml+=          ::XmlTag([csll]                 , Left([0], 16))
      ::cXml+=          ::XmlTag([deducaoMaterial]      , Left([0], 16))
      ::cXml+=          ::XmlTag([descontoIncondicional], Left([0], 16))
      ::cXml+=          ::XmlTag([inss]                 , Left([0], 16))
      ::cXml+=          ::XmlTag([ir]                   , Left([0], 16))
      ::cXml+=          ::XmlTag([issRetido]            , [0])   // Retenção de Iss para o Tomador (0 – Não ou 1 – Sim) (OBS:. Mesmo informando este campo, a retenção poderá sofrer ALTERAÇÃO de acordo com a REGRA informada pela Prefeitura)
      ::cXml+=          [<item>]

      If !Empty(::ngAliquotaServico)
         ::cXml+=          ::XmlTag([aliquota]          , Left(Hb_Ntos(::ngAliquotaServico), 16))     // 5,00 % =  0.05
      Endif

      ::cXml+=             ::XmlTag([cnae]              , ::SoNumeros(::cgCodigoCnae))
      ::cXml+=             ::XmlTag([codigo]            , Left(::cgItemListaServico, 4))
      ::cXml+=             ::XmlTag([descricao]         , Left(::fRetiraAcento(::cgDiscriminacao), 500))
      ::cXml+=             ::XmlTag([valor]             , Hb_Ntos(::ngValorServico)) 
      ::cXml+=          [</item>]

      If !Empty(::cgObservacao)
         ::cXml+=       ::XmlTag([obs]                  , Left(::fRetiraAcento(::cgObservacao), 500))
      Endif

      ::cXml+=          ::XmlTag([pisPasep]             , Left([0], 16))
      ::cXml+=       [</detalheServico>]
      ::cXml+=    [</notaFiscal>]
      ::cXml+= [</nfe>]
   ElseIf ::nCodigoMunicipio == 3550308     // SP capital                                                                         // SP capital
      cTipoCnpjCpf:= If(Len(::SoNumeroCnpj(::cgCnpjt)) < 14, [1], [2])                                                      // 1 - CPF |  2 - CNPJ do tomador

      ::cXml:= ::cXmlUtf8
      ::cXml+= [<PedidoEnvioLoteRPS xmlns="http://www.prefeitura.sp.gov.br/nfe">]
      ::cXml+=    [<Cabecalho Versao="] + Hb_Ntos(::ngVersaoSchema) + [" xmlns="">]   /// Versão 2 para RTC
      ::cXml+=       [<CPFCNPJRemetente>]
      ::cXml+=           ::XmlTag([CNPJ], Padl(AllTrim(::SoNumeroCnpj(::cgCnpjp)), 14, [0]))                                 // cnpj do emitente
      ::cXml+=       [</CPFCNPJRemetente>]
      ::cXml+=       ::XmlTag([transacao]          , [false])
      ::cXml+=       ::XmlTag([dtInicio]           , Transf(Dtos(Date()), [@R 9999-99-99])) 
      ::cXml+=       ::XmlTag([dtFim]              , Transf(Dtos(Date()), [@R 9999-99-99])) 
      ::cXml+=       ::XmlTag([QtdRPS]             , Hb_Ntos(::ngQuantidadeRps))

      If ::ngVersaoSchema == 1
         ::cXml+=    ::XmlTag([ValorTotalServicos] , Hb_Ntos(::nValorTotalServicos))   // Não vai ter na versão 2 para RTC
         ::cXml+=    ::XmlTag([ValorTotalDeducoes] , Hb_Ntos(::nValorTotalDeducoes))   // Não vai ter na versão 2 para RTC
      Endif

      ::cXml+=    [</Cabecalho>]
      ::cXml+=    [<RPS xmlns="">]
      ::cXml+=       ::XmlTag([Assinatura], ::Gera_Chave_SHA1(::MontaStringAssinaturaRpsSpV1e2()))
      ::cXml+=       [<ChaveRPS>]
      ::cXml+=          ::XmlTag([InscricaoPrestador]  , If(::ngVersaoSchema >= 2, PadL(AllTrim(::SoNumeros(::cgInscricaoMunicipalp)), 12, [0]), Left(::SoNumeros(::cgInscricaoMunicipalp), 8)))
      ::cXml+=          ::XmlTag([SerieRPS]            , Left(::cgSerieRPS, 5))
      ::cXml+=          ::XmlTag([NumeroRPS]           , Str(::ngNumeroRps, 12))
      ::cXml+=       [</ChaveRPS>]
      ::cXml+=       ::XmlTag([TipoRPS]                , [RPS])
      ::cXml+=       ::XmlTag([DataEmissao]            , Transf(Dtos(::dgDataEmissao), [@R 9999-99-99]))  
      ::cXml+=       ::XmlTag([StatusRPS]              , [N]) 
      ::cXml+=       ::XmlTag([TributacaoRPS]          , [T])
      If ::ngVersaoSchema >= 2
         ::cXml+=       ::XmlTag([ValorInicialCobrado]   , Str(::ngValorServico, 15))
      Else
         ::cXml+=       ::XmlTag([ValorServicos]          , Str(::ngValorServico, 15))
      Endif                                           // 1,00 = 1 ; 100,00 = 100 mas na assinatura tem que multiplicar por 100 ; 1,00 = 100 ; 100,00 = 10000
      ::cXml+=       ::XmlTag([ValorDeducoes]          , ::nValorTotalDeducoes)
      ::cXml+=       ::XmlTag([ValorPIS]               , [0])
      ::cXml+=       ::XmlTag([ValorCOFINS]            , [0])
      ::cXml+=       ::XmlTag([ValorINSS]              , [0])
      ::cXml+=       ::XmlTag([ValorIR]                , [0])
      ::cXml+=       ::XmlTag([ValorCSLL]              , [0])
      ::cXml+=       ::XmlTag([CodigoServico]          , Left(::cgItemListaServico, 5))
      ::cXml+=       ::XmlTag([AliquotaServicos]       , Hb_Ntos(::ngAliquotaServico))     // 5,00 % =  0.05                                                    // 1,00 %
      ::cXml+=       ::XmlTag([ISSRetido]              , [false])

      ::cXml+=       [<CPFCNPJTomador>]
      If cTipoCnpjCpf == [1] 
         ::cXml+=   ::XmlTag([CPF]                     , Left(::SoNumeroCnpj(::cgCnpjt), 11))
      Else
         ::cXml+=   ::XmlTag([CNPJ]                    , Left(::SoNumeroCnpj(::cgCnpjt), 14))
      Endif     
      ::cXml+=       [</CPFCNPJTomador>]

      ::cXml+=       ::XmlTag([RazaoSocialTomador]     , Left(::fRetiraAcento(::cgRazaoSocialt), 75)) 
      ::cXml+=       [<EnderecoTomador>]
      ::cXml+=          ::XmlTag([TipoLogradouro]      , Left(::cgTipoLogradourot, 3))                                         // Rua, av
      ::cXml+=          ::XmlTag([Logradouro]          , Left(::fRetiraAcento(::cgEnderecot), 50))
      ::cXml+=          ::XmlTag([NumeroEndereco]      , Left(::cgNumerot, 12))
      ::cXml+=          ::XmlTag([ComplementoEndereco] , Left(::fRetiraAcento(::cgComplementoEnderecot), 30))
      ::cXml+=          ::XmlTag([Bairro]              , Left(::fRetiraAcento(::cgBairrot), 30))
      ::cXml+=          ::XmlTag([Cidade]              , Left(::SoNumeros(::cgCodigoMunicipiot), 7)) 
      ::cXml+=          ::XmlTag([UF]                  , Left(Upper(::cgUft), 2))
      ::cXml+=          ::XmlTag([CEP]                 , Left(::SoNumeros(::cgCept), 8))
      ::cXml+=       [</EnderecoTomador>]
      If !Empty(::cgEmailt)
         ::cXml+=       ::XmlTag([EmailTomador]        , Left(::cgEmailt, 75))
      Endif
      ::cXml+=       ::XmlTag([Discriminacao]          , Left(::fRetiraAcento(::cgDiscriminacao), 2000))

      ***********************************************************
      /* Grupo da RTC Obrigatório a partir de janeiro 2026
      ***********************************************************
      ::cXml+=       [<IBSCBS>]
      ::cXml+=          [<serv>]
      ::cXml+=             ::XmlTag([modoPrestServ]   , [1])
      ::cXml+=             ::XmlTag([clocalPrestServ] , ::cgCodigoMunicipiot)
      ::cXml+=             ::XmlTag([indCompGov]      , [0])
      ::cXml+=          [</serv>]
      ::cXml+=          [<valores>]
      ::cXml+=             [<trib>]
      ::cXml+=                [<gIBSCBS>]
      ::cXml+=                   ::XmlTag([cClassTribIBSCBS], ::cClassTribIBSCBS)
      ::cXml+=                [</gIBSCBS>]
      ::cXml+=             [</trib>]
      ::cXml+=          [</valores>]
      ::cXml+=       [</IBSCBS>]
      ***********************************************************/

      ::cXml+=    [</RPS>]
      ::cXml+= [</PedidoEnvioLoteRPS>]
   ElseIf ::nCodigoMunicipio == 3529005    // Marília
      ::cXml:= ::cXmlUtf8
      ::cXml+= [<GerarNota>]
      ::cXml+=    [<DescricaoRps>]
      ::cXml+=       ::XmlTag([ccm]                 , Left(::SoNumeros(::cgInscricaoMunicipalp), 15))
      ::cXml+=       ::XmlTag([cnpj]                , Left(::SoNumeroCnpj(::cgCnpjp), 14))
      ::cXml+=       ::XmlTag([senha]               , Left(::cPassword, 15))

      If Val(::cCrt) <= 2
         ::cXml+=    ::XmlTag([aliquota_simples]    , StrTran(AllTrim(Str(::ngAliquotaServico, 15, 2)), [.], [,]))        // 5,00 Obrigatório se a empresa prestadora é do tipo simples nacional.
      EndIf
      ::cXml+=       ::XmlTag([servico]             , Left(::cgItemListaServico, 7))                                          // 401
      ::cXml+=       ::XmlTag([situacao]            , Iif(!(::cSituacao $ [tp_tt_is_im_nt]), [tp], Left(::cSituacao, 2))) // tp - Situação da nota fiscal eletrônica: tp – Tributada no prestador; tt – Tributada no tomador; is – Isenta; im – Imune; nt – Nãotributada.
      ::cXml+=       ::XmlTag([valor]               , StrTran(AllTrim(Str(::ngValorServico, 15, 2)), [.], [,]))           // 1,00 ( 2 CASAS DECIMAIS )
      ::cXml+=       ::XmlTag([base]                , StrTran(AllTrim(Str(::ngValorServico, 15, 2)), [.], [,]))           // 1,00 ( 2 CASAS DECIMAIS )
      If !Empty(::cgDiscriminacao) 
         ::cXml+=    ::XmlTag([descricaoNF]         , Left(::fRetiraAcento(::cgDiscriminacao), 1000))                         // teste de emissao
      EndIf

      ::cXml+=       ::XmlTag([tomador_tipo]        , Iif(!(Hb_Ntos(::ngNaturezaOperacao ) $ [1_2_3_4_5_6]), 3, ::ngNaturezaOperacao), 0)  // 3 - Tipo do tomador que se quer escriturar: 1 – PFNI; 2 – Pessoa Física; 3 – Jurídica do Município; 4 – Jurídica de Fora; 5 – Jurídica de Fora do País (exportação); 6 – Produtor Rural/Político
      ::cXml+=       ::XmlTag([tomador_cnpj]        , Left(::SoNumeroCnpj(::cgCnpjt), 14))
      If !Empty(::cgEmailt) 
         ::cXml+=    ::XmlTag([tomador_email]       , Left(::cgEmailt, 80))
      EndIf
      If ::cgCodigoMunicipiop == [3529005]
         ::cXml+=    ::XmlTag([tomador_im]          , Left(::SoNumeros(::cgInscricaoMunicipalt), 15))                         // Obrigatório somente para tomadores que sejam de dentro do município.
      EndIf
      ::cXml+=       ::XmlTag([tomador_razao]       , Left(::fRetiraAcento(::cgRazaoSocialt), 100)) 

      If !Empty(::cgFantasiat)
         ::cXml+=    ::XmlTag([tomador_fantasia]    , Left(::fRetiraAcento(::cgFantasiat), 100))     
      EndIf
      ::cXml+=       ::XmlTag([tomador_endereco]    , Left(::fRetiraAcento(::cgEnderecot), 50))
      ::cXml+=       ::XmlTag([tomador_numero]      , Left(::cgNumerot, 10))
      If !Empty(::cgComplementoEnderecot)
         ::cXml+=    ::XmlTag([tomador_complemento] , Left(::fRetiraAcento(::cgComplementoEnderecot), 30))
      EndIf
      ::cXml+=       ::XmlTag([tomador_bairro]      , Left(::fRetiraAcento(::cgBairrot), 30))
      ::cXml+=       ::XmlTag([tomador_cod_cidade]  , Left(::cgCodigoMunicipiop, 7))
      ::cXml+=       ::XmlTag([tomador_CEP]         , Left(::SoNumeros(::cgCept), 7))
      If !Empty(::cgTelefonet) 
         ::cXml+=    ::XmlTag([tomador_fone]        , Left(::cgTelefonet, 11))
      EndIf

      ::cXml+=       ::XmlTag([rps_num]             , Hb_Ntos(::ngNumeroRps))
      ::cXml+=       ::XmlTag([rps_serie]           , Left(::cgSerieRPS, 5))
      ::cXml+=       ::XmlTag([rps_dia]             , Substr(Dtoc(::dgDataEmissao), 1, 2))
      ::cXml+=       ::XmlTag([rps_mes]             , Substr(Dtoc(::dgDataEmissao), 4, 2))
      ::cXml+=       ::XmlTag([rps_ano]             , Substr(Dtoc(::dgDataEmissao), 7, 4))
 
      // *********************************************************** todos opcionais 
      /*
      If !Empty()
         ::cXml+=    ::XmlTag([pis]                 , [0,00])
      EndIf

      If !Empty()
         ::cXml+=    ::XmlTag([cofins]              , [0,00])
      EndIf

      If !Empty()
         ::cXml+=    ::XmlTag([inss]                , [0,00])
      EndIf

      If !Empty()
         ::cXml+=    ::XmlTag([irrf]                , [0,00])
      EndIf

      If !Empty()
         ::cXml+=    ::XmlTag([csll]                , [0,00])
      EndIf
      */
      // ***********************************************************
      ::cXml+=    [</DescricaoRps>]
      ::cXml+= [</GerarNota>]
   Endif                                                                   

   If Len(AllTrim(::cXml)) > 0                                                                                               // gravar com o numero da rps
*     Hb_MemoWrit(::cPasta + [\TesteEnvioLoteRps-env-loterps.xml], ::cXml) // Para Monitor Uninfe
      Hb_MemoWrit(::cPasta + [\Rps_] + StrZero(::ngNumeroRps, 12) + [.xml], ::cXml)
      ::fGravaLog(AllTrim(Str(::ngNumeroRps, 12)) + [ NFSe XML gerado com sucesso !!!], [Criar XML do RPS], [SUCESSO], ::cXml)
   Endif

   ::ExecutaNfse(::cXml, 2)                                                                                                 // Gera a NFSe
   Inkey(::nTempoEspera)
   ::fConsulta_Retorno_Rps_Enviado()
Return (Nil)

* --------------> Método para consultar o lote de RPS da NFSe <--------------- *
METHOD fConsulta_Nfse(nTipo)
   hb_Default(@nTipo, 1)

   If ::nCodigoMunicipio == 3513009        // Cotia SP
      ::cXml:= ::cXmlUtf8
      ::cXml+= [<consulta>]
      ::cXml+=    ::XmlTag([inscricaoMunicipal], Left(::SoNumeros(::cgInscricaoMunicipalp), 11))
      ::cXml+=    ::XmlTag([codigoVerificacao] , Left(::cAutenticidade, 11))
      ::cXml+= [</consulta>]

      ::ExecutaNfse(::cXml, 4)                                                                                                 // consulta
      Inkey(::nTempoEspera)

      Hb_MemoWrit(::cPasta + [\Nfse_] + ::cAutenticidade + [_consulta.xml], ::cXml)
      ::fGravaLog(Left(::cAutenticidade, 11) + [ Consulta ok !!!], [Consulta Lote Nfse], [OK], ::cXml)
   ElseIf ::nCodigoMunicipio == 3550308    // SP capital
      ::cXml:= ::cXmlUtf8
      ::cXml+= [<p1:PedidoConsultaNFe xmlns:p1="http://www.prefeitura.sp.gov.br/nfe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">]
      ::cXml+=    [<Cabecalho Versao="] + Hb_Ntos(::ngVersaoSchema) + [">]
      ::cXml+=       [<CPFCNPJRemetente>]
      ::cXml+=          ::XmlTag([CNPJ], ::SoNumeroCnpj(::cgCnpjp))                                                             // cnpj do emitente
      ::cXml+=       [</CPFCNPJRemetente>]
      ::cXml+=    [</Cabecalho>]
      ::cXml+=    [<Detalhe>]

      If nTipo == 1      
         ::cXml+=       [<ChaveNFe>]
      Else
         ::cXml+=       [<ChaveRPS>]  // Pode-consultar também pela rps 
      Endif

      ::cXml+=          ::XmlTag([InscricaoPrestador], Left(::SoNumeros(::cgInscricaoMunicipalp), 8))

      If nTipo == 1      
         ::cXml+=          ::XmlTag([NumeroNFe], Left(::cNumNfse, 8))
         ::cXml+=       [</ChaveNFe>]
      Else
         ::cXml+=          ::XmlTag([SerieRPS] , ::cgSerieRPS)
         ::cXml+=          ::XmlTag([NumeroRPS], ::ngNumeroRps, 0)
         ::cXml+=       [</ChaveRPS>]
      Endif

      ::cXml+=    [</Detalhe>]
      ::cXml+= [</p1:PedidoConsultaNFe>]
   ElseIf ::nCodigoMunicipio == 3529005    // Marília SP
      ::cXml:=    [<DadosConsultaNota>]
      ::cXml+=       ::XmlTag([nota]          , Left(::cNumNfse, 8))
      ::cXml+=       ::XmlTag([serie]         , Left(::cgSerieNfe, 5))   
      ::cXml+=       ::XmlTag([valor]         , StrTran(AllTrim( Str(::ngValorServico, 15, 2)), [.], [,])) // 1,00
      ::cXml+=       ::XmlTag([prestador_ccm] , Left(::SoNumeros(::cgInscricaoMunicipalp), 8))
      If Len(::SoNumeroCnpj(::cgCnpjp)) == 14
         ::cXml+=    ::XmlTag([prestador_cnpj], ::SoNumeroCnpj(::cgCnpjp))                                 // cnpj do emitente
      Else   
         ::cXml+=    ::XmlTag([prestador_cpf] , ::SoNumeroCnpj(::cgCnpjp))                                 // cnpj do emitente
      EndIf   
      ::cXml+=      ::XmlTag([autenticidade] , Left(Upper(::cAutenticidade), 8))
      ::cXml+=    [</DadosConsultaNota>]
   Endif

   ::ExecutaNfse(::cXml, 4)                                                                                // consulta
   Inkey(::nTempoEspera)

   ::fConsulta_Retorno_Rps_Enviado()
Return (Nil)

* -------------> Método para consultar o Retorno do RPS enviado <------------- *
METHOD fConsulta_Retorno_Rps_Enviado()
   Local cNfse:= cCodigo:= cLink:= []

   If !Empty(::cXmlRetorno)
      If ::nCodigoMunicipio == 3513009          // Cotia SP
         ::cXmlRetorno:= ::fRetiraAcento(::XmlTransf(::XmlToString(::cXmlRetorno, .T.)))

         If ::XmlNode(::cXmlRetorno, [notaExiste]) == [Sim] .or. ::XmlNode(::cXmlRetorno, [statusEmissao]) == [200]
            *MsgInfo([NFSe gerada com sucesso !!!], [Sucesso])
            cNfse:= ::XmlNode(::cXmlRetorno, [numeroNota])
         
            Hb_MemoWrit(::cPasta + [\Nfse_] + Left(cNfse, 12) + [-ok.xml], ::cXmlRetorno)
            ::fGravaLog(cNfse + [ NFSe gerada com sucesso !!!], [Enviar Lote RPS], [SUCESSO], ::cXmlRetorno)
   
            // Imprimir direto do site  
            cLink:= ::XmlNode(::cXmlRetorno, [link])
            WAPI_ShellExecute(0, [open], cLink, , , 1)
            WAPI_ShellExecute(0, [open], [C:\Downloads\NF_] + cNfse + [.pdf], , , 1)
         Else /// erro
            cNfse:= ::XmlNode(::cXmlRetorno, [numeroRps])

            Hb_MemoWrit(::cPasta + [\Nfse_] + Left(cNfse, 12) + [-retorno-erro.xml], ::cXmlRetorno)
            ::fGravaLog(cNfse + [ NFSe NÃO gerada !!!], [Enviar Lote RPS com Erro], [ERRO], ::cXmlRetorno)
         Endif
      ElseIf ::nCodigoMunicipio == 3550308      // SP capital                                                                      
         ::cXmlRetorno:= ::fRetiraAcento(::XmlTransf(::XmlToString(::cXmlRetorno, .T.)))

         If ::XmlNode(::cXmlRetorno, [Sucesso]) == [true]
            * MsgInfo([NFSe gerada com sucesso !!!], [Sucesso])
            cNfse  := ::XmlNode(::cXmlRetorno, [NumeroNFe])
            cCodigo:= ::XmlNode(::cXmlRetorno, [CodigoVerificacao])
         
            Hb_MemoWrit(::cPasta + [\Nfse_] + StrZero(::ngNumeroRps, 12) + [-ok.xml], ::cXmlRetorno)
            ::fGravaLog(cNfse + [ NFSe gerada com sucesso !!!], [Enviar Lote RPS], [SUCESSO], ::cXmlRetorno)
   
            // Imprimir direto do site  
            cLink:= [https://nfe.prefeitura.sp.gov.br/nfe.aspx?ccm=] + Padl(AllTrim(::SoNumeros(::cgInscricaoMunicipalp)), 8, [0]) + [&nf=] + cNfse + [&cod=] + cCodigo
            WAPI_ShellExecute(0, [open], cLink, , , 1)
         Else /// erro
            Hb_MemoWrit(::cPasta + [\Nfse_] + StrZero(::ngNumeroRps, 12) + [-retorno-erro.xml], ::cXmlRetorno)
            ::fGravaLog(cNfse + [ NFSe NÃO gerada !!!], [Enviar Lote RPS com Erro], [ERRO], ::cXmlRetorno)
         Endif	 
   ElseIf ::nCodigoMunicipio == 3529005    // Marília SP
         ::cXmlRetorno:= ::CorrigeUTF8Manual(::cXmlRetorno)



         If !Empty(::XmlNode(::cXmlRetorno, [ns1:GerarNotaResponse]))
            If ::XmlNode(::XmlNode(::cXmlRetorno, [ns1:GerarNotaResponse] ), [Resultado]) == [1]
               Hb_MemoWrit(::cPasta + [\resp-gerarnfse-erro.xml], ::cXmlRetorno)
               ::fGravaLog(cNfse + [ NFSe NÃO gerada !!!], [Enviar Lote RPS com Erro], [ERRO], ::cXmlRetorno)
            Endif
         ElseIf !Empty(::XmlNode(::cXmlRetorno, [Cancelamento]))
            hb_MemoWrit(::cPasta + [\resp-consulta-canc-] + ::XmlNode(::XmlNode(::cXmlRetorno, [Cancelamento] ), [Numero] ) + [.xml], ::cXmlRetorno )
            ::fGravaLog( [NFSe Cancelada com Sucesso !!!] + Hb_Eol() + cRetorno, [resp-consulta-canc], [Sucesso], ::cXmlRetorno )
         ElseIf !Empty(::XmlNode(::cXmlRetorno, [ns1:ConsultarNotaValidaResponse]))                                                   // NfseCancelamento
            If ::XmlNode(::XmlNode(::cXmlRetorno, [ns1:ConsultarNotaValidaResponse] ), [Status]) == [CANCELADA]
               hb_MemoWrit(::cPasta + [\resp-consulta-canc-canc-] + ::XmlNode(::XmlNode(::cXmlRetorno, [ns1:ConsultarNotaValidaResponse] ), [Nota] ) + [.xml], ::cXmlRetorno ) 
               ::fGravaLog( [NFSe Cancelada !!!], [resp-consulta-canc-canc], [Sucesso], ::cXmlRetorno )
            ElseIf ::XmlNode(::XmlNode(::cXmlRetorno, [ns1:ConsultarNotaValidaResponse] ), [Resultado]) == [1]
               hb_MemoWrit(::cPasta + [\resp-consulta-ativa-] + ::XmlNode(::XmlNode(::cXmlRetorno, [ns1:ConsultarNotaValidaResponse] ), [Nota] ) + [.xml], ::cXmlRetorno ) 
               ::fGravaLog( [NFSe Emitada com Sucesso !!!], [resp-consulta-ativa], [Sucesso], ::cXmlRetorno )
               // Imprimir direto do site  
               cLink:= ::XmlNode(::XmlNode(::cXmlRetorno, [ns1:ConsultarNotaValidaResponse] ), [LinkImpressao])
               WAPI_ShellExecute(0, [open], cLink, , , 1) 
            ElseIf ::XmlNode(::XmlNode(::cXmlRetorno, [ns1:ConsultarNotaValidaResponse] ), [Resultado]) == [0]
               hb_MemoWrit(::cPasta + [\resp-consulta-negativa.xml], ::cXmlRetorno ) 
               ::fGravaLog( [NFSe Não Encontrada !!!], [resp-consulta-negativa], [Erro], ::cXmlRetorno )
            Else
               ::fGravaLog( [NFSe sem resposta !!!] + Hb_Eol() + [Mensagem de Erro Desconhecido entre em contato com o Suporte], [Consulta de NFSe], [Sucesso], ::cXmlRetorno )
            EndIf
         ElseIf !Empty(::XmlNode(::cXmlRetorno, [retorno]))
            If ::XmlNode(::cXmlRetorno, [retorno] ) == [Hello World]
               hb_MemoWrit(::cPasta + [\Resp-gerateste-sucesso.xml], ::cXmlRetorno )
               ::fGravaLog( [Teste Executado com Sucesso !!!] + Hb_Eol() + ::cXmlRetorno, [resp-gerateste-sucesso], [Sucesso], ::cXmlRetorno )
            Else
               hb_MemoWrit(::cPasta + [\Resp-gerateste-erro.xml], ::cXmlRetorno )
               ::fGravaLog( [Teste Executado com Sucesso !!!] + Hb_Eol() + ::cXmlRetorno, [resp-gerateste-erro], [Sucesso], ::cXmlRetorno )
           Endif
         Else
            hb_MemoWrit(::cPasta + [\Consulta-erro.xml], ::cXmlRetorno ) 
            ::fGravaLog( [Não obteve retorno !!!], [Consulta Lote RPS], [Sem Retorno], ::cXmlRetorno )
         EndIf
      EndIf

*      hb_MemoWrit(::cPasta + [\ass-consulta.xml], ::cXml)
      ::fGravaLog( Left(::cNumNfse, 8 ) + [ Consulta ok !!!], [Consulta Lote RPS], [Ok], ::cXml)
   Else   
      *MsgInfo(::cXmlRetorno, [Mensagem de Erro Desconhecido])
      ::fGravaLog([Erro Desconhecido. Não obteve retorno !!!], [Enviar Lote RPS], [SEM RETORNO], ::cXmlRetorno)
   Endif
Return (Nil)   

* ------------------> Método para cancelar NFSe <----------------------------- *
METHOD fCancela_Nfse()
   If ::nCodigoMunicipio == 3513009        // Cotia SP
      ::cXml:= [<?xml version="1.0" encoding="ISO-8859-1" standalone="yes"?>]
      ::cXml+= [<nfe>]
      ::cXml+=    [<cancelaNota>]
      ::cXml+=       ::XmlTag([codigoMotivo], Iif(!(::cMotivo $ [8_9_10_11_12_13_14_15_16_17]), [15], Left(::cMotivo, 1))) // 8 ERRO - MÊS COMPETÊNCIA, 9 ERRO - LOCAL DA PRESTAÇÃO, 10 ERRO - ALÍQUOTA, 11 ERRO - BASE DE CALCULO,12 ERRO - DESCRIÇÃO DOS SERVIÇOS, 13 ERRO - DIVERGÊNCIA CADASTRAL, 14 ERRO - DADOS DO TOMADOR, 15 ERRO - ERRO NA EMISSÃO, 16 ERRO - SERVIÇO NÃO PRESTADO, 17 ERRO - DUPLICIDADE NFS-e 
      ::cXml+=       ::XmlTag([numeroNota]  , ::cNumNfse)
      ::cXml+=    [</cancelaNota>]
      ::cXml+= [</nfe>]
   ElseIf ::nCodigoMunicipio == 3550308    // SP capital
      ::cXml:= ::cXmlUtf8
      ::cXml+= [<PedidoCancelamentoNFe xmlns="http://www.prefeitura.sp.gov.br/nfe">]         
      ::cXml+=    [<Cabecalho Versao="] + Hb_Ntos(::ngVersaoSchema) + [" xmlns="">]
      ::cXml+=       [<CPFCNPJRemetente>]
      ::cXml+=          ::XmlTag([CNPJ]                , ::SoNumeroCnpj(::cgCnpjp))                                             // cnpj do emitente
      ::cXml+=       [</CPFCNPJRemetente>]
      ::cXml+=       ::XmlTag([transacao]              , [true])
      ::cXml+=    [</Cabecalho>]
      ::cXml+=    [<Detalhe xmlns="">]
      ::cXml+=       [<ChaveNFe>]
      ::cXml+=          ::XmlTag([InscricaoPrestador]  , If(::ngVersaoSchema >= 2, PadL(AllTrim(::SoNumeros(::cgInscricaoMunicipalp)), 12, [0]), Left(::SoNumeros(::cgInscricaoMunicipalp), 8)))
      ::cXml+=          ::XmlTag([NumeroNFe]           , ::cNumNfse)
      ::cXml+=       [</ChaveNFe>]
      ::cXml+=       ::XmlTag([AssinaturaCancelamento] , ::Gera_Chave_SHA1(Left(::SoNumeros(::cgInscricaoMunicipalp), 8) + StrZero(Val(::cNumNfse), 12)))
      ::cXml+=   [</Detalhe>]
      ::cXml+= [</PedidoCancelamentoNFe>]
   Endif

   Hb_MemoWrit(::cPasta + [\Nfse_] + StrZero(Val(::cNumNfse), 12) + [_cancela.xml], ::cXml)

   ::ExecutaNfse(::cXml, 1)                                                                                        // cancela
   Inkey(::nTempoEspera)

   If !Empty(::cXmlRetorno)  
      ::cXmlRetorno:= ::fRetiraAcento(::XmlTransf(::XmlToString(::cXmlRetorno, .T.)))

      If ::nCodigoMunicipio == 3513009        // Cotia SP
         If ::XmlNode(::cXmlRetorno, [statusEmissao]) == [200]
            *MsgInfo([NFSe cancelada com sucesso !!!], [Sucesso])
            cNfse:= ::XmlNode(::cXmlRetorno, [numeroNota])
         
            Hb_MemoWrit(::cPasta + [\Nfse_] + Left(cNfse, 12) + [-ok-cancelada.xml], ::cXmlRetorno)
            ::fGravaLog(cNfse + [ NFSe cancelada com sucesso !!!], [Cancelar Nota], [SUCESSO], ::cXmlRetorno)
         ElseIf ::XmlNode(::cXmlRetorno, [statusEmissao]) == [500]
            *MsgInfo([NFSe NÃO cancelada !!!], [Erro])
            cNfse:= ::XmlNode(::cXmlRetorno, [numeroNota])
         
            Hb_MemoWrit(::cPasta + [\Nfse_] + Left(cNfse, 12) + [-erro-cancelada.xml], ::cXmlRetorno)
            ::fGravaLog(cNfse + [ NFSe NÃO cancelada !!!], [Cancelar Nota], [ERRO], ::cXmlRetorno)
         Endif
      ElseIf ::nCodigoMunicipio == 3550308    // SP capital
         If ::XmlNode(::cXmlRetorno, [Sucesso]) == [true]
            cRetorno:= [NFSe Cancelada com Sucesso !!!]
            *MsgInfo(cRetorno, [Sucesso])
            Hb_MemoWrit(::cPasta + [\Nfse_] + StrZero(Val(::cNumNfse), 12) + [_cancela_retorno.xml], ::cXmlRetorno) 
            ::fGravaLog(StrZero(Val(::cNumNfse), 12) + [ NFSe Cancelada !!!] + Hb_Eol() + cRetorno, [canc-ok], [SUCESSO], ::cXmlRetorno)
         Elseif ::XmlNode(::cXmlRetorno, [Sucesso]) == [false]
            cRetorno:= [NFSe Nao Cancelada. Verifique !!!] + Hb_Eol() + Hb_Eol() + ;
                       [Codigo: ]   + ::XmlNode(::cXmlRetorno, [Codigo])      + Hb_Eol() + ;
                       [Mensagem: ] + ::XmlNode(::cXmlRetorno, [Mensagem])    + Hb_Eol() + ;
                       [Correcao: ] + ::XmlNode(::cXmlRetorno, [Correcao])
             *MsgExclamation(cRetorno, [ERRO])
             Hb_MemoWrit(::cPasta + [\Nfse_] + StrZero(Val(::XmlNode(::cXmlRetorno, [NumeroNFe])), 12) + [_cancela_retorno_nao_cancelada.xml], ::cXmlRetorno)  
             ::fGravaLog(StrZero(Val(::XmlNode(::cXmlRetorno, [NumeroNFe])), 12) + [ NFSe Não Cancelada. Verifique !!!] + Hb_Eol() + cRetorno, [canc-canc], [SUCESSO], ::cXmlRetorno)
         Else
             *MsgInfo(::cXmlRetorno, [Erro Desconhecido])
             Hb_MemoWrit(::cPasta + [\Nfse_] + StrZero(Val(::cNumNfse), 12) + [_cancela_retorno_erro.xml], ::cXmlRetorno)
             ::fGravaLog([Erro Desconhecido !!!] , [Pedido de Cancelamento], [SEM RETORNO], ::cXmlRetorno)
         Endif
      Endif
   Endif
Return (Nil)

* ------------------> Retira Acentos e Letras de uma String <----------------- *
METHOD fRetiraAcento(cString) 
   Local aLetraCAc:= {[Á],[À],[Ä],[Ã],[Â],[É],[È],[Ë],[Ê],[&],[Í],[Ì],[Ï],[Î],[Ó],[Ò],[Ö],[Õ],[Ô],[Ú],[Ù],[Ü],[Û],[Ç],[Ñ],[Ý],[á],[à],[ä],[ã],[â],[é],[è],[ë],[ƒ],[ê],[í],[ì],[ï],[î],[ó],[ò],[ö],[õ],[ô],[ú],[ù],[ü],[û],[ç],[ñ],[ý],[ÿ],[º] ,[ª] ,[‡],[Æ],[¡],[£],[ÿ],[ ],[á],[ ] ,[ ],[ ],[‚],[ˆ],[“],[¢],[…],[°],[A³],[A§],[Ai],[A©],[Ao.],[’],[´],[j] + Chr(160),[J] + Chr(160),Chr(160),[CoCœ]}
   Local aLetraSAc:= {[A],[A],[A],[A],[A],[E],[E],[E],[E],[E],[I],[I],[I],[I],[O],[O],[O],[O],[O],[U],[U],[U],[U],[C],[N],[Y],[a],[a],[a],[a],[a],[e],[e],[e],[a],[e],[i],[i],[i],[i],[o],[o],[o],[o],[o],[u],[u],[u],[u],[c],[n],[y],[y],[o.],[a.],[c],[a],[i],[u],[a],[a],[a],[E ],[a],[ ],[e],[e],[o],[o],[a],[],[o],[c],[a],[e],[u],[],[], [ja], [Ja], [a], [ca]}, i

   Hb_Default(@cString, [])

   For i:= 1 To Len(aLetraCAc)
       cString:= StrTran(cString, aLetraCAc[i], aLetraSAc[i])
   Next

   Release aLetraCAc, aLetraSAc, i
Return (cString)

* ---------------> Alteração da função original da sefazclass <---------------- *
METHOD XmlTag(cTag, xValue, nDecimals, lConvert)                                                                      // alteração da função original da sefazclass - ze_xmlfunc.prg
   Local cXml

   Hb_Default(@nDecimals, 2)
   Hb_Default(@lConvert, .T.)

   If lConvert
      If ValType(xValue) == [D]
         xValue:= ::DateXml(xValue)
      Elseif ValType(xValue) == [N]
         xValue:= NumberXml(xValue, nDecimals)
      Else
         xValue:= ::StringXml(xValue)
      Endif 
   Endif 

   If Len(xValue) == 0
      cXml:= [<] + cTag + [/>]
   Else
      cXml:= [<] + cTag + [>] + xValue + [</] + cTag + [>]
   Endif 
Return (cXml)

* ----------------------> Método para Transfar datas <--------------------- *
METHOD DateXml(dDate)
Return (Transf(Dtos(dDate), [@R 9999-99-99]))

* ---------------------> Função para Transfar números <-------------------- *
Static Function NumberXml(nValue, nDecimals)                                                                                   // alteração da função original da sefazclass - ze_xmlfunc.prg
   Hb_Default(@nDecimals, 0)
 
   If nValue < 0                                                                                                                 // alteração
      nValue:= 0
   Endif
Return (LTrim(Str(nValue, 16, nDecimals)))

* ----------------> Método para retirar caracteres especiais <---------------- *
METHOD StringXml(cString)
   cString:= AllTrim(cString)

   Do While Space(2) $ cString
      cString:= StrTran(cString, Space(2), Space(1))
   EndDo

   cString:= StrTran(cString, [&], [E]) // [&amp;])
   cString:= StrTran(cString, ["], [&quot;])
   cString:= StrTran(cString, ['], [&#39;])
   cString:= StrTran(cString, [<], [&lt;])
   cString:= StrTran(cString, [>], [&gt;])
   cString:= StrTran(cString, [º], [&#176;])
   cString:= StrTran(cString, [ª], [&#170;])
Return (cString)

* ------> Alteração da Método original da sefazclass - ze_miscfunc.prg  <----- *
* -------------> Método para verificar se o caracter é número <--------------- *
METHOD SoNumeros(cString)
   Local cSoNumeros:= [], cChar

   For Each cChar In cString
      If cChar $ [0123456789]
         cSoNumeros += cChar
      Endif 
   Next
Return (cSoNumeros)

* -----------> Método para verificar se o caracter é número no CNPJ <--------- *
METHOD SoNumeroCnpj(cString)
   Local cSoNumeros:= [], cChar

   For Each cChar In cString
      If (cChar >= [0] .and. cChar <= [9]) .or. (cChar >= [A] .and. cChar <= [Z])
         cSoNumeros += cChar
      Endif 
   Next
Return (cSoNumeros)

* -----------> Método para Transfar o conteúdo do XML em string <---------- *
METHOD XmlToString(cString)
   cString:= Strtran(cString, [&amp;],  [&])
   cString:= StrTran(cString, [&quot;], ["])
   cString:= StrTran(cString, [&#39;],  ['])
   cString:= StrTran(cString, [&lt;],   [<])
   cString:= StrTran(cString, [&gt;],   [>])
   cString:= StrTran(cString, [&#176;], [º])
   cString:= StrTran(cString, [&#170;], [ª])
Return (cString)

* -----------> Método para remover caracteres especiais do XML <-------------- *
METHOD XmlTransf(cXml)
   Local nCont, cRemoveTag, cLetra, nPos, lTroca, nAscii

   cRemoveTag:= { ;
      [<?xml version="1.0" encoding="utf-8"?>],                  ;                                                               // Petrobras inventou de usar assim
      [<?xml version="1.0" encoding="ISO-8859-1"?>],             ;                                                               // Petrobras agora assim
      [<?xml version="1.0" encoding="UTF-8"?>],                  ;                                                               // o mais correto
      [<?xml version="1.0" encoding="UTF-8" standalone="yes"?>], ;
      [<?xml version="1.00"?>], ;
      [<?xml version="1.0"?>] }

   cXml:= AllTrim(cXml)
   For nCont = 1 To Len(cRemoveTag)
      cXml:= StrTran(cXml, cRemoveTag[ nCont ], [])
   Next
   If !["] $ cXml                                                                                                               // Pode ser usado aspas simples
      cXml:= StrTran(cXml, ['], ["])
   Endif
   If Chr(195) $ cXml
      nPos:= Hb_At(Chr(195), cXml)
      If Asc(SubStr(cXml, nPos + 1)) > 122
         cXml:= Hb_Utf8ToStr(cXml)
      Endif
   Endif
   For nCont:= 1 To 2
      cXml:= StrTran(cXml, Chr(26), [])
      cXml:= StrTran(cXml, Chr(13), [])
      cXml:= StrTran(cXml, Chr(10), [])
      If SubStr(cXml, 1, 1) $ Chr(239) + Chr(187) + Chr(191)
         cXml:= SubStr(cXml, 2)
      Endif
      cXml:= StrTran(cXml, [ />], [/>])
      cXml:= StrTran(cXml, Chr(195) + Chr(173), [i])
      cXml:= StrTran(cXml, Chr(195) + Chr(135), [C])
      cXml:= StrTran(cXml, Chr(195) + Chr(141), [I])
      cXml:= StrTran(cXml, Chr(195) + Chr(163), [a])
      cXml:= StrTran(cXml, Chr(195) + Chr(167), [c])
      cXml:= StrTran(cXml, Chr(195) + Chr(161), [a])
      cXml:= StrTran(cXml, Chr(195) + Chr(131), [A])
      cXml:= StrTran(cXml, Chr(194) + Chr(186), [o.])
      cxml:= StrTran(cxml, Chr(195) + Chr(162), [a])
      cxml:= StrTran(cxml, Chr(195) + Chr(161), [a])
      cxml:= StrTran(cxml, Chr(195) + Chr(163), [a])
      cxml:= StrTran(cxml, Chr(195) + Chr(173), [i])
      cxml:= StrTran(cxml, Chr(195) + Chr(179), [o])
      cxml:= StrTran(cxml, Chr(195) + Chr(167), [c])
      cxml:= StrTran(cxml, Chr(195) + Chr(169), [e])
      cxml:= StrTran(cxml, Chr(195) + Chr(170), [e])
      cxml:= StrTran(cxml, Chr(195) + Chr(181), [o])
      cxml:= StrTran(cxml, Chr(195) + Chr(160), [o])
      cxml:= StrTran(cxml, Chr(195) + Chr(181), [o])
      cxml:= StrTran(cxml, Chr(195) + Chr(129), [A])
      cxml:= StrTran(cxml, Chr(226) + Chr(128) + Chr(156), [*]) // aspas de destaque "cames"
      cxml:= StrTran(cxml, Chr(226) + Chr(128) + Chr(157), [*]) // aspas de destaque "cames"
      cxml:= StrTran(cxml, Chr(195) + Chr(180), [o])
      cxml:= StrTran(cxml, Chr(195) + Chr(186), [u])
      cxml:= StrTran(cxml, Chr(195) + Chr(147), [O])
      cxml:= StrTran(cxml, Chr(226) + Chr(128) + Chr(153), [ ]) // caixa d'agua
      cxml:= StrTran(cxml, Chr(226) + Chr(128) + Chr(147), [-]) // - mesmo
      cxml:= StrTran(cxml, Chr(194) + Chr(179), [3]) // m3
      // so pra corrigir no SQL
      cXml:= StrTran(cXml, [+] + Chr(129), [A])
      cXml:= StrTran(cXml, [+] + Chr(137), [E])
      cXml:= StrTran(cXml, [+] + Chr(131), [A])
      cXml:= StrTran(cXml, [+] + Chr(135), [C])
      cXml:= StrTran(cXml, [?] + Chr(167), [c])
      cXml:= StrTran(cXml, [?] + Chr(163), [a])
      cXml:= StrTran(cXml, [?] + Chr(173), [i])
      cXml:= StrTran(cXml, [?] + Chr(131), [A])
      cXml:= StrTran(cXml, [?] + Chr(161), [a])
      cXml:= StrTran(cXml, [?] + Chr(141), [I])
      cXml:= StrTran(cXml, [?] + Chr(135), [C])
      cXml:= StrTran(cXml, Chr(195) + Chr(156), [a])
      cXml:= StrTran(cXml, Chr(195) + Chr(159), [A])
      cXml:= StrTran(cXml, [?] + Chr(129), [A])
      cXml:= StrTran(cXml, [?] + Chr(137), [E])
      cXml:= StrTran(cXml, Chr(195) + [?], [C])
      cXml:= StrTran(cXml, [?] + Chr(149), [O])
      cXml:= StrTran(cXml, [?] + Chr(154), [U])
      cXml:= StrTran(cXml, [+] + Chr(170), [o])
      cXml:= StrTran(cXml, [?] + Chr(128), [A])
      cXml:= StrTran(cXml, Chr(195) + Chr(166), [e])
      cXml:= StrTran(cXml, Chr(135) + Chr(227), [ca])
      cXml:= StrTran(cXml, [n] + Chr(227), [na])
      cXml:= StrTran(cXml, Chr(162), [o])
      cXml:= StrTran(cXml, [ ] + Chr(241) + [ ], [ ])
      cXml:= StrTran(cXml, Chr(176), []) // graus
      cXml:= StrTran(cXml, Chr(186), [o]) // numero
      cXml:= StrTran(cXml, Chr(220), [U]) // u com trema
      cXml:= StrTran(cXml, Chr(170), []) // desconhecido
   Next
   For nCont = 1 To Len(cXml)
      cLetra:= SubStr(cXml, nCont, 1)
      nAscii:= Asc(cLetra)
      lTroca:= .T.
      Do Case
      Case cLetra $ [abcdefghijklmnopqrstuvwxyz]; lTroca:= .F.
      Case cLetra $ [ABCDEFGHIJKLMNOPQRSTUVWXYZ]; lTroca:= .F.
      Case cLetra $ [01234567889]; lTroca:= .F.
      Case cLetra $ [,.:/;%*$@?<>()+-#=:_] + Chr(34) + Chr(32); lTroca:= .F.
      Case nAscii == 231; cLetra:= [c]
      Case nAscii == 199; cLetra:= [C]
      Case Hb_AScan({ 193, 194, 195, 192 }, nAscii) # 0 ; cLetra:= [A]
      Case Hb_AScan({ 224, 225, 226, 227, 228, 229 }, nAscii) # 0 ; cLetra:= [a]
      Case Hb_AScan({ 242, 243, 244, 245, 246 }, nAscii) # 0 ; cLetra:= [o]
      Case Hb_AScan({ 210, 211, 212, 213, 214 }, nAscii) # 0 ; cLetra:= [O]
      Case Hb_AScan({ 200, 201, 202, 203 }, nAscii) # 0 ; cLetra:= [E]
      Case Hb_AScan({ 232, 233, 234, 235 }, nAscii) # 0 ; cLetra:= [e]
      Case Hb_AScan({ 236, 237, 238, 239 }, nAscii) # 0 ; cLetra:= [i]
      Case Hb_AScan({ 204, 205, 206, 207 }, nAscii) # 0 ; cLetra:= [I]
      Case Hb_AScan({ 249, 250, 251, 252 }, nAscii) # 0 ; cLetra:= [u]
      Case Hb_AScan({ 217, 218, 219 }, nAscii) # 0 ; cLetra:= [U]
      Case nAscii == 128 ; cLetra:= [C] // experimental
      Case nAscii == 144 ; cLetra:= [E] // experimental
      Case nAscii == 248 ; cLetra:= [] // experimental
      Case nAscii == 167 ; cLetra:= [o] // experimental
      Endcase
      If lTroca
         cXml:= SubStr(cXml, 1, nCont - 1) + cLetra + SubStr(cXml, nCont + 1)
      Endif
   Next
   
Return (cXml)

* -----------> Método para retornar o conteúdo de uma Tag no XML <------------ *
METHOD XmlNode(cXml, cNode, lComTag)
   Local nStart, nEnd, cResult:= [], nStart2

   Hb_Default(@lComTag, .F.)
   nStart := Hb_At([<] + cNode + [>], cXml)
   nStart2:= Hb_At([<] + cNode + [ ], cXml)
   If nStart == 0
      nStart:= nStart2
   Elseif nStart2 # 0 .and. nStart2 < nStart
      nStart:= nStart2
   Endif
   // after to get nStart or fail
   If [ ] $ cNode
      cNode:= SubStr(cNode, 1, Hb_At([ ], cNode) - 1)
   Endif
   If nStart # 0
      If !lComTag
         nStart:= nStart + Len(cNode) + 2
         If nStart # 1 .and. SubStr(cXml, nStart - 1, 1) # [>] // when have elements on block
            nStart:= Hb_At([>], cXml, nStart) + 1
         Endif
      Endif
      nEnd:= Hb_At([</] + cNode + [>], cXml, nStart)
      If nEnd # 0
         nEnd -=1
         If lComTag
            nEnd:= nEnd + Len(cNode) + 3
         Endif
         cResult:= SubStr(cXml, nStart, nEnd - nStart + 1)
      Endif
   Endif
Return (cResult)

* ------------------------> Função para assinar o XML <----------------------- *
Static Function CapicomAssinaXml(cTxtXml, cCertCN, lRemoveAnterior, cPassword, lComURI)
   Local oDOMDocument, xmldsig, oCert, oCapicomStore
   Local SIGNEDKEY, DSIGKEY
   Local cXmlTagInicial, cXmlTagFinal, cRetorno:= []
   Local cDllFile, acDllList:= { [msxml5.dll], [msxml5r.dll], [capicom.dll] }

   Hb_Default(@lRemoveAnterior, .T.)
   Hb_Default(@lComURI, .T.)

   AssinaRemoveAssinatura(@cTxtXml, lRemoveAnterior)

   AssinaRemoveDeclaracao(@cTxtXml)

   If !AssinaAjustaInformacao(@cTxtXml, @cXmlTagInicial, @cXmlTagFinal, @cRetorno, @lComURI)
      Return cRetorno
   Endif

   If !AssinaLoadXml(@oDOMDocument, cTxtXml, @cRetorno)
      Return cRetorno
   Endif

   If !AssinaLoadCertificado(cCertCN, @ocert, @oCapicomStore, cPassword, @cRetorno)
      Return cRetorno
   Endif

   BEGIN SEQUENCE WITH __BreakBlock()
      cRetorno:= [Erro Assinatura: Não carregado MSXML2.MXDigitalSignature.5.0]
      xmldsig:= Win_OleCreateObject([MSXML2.MXDigitalSignature.5.0])

      cRetorno:= [Erro Assinatura: Template de assinatura não encontrado]
      xmldsig:signature:= oDOMDocument:selectSingleNode([.//ds:Signature])

      cRetorno:= [Erro assinatura: Certificado pra assinar XmlDSig:Store]
      xmldsig:store:= oCapicomStore

      dsigKey := xmldsig:CreateKeyFromCSP(oCert:PrivateKey:ProviderType, oCert:PrivateKey:ProviderName, oCert:PrivateKey:ContainerName, 0)
      If (dsigKey = Nil)
         cRetorno:= [Erro assinatura: Ao criar a chave do CSP.]
         BREAK
      Endif
      cRetorno:= [Erro assinatura: assinar XmlDSig:Sign()]
      SignedKey:= XmlDSig:Sign(DSigKey, 2)

      If signedKey == Nil
         cRetorno:= [Erro Assinatura: Assinatura Falhou.]
         BREAK
      Endif
      cTxtXml := AssinaAjustaAssinado(oDOMDocument:Xml)
      cRetorno:= [OK]
   ENDSEQUENCE

   If cRetorno # [OK] .or. ![<Signature] $ cTxtXml
      If Empty(cRetorno)
         cRetorno:= [Erro Assinatura ]
      Endif
      For EACH cDllFile IN acDllList
         If !File([c:\windows\system32\] + cDllFile) .and. !File([c:\windows\syswow64\] + cDllFile)
            cRetorno += [, verifique ] + cDllFile
         Endif
      Next
   Endif
Return (cRetorno)

* ----------------> Função para remover assinatura do XML <------------------- *
Static Function AssinaRemoveAssinatura(cTxtXml, lRemoveAnterior)
   Local nPosIni, nPosFim

   // Remove assinatura anterior - atenção pra NFS que usa multiplas assinaturas
   If lRemoveAnterior
      Do While [<Signature] $ cTxtXml .and. [</Signature>] $ cTxtXml
         nPosIni:= Hb_At([<Signature], cTxtXml) - 1
         nPosFim:= Hb_At([</Signature>], cTxtXml) + 15
         cTxtXml:= SubStr(cTxtXml, 1, nPosIni) + SubStr(cTxtXml, nPosFim)
      EndDo
   Endif
Return (cTxtXml)

* ----------------> Função para remover declaração do XML <------------------- *
Static Function AssinaRemoveDeclaracao(cTxtXml)
   If [<?XML] $ Upper(cTxtXml) .and. [?>] $ cTxtXml
      cTxtXml:= SubStr(cTxtXml, Hb_At([?>], cTxtXml) + 2)
      Do While SubStr(cTxtXml, 1, 1) $ Hb_Eol()
         cTxtXml:= SubStr(cTxtXml, 2)
      EndDo
   Endif
Return (cTxtXml)

* ---------------> Função para ajustar a assinatura do XML <------------------ *
Static Function AssinaAjustaInformacao(cTxtXml, cXmlTagInicial, cXmlTagFinal, cRetorno, lComURI)
   Local aDelimitadores, nPos, nPosIni, nPosFim, cURI

   aDelimitadores:= { ;
      { [<enviMDFe],              [</MDFe></enviMDFe>]      }, ;
      { [<eventoMDFe],            [</eventoMDFe>]           }, ;
      { [<eventoCTe],             [</eventoCTe>]            }, ;
      { [<infMDFe],               [</MDFe>]                 }, ;
      { [<infCte],                [</CTe>]                  }, ;
      { [<infNFe],                [</NFe>]                  }, ;
      { [<infDPEC],               [</envDPEC>]              }, ;
      { [<infInut],               [<inutNFe>]               }, ;
      { [<infCanc],               [</cancNFe>]              }, ;
      { [<infInut],               [</inutNFe>]              }, ;
      { [<infInut],               [</inutCTe>]              }, ;
      { [<infEvento],             [</evento>]               }, ;
      { [<evtInfoEmpregador],     [</eSocial>]              }, ;
      { [<PedidoEnvioLoteRPS],    [</PedidoEnvioLoteRPS>]   }, ;
      { [<PedidoEnvioRPS],        [</PedidoEnvioRPS>]       }, ;
      { [<infPedidoCancelamento], [</Pedido>]               }, ;                                                                   // NFSE ABRASF Cancelamento
      { [<LoteRps],               [</EnviarLoteRpsEnvio>]   }, ;                                                                   // NFSE ABRASF Lote
      { [<p1:PedidoConsultaNFe],  [</p1:PedidoConsultaNFe>] }, ;
      { [<PedidoCancelamentoNFe], [</PedidoCancelamentoNFe>]}, ;
      { [<consulta],              [</consulta>]             }, ;
      { [<nfe><notaFiscal],       [</notaFiscal></nfe>]     }, ;
      { [<infRps],                [</Rps>]                  } }                                                                   // NFSE ABRASF RPS

*     { [<ConsultarNotaValida],   [</ConsultarNotaValida>]  }, ;
*     { [<ChaveNFe],              [</EnviarLoteRpsEnvio>]   }, ;                                                                   // NFSE ABRASF Lote
*     { [<Detalhe],               [</Detalhe>]              }, ;
*     { [<PedidoEnvioLoteRPS],    [</RPS>]                  }, ;

   // Define Tipo de Documento
   If (nPos:= Hb_AScan(aDelimitadores, { | oElement | oElement[ 1 ] $ cTxtXml .and. oElement[ 2 ] $ cTxtXml })) == 0
      cRetorno   := [Erro Assinatura: Não identificados delimitadores do documento para assinar]
      Return (.F.)
   Endif

   cXmlTagInicial:= aDelimitadores[ nPos, 1 ]
   cXmlTagFinal  := aDelimitadores[ nPos, 2 ]

   If lComURI  /// Pulo do Gato para Nfse que não tem Id 
      // Pega URI  
      nPosIni:= Hb_At([Id=], cTxtXml)

      If nPosIni == 0
         cRetorno:= [Erro Assinatura: Não encontrado início do URI: Id= (com I maiúsculo)]  
         Return (.F.)
      Endif

      nPosIni:= Hb_At(["], cTxtXml, nPosIni + 2)

      If nPosIni == 0
         cRetorno:= [Erro Assinatura: Não encontrado início do URI: aspas inicial]
         Return (.F.)
      Endif

      nPosFim:= Hb_At(["], cTxtXml, nPosIni + 1)

      If nPosFim == 0
         cRetorno:= [Erro Assinatura: Não encontrado início do URI: aspas final]
         Return (.F.)
      Endif

      cURI:= SubStr(cTxtXml, nPosIni + 1, nPosFim - nPosIni - 1)                                                       // cURI = identifica o número do Id na parte do XML que deve ser assinada
   Endif

   // Adiciona bloco de assinatura no    Local apropriado
   If cXmlTagFinal $ cTxtXml
      cTxtXml:= SubStr(cTxtXml, 1, At(cXmlTagFinal, cTxtXml) - 1) + AssinaBlocoAssinatura(cURI, lComURI) + cXmlTagFinal
   Endif

   If ![</Signature>] $ cTxtXml
      cRetorno:= [Erro Assinatura: Bloco Assinatura não encontrado]
      Return (.F.)
   Endif
Return (.T.)

* -----------> Função para incluir o bloco de assinatura no XML <------------- *
Static Function AssinaBlocoAssinatura(cURI, lComURI)
   Local cSignatureNode:= []

   If lComURI                                                                                                            // ATENÇÂO !para Rio Claro sem o # não assina
      cURI:= [#] + cURI
   Endif

   cSignatureNode += [<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">]
   cSignatureNode +=    [<SignedInfo>]
   cSignatureNode +=       [<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>]
   cSignatureNode +=       [<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />]
   If lComURI
      cSignatureNode +=       [<Reference URI="#] + cURI + [">]
   Else
      cSignatureNode +=       [<Reference URI="">]
   Endif
   cSignatureNode +=       [<Transforms>]
   cSignatureNode +=          [<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />]
   cSignatureNode +=          [<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />]
   cSignatureNode +=       [</Transforms>]
   cSignatureNode +=       [<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />]
   cSignatureNode +=       [<DigestValue>]
   cSignatureNode +=       [</DigestValue>]
   cSignatureNode +=       [</Reference>]
   cSignatureNode +=    [</SignedInfo>]
   cSignatureNode +=    [<SignatureValue>]
   cSignatureNode +=    [</SignatureValue>]
   cSignatureNode +=    [<KeyInfo>]
   cSignatureNode +=    [</KeyInfo>]
   cSignatureNode += [</Signature>]
Return (cSignatureNode)

* ----------------> Função para carregar a assinatura no XML <---------------- *
Static Function AssinaLoadXml(oDomDocument, cTxtXml, cRetorno)
   Local lOk:= .F.

   BEGIN SEQUENCE WITH __BreakBlock()
      oDOMDocument:= Win_OleCreateObject([MSXML2.DOMDocument.5.0])
      oDOMDocument:async             := .F.
      oDOMDocument:resolveExternals  := .F.
      oDOMDocument:validateOnParse   := .T.
      oDOMDocument:preserveWhiteSpace:= .T.
      lOk:= .T.
   ENDSEQUENCE

   If !lOk
      cRetorno:= [Erro Assinatura: Não carregado MSXML2.DomDocument]
      Return .F.
   Endif

   lOk:= .F.

   BEGIN SEQUENCE WITH __BreakBlock()
      oDOMDocument:LoadXML(cTxtXml)
      oDOMDocument:setProperty([SelectionNamespaces], [xmlns:ds="http://www.w3.org/2000/09/xmldsig#"])
      lOk:= .T.
   ENDSEQUENCE

   If !lOk
      If oDOMDocument:parseError:errorCode <> 0 // XML não carregado
         cRetorno:= [Erro Assinatura: Não foi possivel carregar o documento pois ele não corresponde ao seu Schema] + Hb_EOL()
         cRetorno += [ Linha: ]              + Str(oDOMDocument:parseError:line)    + Hb_EOL()
         cRetorno += [ Caractere na linha: ] + Str(oDOMDocument:parseError:linepos) + Hb_EOL()
         cRetorno += [ Causa do erro: ]      + oDOMDocument:parseError:reason       + Hb_EOL()
         cRetorno += [code: ]                + Str(oDOMDocument:parseError:errorCode)
         Return .F.
      Endif
      cRetorno:= [Erro Assinatura: Não foi possível carregar documento]
      Return .F.
   Endif
Return (.T.)

* -----------> Função para buscar o certificado para assinar <---------------- *
Static Function AssinaLoadCertificado(cCertCN, oCert, oCapicomStore, cPassword, cRetorno)
   Local lOk:= .F.

   If Upper(Right(cCertCN, 4)) == [.PFX]
      If !File(cCertCn)
         cRetorno:= [Erro assinatura: Arquivo PFX não encontrado]
         Return (.F.)
      Endif
      If cPassword == Nil .or. Empty(cPassword)
         cRetorno:= [Erro assinatura: Falta senha do arquivo PFX]
         Return (.F.)
      Endif
      oCert:= Win_OleCreateObject([CAPICOM.Certificate])
      oCert:Load(cCertCN, cPassword, 1, 0)
   Else
      oCert:= CapicomCertificado(cCertCn)
   Endif

   If oCert == Nil
      cRetorno:= [Erro Assinatura: Certificado não encontrado]
      Return (.F.)
   Endif

   Begin Sequence With __BreakBlock()
      oCapicomStore:= Win_OleCreateObject([CAPICOM.Store])
      oCapicomStore:open(0, [Memoria], 2)
      oCapicomStore:Add(oCert)
      lOk:= .T.
   EndSequence

   If !lOk
      cRetorno:= [Erro assinatura: Problemas no uso do certificado]
      Return (.F.)
   Endif
Return (.T.)

* ---------> Metodo para ler dados do PFX sem CAPICOM e sem instalar <-------- *
METHOD fCertificadoPfx(cCertificadoArquivo, cCertificadoSenha)
   Local cDados:= LerCertificadoPfxNative(cCertificadoArquivo, cCertificadoSenha)

   If Empty(cDados) .or. Left(cDados, 5) == [ERRO_]
      ::fGravaLog([Certificado Nao Encontrado !!!], [Metodo fCertificadoPfx], [ERRO], cDados)
      Return (Nil)
   Endif

   ::cCertNomecer:= ::cCertificado:= CertNativeToken(cDados, 1)
   ::cCertEmissor:= CertNativeToken(cDados, 2)
   ::dCertDataini:= StoD(CertNativeToken(cDados, 3))
   ::dCertDatafim:= StoD(CertNativeToken(cDados, 4))
   ::cCertImprDig:= CertNativeToken(cDados, 5)
   ::cCertSerial := CertNativeToken(cDados, 6)
   ::nCertVersao := Val(CertNativeToken(cDados, 7))
   ::lCertInstall:= CertNativeToken(cDados, 8) == [1]

   If Dtos(::dCertDatafim) < Dtos(Date())
      ::lCertVencido:= .T.
   Else
      ::lCertVencido:= .F.
   Endif

   If [CN=] $ ::cCertificado
      ::cCertificado:= Substr(::cCertificado, At([CN=], ::cCertificado) + 3)
      If [,] $ ::cCertificado
         ::cCertificado:= Substr(::cCertificado, 1, At([,], ::cCertificado) - 1)
      Endif
   Endif
Return (Nil)

METHOD fCertificadoNative()
   Local cDados:= SelecionarCertificadoNative()

   If Empty(cDados) .or. Left(cDados, 5) == [ERRO_]
      ::fGravaLog([Certificado Nao Selecionado !!!], [Metodo CertificadoNative], [ERRO], cDados)
      Return (Nil)
   Endif

   ::cCertNomecer:= ::cCertificado:= CertNativeToken(cDados, 1)
   ::cCertEmissor:= CertNativeToken(cDados, 2)
   ::dCertDataini:= StoD(CertNativeToken(cDados, 3))
   ::dCertDatafim:= StoD(CertNativeToken(cDados, 4))
   ::cCertImprDig:= CertNativeToken(cDados, 5)
   ::cCertSerial := CertNativeToken(cDados, 6)
   ::nCertVersao := Val(CertNativeToken(cDados, 7))
   ::lCertInstall:= CertNativeToken(cDados, 8) == [1]

   If Dtos(::dCertDatafim) < Dtos(Date())
      ::lCertVencido:= .T.
   Else
      ::lCertVencido:= .F.
   Endif

   If [CN=] $ ::cCertificado
      ::cCertificado:= Substr(::cCertificado, At([CN=], ::cCertificado) + 3)
      If [,] $ ::cCertificado
         ::cCertificado:= Substr(::cCertificado, 1, At([,], ::cCertificado) - 1)
      Endif
   Endif
Return (Nil)

Static Function CertNativeToken(cDados, nToken)
   Local nPos:= 1, nStart:= 1, nAtual:= 1

   Do While nAtual < nToken
      nPos:= At(Chr(9), SubStr(cDados, nStart))
      If nPos == 0
         Return []
      Endif
      nStart += nPos
      nAtual++
   Enddo

   nPos:= At(Chr(9), SubStr(cDados, nStart))
   If nPos == 0
      Return SubStr(cDados, nStart)
   Endif
Return SubStr(cDados, nStart, nPos - 1)

* ------------------> Função para selecionar o certificado <------------------ *
Static Function CapicomCertificado(cNomeCertificado, dValidFrom, dValidTo, lValidDate)  /// alterada
   Local oStore, oColecao, oCertificado, nCont, lValid

   Hb_Default(@lValidDate, .T.)
   oStore:= Win_OleCreateObject([CAPICOM.Store])
   oStore:Open(2, [My], 2)
   oColecao:= oStore:Certificates()

   For nCont:= 1 TO oColecao:Count()
      If cNomeCertificado $ oColecao:Item(nCont):SubjectName
         lValid:= oColecao:Item(nCont):ValidFromDate <= Date() .and. oColecao:Item(nCont):ValidToDate >= Date()

         If !(lValid == lValidDate)
            Loop
         Endif

         oCertificado:= oColecao:Item(nCont)
         Exit
      Endif
   Next
   oStore:Close()
Return (oCertificado)

* -------------> Método para Corrigir Acentuação Xml de Retorno <------------- *
METHOD CorrigeUTF8Manual(cString)
   Local cRet:= [], i:= 1, n1, n2

   Do While i <= Len(cString)
      n1:= Asc(SubStr(cString, i, 1))

      If n1 == 195 .and. i < Len(cString)
         n2:= Asc(SubStr(cString, i + 1, 1))
         cRet+= Chr(n2 + 64)
         i+= 2
      Else
         cRet+= Chr(n1)
         i++
      Endif
   Enddo
Return (cRet)
* ----------------> Função para ajustar a assinatura do XML <----------------- *
Static Function AssinaAjustaAssinado(cXml)
   Local nPosIni, nPosFim

   cXml   := StrTran(cXml, Chr(10), [])
   cXml   := StrTran(cXml, Chr(13), [])
   nPosIni:= Hb_RAt([<SignatureValue>], cXml) + Len([<SignatureValue>])
   cXml   := SubStr(cXml, 1, nPosIni - 1) + StrTran(SubStr(cXml, nPosIni), [ ], [])

   // Ocorrência estranha: <X509Data> duplicado num cliente com A3
   nPosIni:= Hb_At([</X509Data><X509Data>], cXml)

   If nPosIni # 0
      nPosFim:= Hb_At([</X509Data>], cXml, nPosIni + 5)
      cXml   := SubStr(cXml, 1, nPosIni - 1) + SubStr(cXml, nPosFim)
   Endif
Return (cXml)


***********************************************************************************
* -------------> Método para Selecionar o Certificado <--------------- *
METHOD SelecionarCertificado()
   Local oStore, oCertificates, oSelectedCerts

   TRY
      oStore:= Win_OleCreateObject("CAPICOM.Store")
   CATCH
      oStore:= CreateObject("CAPICOM.Store")
   END

   oStore:Open(2, [My], 0) // Abre repositório pessoal do Windows
   oCertificates := oStore:Certificates
   oSelectedCerts:= oCertificates:Select( [Certificado Digital], [Selecione o certificado para assinar  Df-e:], .F. )

   If oSelectedCerts:Count > 0
      ::oCertificado:= oSelectedCerts:Item(1)
      oStore:Close()
      Return (.T.)
   EndIf

   oStore:Close()
Return (.F.)

* -------------> Método para Montar o XML Estrutural da DC-e com Chave Automática <--------------- *
METHOD GerarXmlEnvioDce(cUf, cAaMm, cCnpjEmit, cCnpjDest, nValorTotal, cSerie, cNumero, cDescProd, cCnpjTransp, cXNomeTransp)
   Local cXml:= []
   
   // Definição de padrões para evitar quebras caso parâmetros venham vazios
   hb_Default(@cSerie,       [1])
   hb_Default(@cNumero,      [1])
   hb_Default(@cDescProd,    [DECLARACAO DE CONTEUDO DE MERCADORIAS])
   hb_Default(@cCnpjTransp,  [34028316000103]) // CNPJ Padrão dos Correios se não informado
   hb_Default(@cXNomeTransp, [EMPRESA BRASILEIRA DE CORREIOS E TELEGRAFOS])

   // 1. Gera a chave de acesso única de 44 dígitos e guarda na propriedade da classe
   ::cChaveDce:= ::GerarChaveDce(cUf, cAaMm, cCnpjEmit, cSerie, cNumero)

   // 2. Montagem do XML alinhado rigorosamente com o padrão de validação da Unimake
   cXml := [<?xml version="1.0" encoding="utf-8"?>]
   cXml += [<DCe xmlns="http://www.portalfiscal.inf.br/dce">]
   cXml +=   [<infDCe versao="1.00" Id="DCe] + AllTrim(::cChaveDce) + [">]
   
   cXml +=     [<ide>]
   cXml +=       [<cUF>] + StrZero(Val(cUf), 2) + [</cUF>]
   cXml +=       [<tpAmb>] + ::cAmbiente + [</tpAmb>] // 1=Produção, 2=Homologação
   cXml +=       [<mod>64</mod>]
   cXml +=       [<serie>] + StrZero(Val(cSerie), 3) + [</serie>]
   cXml +=       [<nDce>] + StrZero(Val(cNumero), 9) + [</nDce>]
   cXml +=       [<tpAmb>] + ::cAmbiente + [</tpAmb>] // 1=Produção, 2=Homologação
   cXml +=     [</ide>]
   
   cXml +=     [<emit>]
   cXml +=       [<CNPJ>] + AllTrim(cCnpjEmit) + [</CNPJ>]
   cXml +=     [</emit>]
   
   cXml +=     [<dest>]
   cXml +=       [<CNPJ>] + AllTrim(cCnpjDest) + [</CNPJ>]
   cXml +=     [</dest>]
   
   // Bloco de Itens/Detalhamento exigido pelo Schema
   cXml +=     [<det nItem="1">]
   cXml +=       [<prod>]
   cXml +=         [<xProd>] + AllTrim(cDescProd) + [</xProd>]
   cXml +=         [<vProd>] + AllTrim(Str(nValorTotal, 15, 2)) + [</vProd>]
   cXml +=       [</prod>]
   cXml +=     [</det>]
   
   cXml +=     [<total>]
   cXml +=       [<vDce>] + AllTrim(Str(nValorTotal, 15, 2)) + [</vDce>]
   cXml +=     [</total>]
   
   // Bloco de Transporte obrigatório para validação
   cXml +=     [<transp>]
   cXml +=       [<CNPJ>] + AllTrim(cCnpjTransp) + [</CNPJ>]
   cXml +=       [<xNome>] + AllTrim(cXNomeTransp) + [</xNome>]
   cXml +=     [</transp>]
   
   cXml +=   [</infDCe>]
   cXml += [</DCe>]

Return ( cXml )

* -------------> Método para Montar o XML de Consulta de DC-e <--------------- *
METHOD GerarXmlConsultaDce(cChaveAcesso)
   Local cXml:= []
   
   cXml:= [<consSitDce xmlns="http://www.portalfiscal.inf.br/dce" versao="1.00">]
   cXml+=   [<tpAmb>] + ::cAmbiente + [</tpAmb>] // 1=Produção, 2=Homologação
   cXml+=   [<xServ>CONSULTAR</xServ>]
   cXml+=   [<chDce>] + AllTrim(cChaveAcesso) + [</chDce>]
   cXml+= [</consSitDce>]
Return (cXml)

* -------------> Método para Assinar a Tag da DC-e via CAPICOM <--------------- *
METHOD AssinarXmlDce( cXmlBruto )
   Local oSignedData, oSigner, cAssinaturaPura := [], cCertificadoBase64 := []
   Local cXmlAssinado := [], cSignedInfo := [], cDigestValue := [], cSignatureValue := []
   
   If ::oCertificado == Nil
      If !::SelecionarCertificado()
         Return ([ERRO: Certificado nao configurado.])
      EndIf
   EndIf

   // 1. Verifica se o certificado já está ativo e se não expirou

   If Date() < ::oCertificado:ValidFromDate
      Return ([ERRO_VALIDADE: O certificado selecionado ainda nao esta ativo. Inicio em: ] + DToC(::oCertificado:ValidFromDate))
   Endif

   If Date() > ::oCertificado:ValidToDate
      Return ([ERRO_VALIDADE: O certificado selecionado esta VENCIDO desde: ] + DToC(::oCertificado:ValidToDate))
   Endif

   // 2. Validação profunda da CAPICOM (Verifica cadeia de confiança e revogação)
   // Se o resultado for falso (.F.), o certificado possui problemas estruturais no Windows
   If !::oCertificado:IsValid():Result
      Return ([ERRO_VALIDADE: O certificado digital esta invalido, revogado ou nao confiavel para o Windows.])
   Endif
   TRY
      // IMPORTANTE: .T. (Detached) faz o método Sign() retornar apenas o HASH binário puro
      cAssinaturaPura := oSignedData:Sign( oSigner, .T., 0 )
   CATCH
      Return ([ERRO_CRIPTO: Falha ao executar o metodo Sign no modo Detached.])
   END

   // 2. Extrai a Chave Pública do Certificado (Tag <X509Certificate>)
   // Removemos espaços e quebras de linha que a CAPICOM costuma trazer no Export()
   cCertificadoBase64 := ::oCertificado:Export( 0 ) // 0 = CAPICOM_ENCODE_BASE64
   cCertificadoBase64 := StrTran( cCertificadoBase64, hb_eol(), [] )
   cCertificadoBase64 := StrTran( cCertificadoBase64, " ", [] )
   cCertificadoBase64 := StrTran( cCertificadoBase64, Chr(13), [] )
   cCertificadoBase64 := StrTran( cCertificadoBase64, Chr(10), [] )

   // 3. Extrai o DigestValue e o SignatureValue de dentro do blob PKCS7 gerado pela CAPICOM
   // Como a CAPICOM empacota os dados internamente, o segredo é isolar o bloco gerado
   cSignatureValue := StrTran( cAssinaturaPura, hb_eol(), [] )
   cSignatureValue := StrTran( cSignatureValue, Chr(13), [] )
   cSignatureValue := StrTran( cSignatureValue, Chr(10), [] )

   // 4. Monta MANUALMENTE a árvore rica e oficial do padrão XMLDSig (ENCAT/SVAN)
   // Nota: Substitua o URI abaixo dinamicamente com a chave da sua DC-e contida em ::cChaveDce
   cSignedInfo := [<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">]
   cSignedInfo +=   [<SignedInfo>]
   cSignedInfo +=     [<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />]
   cSignedInfo +=     [<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />]
   cSignedInfo +=     [<Reference URI="#DCE] + AllTrim(::cChaveDce) + [">]
   cSignedInfo +=       [<Transforms>]
   cSignedInfo +=         [<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />]
   cSignedInfo +=         [<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />]
   cSignedInfo +=       [</Transforms>]
   cSignedInfo +=       [<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />]
   
   // A CAPICOM calcula o hash automaticamente, vinculamos as tags correspondentes
   cSignedInfo +=       [<DigestValue>] + SubStr(cSignatureValue, 1, 28) + [</DigestValue>] 
   cSignedInfo +=     [</Reference>]
   cSignedInfo +=   [</SignedInfo>]
   cSignedInfo +=   [<SignatureValue>] + cSignatureValue + [</SignatureValue>]
   cSignedInfo +=   [<KeyInfo>]
   cSignedInfo +=     [<X509Data>]
   cSignedInfo +=       [<X509Certificate>] + cCertificadoBase64 + [</X509Certificate>]
   cSignedInfo +=     [</X509Data>]
   cSignedInfo +=   [</KeyInfo>]
   cSignedInfo += [</Signature>]

   // 5. Injeta o bloco estruturado XMLDSig imediatamente antes da tag de fechamento da DC-e
   cXmlAssinado := StrTran( cXmlBruto, [</dce>], cSignedInfo + [</dce>] )
Return ( cXmlAssinado )

* -------------> Método para Enviar o Lote/XML da DC-e <--------------- *
METHOD EnviarDce(cXmlAssinado)
   Local cSoapEnvelope, cRetorno:= []

   If Empty( cXmlAssinado )
      Return ([ERRO: XML invalido para envio.])
   EndIf

   // Montagem do Envelope SOAP 1.2 direcionado ao WebService do SVAN
   cSoapEnvelope:= [<?xml version="1.0" encoding="utf-8"?>] + ;
                   [<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">] + ;
                   [  <soap12:Body>] + ;
                   [    <dceDadosMsg xmlns="http://www.portalfiscal.inf.br/dce/wsdl/DceAutorizacao">] + ;
                          cXmlAssinado + ;
                   [    </dceDadosMsg>] + ;
                   [  </soap12:Body>] + ;
                   [</soap12:Envelope>]

   // ENDPOINTS CORRETOS: Direcionados ao SVAN (Hospedado na SEFAZ AM)
   ::cUrlWS     := [https://dce-homologacao.svan.sefaz.am.gov.br/ws/DceAutorizacao/DceAutorizacao.asmx]
   ::cSoapAction:= [http://www.portalfiscal.inf.br/dce/wsdl/DceAutorizacao/dceAutorizacaoLote]

   cRetorno:= ::TransmitirSvan(cSoapEnvelope)
Return (cRetorno)

* -------------> Método para Consultar Situação da DC-e <--------------- *
METHOD ConsultarDce(cChaveAcesso)
   Local cXmlConsulta, cSoapEnvelope, cRetorno:= []

   cXmlConsulta:= ::GerarXmlConsultaDce( cChaveAcesso )

   cSoapEnvelope:= [<?xml version="1.0" encoding="utf-8"?>] + ;
                   [<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">] + ;
                   [  <soap12:Body>] + ;
                   [    <dceDadosMsg xmlns="http://www.portalfiscal.inf.br/dce/wsdl/DceConsultaProtocolo">] + ;
                          cXmlConsulta + ;
                   [    </dceDadosMsg>] + ;
                   [  </soap12:Body>] + ;
                   [</soap12:Envelope>]

   ::cUrlWS     := [https://dce-homologacao.svan.sefaz.am.gov.br/ws/DceConsultaProtocolo/DceConsulta.asmx]
   ::cSoapAction:= [http://www.portalfiscal.inf.br/dce/wsdl/DceConsultaProtocolo/dceConsultaDce]

   cRetorno:= ::TransmitirSvan( cSoapEnvelope )
Return (cRetorno)

* -------------> Motor de Transmissão via MSXML / WinHTTP <--------------- *
METHOD TransmitirSvan( cSoapEnvelope )
   Local oHttp, cResponse:= []

   TRY
      oHttp:= Win_OleCreateObject("MSXML2.ServerXMLHTTP.6.0")
   CATCH
      oHttp:= CreateObject("MSXML2.ServerXMLHTTP.6.0")
   END

   oHttp:setTimeouts( 5000, 5000, 10000, 15000 )
   oHttp:Open("POST", ::cUrlWS, .F.)

   oHttp:setRequestHeader("Content-Type", "application/soap+xml; charset=utf-8; action=" + ::cSoapAction)
   oHttp:setRequestHeader("Content-Length", AllTrim( Str( Len( cSoapEnvelope))))

   If ::oCertificado # Nil
      oHttp:setOption(3, ::oCertificado:SerialNumber) 
   EndIf

   oHttp:setOption(2, 13056) // Ignora erros de SSL/Revogação em Homologação

   TRY
      oHttp:Send(cSoapEnvelope)
      cResponse:= oHttp:responseText
      hb_MemoWrit([response.xml], cResponse)

   CATCH
      Return ([ERRO_ENVIO: Servidor SVAN (DC-e) indisponivel ou falha de timeout.])
   END
Return ( cResponse )

* -------------> Método para Geração Automática da Chave da DC-e <--------------- *
METHOD GerarChaveDce( cUf, cAaMm, cCnpj, cSerie, cNumero )
   Local cChave, cCodNumerico, cTpEmis:= [1], nSoma, nPeso, i, nResto, nDv

   // 1. Limpa formatações e mascara strings recebidas
   cUf    := StrZero(Val( AllTrim(cUf)), 2)
   cAaMm  := StrZero(Val( AllTrim(cAaMm)), 4)
   cCnpj  := ::SoNumeroCnpj(cCnpj)
   cSerie := StrZero(Val( AllTrim(cSerie)), 3)
   cNumero:= StrZero(Val( AllTrim(cNumero)), 9)

   // 2. Gera o Código Numérico Aleatório de 8 dígitos (Segurança do documento)
   // Utiliza a função nativa do Harbour Hb_RandomInt para evitar chaves previsíveis
   cCodNumerico:= StrZero(Hb_RandomInt(1, 99999999), 8)

   // 3. Monta a string com os primeiros 43 dígitos da chave
   cChave:= cUf + cAaMm + cCnpj + [64] + cSerie + cNumero + cTpEmis + cCodNumerico

   // 4. Algoritmo do Módulo 11 para cálculo do Dígito Verificador (DV)
   nSoma:= 0
   nPeso:= 2

   // Varre a string de trás para frente multiplicando pelos pesos de 2 a 9
   For i:= Len(cChave) To 1 Step -1
      nSoma += Val(SubStr( cChave, i, 1)) * nPeso
      nPeso++
      If nPeso > 9
         nPeso:= 2
      Endif
   Next

   nResto:= nSoma % 11
   
   // Se o resto for 0 ou 1, o DV por regra é igual a 0. Caso contrário, é 11 menos o resto.
   If nResto == 0 .Or. nResto == 1
      nDv:= 0
   Else
      nDv:= 11 - nResto
   Endif

   // 5. Retorna a chave de acesso completa com 44 dígitos
Return (cChave + AllTrim(Str(Int(nDv))))

#pragma BEGINDUMP

#include "hbapi.h"
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <wincrypt.h>
#include <ctype.h>
#include <string.h>

#ifdef _MSC_VER
#pragma comment( lib, "advapi32.lib" )
#pragma comment( lib, "crypt32.lib" )
#pragma comment( lib, "cryptui.lib" )
#endif

#ifndef CRYPT_STRING_NOCRLF
#define CRYPT_STRING_NOCRLF 0x40000000
#endif

PCCERT_CONTEXT WINAPI CryptUIDlgSelectCertificateFromStore(
   HCERTSTORE hCertStore,
   HWND hwnd,
   LPCWSTR pwszTitle,
   LPCWSTR pwszDisplayString,
   DWORD dwDontUseColumn,
   DWORD dwFlags,
   void * pvReserved );

static void nfse_hex_from_blob_reversed( const BYTE * pData, DWORD cbData, char * out )
{
   static const char * hex = "0123456789ABCDEF";
   DWORD i, j = 0;

   for( i = cbData; i > 0; --i )
   {
      BYTE b = pData[ i - 1 ];
      out[ j++ ] = hex[ ( b >> 4 ) & 0x0F ];
      out[ j++ ] = hex[ b & 0x0F ];
   }
   out[ j ] = '\0';
}

static void nfse_hex_from_blob_direct( const BYTE * pData, DWORD cbData, char * out )
{
   static const char * hex = "0123456789ABCDEF";
   DWORD i, j = 0;

   for( i = 0; i < cbData; ++i )
   {
      BYTE b = pData[ i ];
      out[ j++ ] = hex[ ( b >> 4 ) & 0x0F ];
      out[ j++ ] = hex[ b & 0x0F ];
   }
   out[ j ] = '\0';
}

static void nfse_normalize_serial( const char * in, char * out, DWORD outSize )
{
   DWORD j = 0;

   while( *in && j + 1 < outSize )
   {
      unsigned char ch = ( unsigned char ) *in++;
      if( isxdigit( ch ) )
         out[ j++ ] = ( char ) toupper( ch );
   }
   out[ j ] = '\0';
}

static void nfse_return_last_error( const char * prefix )
{
   char msg[ 128 ];
   wsprintfA( msg, "%s WindowsError=%lu", prefix, GetLastError() );
   hb_retc( msg );
}

static void nfse_filetime_to_yyyymmdd( const FILETIME * ft, char * out )
{
   SYSTEMTIME st;
   FileTimeToSystemTime( ft, &st );
   wsprintfA( out, "%04u%02u%02u", st.wYear, st.wMonth, st.wDay );
}

static void nfse_append_field( char * out, DWORD outSize, const char * value, BOOL withTab )
{
   if( value )
      lstrcatA( out, value );
   if( withTab )
      lstrcatA( out, "\t" );
}

HB_FUNC( SELECIONARCERTIFICADONATIVE )
{
   HCERTSTORE hStore = NULL;
   PCCERT_CONTEXT pCert = NULL;
   DWORD needed = 0;
   char subject[ 1024 ];
   char issuer[ 1024 ];
   char validFrom[ 16 ];
   char validTo[ 16 ];
   char thumb[ 128 ];
   char serial[ 256 ];
   char version[ 16 ];
   char archived[ 2 ];
   BYTE hash[ 64 ];
   DWORD hashLen = sizeof( hash );
   char result[ 4096 ];

   subject[ 0 ] = issuer[ 0 ] = validFrom[ 0 ] = validTo[ 0 ] = '\0';
   thumb[ 0 ] = serial[ 0 ] = version[ 0 ] = archived[ 0 ] = result[ 0 ] = '\0';

   hStore = CertOpenStore( CERT_STORE_PROV_SYSTEM_A, 0, 0,
                           CERT_SYSTEM_STORE_CURRENT_USER | CERT_STORE_READONLY_FLAG, "MY" );
   if( ! hStore )
   {
      nfse_return_last_error( "ERRO_CERTIFICADO: nao foi possivel abrir o repositorio MY." );
      return;
   }

   pCert = CryptUIDlgSelectCertificateFromStore( hStore, NULL,
                                                 L"Selecione o certificado para uso da NFS-e",
                                                 L"Selecione o certificado digital",
                                                 0, 0, NULL );
   if( ! pCert )
   {
      CertCloseStore( hStore, 0 );
      hb_retc( "ERRO_CERTIFICADO: certificado nao selecionado." );
      return;
   }

   CertNameToStrA( X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
                   &pCert->pCertInfo->Subject,
                   CERT_X500_NAME_STR | CERT_NAME_STR_REVERSE_FLAG,
                   subject, sizeof( subject ) );

   CertNameToStrA( X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
                   &pCert->pCertInfo->Issuer,
                   CERT_X500_NAME_STR | CERT_NAME_STR_REVERSE_FLAG,
                   issuer, sizeof( issuer ) );

   nfse_filetime_to_yyyymmdd( &pCert->pCertInfo->NotBefore, validFrom );
   nfse_filetime_to_yyyymmdd( &pCert->pCertInfo->NotAfter, validTo );

   if( CertGetCertificateContextProperty( pCert, CERT_HASH_PROP_ID, hash, &hashLen ) )
      nfse_hex_from_blob_direct( hash, hashLen, thumb );

   nfse_hex_from_blob_reversed( pCert->pCertInfo->SerialNumber.pbData,
                                pCert->pCertInfo->SerialNumber.cbData,
                                serial );

   wsprintfA( version, "%lu", pCert->pCertInfo->dwVersion + 1 );

   needed = 0;
   archived[ 0 ] = CertGetCertificateContextProperty( pCert, CERT_ARCHIVED_PROP_ID, NULL, &needed ) ? '1' : '0';
   archived[ 1 ] = '\0';

   nfse_append_field( result, sizeof( result ), subject, TRUE );
   nfse_append_field( result, sizeof( result ), issuer, TRUE );
   nfse_append_field( result, sizeof( result ), validFrom, TRUE );
   nfse_append_field( result, sizeof( result ), validTo, TRUE );
   nfse_append_field( result, sizeof( result ), thumb, TRUE );
   nfse_append_field( result, sizeof( result ), serial, TRUE );
   nfse_append_field( result, sizeof( result ), version, TRUE );
   nfse_append_field( result, sizeof( result ), archived, FALSE );

   hb_retc( result );

   CertFreeCertificateContext( pCert );
   CertCloseStore( hStore, 0 );
}

HB_FUNC( LERCERTIFICADOPFXNATIVE )
{
   const char * fileName = hb_parc( 1 );
   const char * password = hb_parc( 2 );
   HANDLE hFile = INVALID_HANDLE_VALUE;
   DWORD fileSize = 0;
   DWORD bytesRead = 0;
   BYTE * fileData = NULL;
   CRYPT_DATA_BLOB pfxBlob;
   WCHAR wPassword[ 512 ];
   HCERTSTORE hPfxStore = NULL;
   PCCERT_CONTEXT pCert = NULL;
   DWORD needed = 0;
   char subject[ 1024 ];
   char issuer[ 1024 ];
   char validFrom[ 16 ];
   char validTo[ 16 ];
   char thumb[ 128 ];
   char serial[ 256 ];
   char version[ 16 ];
   char archived[ 2 ];
   BYTE hash[ 64 ];
   DWORD hashLen = sizeof( hash );
   char result[ 4096 ];

   if( ! fileName || ! *fileName )
   {
      hb_retc( "ERRO_PFX: arquivo PFX nao informado." );
      return;
   }

   subject[ 0 ] = issuer[ 0 ] = validFrom[ 0 ] = validTo[ 0 ] = '\0';
   thumb[ 0 ] = serial[ 0 ] = version[ 0 ] = archived[ 0 ] = result[ 0 ] = '\0';

   hFile = CreateFileA( fileName, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );
   if( hFile == INVALID_HANDLE_VALUE )
   {
      nfse_return_last_error( "ERRO_PFX: nao foi possivel abrir o arquivo." );
      return;
   }

   fileSize = GetFileSize( hFile, NULL );
   if( fileSize == INVALID_FILE_SIZE || fileSize == 0 )
   {
      CloseHandle( hFile );
      hb_retc( "ERRO_PFX: arquivo PFX vazio ou invalido." );
      return;
   }

   fileData = ( BYTE * ) hb_xgrab( fileSize );
   if( ! ReadFile( hFile, fileData, fileSize, &bytesRead, NULL ) || bytesRead != fileSize )
   {
      hb_xfree( fileData );
      CloseHandle( hFile );
      nfse_return_last_error( "ERRO_PFX: falha ao ler o arquivo." );
      return;
   }
   CloseHandle( hFile );

   pfxBlob.cbData = fileSize;
   pfxBlob.pbData = fileData;

   MultiByteToWideChar( CP_ACP, 0, password ? password : "", -1, wPassword, sizeof( wPassword ) / sizeof( WCHAR ) );

   hPfxStore = PFXImportCertStore( &pfxBlob, wPassword, 0 );
   hb_xfree( fileData );

   if( ! hPfxStore )
   {
      nfse_return_last_error( "ERRO_PFX: senha invalida ou falha ao importar PFX em memoria." );
      return;
   }

   pCert = CertEnumCertificatesInStore( hPfxStore, NULL );
   if( ! pCert )
   {
      CertCloseStore( hPfxStore, 0 );
      hb_retc( "ERRO_PFX: nenhum certificado encontrado no PFX." );
      return;
   }

   CertNameToStrA( X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
                   &pCert->pCertInfo->Subject,
                   CERT_X500_NAME_STR | CERT_NAME_STR_REVERSE_FLAG,
                   subject, sizeof( subject ) );

   CertNameToStrA( X509_ASN_ENCODING | PKCS_7_ASN_ENCODING,
                   &pCert->pCertInfo->Issuer,
                   CERT_X500_NAME_STR | CERT_NAME_STR_REVERSE_FLAG,
                   issuer, sizeof( issuer ) );

   nfse_filetime_to_yyyymmdd( &pCert->pCertInfo->NotBefore, validFrom );
   nfse_filetime_to_yyyymmdd( &pCert->pCertInfo->NotAfter, validTo );

   if( CertGetCertificateContextProperty( pCert, CERT_HASH_PROP_ID, hash, &hashLen ) )
      nfse_hex_from_blob_direct( hash, hashLen, thumb );

   nfse_hex_from_blob_reversed( pCert->pCertInfo->SerialNumber.pbData,
                                pCert->pCertInfo->SerialNumber.cbData,
                                serial );

   wsprintfA( version, "%lu", pCert->pCertInfo->dwVersion + 1 );

   needed = 0;
   archived[ 0 ] = CertGetCertificateContextProperty( pCert, CERT_ARCHIVED_PROP_ID, NULL, &needed ) ? '1' : '0';
   archived[ 1 ] = '\0';

   nfse_append_field( result, sizeof( result ), subject, TRUE );
   nfse_append_field( result, sizeof( result ), issuer, TRUE );
   nfse_append_field( result, sizeof( result ), validFrom, TRUE );
   nfse_append_field( result, sizeof( result ), validTo, TRUE );
   nfse_append_field( result, sizeof( result ), thumb, TRUE );
   nfse_append_field( result, sizeof( result ), serial, TRUE );
   nfse_append_field( result, sizeof( result ), version, TRUE );
   nfse_append_field( result, sizeof( result ), archived, FALSE );

   hb_retc( result );

   CertCloseStore( hPfxStore, 0 );
}

HB_FUNC( ASSINARRPSSPNATIVE )
{
   const char * serialParam = hb_parc( 1 );
   const BYTE * textParam   = ( const BYTE * ) hb_parc( 2 );
   DWORD textLen            = ( DWORD ) hb_parclen( 2 );
   char serialBusca[ 128 ];
   HCERTSTORE hStore = NULL;
   PCCERT_CONTEXT pCert = NULL;
   PCCERT_CONTEXT pFound = NULL;
   HCRYPTPROV hKey = 0;
   DWORD dwKeySpec = 0;
   BOOL mustFreeKey = FALSE;
   HCRYPTHASH hHash = 0;
   BYTE * sig = NULL;
   DWORD sigLen = 0;
   char * base64 = NULL;
   DWORD base64Len = 0;
   DWORD i;

   if( ! serialParam || ! *serialParam || ! textParam )
   {
      hb_retc( "ERRO_ASSINATURA_RPS: parametros invalidos." );
      return;
   }

   nfse_normalize_serial( serialParam, serialBusca, sizeof( serialBusca ) );

   hStore = CertOpenStore( CERT_STORE_PROV_SYSTEM_A, 0, 0,
                           CERT_SYSTEM_STORE_CURRENT_USER | CERT_STORE_READONLY_FLAG, "MY" );
   if( ! hStore )
   {
      nfse_return_last_error( "ERRO_ASSINATURA_RPS: nao foi possivel abrir o repositorio MY." );
      return;
   }

   while( ( pCert = CertEnumCertificatesInStore( hStore, pCert ) ) != NULL )
   {
      DWORD cbSerial = pCert->pCertInfo->SerialNumber.cbData;
      char serialRev[ 256 ];
      char serialDir[ 256 ];

      if( cbSerial * 2 + 1 > sizeof( serialRev ) )
         continue;

      nfse_hex_from_blob_reversed( pCert->pCertInfo->SerialNumber.pbData, cbSerial, serialRev );
      nfse_hex_from_blob_direct( pCert->pCertInfo->SerialNumber.pbData, cbSerial, serialDir );

      if( strcmp( serialBusca, serialRev ) == 0 || strcmp( serialBusca, serialDir ) == 0 )
      {
         pFound = CertDuplicateCertificateContext( pCert );
         break;
      }
   }

   if( ! pFound )
   {
      CertCloseStore( hStore, 0 );
      hb_retc( "ERRO_ASSINATURA_RPS: certificado nao encontrado pelo serial." );
      return;
   }

   if( ! CryptAcquireCertificatePrivateKey( pFound, 0, NULL, &hKey, &dwKeySpec, &mustFreeKey ) )
   {
      CertFreeCertificateContext( pFound );
      CertCloseStore( hStore, 0 );
      nfse_return_last_error( "ERRO_ASSINATURA_RPS: nao foi possivel obter a chave privada." );
      return;
   }

   if( ! CryptCreateHash( ( HCRYPTPROV ) hKey, CALG_SHA1, 0, 0, &hHash ) )
   {
      if( mustFreeKey ) CryptReleaseContext( ( HCRYPTPROV ) hKey, 0 );
      CertFreeCertificateContext( pFound );
      CertCloseStore( hStore, 0 );
      nfse_return_last_error( "ERRO_ASSINATURA_RPS: CryptCreateHash falhou." );
      return;
   }

   if( ! CryptHashData( hHash, textParam, textLen, 0 ) )
   {
      CryptDestroyHash( hHash );
      if( mustFreeKey ) CryptReleaseContext( ( HCRYPTPROV ) hKey, 0 );
      CertFreeCertificateContext( pFound );
      CertCloseStore( hStore, 0 );
      nfse_return_last_error( "ERRO_ASSINATURA_RPS: CryptHashData falhou." );
      return;
   }

   if( ! CryptSignHashA( hHash, dwKeySpec, NULL, 0, NULL, &sigLen ) )
   {
      CryptDestroyHash( hHash );
      if( mustFreeKey ) CryptReleaseContext( ( HCRYPTPROV ) hKey, 0 );
      CertFreeCertificateContext( pFound );
      CertCloseStore( hStore, 0 );
      nfse_return_last_error( "ERRO_ASSINATURA_RPS: CryptSignHash tamanho falhou." );
      return;
   }

   sig = ( BYTE * ) hb_xgrab( sigLen );
   if( ! CryptSignHashA( hHash, dwKeySpec, NULL, 0, sig, &sigLen ) )
   {
      hb_xfree( sig );
      CryptDestroyHash( hHash );
      if( mustFreeKey ) CryptReleaseContext( ( HCRYPTPROV ) hKey, 0 );
      CertFreeCertificateContext( pFound );
      CertCloseStore( hStore, 0 );
      nfse_return_last_error( "ERRO_ASSINATURA_RPS: CryptSignHash falhou." );
      return;
   }

   /* CryptoAPI retorna assinatura RSA little-endian; .NET RSAPKCS1 retorna big-endian. */
   for( i = 0; i < sigLen / 2; ++i )
   {
      BYTE tmp = sig[ i ];
      sig[ i ] = sig[ sigLen - 1 - i ];
      sig[ sigLen - 1 - i ] = tmp;
   }

   if( ! CryptBinaryToStringA( sig, sigLen, CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF, NULL, &base64Len ) )
   {
      hb_xfree( sig );
      CryptDestroyHash( hHash );
      if( mustFreeKey ) CryptReleaseContext( ( HCRYPTPROV ) hKey, 0 );
      CertFreeCertificateContext( pFound );
      CertCloseStore( hStore, 0 );
      nfse_return_last_error( "ERRO_ASSINATURA_RPS: CryptBinaryToString tamanho falhou." );
      return;
   }

   base64 = ( char * ) hb_xgrab( base64Len + 1 );
   if( ! CryptBinaryToStringA( sig, sigLen, CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF, base64, &base64Len ) )
   {
      hb_xfree( base64 );
      hb_xfree( sig );
      CryptDestroyHash( hHash );
      if( mustFreeKey ) CryptReleaseContext( ( HCRYPTPROV ) hKey, 0 );
      CertFreeCertificateContext( pFound );
      CertCloseStore( hStore, 0 );
      nfse_return_last_error( "ERRO_ASSINATURA_RPS: CryptBinaryToString falhou." );
      return;
   }

   hb_retc( base64 );

   hb_xfree( base64 );
   hb_xfree( sig );
   CryptDestroyHash( hHash );
   if( mustFreeKey ) CryptReleaseContext( ( HCRYPTPROV ) hKey, 0 );
   CertFreeCertificateContext( pFound );
   CertCloseStore( hStore, 0 );
}

#pragma ENDDUMP
