#include "minigui.ch"

Procedure Main()
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
 
   Set Font to "MS Sans Serif", 8
   DEFINE WINDOW f_demo AT 0, 0 WIDTH 800 HEIGHT 600 TITLE [Gerar Xml] ICON [demo.ico] MAIN NOSIZE NOMAXIMIZE
        DEFINE MAIN MENU 
  	     POPUP [&Manutenções]
                 MENUITEM [&1. Calcular Ids Alfas]    ACTION {|| ids()}
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

#include <hbclass.ch>

PROCEDURE ids()
   Local oNfe
   Local aExemplos := {}
   Local nCont, cChaveRaiz, cDigitoGerado, cDigitoEsperado

   // Casos reais fornecidos tirando o último dígito (DV) para testar o método
   AAdd(aExemplos, { "352607A1B2C3D4000A0655001000123001173000137", "9" })
   AAdd(aExemplos, { "352607Z9Y8X7W6000B9255002000123002173000274", "2" })
   AAdd(aExemplos, { "352607M5N4P3R2000C6455003000123003173000411", "6" })
   AAdd(aExemplos, { "352607S7T6V5W4000D3155004000123004173000548", "7" })
   AAdd(aExemplos, { "352607L1K2J3H4000E5155005000123005173000685", "1" })
   AAdd(aExemplos, { "352607G8H7J6K5000G1355006000123006173000822", "5" })
   AAdd(aExemplos, { "352607R2S3T4V5000H1755007000123007173000959", "5" })
   AAdd(aExemplos, { "352607W4X5Y6Z7000J9055008000123008173001096", "1" })
   AAdd(aExemplos, { "352607C9D8E7G6000K1555009000123009173001233", "4" })
   AAdd(aExemplos, { "3525090139106300018955001000042763119995394", "1" })
   AAdd(aExemplos, { "352607N3M2L1K9000L2055010000123010173001370", "0" })

   ? "======================================================================="
   ? "   VALIDACAO DEFINITIVA DO ALGORITMO - CNPJ ALFANUMERICO (MODULO 11)   "
   ? "======================================================================="
   ? ""

   oNfe := Malc_GeraXml():New()

   For nCont := 1 To Len(aExemplos)
      cChaveRaiz     := aExemplos[nCont][1]
      cDigitoEsperado := aExemplos[nCont][2]
      
      // Executa o método matemático da sua classe
      cDigitoGerado   := oNfe:CalculaDigito(cChaveRaiz)

      msginfo( "Caso " + hb_ntos(nCont) + " -> Chave 43 Digitos: " + cChaveRaiz + hb_eol() + ;
       "        -> DV Gerado  : [ " + cDigitoGerado + " ]" + hb_eol() + ;
       "        -> DV Esperado: [ " + cDigitoEsperado + " ]")
      
      If cDigitoGerado == cDigitoEsperado
         msginfo( "STATUS  : OK - Digito Verificador bateu perfeitamente!")
      Else
         msginfo( "STATUS  : ERRO - Falha na conversao ou peso!")
      EndIf
      ? "-----------------------------------------------------------------------"
   Next

Return

// -----------------------------------------------------------------------------
// CLASSE AUXILIAR DE TESTE
// -----------------------------------------------------------------------------
CLASS Malc_GeraXml
   METHOD New() SETGET
   METHOD CalculaDigito()
ENDCLASS

METHOD New() CLASS Malc_GeraXml
Return Self

METHOD CalculaDigito(cNumero, cModulo)
   Local nFator:= 2, nPos:= nSoma:= nResto:= nModulo:= 0, cCalculo
 
   hb_Default(@cModulo, [11])

   If Empty(cNumero)
      Return ([])
   EndIf

   nModulo := Val(cModulo)
   cCalculo:= AllTrim(cNumero)

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
         EndIf
      Next
   EndIf

   nResto:= 11 - Mod(nSoma, 11)
   If nResto > 9
      nResto:= 0
   EndIf
Return (Str(nResto, 1))