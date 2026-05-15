/*****************************************************************************
 * SISTEMA  : ROTINA EVENTUAL                                                *
 * PROGRAMA : DEMO.PRG   		                                     *
 * OBJETIVO : Gerar Xml de Nfe/Nfce                                          *
 * AUTOR    : Marcelo Antonio Lázzaro Carli                                  *
 * DATA     : 23.06.2025                                                     *
 * ULT. ALT.: 15.05.2026                                                     *
 *****************************************************************************/
#include <minigui.ch>

Procedure Main()
   REQUEST HB_LANG_PT
   REQUEST HB_CODEPAGE_PTISO
   REQUEST HB_CODEPAGE_PT850  &&& PARA INDEXAR CAMPOS ACENTUADOS
   REQUEST DBFCDX, DBFFPT
   HB_LangSelect([PT])
   HB_SETCODEPAGE([PT850])    &&& PARA INDEXAR CAMPOS ACENTUADOS
   HB_SETCODEPAGE([PTISO])    &&& PARA INDEXAR CAMPOS ACENTUADOS
   RDDSETDEFAULT([DBFCDX])
   Set Date Briti             &&& data no formato dd/mm/aaaados
   Set Dele On                &&& ignora registros marcados por deleção
   Set Score Off
   Set Exact On
   Setcancel(.F.)             &&& evitar cancelar sistema c/ ALT + C
   Set Cent On                &&& ano com 4 dígitos
   Set Epoch to 2000          &&& ano a partir de 2000
 
   Set Font to "MS Sans Serif", 8
   DEFINE WINDOW f_demo AT 0, 0 WIDTH 800 HEIGHT 600 TITLE [Gerar Xml] ICON [demo.ico] MAIN NOSIZE NOMAXIMIZE
        DEFINE MAIN MENU 
  	     POPUP [&Manutenções]
                 MENUITEM [&1. Gerar]          ACTION {|| fGerarxml()}
                 MENUITEM [&2. Buscar Pfx]     ACTION {|| fBuscarpfx()}
                 MENUITEM [&3. Gerar Json]     ACTION {|| fGerarjson()}
                 MENUITEM [&4. Consultar Gtin] ACTION {|| fConsultarGtin()}
                 MENUITEM [&5. Consultar Cnpj] ACTION {|| fConsultaCnpj()}
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

