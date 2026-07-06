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
#include "hbclass.ch"

PROCEDURE Main()
   LOCAL oXml, cXmlFinal

   // 1. Instancia a classe
   oXml := Malc_GeraXml():New()

   // 2. Define a versão do documento
   oXml:SetVersao( "4.00" )

   // 3. Inicia o cabeçalho do documento (Chave fictícia de 44 dígitos)
   oXml:GeraA01( "35260755064661000172550010000000011000000010" )

   // 4. Identificação da Nota (Exemplo de parâmetros: cUf, cNf, cNatOp, nMod, nSerie, nNf, dEmi...)
   oXml:GeraB01( "35", "00000001", "VENDA DE MERCADORIA", 55, 1, 1, Date(), Date(), "12:00:00", 1, "3550308", 1, 1, 1, 2, 1, 1, 1, 1 )

   // 5. Dados do Emitente (Razão Social, Nome Fantasia, IE, CRT...)
   oXml:GeraC01( "MINHA EMPRESA LTDA", "EMPRESA", "111222333444", "", "", "", "", "3" )
   oXml:GeraC05( "RUA PRINCIPAL", "100", "", "CENTRO", "3550308", "SAO PAULO", "SP", "01001000", "1058", "BRASIL", "1133334444", "" )

   // [Adicione aqui os laços de Itens, Impostos, Totais e Transporte conforme os Manuais]

   // 6. Obtém a string do XML montada para salvar ou enviar
   cXmlFinal := oXml:GetXml()

   // Salva em disco de forma segura
   hb_MemoWrit( "nota_fiscal.xml", cXmlFinal )

   ? "XML da nota fiscal gerado com sucesso!"
RETURN
