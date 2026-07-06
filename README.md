# Malc_GeraXml

**Classe para Geração de XML de DF-e (NF-e Modelo 55 e NFC-e Modelo 65) em Harbour**

Uma biblioteca nativa, profissional e de alta performance desenvolvida em Harbour para geração de arquivos XML destinados à Nota Fiscal Eletrônica (NF-e) e Nota Fiscal de Consumidor Eletrônica (NFC-e). 

Esta classe foi totalmente atualizada e já contempla as novas tags da **Reforma Tributária do Consumo (RTC)**, além de manter compatibilidade com os padrões atuais das Notas Fiscais estruturadas no padrão **NF-e 4.00** e **NFC-e 4.00**.

---

## 📌 Considerações Importantes

> ⚠️ **A `Malc_GeraXml` não inventa nada.** Tudo o que é gerado e estruturado por esta classe segue estritamente as regras de negócio, notas técnicas e os manuais de orientação do contribuinte disponibilizados pelo governo (SEFAZ).
> 
> 💡 **Projeto em evolução contínua:** Qualquer contribuição é extremamente válida! Esta ainda não é uma classe definitiva, uma vez que muitas alterações e regulamentações na legislação da Reforma Tributária ainda estão em processo de definição e publicação pelos órgãos competentes.

---

## ✨ Características Principais

* **Compatibilidade:** Desenvolvida especificamente para ecossistemas Harbour e xHarbour.
* **Modelos Suportados:** NF-e (Modelo 55) e NFC-e (Modelo 65).
* **Versão do Leiaute:** Atualizada com o padrão nacional **4.00**.
* **Pronta para a Reforma Tributária (RTC):** Suporte nativo para os novos grupos de tributação do IBS (Imposto sobre Bens e Serviços) e CBS (Contribuição sobre Bens e Serviços).
* **Segurança e Manipulação Limpa:** Métodos estruturados que automatizam a validação, formatação de tags vazias e tratamento de caracteres especiais inerentes ao formato XML.

---

## 🛠️ Principais Métodos Disponíveis

A classe organiza a nota fiscal de forma modularizada e hierárquica através de métodos intuitivos:

### 1. Inicialização e Configuração
* `New()`: Instancia o objeto da classe e limpa o buffer do XML.
* `SetVersao( cVersao )`: Define a versão do leiaute (Padrão: `"4.00"`).

### 2. Estrutura e Identificação (Grupo A, B, C e D)
* `GeraA01( cId )`: Cria o nó raiz da NF-e com a chave de acesso.
* `GeraB01( ... )`: Identificação da Nota Fiscal Eletrônica (Série, Número, Datas, Tipo de Operação).
* `GeraC01( ... )`: Dados do Emitente (CNPJ/CPF, Razão Social, IE, CRT).
* `GeraE01( ... )`: Dados do Destinatário/Remetente.

### 3. Detalhamento de Produtos e Itens (Grupo H e I)
* `GeraH01( nItem )`: Inicializa um novo item de produto na nota.
* `GeraI01( ... )`: Dados do Produto/Serviço (Código, EAN, NCM, CFOP, Unidade, Quantidade, Valor).

### 4. Tributação Avançada (Grupo N)
* Suporte a todos os regimes de ICMS comuns (CST e CSOSN).
* Suporte aos grupos de PIS, COFINS e IPI.
* **Grupo RTC (Reforma Tributária):** Métodos dedicados para inserção das novas tags de CBS e IBS conforme os novos manuais técnicos da SEFAZ.

---

## 🚀 Exemplo Básico de Uso

Abaixo, um exemplo simples de como instanciar a classe e iniciar a montagem de uma estrutura básica de nota fiscal no seu código Harbour:

```harbour
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