Static Procedure fConsultaCnpj()
   HB_SETCODEPAGE([PTISO])

   Set Font to "MS Sans Serif", 8
   DEFINE WINDOW fConsultaCnpj AT 0,0 WIDTH 620 HEIGHT 735 TITLE [Consulta de CNPJ] ICON [DEMO.ICO] MODAL NOSIZE NOSYSMENU
 
     DEFINE FRAME Frame_1
            ROW    10
            COL    10
            WIDTH  580
            HEIGHT 95
            OPAQUE .T.
     END FRAME

     DEFINE LABEL Label_1
            ROW    20
            COL    20
            WIDTH  60
            HEIGHT 16
            VALUE "CNPJ"
            FONTSIZE 10
     END LABEL

     DEFINE LABEL Label_2
            ROW    110
            COL    10
            WIDTH  120
            HEIGHT 16
            VALUE "Número de Inscrição"
     END LABEL

     DEFINE LABEL Label_3
            ROW    110
            COL    170
            WIDTH  120
            HEIGHT 16
            VALUE "Tipo"
     END LABEL

     DEFINE LABEL Label_4
            ROW    110
            COL    300
            WIDTH  100
            HEIGHT 16
            VALUE "Data de Abertura"
     END LABEL

     DEFINE LABEL Label_5
            ROW    110
            COL    410
            WIDTH  100
            HEIGHT 16
            VALUE "Porte"
     END LABEL

     DEFINE LABEL Label_6
            ROW    155
            COL    10
            WIDTH  120
            HEIGHT 16
            VALUE "Nome Empresarial"
     END LABEL

     DEFINE LABEL Label_7
            ROW    200
            COL    10
            WIDTH  110
            HEIGHT 16
            VALUE "Nome de Fantasia"
     END LABEL

     DEFINE LABEL Label_8
            ROW    245
            COL    10
            WIDTH  60
            HEIGHT 16
            VALUE "Endereço"
     END LABEL

     DEFINE LABEL Label_9
            ROW    245
            COL    490
            WIDTH  50
            HEIGHT 16
            VALUE "Número"
     END LABEL

     DEFINE LABEL Label_10
            ROW    290
            COL    10
            WIDTH  85
            HEIGHT 16
            VALUE "Complemento"
     END LABEL

     DEFINE LABEL Label_11
            ROW    290
            COL    320
            WIDTH  85
            HEIGHT 16
            VALUE "Bairro/Distrito"
     END LABEL

     DEFINE LABEL Label_12
            ROW    335
            COL    10
            WIDTH  60
            HEIGHT 16
            VALUE "Município"
     END LABEL

     DEFINE LABEL Label_13
            ROW    335
            COL    400
            WIDTH  20
            HEIGHT 16
            VALUE "Uf"
     END LABEL

     DEFINE LABEL Label_14
            ROW    335
            COL    460
            WIDTH  30
            HEIGHT 16
            VALUE "CEP"
     END LABEL

     DEFINE LABEL Label_15
            ROW    380
            COL    10
            WIDTH  40
            HEIGHT 16
            VALUE "Email"
     END LABEL

     DEFINE LABEL Label_16
            ROW    380
            COL    300
            WIDTH  55
            HEIGHT 16
            VALUE "Telefone"
     END LABEL

     DEFINE LABEL Label_17
            ROW    425
            COL    10
            WIDTH  120
            HEIGHT 16
            VALUE "Situação Cadastral"
     END LABEL

     DEFINE LABEL Label_18
            ROW    425
            COL    410
            WIDTH  155
            HEIGHT 16
            VALUE "Data da Situação Cadastral"
     END LABEL

     DEFINE LABEL Label_19
            ROW    470
            COL    10
            WIDTH  180
            HEIGHT 16
            VALUE "Ente Federativo Responsável"
     END LABEL

     DEFINE LABEL Label_20
            ROW    470
            COL    300
            WIDTH  180
            HEIGHT 16
            VALUE "Motivo de Situação Cadastral"
     END LABEL

     DEFINE LABEL Label_21
            ROW    515
            COL    10
            WIDTH  120
            HEIGHT 16
            VALUE "Situação Especial"
     END LABEL

     DEFINE LABEL Label_22
            ROW    515
            COL    410
            WIDTH  160
            HEIGHT 16
            VALUE "Data da Situação Especial"
     END LABEL

     DEFINE TEXTBOX Text_ConsCnpj
            ROW    35
            COL    20
            WIDTH  180
            HEIGHT 20
            FONTSIZE 11
            FONTBOLD .T.
            ONENTER {|| DoMethod([fConsultaCnpj], [Text_ConsCap], [SetFocus])}
            INPUTMASK "99.999.999/9999-99"
            TOOLTIP   "Entre com o Cnpj"
     END TEXTBOX

     DEFINE BUTTON Button_1
            ROW    35
            COL    230
            WIDTH  100
            HEIGHT 20
            ACTION {|| fConsultarCnpjClasse(GetProperty([fConsultaCnpj], [Text_ConsCnpj], [Value]))}
            CAPTION "Consultar"
            FONTBOLD .T.
     END BUTTON

     DEFINE BUTTON Button_2
            ROW    35
            COL    480
            WIDTH  100
            HEIGHT 20
            ACTION {|| ThisWindow.Release()}
            CAPTION "Sair"
            FONTBOLD .T.
     END BUTTON

     DEFINE TEXTBOX Text_3
            ROW    125
            COL    10
            WIDTH  150
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_4
            ROW    125
            COL    170
            WIDTH  120
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_5
            ROW    125
            COL    300
            WIDTH  100
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_55
            ROW    125
            COL    410
            WIDTH  180
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_6
            ROW    170
            COL    10
            WIDTH  580
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_7
            ROW    215
            COL    10
            WIDTH  580
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_8
            ROW    260
            COL    10
            WIDTH  470
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_9
            ROW    260
            COL    490
            WIDTH  100
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_10
            ROW    305
            COL    10
            WIDTH  300
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_12
            ROW    305
            COL    320
            WIDTH  270
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_13
            ROW    350
            COL    10
            WIDTH  380
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_14
            ROW    350
            COL    400
            WIDTH  50
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_11
            ROW    350
            COL    460
            WIDTH  130
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_15
            ROW    395
            COL    10
            WIDTH  280
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_16
            ROW    395
            COL    300
            WIDTH  290
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_18
            ROW    440
            COL    10
            WIDTH  390
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

      DEFINE TEXTBOX Text_19
            ROW    440
            COL    410
            WIDTH  180
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_17
            ROW    485
            COL    10
            WIDTH  280
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_20
            ROW    485
            COL    300
            WIDTH  290
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_21
            ROW    530
            COL    10
            WIDTH  390
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

     DEFINE TEXTBOX Text_22
            ROW    530
            COL    410
            WIDTH  180
            HEIGHT 24
            READONLY .T.
            FONTBOLD .T.
     END TEXTBOX

    DEFINE TAB Tab_1 AT 560,10 WIDTH 580 HEIGHT 130 VALUE 1 FONT 'Arial' SIZE 9

    PAGE 'Atividade Principal'

        DEFINE EDITBOX Edit_1
               ROW    30
               COL    10
               WIDTH  560
               HEIGHT 90
               READONLY .T.
               FONTBOLD .T.
        END EDITBOX

    END PAGE

    PAGE 'Atividades Secundárias'

        DEFINE EDITBOX Edit_2
               ROW    30
               COL    10
               WIDTH  560
               HEIGHT 90
               READONLY .T.
               FONTBOLD .T.
        END EDITBOX

    END PAGE

    PAGE 'Natureza Jurídica'

        DEFINE EDITBOX Edit_3
               ROW    30
               COL    10
               WIDTH  560
               HEIGHT 90
               READONLY .T.
               FONTBOLD .T.
        END EDITBOX

    END PAGE

    PAGE 'Capital Social'

        DEFINE EDITBOX Edit_4
               ROW    30
               COL    10
               WIDTH  560
               HEIGHT 90
               READONLY .T.
               FONTBOLD .T.
        END EDITBOX

    END PAGE

    PAGE 'Qsa'

        DEFINE EDITBOX Edit_5
               ROW    30
               COL    10
               WIDTH  560
               HEIGHT 90
               READONLY .T.
               FONTBOLD .T.
        END EDITBOX

    END PAGE

    END TAB

   END WINDOW

   On Key ESCAPE of fConsultaCnpj ACTION {|| ThisWindow.Release()}

   fConsultaCnpj.Center()
   fConsultaCnpj.Activate()
   HB_SETCODEPAGE([PT850])
