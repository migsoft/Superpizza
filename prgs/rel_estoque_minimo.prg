/*
  sistema     : superchef pizzaria
  programa    : relat�rio controle do estoque m�nimo
  compilador  : xharbour 1.2 simplex
  lib gr�fica : minigui 1.7 extended
  programador : marcelo neves
*/

#include 'minigui.ch'
#include 'miniprint.ch'
#include 'super.ch'

function relatorio_estoque_minimo()

         define window form_est_minimo;
                at 000,000;
                width 400;
                height 250;
                title 'Rela��o estoque m�nimo';
                icon path_imagens+'icone.ico';
                modal;
                nosize

                @ 010,010 label lbl_001;
                          of form_est_minimo;
                          value 'Este relat�rio ir� listar somente os produtos que';
                          autosize;
                          font 'tahoma' size 010;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 030,010 label lbl_002;
                          of form_est_minimo;
                          value 'estejam com o estoque atual igual ou abaixo do m�nimo';
                          autosize;
                          font 'tahoma' size 010;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 050,010 label lbl_003;
                          of form_est_minimo;
                          value 'cadastrado. Somente produtos que n�o sejam - pizza -';
                          autosize;
                          font 'tahoma' size 010;
                          bold;
                          fontcolor _preto_001;
                          transparent
                @ 070,010 label lbl_004;
                          of form_est_minimo;
                          value 'aparecer�o no relat�rio.';
                          autosize;
                          font 'tahoma' size 010;
                          bold;
                          fontcolor _preto_001;
                          transparent

                * linha separadora
                define label linha_rodape
                       col 000
                       row form_est_minimo.height-090
                       value ''
                       width form_est_minimo.width
                       height 001
                       backcolor _preto_001
                       transparent .F.
                end label

                * bot�es
                define button button_ok
                       picture path_imagens+'img_relatorio.bmp'
                       col form_est_minimo.width-255
                       row form_est_minimo.height-085
                       width 150
                       height 050
                       caption 'Ok, imprimir'
                       action relatorio()
                       fontbold .T.
                       tooltip 'Gerar o relat�rio'
                       flat .F.  //                    noxpstyle .T.
                end button
                define button button_cancela
                       picture path_imagens+'img_sair.bmp'
                       col form_est_minimo.width-100
                       row form_est_minimo.height-085
                       width 090
                       height 050
                       caption 'Voltar'
                       action form_est_minimo.release
                       fontbold .T.
                       tooltip 'Sair desta tela'
                       flat .F.   //                     noxpstyle .T.
                end button

                on key escape action thiswindow.release

         end window

         form_est_minimo.center
         form_est_minimo.activate

         return(nil)
*-------------------------------------------------------------------------------
static function relatorio()

       local p_linha := 040
       local u_linha := 260
       local linha   := p_linha
       local pagina  := 1
       
       SELECT PRINTER DIALOG PREVIEW

       START PRINTDOC NAME 'Gerenciador de impress�o'
       START PRINTPAGE

       dbselectarea('produtos')
       produtos->(ordsetfocus('nome_longo'))
       produtos->(dbgotop())
       
       cabecalho(pagina)
       
       while .not. eof()

             if produtos->qtd_estoq <= produtos->qtd_min .and. !produtos->pizza
                @ linha,010 PRINT alltrim(produtos->codigo) FONT 'courier new' SIZE 010
                @ linha,030 PRINT alltrim(produtos->nome_longo) FONT 'courier new' SIZE 010
                @ linha,090 PRINT str(produtos->qtd_min,6) FONT 'courier new' SIZE 010
                @ linha,130 PRINT str(produtos->qtd_estoq,6) FONT 'courier new' SIZE 010
                @ linha,170 PRINT str(produtos->qtd_estoq-produtos->qtd_min,6) FONT 'courier new' SIZE 010
             
                linha += 5
                
                if linha >= u_linha
                   END PRINTPAGE
                   START PRINTPAGE
                   pagina ++
                   cabecalho(pagina)
                   linha := p_linha
                endif
             endif
             
             produtos->(dbskip())

       end

       rodape()
       
       END PRINTPAGE
       END PRINTDOC

       return(nil)
*-------------------------------------------------------------------------------
static function cabecalho(p_pagina)

       @ 007,010 PRINT IMAGE path_imagens+'logotipo.bmp' WIDTH 050 HEIGHT 020 STRETCH
       @ 010,070 PRINT 'RELA��O ESTOQUE M�NIMO' FONT 'courier new' SIZE 018 BOLD
       @ 024,070 PRINT 'p�gina : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012

       @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR _preto_001

       @ 035,010 PRINT 'C�DIGO' FONT 'courier new' SIZE 010 BOLD
       @ 035,030 PRINT 'PRODUTO' FONT 'courier new' SIZE 010 BOLD
       @ 035,090 PRINT 'QTD.M�NIMA' FONT 'courier new' SIZE 010 BOLD
       @ 035,130 PRINT 'QTD.ESTOQUE' FONT 'courier new' SIZE 010 BOLD
       @ 035,170 PRINT 'QTD.ABAIXO' FONT 'courier new' SIZE 010 BOLD

       return(nil)
*-------------------------------------------------------------------------------
static function rodape()

       @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR _preto_001
       @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008

       return(nil)