Return (Nil)

Static Function fConsultarCnpjClasse(cCnpj)
   Local oNfe:= Malc_GeraXml():New(), cRet:= oNfe:fConsultaCNPJ(cCnpj)

   If cRet == [OK]
      _SetValue([Text_3] , [fConsultaCnpj], oNfe:cCnpj_Cnpj)
      _SetValue([Text_4] , [fConsultaCnpj], oNfe:cCnpj_tipo)
      _SetValue([Text_5] , [fConsultaCnpj], oNfe:cCnpj_abertura)
      _SetValue([Text_55], [fConsultaCnpj], oNfe:cCnpj_porte)
      _SetValue([Text_6] , [fConsultaCnpj], oNfe:cCnpj_RazaoSocial)
      _SetValue([Text_7] , [fConsultaCnpj], oNfe:cCnpj_NomeFantasia)
      _SetValue([Text_8] , [fConsultaCnpj], oNfe:cCnpj_logradouro)
      _SetValue([Text_9] , [fConsultaCnpj], oNfe:cCnpj_numero)
      _SetValue([Text_10], [fConsultaCnpj], oNfe:cCnpj_complemento)
      _SetValue([Text_11], [fConsultaCnpj], oNfe:cCnpj_cep)
      _SetValue([Text_12], [fConsultaCnpj], oNfe:cCnpj_bairro)
      _SetValue([Text_13], [fConsultaCnpj], oNfe:cCnpj_municipio)
      _SetValue([Text_14], [fConsultaCnpj], oNfe:cCnpj_uf)
      _SetValue([Text_15], [fConsultaCnpj], oNfe:cCnpj_email)
      _SetValue([Text_16], [fConsultaCnpj], oNfe:cCnpj_telefone)
      _SetValue([Text_17], [fConsultaCnpj], oNfe:cCnpj_efr)
      _SetValue([Text_18], [fConsultaCnpj], oNfe:cCnpj_situacao)
      _SetValue([Text_19], [fConsultaCnpj], oNfe:cCnpj_DataSituacao)
      _SetValue([Text_20], [fConsultaCnpj], oNfe:cCnpj_MotivoSituacao)
      _SetValue([Text_21], [fConsultaCnpj], oNfe:cCnpj_SitEspecial)
      _SetValue([Text_22], [fConsultaCnpj], oNfe:cCnpj_DataSitEspecial)
      _SetValue([Edit_1] , [fConsultaCnpj], oNfe:cCnpj_CnaePrincipal)
      _SetValue([Edit_2] , [fConsultaCnpj], oNfe:cCnpj_CnaeSecundario)
      _SetValue([Edit_3] , [fConsultaCnpj], oNfe:cCnpj_NaturezaJuridica)
      _SetValue([Edit_4] , [fConsultaCnpj], oNfe:cCnpj_CapitalSocial)
      _SetValue([Edit_5] , [fConsultaCnpj], oNfe:cCnpj_QSA)

      // Checagem de Simples
      IF oNfe:lCnpj_OptanteSimples
         MsgInfo("Esta empresa é optante pelo Simples Nacional!")
      ENDIF


   ELSE
      MsgStop(cRet)
   ENDIF
Return

Static Procedure fBuscarpfx()
   Local oXml:= Malc_GeraXml():New()  // Chamar a classe para gerar xml nfse no objeto oXml 
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
   Local oXml:= Malc_GeraXml():New(), i:= 0 // Chamar a classe para gerar xml nfe/nfce no objeto oXml 

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

   oXml:fCria_Destinatario() // criando a tag destinatário

   // ------------------------
   // DADOS DE ENTREGA
   // ------------------------
   oXml:cCnpjg   := "12345678000195"
   oXml:cXnomeg  := "Cliente Teste Ltda"
   oXml:cXfantg  := "Cliente Fantasia"
   oXml:cXlgrg   := "Rua das Flores"
   oXml:cNrog    := "123"
   oXml:cXcplg   := "Bloco A"
   oXml:cXBairrog:= "Centro"
   oXml:cMunfg   := "3550308"
   oXml:cXmung   := "Sao Paulo"
   oXml:cUfg     := "SP"
   oXml:cCepg    := "01001000"
   oXml:cPaisg   := "1058"
   oXml:cXpaisg  := "BRASIL"
   oXml:cFoneg   := "11987654321"
   oXml:cEmailg  := "cliente@teste.com.br"
   oXml:cIeg     := "123456789012"

   oXml:fCria_Entrega()

   // ------------------------
   // DADOS DE RETIRADA
   // ------------------------
   oXml:cCnpjr   := "12345678901"   // CPF neste caso
   oXml:cXnomer  := "Joao da Silva"
   oXml:cXlgrr   := "Avenida Brasil"
   oXml:cNror    := "456"
   oXml:cXBairror:= "Jardins"
   oXml:cMunfg   := "3304557"
   oXml:cXmunr   := "Rio de Janeiro"
   oXml:cUfE     := "RJ"
   oXml:cCepr    := "20040002"
   oXml:cPaisr   := "1058"
   oXml:cXpaisr  := "BRASIL"
   oXml:cFoner   := "21999999999"
   oXml:cIer     := "987654321000"

   oXml:fCria_Retirada()

   *** teste para nota para exterior / trocar por este valor
   * oXml:cIdestrangeiro:= [20250707]
   * oXml:cCmund        := [9999999]
   * oXml:cXmund        := [EXTERIOR]
   * oXml:cUfd          := [EX]
   * oXml:cPaisd        := [1694]
   * oXml:cXpaisd       := [COLOMBIA]
   * oXml:cIndiedest    := [9]


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

       // Reforma Tributária  - RTC
       oXml:cClasstribis := [000001]
       oXml:nVbcis       := 10
       oXml:nPisis       := 1
       oXml:cUtrib_is    := [UN]
       oXml:nQtrib_is    := 1
       oXml:nPredaliqgcbs:= 0.6

       oXml:cCclasstrib  := [000001]
       oXml:nVbcibs      := 10
       oXml:cCredPresgibs:= [01]
       oXml:cCredPrescbs := [01]

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

Static Procedure fGerarjson()
   Local cJsonText:= [], oJson, aNomenclaturas, nItem, oAnexos, nI, nj, cCdx, cNomArq := {}

   If !Hb_FileExists(GetCurrentfolder() + [/tabela_ncm.json])
      MsgExclamation([Não Existe Arquivo: tabela_ncm.json, Baixe em:] + hb_OsNewLine() + [https://www.unimake.com.br/downloads/tabela_ncm.json], [Atenção])
      Return (Nil)
   Endif

   If !Hb_FileExists(GetCurrentfolder() + [/tabela_cest.json])
      MsgExclamation([Não Existe Arquivo: tabela_cest.json. Baixe em:] + hb_OsNewLine() + [https://www.unimake.com.br/downloads/tabela_cest.json], [Atenção])
      Return (Nil)
   Endif

   If !Hb_FileExists(GetCurrentfolder() + [/tabela_nbs.json])
      MsgExclamation([Não Existe Arquivo: tabela_nbs.json, Baixe em] + hb_OsNewLine() + [https://www.unimake.com.br/downloads/tabela_nbs.json], [Atenção])
      Return (Nil)
   Endif

   If !Hb_FileExists(GetCurrentfolder() + [/tabela_ncm.dbf])
      Dbcreate([tabela_ncm], {{[CODIGO]    , [C], 010, 0},;
                              {[DESCRICAO] , [C], 999, 0},;
                              {[DT_INICIO] , [D], 008, 0},;
                              {[DT_FIM]    , [D], 008, 0},;
                              {[TIPO_ATO]  , [C], 030, 0},;
                              {[NUM_ATO]   , [N], 004, 0},;
                              {[ANO_ATO]   , [N], 004, 0},;
                              {[REDUZIDA]  , [C], 050, 0},;  
                              {[CST]       , [C], 003, 0},;
                              {[CCLASSTRIB], [C], 006, 0},;
                              {[ANEXOS]    , [C], 999, 0}})
   Else      
      use tabela_ncm exclusive
      tabela_ncm->(__dbzap())
   Endif

   If !Hb_FileExists(GetCurrentfolder() + [/tabela_cest.dbf])
      Dbcreate([tabela_cest], {{[CEST]     , [C], 009, 0},;
                               {[NCM_SH]   , [C], 010, 0},;
                               {[SEG_CEST] , [C], 300, 0},;
                               {[ITEM]     , [C], 010, 0},;
                               {[DESC_CEST], [C], 999, 0},;
                               {[ANEXO]    , [C], 100, 0}})
   Else      
      use tabela_cest exclusive
      tabela_cest->(__dbzap())
   Endif

   If !Hb_FileExists(GetCurrentfolder() + [/tabela_nbs.dbf])
      Dbcreate([tabela_nbs], {{[ITEM]     , [C], 005, 0},;
                              {[DESC_ITEM], [C], 300, 0},;
                              {[NBS]      , [C], 012, 0},;
                              {[DESC_NBS] , [C], 999, 0},;
                              {[ONEROSA]  , [C], 001, 0},;
                              {[EXTERIOR] , [C], 001, 0},;
                              {[INDOP]    , [C], 006, 0},;
                              {[LOCAL_INC], [C], 300, 0},;
                              {[CLASSTRIB], [C], 006, 0},;
                              {[DESC_CLAS], [C], 999, 0}})
   Else      
      use tabela_nbs exclusive
      tabela_nbs->(__dbzap())
   Endif

   Dbcloseall()
   HB_SETCODEPAGE([PTISO])

   cFile:= GetCurrentfolder() + [/tabela_ncm.json]
   If Hb_FileExists(cFile)
      use tabela_ncm shared

      cJsonText:= StrTran(Hb_MemoRead(cFile), '"; ', '"=> ' )

      oJson := hb_jsonDecode( cJsonText )
      aNomenclaturas := oJson["Nomenclaturas"]
 
      For nI:= 1 To Len( aNomenclaturas )
          oItem := aNomenclaturas[ nI ]

          tabela_ncm->( DBAppend() )
          tabela_ncm->Codigo   := oItem["Codigo"]
          tabela_ncm->Descricao:= hb_utf8ToStr( oItem["Descricao"], "PTISO" )
          tabela_ncm->Dt_inicio:= CToD( oItem["Data_Inicio"] )
          tabela_ncm->Dt_fim   := CToD( oItem["Data_Fim"] )
          tabela_ncm->tipo_ato := oItem["Tipo_Ato"]
          tabela_ncm->num_ato  := Val(oItem["Numero_Ato"])
          tabela_ncm->ano_ato  := Val(oItem["Ano_Ato"])
          tabela_ncm->Reduzida := SubStr( tabela_ncm->Codigo, 1, 50 )
      
          If HB_HHasKey( oItem, "Anexos" ) .And. HB_ISARRAY( oItem["Anexos"] )
             aAnexos := oItem["Anexos"]
             For nJ:= 1 To Len( aAnexos )
                 oAnexo := aAnexos[ nJ ]
                 tabela_ncm->CST        := oAnexo["CST"]
                 tabela_ncm->CclassTrib := oAnexo["cClassTrib"]
             Next
          Endif
      Next

      tabela_ncm->(DbcloseArea())
   Endif

   nItem:= 1
   cFile:= GetCurrentfolder() + [/tabela_cest.json]
   If Hb_FileExists(cFile)
      use tabela_cest shared

      If At(["CEST"], hb_Memoread(cFile)) # 0
         For EACH nItem IN Hb_jsonDecode(hb_Memoread(cFile))
             tabela_cest->(DBAppend())
             tabela_cest->cest     := nItem["CEST"]
             tabela_cest->ncm_sh   := nItem["NCM_SH"]
             tabela_cest->seg_cest := hb_UTF8ToStr(nItem["Segmento_CEST"])
             tabela_cest->item     := nItem["Item"]
             tabela_cest->desc_cest:= hb_UTF8ToStr(nItem["Descricao_CEST"])
             tabela_cest->anexo    := nItem["Anexo_XXVII"]
         Next
      Endif

      tabela_cest->(DbcloseArea())
   Endif

   nItem:= 1
   cFile:= GetCurrentfolder() + [/tabela_nbs.json]
   If Hb_FileExists(cFile)
      use tabela_nbs shared

      If At(["Item_LC_116"], hb_Memoread(cFile)) # 0
         For EACH nItem IN Hb_jsonDecode(hb_Memoread(cFile))
             tabela_nbs->(DBAppend())
             tabela_nbs->item     := nItem["Item_LC_116"]
             tabela_nbs->desc_item:= hb_UTF8ToStr(nItem["Descricao_Item"])
             tabela_nbs->nbs      := nItem["NBS"]
             tabela_nbs->desc_nbs := hb_UTF8ToStr(nItem["Descricao_NBS"])
             tabela_nbs->onerosa  := hb_UTF8ToStr(nItem["PS_Onerosa"])
             tabela_nbs->exterior := nItem["ADQ_Exterior"]
             tabela_nbs->indop    := nItem["IndOP"]
             tabela_nbs->local_inc:= hb_UTF8ToStr(nItem["Local_Incidencia_IBS"])
             tabela_nbs->classtrib:= nItem["cClassTrib"]
             tabela_nbs->desc_clas:= hb_UTF8ToStr(nItem["Nome_cClassTrib"])
         Next
      Endif

      tabela_nbs->(DbcloseArea())
   Endif
   HB_SETCODEPAGE([PT850])
Return

Static Procedure fConsultarGtin()
   Local oXml:= Malc_GeraXml():New(), cChave:= cRetorno:= [] // Chamar a classe para gerar xml nfe/nfce no objeto oXml 

   WaitWindow([*** Consultando Gtin. Aguarde término do processo... ***], .T.)

*   fSelecionarCertificado()

   cChave:= InputBox([Gtin: ], [Digite o Gtin], [7896045506934])

   cRetorno:= oXml:fConsultaGTIN(cChave)

   MsgInfo(cRetorno)

   WaitWindow()
Return (Nil)

#include <nfe_classe.prg>